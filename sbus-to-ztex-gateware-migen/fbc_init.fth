
-1 instance value fbc-virt
: map-in-fbc ( -- ) my-sbus-address sbusfpga_regionaddr_cg6_fbc + my-sbus-space h# 2000 map-in is fbc-virt ;
: map-out-fbc ( -- ) fbc-virt h# 2000 map-out ;

: fbc! ( val off -- )
  fbc-virt + l!
;
: fbc@ ( off -- val )
  fbc-virt + l@
;

\ a.k.a. 'rasterops'
: fbc_alu! ( val -- )
  h# 108 fbc!
;

\ a.k.a. 'misc'
: fbc_mode! ( val -- )
  h# 4 fbc!
;

: fbc_clip! ( val -- )
  h# 8 fbc!
;

: fbc_offx! ( val -- )
  h# c0 fbc!
;
: fbc_offy! ( val -- )
  h# c4 fbc!
;

: fbc_x0! ( val -- )
  h# 80 fbc!
;
: fbc_y0! ( val -- )
  h# 84 fbc!
;
: fbc_x1! ( val -- )
  h# 90 fbc!
;
: fbc_y1! ( val -- )
  h# 94 fbc!
;
: fbc_x2! ( val -- )
  h# a0 fbc!
;
: fbc_y2! ( val -- )
  h# a4 fbc!
;
: fbc_x3! ( val -- )
  h# b0 fbc!
;
: fbc_y3! ( val -- )
  h# b4 fbc!
;

: fbc_incx! ( val -- )
  h# d0 fbc!
;
: fbc_incy! ( val -- )
  h# d4 fbc!
;

: fbc_clipminx! ( val -- )
  h# e0 fbc!
;
: fbc_clipminy! ( val -- )
  h# e4 fbc!
;

: fbc_clipmaxx! ( val -- )
  h# f0 fbc!
;
: fbc_clipmaxy! ( val -- )
  h# f4 fbc!
;

: fbc_fg! ( val -- )
  h# 100 fbc!
;

: fbc_bg! ( val -- )
  h# 104 fbc!
;

: fbc_arectx! ( val --)
  h# 900 fbc!
;

: fbc_arecty! ( val --)
  h# 904 fbc!
;

: fbc_s@ ( -- val )
  h# 10 fbc@
;

: fbc_draw@ ( -- val )
  h# 14 fbc@
;
: fbc_blit@ ( -- val )
  h# 18 fbc@
;

h# ff constant fground-color
h# 00 constant bground-color
  
: init-fbc
  h# 0 fbc_clip!
  h# 0 fbc_offx!
  h# 0 fbc_offy!
  h# 0 fbc_incx!
  h# 0 fbc_incy!
  h# 0 fbc_clipminx!
  h# 0 fbc_clipmaxy!
  openbios-video-width 1 - fbc_clipmaxx!
  openbios-video-height 1 - fbc_clipmaxy!
  h# ff fbc_fg!
  h# 0 fbc_bg!
  \ a9806c60 = 1010_1001__1000_0000__0110_1100__0110_0000
  \ from the doc:
  \ 31-30 Override Plane Mask Select
  \       (OO=Ignore, Ol=Use zeroes, 10=Use ones, ll=Use PLANEMASK)
  \ 29-28 Override Pixel Mask Select
  \       (OO=Ignore, 01-Use zeroes, 10=Use ones, ll=Use PIXELMASK)
  \ 27-26 Override Pattern Select
  \       (OO=Ignore, Ol=Use zeroes, 10=Use ones, ll=Use PATTERN)
  \ 25-24 Polygon Draw Select
  \       (OO=Ignore, 01=0verlapping, lO=Nonoverlapping, Il=Illegal)
  \ 23-22 UNSUPPORTED-ATTR
  \       (OO=Ignore, Ol=Unsupported, lO=Supported, ll=Illegal)
  \  17   Rasterop Mode            (()=BOOLEAN, l=LINEAR)
  \  16   Plot/Unplot Mode         (O=PLOT, l=UNPLOT)
  \ 15-12 Rasterop used when FCOLOR[p]=l and BCOLOR[pl=l
  \ 11-8  Rasterop used when FCOLOR[p]=l and BCOLOR[pl=O
  \  7-4  Rasterop used when FCOLOR[p]=O and BCOLOR[pl=l
  \  3-0  Rasterop used when FCOLOR[p]=O and BCOLOR[p]=O
  \ 
  \ so:             =>  all 3 override are 'use 1'
  \    polygon draw => overlapping
  \    unsup attr   => supported
  \    rop mode     => boolean
  \    plot/unplot  => plot
  \    rops         => four groups of <whatever> (still don't understand it)
  h# a9806c60 fbc_alu!

  \ ff for planemask (unimp)
  \ ffffffff for pixelmask (unimp)
  \ 0 for patalign (unimp)
  \ ffffffff for pattern0-7 (unimp)
  

  \ 229540 = 0000_0000__0010_0010__1001_0101__0100_0000
  \ from the doc:
  \ 31-22 0000_0000_00
  \ 21-20 BLIT-SRC-CHK
  \       (OO=ignore, 01-Exclude Src, lO=Include Src, ll=Illegal)
  \  19   VBLANK OCCURED           (l=VBLANK has occurred)
  \ 18-17 Anti-Aliasing/Color Mode Select
  \       (00=ignore, Ol=COLOR8, lO=COLORl, ll=HRMONO)
  \ 16-15 Render/Pick Mode Select
  \       (OO=ignore, Ol=RENDER, 10=PICK, 11-Illegal)
  \ 14-13 Buffer 0 Write Enable
  \        (OO=ignore, Ol=Enable, lO=Disable, ll=Illegal)
  \ 12-11 Buffer 1 Write Enable
  \       (00-ignore, Ol=Enable, lO-Disable, ll=Illegal)
  \ 10-9  Buffer Read Enable
  \       (OO=ignore, 01-Read from BufferO, lO=Read Bufferl, ll=Illegal)
  \  8-7  Buffer Display Enable
  \       (OO=ignore, Ol=Display BufferO, lO=Display Bufferl, ll=Illegal)
  \   6   Modify Address INDEX     (l=Modify Address Index)
  \  5-4  Address INDEX
  \  3-0  0000
  \
  \ so:   BLIT-SRC-CHECK => include src
  \       VBLANK         => no (guessig this is RO?)
  \       aa/color:      => COLOR8
  \       render/pick    => render
  \       buf 0 wr ena   => ignore
  \       buf 1 wr ena   => disable
  \       buf read ena   => buffer 1
  \       buf dis ena    => buffer 1
  \       mod. addr inx  => 1 (always)
  \       addr idx       => 0
  h# 229540 fbc_mode!
;

\ this reads 'draw' until no longer full
\ (we're never full..)
: fbc-draw-wait ( -- )
    begin
		fbc_draw@
        h# 20000000
        and
        0=
	until
;
\ this reads 'blit' until no longer full
\ (we're never full..)
: fbc-blit-wait ( -- )
    begin
		fbc_blit@
        h# 20000000
        and
        0=
	until
;
\ busy-wait on PROGRESS in 's(tatus)'
: fbc-busy-wait ( -- )
    begin
        fbc_s@ 
        h# 10000000
        and 
        0=
	until
;

\ convert char pos to pixel pos
: >pixel ( cx cy -- px py )
    swap
    char-width 
    * 
    window-left 
    + 
    swap 
    char-height 
    * 
    window-top 
    +
;

: fbc-rect-fill ( x0 y0 x1 y1 fg_color -- )
    fbc-busy-wait
    fbc_fg!
	\ fix the registers to what we currently expect
	h# a980ff00 fbc_alu!
	h# 00220000 fbc_mode!
	\ we start with x0/y0
    2swap
	fbc_arecty!
	fbc_arectx!
	fbc_arecty!
	fbc_arectx!
    fbc-draw-wait 
    fbc-busy-wait
	\ reset fg_color
    fground-color fbc_fg!
;

: fbc-blit ( cx0 cy0 cx1 cy1 cx2 cy2 cx3 cy3 -- )
    fbc-busy-wait 
	\ fix the registers to what we currently expect
	h# a980cccc fbc_alu!
	h# 00220000 fbc_mode!
    >pixel 
    1 
    -
    fbc_y3!
    1 
    - 
    fbc_x3!
    >pixel 
    fbc_y2!
    fbc_x2! 
    >pixel 
    1 
    - 
    fbc_y1! 
    1 
    - 
    fbc_x1! 
    >pixel 
    fbc_y0!
    fbc_x0! 
    fbc-blit-wait 
    fbc-busy-wait 
;

\ fill a rectangle of char with background-color
: fbc-char-fill ( cw0 ch0 cw1 ch1 -- )
    2swap
    >pixel
    2swap
    >pixel
    bground-color 
    fbc-rect-fill 
;

: fbc-erase-screen ( -- )
  \ x0
  0
  \ y0
  0
  \ x1
  openbios-video-width 1 -
  \ y1
  openbios-video-height 1 -
  \ fg_col
  bground-color
  fbc-rect-fill
;

: fbc-delete-lines ( n -- )
    \ check if we move the whole screen
    dup #lines < if
        >r 
        0 
        line# 
        r@ 
        + 
        #columns 
        #lines 
        0 
        line# 
        #columns 
        #lines 
        r@ 
        - 
        line#
		\ check if there's some lines at the bottom to blit
        r@ + #lines < if
		   fbc-blit
		else
			2drop 
           	2drop 
           	2drop 
           	2drop
		then
        0
        #lines 
        r> 
        - 
        #columns 
        #lines 
        fbc-char-fill
	else
        0 
        swap 
        #lines 
        swap 
        - 
        #columns 
        #lines 
        fbc-char-fill 
    then
;

: fbc-insert-lines ( n -- )
    dup #lines < if
        >r 
        0 
        line# 
        #columns 
        #lines 
        r@ 
        - 
        0 
        line# 
        r@ 
        + 
        #columns 
        #lines 
        fbc-blit 
        0 
        line# 
        #columns 
        line# 
        r> 
        + 
        fbc-char-fill 
	else
        0 
        swap 
        line# 
        swap 
        #columns 
        swap 
        line# 
        swap 
        + 
        fbc-char-fill 
    then 
;

\ unaccelerated placeholders, we need to wait before drawing
: cg6-blink-screen
 \ FIXME
;
: cg6-reset-screen
 \ FIXME
;
: cg6-draw-char
    fbc-busy-wait 
    fb8-draw-character 
;
: cg6-toggle-cursor
    fbc-busy-wait 
    fb8-toggle-cursor 
;
: cg6-invert-screen
    fbc-busy-wait 
    fb8-invert-screen 
;
: cg6-erase-screen
    fbc-busy-wait 
    fb8-erase-screen 
;
: cg6-insert-characters
    fbc-busy-wait 
    fb8-insert-characters 
;
: cg6-delete-characters
    fbc-busy-wait 
    fb8-delete-characters 
;
: cg6-delete-lines
    fbc-busy-wait 
    fb8-delete-lines 
;
: cg6-insert-lines
    fbc-busy-wait 
    fb8-insert-lines 
;
