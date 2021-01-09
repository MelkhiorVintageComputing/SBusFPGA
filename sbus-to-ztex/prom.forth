fcode-version2

\ Absolute minimal stuff; name & registers def.
" RDOL,cryptoengine" name
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

\ external

: blink! ( pattern -- )
  map-in-led
  led-virt l! ( pattern virt -- )
  map-out-led
;

h# a0500a05 blink!

\ OpenBIOS tokenizer won't accept finish-device without new-device
\ Cheat by using the tokenizer so we can do OpenBoot 2.x siblings
tokenizer[ 01 emit-byte 27 emit-byte 01 emit-byte 1f emit-byte  ]tokenizer

\ Absolute minimal stuff; name & registers def.
" RDOL,trng" name
my-address h# 20000 + my-space h# 100 reg
\ we don't support ET or anything non-32bits
h# 04 xdrint " slave-burst-sizes" attribute
h# 04 xdrint " burst-sizes" attribute

headers

my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;


\ OpenBIOS tokenizer won't accept finish-device without new-device
\ Cheat by using the tokenizer so we can do OpenBoot 2.x siblings
tokenizer[ 01 emit-byte 27 emit-byte 01 emit-byte 1f emit-byte  ]tokenizer

\ Absolute minimal stuff; name & registers def.
" RDOL,sdcard" name
my-address h# 30000 + my-space h# 100 reg
\ we don't support ET or anything non-32bits
h# 04 xdrint " slave-burst-sizes" attribute
h# 04 xdrint " burst-sizes" attribute

headers

my-address constant my-sbus-address
my-space   constant my-sbus-space

: map-in ( adr space size -- virt ) " map-in" $call-parent ;
: map-out ( virt size -- ) " map-out" $call-parent ;

end0
