fcode-version2

\ loads constants
fload prom_csr.fth

\ fload v2compat.fth

\ Absolute minimal stuff; name & registers def.
" RDOL,led" device-name
my-address sbusfpga_csraddr_leds + my-space h# 4 reg
\ we don't support ET or HWORD
h# 7d xdrint " slave-burst-sizes" attribute
h# 7d xdrint " burst-sizes" attribute

headers
-1 instance value led-virt
my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

: map-in-led ( -- ) my-sbus-address sbusfpga_csraddr_leds + my-sbus-space h# 4 map-in is led-virt ;
: map-out-led ( -- ) led-virt h# 4 map-out ;

\ external

: setled! ( pattern -- )
  map-in-led
  led-virt l! ( pattern virt -- )
  map-out-led
;

\ h# a5 setled!

\ OpenBIOS tokenizer won't accept finish-device without new-device
\ Cheat by using the tokenizer so we can do OpenBoot 2.x siblings
\ tokenizer[ 01 emit-byte h# 27 emit-byte h# 01 emit-byte h# 1f emit-byte  ]tokenizer
\ The OpenFirmware tokenizer does accept the 'clean' syntax
finish-device
new-device

\ Absolute minimal stuff; name & registers def.
" DISABLED-generic-ohci" device-name

\ USB registers are in the device space, not the CSR space
my-address sbusfpga_regionaddr_usb_host_ctrl + my-space h# 1000 reg
\ we don't support ET or anything non-32bits
h# 7c xdrint " slave-burst-sizes" attribute
h# 7c xdrint " burst-sizes" attribute

1 xdrint " interrupts" attribute

headers
-1 instance value regs-virt
my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

: map-in-regs ( -- ) my-sbus-address sbusfpga_regionaddr_usb_host_ctrl + my-sbus-space h# 1000 map-in is regs-virt ;
: map-out-regs ( -- ) regs-virt h# 1000 map-out ;

: my-reset! ( -- )
 map-in-regs
 00000001 regs-virt h#  4 + l! ( -- ) ( reset the HC )
 00000000 regs-virt h# 18 + l! ( -- ) ( reset HCCA & friends )
 00000000 regs-virt h# 1c + l! ( -- )
 00000000 regs-virt h# 20 + l! ( -- )
 00000000 regs-virt h# 24 + l! ( -- )
 00000000 regs-virt h# 28 + l! ( -- )
 00000000 regs-virt h# 2c + l! ( -- )
 00000000 regs-virt h# 30 + l! ( -- )
 map-out-regs
;

my-reset!

\ " ohci" encode-string " device_type" property
\ fload openfirmware/dev/usb2/hcd/ohci/loadpkg-sbus.fth
\ open

\ OpenBIOS tokenizer won't accept finish-device without new-device
\ Cheat by using the tokenizer so we can do OpenBoot 2.x siblings
\ tokenizer[ 01 emit-byte h# 27 emit-byte h# 01 emit-byte h# 1f emit-byte  ]tokenizer
\ The OpenFirmware tokenizer does accept the 'clean' syntax
finish-device
new-device

\ Absolute minimal stuff; name & registers def.
" RDOL,sdram" device-name
\ three pages of registers:
my-address sbusfpga_csraddr_ddrphy + my-space xdrphys \ Offset#1
h# 1000 xdrint xdr+ \ Merge size#1
my-address sbusfpga_csraddr_sdram + my-space xdrphys xdr+  \ Merge offset#2
h# 1000 xdrint xdr+  \ Merge size#2
my-address sbusfpga_csraddr_exchange_with_mem + my-space xdrphys xdr+  \ Merge offset#3
h# 1000 xdrint xdr+  \ Merge size#3
\ my-address sbusfpga_regionaddr_main_ram + my-space xdrphys xdr+  \ Merge offset#4
\ h# 10000 xdrint xdr+  \ Merge size#4
" reg" attribute

\ we don't support ET or anything non-32bits
h# 7c xdrint " slave-burst-sizes" attribute
h# 7c xdrint " burst-sizes" attribute

headers
-1 instance value mregs-ddrphy-virt
-1 instance value mregs-sdram-virt
-1 instance value mregs-exchange_with_mem-virt
my-address constant my-sbus-address
my-space   constant my-sbus-space
: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

: map-in-mregs ( -- )
  my-sbus-address sbusfpga_csraddr_ddrphy + my-sbus-space h# 1000 map-in is mregs-ddrphy-virt
  my-sbus-address sbusfpga_csraddr_sdram + my-sbus-space h# 1000 map-in is mregs-sdram-virt
  my-sbus-address sbusfpga_csraddr_exchange_with_mem + my-sbus-space h# 1000 map-in is mregs-exchange_with_mem-virt
;
: map-out-mregs ( -- )
  mregs-ddrphy-virt h# 1000 map-out
  mregs-sdram-virt h# 1000 map-out
  mregs-exchange_with_mem-virt h# 1000 map-out
;

\ fload sdram_init.fth

\ init!

end0
