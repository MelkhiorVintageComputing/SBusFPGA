\ version1 fcode-revision
fcode-version1

\ beware the space with the quotes, Forth is strict
\ minimal required stuff
\ " RDOL,SBusFPGA" encode-string " name" property
\ my-address h# 200 + my-space encode-phys
\ h# 100 encode-int encode+
\ " reg" property

" RDOL,SBusFPGA" name
my-address h# 200 + my-space h# 100 reg


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
