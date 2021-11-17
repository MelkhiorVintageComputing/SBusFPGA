\ DMA BLOCK2MEM (read)

headers

" block"  encode-string " device_type" property \ underscore in the peoprtye name...

0 instance value offset-low
0 instance value offset-high
0 instance value label-package
0 value deblocker-package

h# 10000 constant maxdmasize
-1 instance value dmasize
-1 instance value dmaaddr
-1 instance value dmadev

: sdblock2mem_dma_base_write! ( val -- )
  0 sdblock2mem-virt h# 0 + l! ( MSB )
  sdblock2mem-virt h# 4 + l! ( LSB )
;
: sdblock2mem_dma_length_write! ( val -- )
  sdblock2mem-virt h# 8 + l!
;
: sdblock2mem_dma_enable_write! ( val -- )
  sdblock2mem-virt h# c + l!
;
: sdblock2mem_dma_done_read@ ( -- val )
  sdblock2mem-virt h# 10 + l@
;

: sdcard_read_single_block ( block# -- res )
  h# 200 sdcore_block_length_write!
  1 sdcore_block_count_write!
  begin
    dup h# 11 h# 21 sdcard_send_command
    0=
  until
  drop
  sdcard_wait_data_done
;
: sdcard_read_multiple_blocks ( block# #blocks -- res )
\  .( sdcard_read_multiple_blocks: stack is ) .s cr
  h# 200 sdcore_block_length_write!
  dup sdcore_block_count_write!
  begin
    over h# 12 h# 21 sdcard_send_command
    0=
  until
  2drop
  sdcard_wait_data_done
\  .( sdcard_read_multiple_blocks: END stack is ) .s cr
;

: sdcard_write_single_block ( block# -- res )
  h# 200 sdcore_block_length_write!
  1 sdcore_block_count_write!
  begin
    dup h# 18 h# 41 sdcard_send_command
    0=
  until
  drop
  sdcard_wait_data_done
;
: sdcard_write_multiple_blocks ( block# #blocks -- res )
  h# 200 sdcore_block_length_write!
  dup sdcore_block_count_write!
  begin
    over h# 19 h# 41 sdcard_send_command
    0=
  until
  2drop
  sdcard_wait_data_done
;

: sdcard_stop_transmission ( -- res )
  h# 0 h# c h# 3 sdcard_send_command
;

external

: dma-alloc ( n -- vaddr )
\  .( dma-alloc: stack is ) .s cr
  " dma-alloc" $call-parent
\  .( dma-alloc: END stack is ) .s cr
;
: dma-free ( vaddr n -- )
\  .( dma-free: stack is ) .s cr
  " dma-free" $call-parent
;
: dma-map-in ( vaddr n cache? -- devaddr )
\  .( dma-map-in: stack is ) .s cr
  " dma-map-in" $call-parent
\  .( dma-map-in: END stack is ) .s cr
;
: dma-map-out ( vaddr devaddr n -- )
\  .( dma-map-out: stack is ) .s cr
  " dma-map-out" $call-parent
;
\ dma-sync could be dummy routine if parent device doesn't support.
: dma-sync ( virt-addr dev-addr size -- )
   " dma-sync" my-parent ['] $call-method catch if
      2drop 2drop 2drop
   then
;

: dma-setup ( adr #bytes -- )
  to dmasize
  to dmaaddr
  dmaaddr dmasize false  " dma-map-in" $call-parent to dmadev
;
: dma-release  ( -- )
   dmaaddr dmadev dmasize " dma-map-out" $call-parent
;

\ : get-dmabuf ( -- )
\   dmasize dma-alloc to dmaaddr
\   dmaaddr dmasize false dma-map-in to dmadev
\ ;

\ : drop-dmabuf ( -- )
\   dmaaddr dmadev dmasize dma-map-out
\   -1 to dmadev
\   dmaaddr dmasize dma-free
\   -1 to dmaaddr
\ ;

external

: read-blocks ( adr block# #blocks -- #done)
\  .( read-blocks: stack is ) .s cr
\  .( RB: ) .s cr
  
  \ h# 80 0 do
  \  2 pick i 4 * + h# deadbeef swap l!
  \ loop

  2 pick over h# 200 * dma-setup

  dmaaddr dmadev dmasize dma-sync

  0 sdblock2mem_dma_enable_write!
  \ 2 pick sdblock2mem_dma_base_write!
  dmadev sdblock2mem_dma_base_write!
  dup h# 200 * sdblock2mem_dma_length_write!
  1 sdblock2mem_dma_enable_write!
  
  2dup sdcard_read_multiple_blocks
  dup 0<> if .( sdcard_read_multiple_blocks failed ) . cr 0 exit then drop
  begin
    1 ms
    sdblock2mem_dma_done_read@
	1 and 0<>
  until
  dup 1 > if sdcard_stop_transmission drop then

  dmaaddr dmadev dmasize dma-sync

  dma-release

  \ dup h# 80 * 0 do
  \   dmaaddr i 4 * + l@
  \   3 pick i 4 * + l!
  \ loop

  nip
  
\  h# 80 h# 70 do
\   over i 4 * dup .( @ ) . + l@ .( : ) . .( , )
\  loop cr
  
  nip
\  .( read-blocks: END stack is ) .s cr
;

headers

\ -1 instance value cur_adr
\ -1 instance value cur_block#
\ -1 instance value cur_#blocks
\ -1 instance value cur_#blocks_i
\ -1 instance value cur_#blocks_done

external

\ : read-blocks-wra ( adr block# #blocks -- #done)
\   .( read-blocks: stack is ) .s cr
\   to cur_#blocks
\   to cur_block#
\   to cur_adr
\   0 to cur_#blocks_i
\   0 to cur_#blocks_done
\   begin
\     cur_adr
\ 	cur_block#
\ 	cur_#blocks	128 > if 128 else cur_#blocks then
\ 	dup to cur_#blocks_i
\ 	\ sd-r-blocks-basic
\ 	read-blocks
\ 	drop
\ 	cur_adr          cur_#blocks_i h# 200 * + to cur_adr
\ 	cur_block#       cur_#blocks_i + to cur_block#
\ 	cur_#blocks      cur_#blocks_i - to cur_#blocks
\ 	cur_#blocks_done cur_#blocks_i + to cur_#blocks_done
\ 	cur_#blocks 0=
\   until
\   cur_#blocks_done
\ ;

: block-size ( -- val )
  h# 200
;

: max-transfer ( -- val )
  maxdmasize
;

: write-blocks ( adr block# #blocks -- #done )
\  .( write-blocks: stack is ) .s cr
  nip nip \ FIXME
;

: selftest ( -- fail? )
  false \ FIXME
;
: reset ( -- )
  \ FIXME
;
: seek ( offset.low offset.high -- okay? )
\  .( seek: stack is ) .s cr
\  .( S: ) .s cr
   offset-low offset-high d+      " seek"  deblocker-package $call-method
;
: read ( adr len -- actual-len )
\  .( read: stack is ) .s cr
\  .( R: ) .s cr
                                  " read"  deblocker-package $call-method
;
: write ( adr len -- actual-len )
\  .( write: stack is ) .s cr
\  .( W: ) .s cr
                                  " write" deblocker-package $call-method
;
: load ( adr -- size )
\  .( load: stack is ) .s cr
\  .( L: ) .s cr
                                  " load"  label-package     $call-method
;

: init-label-package ( -- okay? )
\  .( init-label-package: stack is ) .s cr
   \ 0 to offset-high
   \ 0 to offset-low
   my-args " disk-label" $open-package to label-package
   label-package if
      0 0 " offset" label-package $call-method
      to offset-high
	  to offset-low
	  \ .( offset is: ) offset-high . offset-low . cr
 	  true
  else
     ." Can't open disk label package" cr
	 false
  then
;
: init-deblocker ( -- okay? )
\  .( init-deblocker: stack is ) .s cr
   " " " deblocker" $open-package to deblocker-package
   deblocker-package if
      true
   else
      ." Can't open deblocker package" cr false
   then
;

0 value open-count

: open ( -- ok? )
\  .( open: stack is ) .s cr
\   .( O: ) open-count .s cr
   open-count 0=  if
     init-deblocker 0= if
	   false
	   exit
     then
   then
   map-in-sdcard
   init-label-package 0= if
     open-count 0=  if
       deblocker-package close-package
	 then
     map-out-sdcard
     false
     exit
   then
   open-count 1+ to open-count
   true
\  .( open: END stack is ) .s cr
;
: close ( -- )
\  .( close: stack is ) .s cr
\   .( C: ) .s cr
   open-count 0 > if
     label-package close-package 0 to label-package
     map-out-sdcard
     open-count 1- to open-count
     open-count 0= if
       deblocker-package close-package 0 to deblocker-package
     then
   then
;

headers

\ map-in-sdcard
\ -1 instance value dmaaddr
\ -1 instance value dmadev
\ 4096 dma-alloc to dmaaddr
\ dmaaddr 4096 false dma-map-in to dmadev
\ h# 80 h# 0 do h# deadbeef dmaaddr i 4 * + l! loop
\ dmaaddr dmadev h# 10000 dma-sync
\ .( we have as addresses ) dmaaddr . dmadev . cr
\ dmadev 0 h# 80 read-blocks
\ .( we have read ) . ( blocks ) cr
\ dmaaddr dmadev 4090 dma-sync
\ h# 80 h# 70 do dmaaddr i 4 * + l@ .( @ ) i 4 * . .( : ) . .( , ) loop 
\ dmaaddr dmadev 4096 dma-map-out
\ dmaaddr 4096 dma-free 
\ map-out-sdcard

