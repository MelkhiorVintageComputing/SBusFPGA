fcode-version2

\ Absolute minimal stuff; name & registers def.
" RDOL,SBusFPGA" name
my-address h# 10000 + my-space h# 100 reg
\ we don't support ET
h# 7f xdrint " slave-burst-sizes" attribute
h# 7f xdrint " burst-sizes" attribute

headers

-1 instance value led-virt
my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

: map-in-led ( -- ) my-sbus-address h# 10000 + my-sbus-space h# 4 map-in is led-virt ;
: map-out-led ( -- ) led-virt h# 4 map-out ;

external

: blink! ( pattern -- )
	map-in-led
	led-virt l! ( pattern virt -- )
	map-out-led
	;

\ works at probe time, but not as a user command
h# a0500a05 blink!

end0
