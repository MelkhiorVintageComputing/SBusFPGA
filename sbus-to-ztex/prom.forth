fcode-version2

\ Absolute minimal stuff; name & registers def.
" RDOL,SBusFPGA" name
my-address h# 200 + my-space h# 100 reg
\ we don't support ET
h# 7f xdrint " slave-burst-sizes" attribute
h# 7f xdrint " burst-sizes" attribute

headers

-1 instance value led-virt
my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

: map-in-led ( -- ) my-sbus-address h# 200 + my-sbus-space h# 4 map-in is led-virt ;
: map-out-led ( -- ) led-virt h# 4 map-out ;

external

: blink! ( pattern -- )
	map-in-led
	led-virt l! ( pattern virt -- )
	map-out-led
	;

\ works at probe time, but not as a user command
h# a0500a05 blink!

\ \hex

\ define one register
\ \my-address 200 + my-space 4 " reg" property

\ accept only 32 bits transfer
\ default is 17, or 1/2/4/16 bytes
\ \15 " slave-burst-sizes" property

\ only if using interrupts; array of int
\ 1 encode-int 2 encode-int " interrupts" property

\ only if generating parity
\ parity-generated

\ blink will send a value to the board so it can blink the led to show the value
\ useful to test before the operating system works
\ \: blink! ( pattern -- ) my-address 200 + ! ;

end0
