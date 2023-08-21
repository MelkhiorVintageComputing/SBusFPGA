fcode-version2
fload prom_csr_V1_3.fth
" RDOL,neorv32trng" device-name
my-address sfca_trng + my-space h# 8 reg
h# 7f encode-int " slave-burst-sizes" property
h# 7f encode-int " burst-sizes" property
headers
-1 instance value trng-virt
my-address constant my-sbus-address
my-space constant my-sbus-space
: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;
: map-in-trng ( -- ) my-sbus-address sfca_trng + my-sbus-space h# 8 map-in to trng-virt ;
: map-out-trng ( -- ) trng-virt h# 8 map-out ;
: disabletrng! ( -- )
  map-in-trng
  1 trng-virt l! ( pattern virt -- )
  map-out-trng
;
disabletrng!
finish-device
new-device
" generic-ohci" device-name
sbusfpga_irq_usb_host encode-int " interrupts" property
my-address sfra_usb_host_ctrl + my-space h# 1000 reg
h# 7f encode-int " slave-burst-sizes" property
h# 7f encode-int " burst-sizes" property
headers
-1 instance value usb_host_ctrl-virt
my-address constant my-sbus-address
my-space constant my-sbus-space
: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;
: map-in-usb_host_ctrl ( -- ) my-sbus-address sfra_usb_host_ctrl + my-sbus-space h# 1000 map-in to usb_host_ctrl-virt ;
: map-out-usb_host_ctrl ( -- ) usb_host_ctrl-virt h# 1000 map-out ;
: my-reset! ( -- )
 map-in-usb_host_ctrl
 00000001 usb_host_ctrl-virt h#  4 + l! ( -- ) ( reset the HC )
 00000000 usb_host_ctrl-virt h# 18 + l! ( -- ) ( reset HCCA & friends )
 00000000 usb_host_ctrl-virt h# 1c + l! ( -- )
 00000000 usb_host_ctrl-virt h# 20 + l! ( -- )
 00000000 usb_host_ctrl-virt h# 24 + l! ( -- )
 00000000 usb_host_ctrl-virt h# 28 + l! ( -- )
 00000000 usb_host_ctrl-virt h# 2c + l! ( -- )
 00000000 usb_host_ctrl-virt h# 30 + l! ( -- )
 map-out-usb_host_ctrl
;
my-reset!
finish-device
new-device
" RDOL,sdram" device-name
my-address sfca_ddrphy + my-space encode-phys             h# 1000 encode-int encode+
my-address sfca_sdram + my-space encode-phys encode+ h# 1000 encode-int encode+
my-address sfca_exchange_with_mem + my-space encode-phys encode+ h# 1000 encode-int encode+
" reg" property
h# 7f encode-int " slave-burst-sizes" property
h# 7f encode-int " burst-sizes" property
headers
-1 instance value ddrphy-virt
-1 instance value sdram-virt
-1 instance value exchange_with_mem-virt
my-address constant my-sbus-address
my-space constant my-sbus-space
: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;
: map-in-mregs ( -- )
my-sbus-address sfca_ddrphy + my-sbus-space h# 1000 map-in to ddrphy-virt
my-sbus-address sfca_sdram + my-sbus-space h# 1000 map-in to sdram-virt
my-sbus-address sfca_exchange_with_mem + my-sbus-space h# 1000 map-in to exchange_with_mem-virt
;
: map-out-mregs ( -- )
ddrphy-virt h# 1000 map-out
sdram-virt h# 1000 map-out
exchange_with_mem-virt h# 1000 map-out
;
sbusfpga_irq_sdram encode-int " interrupts" property
h# 19 constant m0_delay
h# 19 constant m1_delay
h# 1 constant m0_bitslip
h# 1 constant m1_bitslip
fload sdram_init.fth
init!
finish-device
new-device
" oc,i2c" device-name
my-address sfca_i2c + my-space h# 40 reg
h# 7f encode-int " slave-burst-sizes" property
h# 7f encode-int " burst-sizes" property
headers
-1 instance value i2c-virt
my-address constant my-sbus-address
my-space constant my-sbus-space
: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;
: map-in-i2c ( -- ) my-sbus-address sfca_i2c + my-sbus-space h# 40 map-in to i2c-virt ;
: map-out-i2c ( -- ) i2c-virt h# 40 map-out ;
h# 5f5e100 encode-int " clock-speed" property
h# 61a80 encode-int " bus-speed" property
  new-device
  " AT30TS74-UFM10" encode-string " name" property
  " lm75" encode-string " compatible" property
  h# 48 encode-int " addr" property
  finish-device
finish-device
new-device
h# -1 constant sfra_jareth-regs
h# 0 constant goblin-has-jareth
: openbios-video-width
    h# 780
;

: openbios-video-height
    h# 438
;

: depth-bits
    h# 8
;

: line-bytes
    h# 780
;

sfra_goblin_bt constant goblin-off-dac
h# 200 constant /goblin-off-dac

h# 1000000 constant goblin-off-fb
h# 1000000 constant /goblin-off-fb
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


end0
