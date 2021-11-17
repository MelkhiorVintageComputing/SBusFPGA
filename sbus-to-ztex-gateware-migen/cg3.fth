\ simplified version of the OpenBIOS cgthree code

: openbios-video-width
    h# SBUSFPGA_CG3_WIDTH
;

: openbios-video-height
    h# SBUSFPGA_CG3_HEIGHT
;

: depth-bits
    h# 8
;

: line-bytes
    h# SBUSFPGA_CG3_WIDTH
;

sbusfpga_regionaddr_cg3_bt constant cg3-off-dac
h# 20 constant /cg3-off-dac

h# 800000 constant cg3-off-fb
h# SBUSFPGA_CG3_BUFSIZE constant /cg3-off-fb

: >cg3-reg-spec ( offset size -- encoded-reg )
  >r 0 my-address d+ my-space encode-phys r> encode-int encode+
;

: cg3-reg
  \ A real cg3 rom appears to just map the entire region with a
  \ single entry
  h# 0 h# 1000000 >cg3-reg-spec
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

-1 value cg3-dac
-1 value fb-addr

: dac! ( data reg# -- )
  cg3-dac + c!
;

external

: color!  ( r g b c# -- )
  0 dac!       ( r g b )
  swap rot     ( b g r )
  4 dac!       ( b g )
  4 dac!       ( b )
  4 dac!       (  )
;

headerless

\
\ Mapping
\

: dac-map
  cg3-off-dac /cg3-off-dac do-map-in to cg3-dac
;

: dac-unmap
  cg3-dac /cg3-off-dac do-map-out
  -1 to cg3-dac
;

: fb-map
  cg3-off-fb /cg3-off-fb do-map-in to fb-addr
;

: fb-unmap
  cg3-off-fb /cg3-off-fb do-map-out
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

" cgthree" device-name
" display" device-type
" RDOL,sbusfpga" model

: qemu-cg3-driver-install ( -- )
  cg3-dac -1 = if
    map-regs
	
	fb-map

    \ Initial pallette taken from Sun's "Writing FCode Programs"
    h# ff h# ff h# ff h# 0  color!    \ Background white
    h# 0  h# 0  h# 0  h# ff color!    \ Foreground black
    h# 64 h# 41 h# b4 h# 1  color!    \ SUN-blue logo

    fb-addr to frame-buffer-adr
    default-font set-font

    frame-buffer-adr encode-int " address" property \ CHECKME

    openbios-video-width openbios-video-height over char-width / over char-height /
    fb8-install
  then
;

: qemu-cg3-driver-remove ( -- )
  cg3-dac -1 <> if
  		  unmap-regs
		  fb-unmap
		  -1 to frame-buffer-adr
		  " address" delete-attribute
  then
;

: qemu-cg3-driver-init

  cg3-reg

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

  ['] qemu-cg3-driver-install is-install
  ['] qemu-cg3-driver-remove is-remove
;

qemu-cg3-driver-init
