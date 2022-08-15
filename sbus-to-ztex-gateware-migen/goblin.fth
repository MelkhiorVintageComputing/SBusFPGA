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

sfra_goblin_bt constant goblin-off-dac
h# 200 constant /goblin-off-dac

h# 1000000 constant goblin-off-fb
h# SBUSFPGA_CG3_BUFSIZE constant /goblin-off-fb
\ only map the first two MiB
h# 200000 constant /goblin-mapped-fb
h# 8f000000 constant goblin-internal-fb

: goblin-reg
  my-address sfra_goblin_bt + my-space encode-phys /goblin-off-dac encode-int encode+
  my-address goblin-off-fb + my-space encode-phys encode+ /goblin-off-fb encode-int encode+
  h# 1 goblin-has-jareth = if
    my-address sfra_goblin_accel + my-space encode-phys encode+ h# 1000 encode-int encode+
  then
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
  h# 14 dac!       ( r g b )
  swap rot     ( b g r )
  h# 18 dac!       ( b g )
  h# 18 dac!       ( b )
  h# 18 dac!       (  )
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
  goblin-off-fb /goblin-mapped-fb do-map-in to fb-addr
;

: fb-unmap
  goblin-off-fb /goblin-mapped-fb do-map-out
  -1 to fb-addr
;

: map-regs
  dac-map
;

: unmap-regs
  dac-unmap
;

\
\ Installation
\

" goblin" device-name
" display" device-type
" RDOL,sbusfpga" model

: goblin-driver-install ( -- )
  goblin-dac -1 = if
    map-regs
	
	fb-map

    \ Initial palette taken from Sun's "Writing FCode Programs"
    h# ff h# ff h# ff h# 0  color!    \ Background white
    h# 0  h# 0  h# 0  h# ff color!    \ Foreground black
    \ h# 64 h# 41 h# b4 h# 1  color!    \ SUN-blue logo
    h# b4 h# 41 h# 64 h# 1  color!    \ SUN-blue logo

    fb-addr to frame-buffer-adr
    default-font set-font

    frame-buffer-adr encode-int " address" property \ CHECKME

	h# 1 h# 8 dac! \ enable

    openbios-video-width openbios-video-height over char-width / over char-height /
    fb8-install
  then
;

: goblin-driver-remove ( -- )
  goblin-dac -1 <> if
  		  unmap-regs
		  fb-unmap
		  -1 to frame-buffer-adr
		  " address" delete-property
  then
;

: goblin-driver-init

  goblin-reg

  openbios-video-height encode-int " height" property
  openbios-video-width encode-int " width" property
  depth-bits encode-int " depth" property
  line-bytes encode-int " linebytes" property

  h# 39 encode-int 0 encode-int encode+ " intr" property

  " RDOL" encode-string " manufacturer" property
  " ISO8859-1" encode-string " character-set" property
  h# c encode-int " cursorshift" property
  /goblin-mapped-fb h# 14 >> encode-int " vmmapped" property
  /goblin-off-fb h# 14 >> encode-int " vmsize" property
  goblin-internal-fb encode-int " goblin-internal-fb" property
  goblin-has-jareth encode-int " goblin-has-jareth" property
  
  map-regs
  h# 0 h# 4 dac! \ disable irq
  h# 0 h# 8 dac! \ turn off videoctrl
  unmap-regs

  ['] goblin-driver-install is-install
  ['] goblin-driver-remove is-remove
;

goblin-driver-init
