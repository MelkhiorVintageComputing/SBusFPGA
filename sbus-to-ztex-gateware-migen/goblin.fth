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

sbusfpga_regionaddr_goblin_bt constant goblin-off-dac
h# 20 constant /goblin-off-dac

h# 800000 constant goblin-off-fb
h# SBUSFPGA_CG3_BUFSIZE constant /goblin-off-fb

: >goblin-reg-spec ( offset size -- encoded-reg )
  >r 0 my-address d+ my-space encode-phys r> encode-int encode+
;

: goblin-reg
  \ FIXME: we don't have to do this like the cg3...
  h# 0 h# 1000000 >goblin-reg-spec
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

-1 value goblin-dac
-1 value fb-addr

: dac! ( data reg# -- )
  goblin-dac + l!
;

external

: color!  ( r g b c# -- )
  h# 18 << h# 14 dac!       ( r g b )
  swap rot     ( b g r )
  h# 18 << h# 18 dac!       ( b g )
  h# 18 << h# 18 dac!       ( b )
  h# 18 << h# 18 dac!       (  )
;

headerless

\
\ Mapping
\

: dac-map
  goblin-off-dac /goblin-off-dac do-map-in to goblin-dac
;

: dac-unmap
  goblin-dac /goblin-off-dac do-map-out
  -1 to goblin-dac
;

: fb-map
  goblin-off-fb /goblin-off-fb do-map-in to fb-addr
;

: fb-unmap
  goblin-off-fb /goblin-off-fb do-map-out
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

" goblin" device-name
" display" device-type
" RDOL,sbusfpga" model

: qemu-goblin-driver-install ( -- )
  goblin-dac -1 = if
    map-regs

	0 h# 4 dac! \ disable irq
	
	fb-map

    \ Initial palette taken from Sun's "Writing FCode Programs"
    h# ff h# ff h# ff h# 0  color!    \ Background white
    h# 0  h# 0  h# 0  h# ff color!    \ Foreground black
    h# 64 h# 41 h# b4 h# 1  color!    \ SUN-blue logo

    fb-addr to frame-buffer-adr
    default-font set-font

    frame-buffer-adr encode-int " address" property \ CHECKME

	h# 3 h# 8 dac! \ enable DMA, VTG

    openbios-video-width openbios-video-height over char-width / over char-height /
    fb8-install
  then
;

: qemu-goblin-driver-remove ( -- )
  goblin-dac -1 <> if
  		  unmap-regs
		  fb-unmap
		  -1 to frame-buffer-adr
		  " address" delete-attribute
  then
;

: qemu-goblin-driver-init

  goblin-reg

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

  ['] qemu-goblin-driver-install is-install
  ['] qemu-goblin-driver-remove is-remove
;

qemu-goblin-driver-init
