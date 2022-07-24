\ simplified version of the OpenBIOS cgthree code
\ ... for the cg6

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

sbusfpga_regionaddr_cg6_bt constant cg6-off-dac
h# 20 constant /cg6-off-dac

h# 800000 constant cg6-off-fb
h# SBUSFPGA_CG3_BUFSIZE constant /cg6-off-fb

: >cg6-reg-spec ( offset size -- encoded-reg )
  >r 0 my-address d+ my-space encode-phys r> encode-int encode+
;

: cg6-reg
  \ A real cg6 rom appears to just map the entire region with a
  \ single entry
  h# 0 h# 1000000 >cg6-reg-spec
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

-1 value cg6-dac
-1 value fb-addr

: dac! ( data reg# -- )
  cg6-dac + l!
;

external

: color!  ( r g b c# -- )
  h# 18 << 0 dac!       ( r g b )
  swap rot     ( b g r )
  h# 18 << 4 dac!       ( b g )
  h# 18 << 4 dac!       ( b )
  h# 18 << 4 dac!       (  )
;

headerless

\
\ Mapping
\

: dac-map
  cg6-off-dac /cg6-off-dac do-map-in to cg6-dac
;

: dac-unmap
  cg6-dac /cg6-off-dac do-map-out
  -1 to cg6-dac
;

: fb-map
  cg6-off-fb /cg6-off-fb do-map-in to fb-addr
;

: fb-unmap
  fb-addr /cg6-off-fb do-map-out
  -1 to fb-addr
;

: map-regs
  dac-map fb-map
;

: unmap-regs
  dac-unmap fb-unmap
;

fload fbc_init.fth

\
\ Installation
\

" cgsix" device-name
" display" device-type
" RDOL,sbusfpga" model

: qemu-cg6-driver-install ( -- )
  cg6-dac -1 = if
    map-regs

    map-in-fbc
	init-fbc
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
    ['] cg6-blink-screen      is blink-screen
    ['] cg6-reset-screen      is reset-screen
    ['] cg6-draw-char         is draw-character
    ['] cg6-toggle-cursor     is toggle-cursor
    ['] cg6-invert-screen     is invert-screen
    ['] cg6-insert-characters is insert-characters
    ['] cg6-delete-characters is delete-characters
    ['] fbc-erase-screen      is erase-screen
    ['] fbc-delete-lines      is delete-lines
    ['] fbc-insert-lines      is insert-lines
  then
;

: qemu-cg6-driver-remove ( -- )
  cg6-dac -1 <> if
  		  unmap-regs
		  map-out-fbc
		  fb-unmap
		  -1 to frame-buffer-adr
		  " address" delete-attribute
  then
;

: qemu-cg6-driver-init

  cg6-reg

  openbios-video-height encode-int " height" property
  openbios-video-width encode-int " width" property
  openbios-video-width encode-int " awidth" property
  depth-bits encode-int " depth" property
  line-bytes encode-int " linebytes" property
  
  h# b encode-int " chiprev" property \ rev 11
  /cg6-off-fb h# 14 >> encode-int " vmsize" property
  0 encode-int " dblbuf" property

  h# 39 encode-int 0 encode-int encode+ " intr" property

  \ Monitor sense. Some searching suggests that this is
  \ 5 for 1024x768 and 7 for 1152x900
  h# 5 encode-int " monitor-sense" property

  " RDOL" encode-string " manufacturer" property
  " ISO8859-1" encode-string " character-set" property
  h# c encode-int " cursorshift" property

  /cg6-off-fb encode-int " fbmapped" property

  ['] qemu-cg6-driver-install is-install
  ['] qemu-cg6-driver-remove is-remove
;

qemu-cg6-driver-init
