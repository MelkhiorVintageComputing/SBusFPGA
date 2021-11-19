\ SDCORE

: sdcore_cmd_argument_write! ( val -- )
  sdcore-virt h# 0 + l!
;
: sdcore_cmd_command_write! ( val -- )
  sdcore-virt h# 4 + l!
;
: sdcore_cmd_send_write! ( val -- )
  sdcore-virt h# 8 + l!
;
\ 0c, 10, 14, 18 : response
: sdcore_cmd_event_read@ ( -- val )
  sdcore-virt h# 1c + l@
;
: sdcore_data_event_read@ ( -- val )
  sdcore-virt h# 20 + l@
;
: sdcore_block_length_write! ( val -- )
  sdcore-virt h# 24 + l!
;
: sdcore_block_count_write! ( val -- )
  sdcore-virt h# 28 + l!
;

\ SDPHY
\ 0 : card detect
: sdphy_clocker_divider_write! ( val -- )
  sdphy-virt h# 4 + l!
;
: sdphy_init_initialize_write! ( val -- )
  sdphy-virt h# 8 + l!
;
\ c : dataw status

\ HELPERS

: sdcard_wait_cmd_done ( -- res )
  0 ( dummy result )
  begin
    drop ( drop previous result )
    sdcore_cmd_event_read@
    1 ms \ should be 10 us
    dup h# 1 and 0<>
  until
  dup h# 4 and 0<> if drop h# 2 else
    dup h# 8 and 0<> if drop h# 1 else
	  drop 0
    then
  then
;

: sdcard_wait_data_done ( -- res )
  0 ( dummy result )
  begin
    drop ( drop previous result )
    sdcore_data_event_read@
	1 ms \ should be 10 us
	dup h# 1 and 0<>
  until
  dup h# 4 and 0<> if drop h# 2 else
    dup h# 8 and 0<> if drop h# 1 else
	  drop 0
    then
  then
;

: sdcard_send_command ( arg cmd rsp -- res )
  rot ( arg cmd rsp -- cmd rsp arg )
  sdcore_cmd_argument_write!
  swap ( cmd rsp -- rsp cmd )
  h# 8 <<
  or
  sdcore_cmd_command_write!
  h# 1 sdcore_cmd_send_write!
  sdcard_wait_cmd_done
;

: sdcard_go_idle ( -- res )
  0 0 0 sdcard_send_command
;

: sdcard_send_ext_csd ( -- res )
  h# 01aa h# 8 h# 1 sdcard_send_command
;

: sdcard_all_send_cid ( -- res)
  h# 0 h# 2 h# 2 sdcard_send_command
;

: sdcard_send_cid ( rca -- res )
  h# 10 << h# a h# 2 sdcard_send_command
;

: sdcard_send_csd ( rca -- res )
  h# 10 << h# 9 h# 2 sdcard_send_command
;

: sdcard_select_card ( rca -- res )
  h# 10 << h# 7 h# 3 sdcard_send_command
;

: sdcard_app_set_bus_width ( -- res )
  h# 2 h# 6 h# 1 sdcard_send_command
;

: sdcard_app_cmd ( rca -- res )
  h# 10 << h# 37 h# 1 sdcard_send_command
;

: sdcard_app_send_op_cond ( hcs -- res )
  0<> if h# 60000000 else h# 0 then
  h# 10ff8000 or
  h# 29 h# 3 sdcard_send_command
;

: sdcard_set_relative_address ( -- res )
  0 3 1 sdcard_send_command
;

: sdcard_decode_cid ( -- ) \ finish me
  sdcore-virt h# 0c + l@ ( 0:3p )
  sdcore-virt h# 10 + l@ ( 1:2p )
  sdcore-virt h# 14 + l@ ( 2:over )
  sdcore-virt h# 18 + l@ ( 3:dup )
  \ .( CID registers, current stack: ) .s cr
  \ 3 pick h# 10 >> h# ffff and
  \ .( Mfr id: ) . cr
  \ 3 pick h# ffff and
  \ .( App id: ) . cr
  2drop
  2drop
;

: sdcard_switch ( mode group value -- res )
  rot ( mode group value -- group value mode )
  h# 1f << h# ffffff or
  2 pick ( group value arg -- group value arg group  )
  h# 4 * h# f swap << h# ffffffff xor
  and
  swap ( group value arg -- group arg value )
  rot ( group arg value -- arg value group )
  h# 4 * <<
  or
  \ .( Switch arg, current stack: ) .s cr
  h# 40 sdcore_block_length_write!
  h# 1 sdcore_block_count_write!
  begin
    dup h# 6 h# 21 sdcard_send_command
	0=
  until
  drop
  sdcard_wait_data_done
;

: sdcard_app_send_scr ( -- res )
  h# 8 sdcore_block_length_write!
  h# 1 sdcore_block_count_write!
  begin
    0 h# 33 h# 21 sdcard_send_command
	0<>
  until
  sdcard_wait_data_done
;

: sdcard_app_set_blocklen ( blklen -- res )
  h# 10 h# 1 sdcard_send_command
;

\ VARIABLE

-1 instance value sdcard-good
-1 instance value rca
-1 instance value max_rd_blk_len
-1 instance value max_size_in_blk

\ MORE HELPERS

: sdcard_decode_rca ( -- )
  sdcore-virt h# 18 + l@
  h# 10 >> h# ffff and
  to rca
;

: sdcard_decode_csd ( -- )
  sdcore-virt h# 0c + l@ ( 0:3p )
  sdcore-virt h# 10 + l@ ( 1:2p )
  sdcore-virt h# 14 + l@ ( 2:over )
  sdcore-virt h# 18 + l@ ( 3:dup )
  \ .( CSD registers, current stack: ) .s cr
  2 pick h# 10 >> h# f and h# 1 swap <<
  to max_rd_blk_len
  over h# 10 >>
  3 pick ( one deeper as we have an extra element on the stack )
  h# ff and h# 10 <<
  + 1+ h# 400 *
  to max_size_in_blk
  2drop
  2drop
;

\ INIT

\ CID Register: 0x1b534d45_42315154_309d595f_40014947 Manufacturer ID: 0x1b53 Application ID 0x4d45 Product name: B1QT0 CRC: 47 Production date(m/yy): 9/20 PSN: 9d595f40 OID: SM
\ CSD Register: 0x400e0032_5b590000_ee7f7f80_0a404055 Max data transfer rate: 64 MB/s Max read block length: 512 bytes Device size: 29 GiB
\ rca is 0x00000001
\ switch arg is 0x80fffff1

: sdcard-init-full ( -- )
  0 to sdcard-good
  h# 100 sdphy_clocker_divider_write! 
  1 ms
  
  0 ( timeout )
  begin
    1+
	( Set SDCard in SPI Mode [generate 80 dummy clocks] )
    h# 1 sdphy_init_initialize_write!
	1 ms
	( Set SDCard in Idle state )
    sdcard_go_idle
    1 ms
    0=
    over 1000 >=
	or
  until
  \ .( After first timeout loop stack is: ) .s cr
  1000 >= if
  	   \ .( sdcard timeout 1 ) cr
	   exit
  then
  
  ( Set SDCard voltages, only supported by ver2.00+ SDCards )
  sdcard_send_ext_csd
  dup 0<> if .( sdcard_send_ext_csd failed ) . cr exit then drop
  
  ( Set SD clk freq to Operational frequency )
  h# 4 sdphy_clocker_divider_write!
  1 ms

  ( Set SDCard in Operational state  )
  0 ( timeout )
  begin
    1+
    0 sdcard_app_cmd
	drop
	1 sdcard_app_send_op_cond
	1 ms
    0<>
    over 1000 >=
	or
  until
  \ .( After second timeout loop stack is: ) .s cr
  1000 >= if
       \ .( sdcard timeout 2 ) cr
	   exit
  then
  
  ( Send identification )
  sdcard_all_send_cid
  dup 0<> if .( sdcard_all_send_cid failed ) . cr exit then drop
  sdcard_decode_cid
  
  ( Set Relative Card Address )
  sdcard_set_relative_address
  dup 0<> if .( sdcard_set_relative_address failed ) . cr exit then drop
  sdcard_decode_rca
  rca sdcard_send_cid
  dup 0<> if .( sdcard_send_cid failed ) . cr exit then drop
  rca sdcard_send_csd
  dup 0<> if .( sdcard_send_csd failed ) . cr exit then drop
  sdcard_decode_csd
  \ .( Max read block length: ) max_rd_blk_len . cr
  \ .( Max size in block: ) max_size_in_blk . cr
  
  ( Select card )
  rca sdcard_select_card
  dup 0<> if .( sdcard_select_card failed ) . cr exit then drop
  
  ( Set bus width )
  rca sdcard_app_cmd
  dup 0<> if .( sdcard_app_cmd failed ) . cr exit then drop
  sdcard_app_set_bus_width
  dup 0<> if .( sdcard_app_set_bus_width failed ) . cr exit then drop
  
  ( Switch speed )
  h# 1 h# 0 h# 1 sdcard_switch
  dup 0<> if .( sdcard_switch failed ) . cr exit then drop
  
  \ .( after switch speed stack is ) .s cr
  
  ( Send SCR )
  rca sdcard_app_cmd
  dup 0<> if .( sdcard_app_cmd failed ) . cr exit then drop
  sdcard_app_send_scr
  dup 0<> if .( sdcard_app_send_scr failed ) . cr exit then drop
  
  \ .( after send scr stack is ) .s cr
  
  ( Set block length )
  h# 200 sdcard_app_set_blocklen
  dup 0<> if .( sdcard_app_set_blocklen failed ) . cr exit then drop
  1 to sdcard-good

  \ .( at the end stack is ) .s cr
;

map-in-sdcard
sdcard-init-full
sdcard-good encode-int " sdcard-good" property
max_rd_blk_len encode-int " max_rd_blk_len" property
max_size_in_blk encode-int " max_size_in_blk" property
map-out-sdcard
