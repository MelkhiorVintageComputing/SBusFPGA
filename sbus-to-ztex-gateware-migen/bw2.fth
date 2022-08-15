\ simplified version of the OpenBIOS cgthree code
\ ... for the bw2

: openbios-video-width
    h# SBUSFPGA_CG3_WIDTH
;

: openbios-video-height
    h# SBUSFPGA_CG3_HEIGHT
;

: depth-bits
    h# 1
;

: line-bytes
    h# SBUSFPGA_CG3_WIDTH h# 8 /
;

sfra_bw2_bt constant bw2-off-dac
h# 20 constant /bw2-off-dac

h# 800000 constant bw2-off-fb
h# SBUSFPGA_CG3_BUFSIZE constant /bw2-off-fb

: >bw2-reg-spec ( offset size -- encoded-reg )
  >r 0 my-address d+ my-space encode-phys r> encode-int encode+
;

: bw2-reg
  \ A real bw2 rom appears to just map the entire region with a
  \ single entry
  h# 0 h# 1000000 >bw2-reg-spec
  " reg" property
;

: do-map-in ( offset size -- virt )
  >r my-space r> " map-in" $call-parent
;

: do-map-out ( virt size )
  " map-out" $call-parent
;

\
\ DAC
\

-1 value bw2-dac
-1 value fb-addr

: dac! ( data reg# -- )
  bw2-dac + c!
;

headerless

\
\ Mapping
\

: dac-map
  bw2-off-dac /bw2-off-dac do-map-in to bw2-dac
;

: dac-unmap
  bw2-dac /bw2-off-dac do-map-out
  -1 to bw2-dac
;

: fb-map
  bw2-off-fb /bw2-off-fb do-map-in to fb-addr
;

: fb-unmap
  bw2-off-fb /bw2-off-fb do-map-out
  -1 to fb-addr
;

: map-regs
  dac-map fb-map
;

: unmap-regs
  dac-unmap fb-unmap
;

\
\ Installation
\

" bwtwo" device-name
" display" device-type
" RDOL,sbusfpga" model

: qemu-bw2-driver-install ( -- )
  bw2-dac -1 = if
    map-regs
	
	fb-map

    fb-addr to frame-buffer-adr
    default-font set-font

    frame-buffer-adr encode-int " address" property \ CHECKME

    openbios-video-width openbios-video-height over char-width / over char-height /
    \ fb1-install ; not supported in my OF compiler :-( -> explicit code# 1 7b
	tokenizer[ h# 1 emit-byte h# 7b emit-byte ]tokenizer
  then
;

: qemu-bw2-driver-remove ( -- )
  bw2-dac -1 <> if
  		  unmap-regs
		  fb-unmap
		  -1 to frame-buffer-adr
		  " address" delete-attribute
  then
;

: qemu-bw2-driver-init

  bw2-reg

  openbios-video-height encode-int " height" property
  openbios-video-width encode-int " width" property
  depth-bits encode-int " depth" property
  line-bytes encode-int " linebytes" property

  h# 39 encode-int 0 encode-int encode+ " intr" property

  \ Monitor sense. Some searching suggests that this is
  \ 5 for 1024x768 and 7 for 1152x900
  h# 7 encode-int " monitor-sense" property

  " RDOL" encode-string " manufacturer" property
  " ISO8859-1" encode-string " character-set" property
  h# c encode-int " cursorshift" property

  ['] qemu-bw2-driver-install is-install
  ['] qemu-bw2-driver-remove is-remove
;

qemu-bw2-driver-init
