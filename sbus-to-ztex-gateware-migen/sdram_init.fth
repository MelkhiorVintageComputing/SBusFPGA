headers

fload sdram_csr.fth

external

: popcnt ( n -- u)
   0 swap
   BEGIN dup WHILE tuck 1 AND +  swap 1 rshift REPEAT
   DROP
;

: cdelay ( count -- )
	\ Forth loop always have a least one iteration
	dup 0<> if
		0 do noop loop
	else drop then
;

headers

: sdram_software_control_on ( -- )
	sdr_dfii_control_rd
	h# e <> if h# e sdr_dfii_control_wr then
;

: sdram_software_control_off ( -- )
	sdr_dfii_control_rd
	h# 1 <> if h# 1 sdr_dfii_control_wr then
;

: command_p0 ( cmd -- )
	sdr_dfii_pi0_command_wr
	1 sdr_dfii_pi0_command_issue_wr
;
: command_p1 ( cmd -- )
	sdr_dfii_pi1_command_wr
	1 sdr_dfii_pi1_command_issue_wr
;
: command_p2 ( cmd -- )
	sdr_dfii_pi2_command_wr
	1 sdr_dfii_pi2_command_issue_wr
;
: command_p3 ( cmd -- )
	sdr_dfii_pi3_command_wr
	1 sdr_dfii_pi3_command_issue_wr
;

: init_sequence ( -- )
	.( init_sequence ) cr
	h# 0 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# c sdr_dfii_control_wr
	50 ms

	h# 0 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# e sdr_dfii_control_wr
	10 ms

	h# 200 sdr_dfii_pi0_address_wr
	h# 2 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	h# 0 sdr_dfii_pi0_address_wr
	h# 3 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	h# 6 sdr_dfii_pi0_address_wr
	h# 1 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	h# 920 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# f command_p0
	200 cdelay

	h# 400 sdr_dfii_pi0_address_wr
	0 sdr_dfii_pi0_baddress_wr
	h# 3 command_p0
	200 cdelay
;

: sdram_read_leveling_rst_delay ( modulenum -- )
	h# 1 swap << dphy_dly_sel_wr
	h# 1 dphy_rdly_dq_rst_wr
	h# 0 dphy_dly_sel_wr
;

: sdram_read_leveling_inc_delay ( modulenum -- )
	h# 1 swap << dphy_dly_sel_wr
	h# 1 dphy_rdly_dq_inc_wr
	h# 0 dphy_dly_sel_wr
;

: sdram_read_leveling_rst_bitslip ( modulenum -- )
	h# 1 swap << dphy_dly_sel_wr
	h# 1 dphy_rdly_dq_bitslip_rst_wr
	h# 0 dphy_dly_sel_wr
;

: sdram_read_leveling_inc_bitslip ( modulenum -- )
	h# 1 swap << dphy_dly_sel_wr
	h# 1 dphy_rdly_dq_bitslip_wr
	h# 0 dphy_dly_sel_wr
;

: lfsr ( bits prev -- res )
	dup 1 and not ( bits prev -- bits prev ~{prev&1} )
	swap 1 >> ( bits prev ~{prev&1} -- bits ~{prev&1} {prev>>1} )
	swap ( bits prev ~{prev&1} -- bits {prev>>1} ~{prev&1} )
	rot ( bits {prev>>1} ~{prev&1} -- {prev>>1} ~{prev&1} bits )
	\ assume bits is 32, 'cause it is
	drop h# 80200003 ( {prev>>1} ~{prev&1} bits --  {prev>>1} ~{prev&1} lfsr_taps[bits] )
	and
	xor
;

: sdram_activate_test_row ( -- )
	h# 0 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# 9 command_p0
	15 cdelay
;

: sdram_precharge_test_row ( -- )	
  	h# 0 sdr_dfii_pi0_address_wr
  	h# 0 sdr_dfii_pi0_baddress_wr
  	h# b command_p0
  	15 cdelay
;

: command_px ( phase value -- )
	over 3 = if dup command_p3 then
	over 2 = if dup command_p2 then
	over 1 = if dup command_p1 then
	over 0 = if dup command_p0 then
	2drop
;

: command_prd ( value -- )
	dphy_rdphase_rd
	swap command_px
;

: command_pwr ( value -- )
	dphy_wrphase_rd
	swap command_px
;

: sdr_dfii_pix_address_wr ( phase value -- )
	over 3 = if dup sdr_dfii_pi3_address_wr then
	over 2 = if dup sdr_dfii_pi2_address_wr then
	over 1 = if dup sdr_dfii_pi1_address_wr then
	over 0 = if dup sdr_dfii_pi0_address_wr then
	2drop
;

: sdr_dfii_pird_address_wr ( value -- )
	dphy_rdphase_rd
	swap sdr_dfii_pix_address_wr
;

: sdr_dfii_piwr_address_wr ( value -- )
	dphy_wrphase_rd
	swap sdr_dfii_pix_address_wr
;

: sdr_dfii_pix_baddress_wr ( phase value -- )
	over 3 = if dup sdr_dfii_pi3_baddress_wr then
	over 2 = if dup sdr_dfii_pi2_baddress_wr then
	over 1 = if dup sdr_dfii_pi1_baddress_wr then
	over 0 = if dup sdr_dfii_pi0_baddress_wr then
	2drop
;

: sdr_dfii_pird_baddress_wr ( value -- )
	dphy_rdphase_rd
	swap sdr_dfii_pix_baddress_wr
;

: sdr_dfii_piwr_baddress_wr ( value -- )
	dphy_wrphase_rd
	swap sdr_dfii_pix_baddress_wr
;

: sdr_wr_rd_chk_tst_pat_get ( seed -- A B C D )
\	.( sdr_wr_rd_chk_tst_pat_get ) cr
	dup 42 = if h# 00000080 swap then
	dup 42 = if h# 00000000 swap then
	dup 42 = if h# 00000000 swap then
	dup 42 = if h# 15090700 swap then
	dup 84 = if h# 00000000 swap then
	dup 84 = if h# 00000000 swap then
	dup 84 = if h# 00000000 swap then
	dup 84 = if h# 2a150907 swap then
	drop
;

: sdr_wr_rd_check_test_pattern ( modulenum seed -- errors )
\	.( sdr_wr_rd_check_test_pattern ) cr
	sdram_activate_test_row
	dup sdr_wr_rd_chk_tst_pat_get
	\ should have the 4 patterns on top of the stack: modulenum seed p0 p1 p2 p3
	sdr_dfii_pi0_wrdata_wr
	sdr_dfii_pi1_wrdata_wr
	sdr_dfii_pi2_wrdata_wr
	sdr_dfii_pi3_wrdata_wr
	\ should be back at modulenum seed
	h# 0 sdr_dfii_piwr_address_wr
	h# 0 sdr_dfii_piwr_baddress_wr
	h# 17 command_pwr
	15 cdelay

  	h# 0 sdr_dfii_pird_address_wr
 	h# 0 sdr_dfii_pird_baddress_wr
	h# 25 command_prd
	15 cdelay

	sdram_precharge_test_row

	sdr_wr_rd_chk_tst_pat_get
	\ should have the 4 patterns on top of the stack: modulenum p0 p1 p2 p3
	sdr_dfii_pi0_rddata_rd xor popcnt
	\ should be at modulenum p0 p1 p2 errors
	swap sdr_dfii_pi0_rddata_rd xor popcnt +
	\ should be at modulenum p0 p1 errors
	swap sdr_dfii_pi0_rddata_rd xor popcnt +
	\ should be at modulenum p0 errors
	swap sdr_dfii_pi0_rddata_rd xor popcnt +
	\ should be at modulenum errors
	\ drop modulenum
	nip
;

: sdram_read_leveling_scan_module ( modulenum bitslip -- score )
\	.( sdram_read_leveling_scan_module ) cr
	over sdram_read_leveling_rst_delay
	\ push score
	0
	\ we should be at 'modulenum bitslip score'
	32 0 do
\		.( starting rd_lvl_scan loop with stack: ) .s cr
		2 pick 42 sdr_wr_rd_check_test_pattern
		\ now we have an error count at the top
		3 pick 84 sdr_wr_rd_check_test_pattern
		\ merge both error count
		+
		\ we should be at 'modulenum bitslip score errorcount'
		dup 0=
		\ we should be at 'modulenum bitslip score errorcount working?'
		if 16384 else 0 then
		\ we should be at 'modulenum bitslip score errorcount (0|16384)'
		swap 512 swap -
		\ we should be at 'modulenum bitslip score (0|16384) (512-errorcount)'
		+
		+
		\ we should be at 'modulenum bitslip score'
		2 pick sdram_read_leveling_inc_delay
	loop
	nip
	nip
;

: sdr_wr_lat_cal_bitslip_loop ( modulenum bestbitslip bestscore bitslip -- modulenum bestbitslip bestscore )
\	.( sdr_wr_lat_cal_bitslip_loop for module: ) 3 pick . .(  bitslip: ) dup . cr
\	.( sdr_wr_lat_cal_bitslip_loop, stack: ) .s cr
	1 4 pick << dphy_dly_sel_wr ( '4 pick' will extract modulenum, needed as we're stacking the '1' )
	1 dphy_wdly_dq_bitslip_rst_wr
	\ Forth loop always have a least one iteration
	dup 0<> if
		dup 0 do
			1 dphy_wdly_dq_bitslip_wr
		loop
	then
	0 dphy_dly_sel_wr
\	.( sdr_wr_lat_cal_bitslip_loop after bitslip init loop, stack: ) .s cr
	\ push current score
	0 ( we should be at 'modulenum bestbitslip bestscore bitslip score' )
	4 pick sdram_read_leveling_rst_bitslip
	8 0 do
		4 pick over sdram_read_leveling_scan_module
		\ we should be at 'modulenum bestbitslip bestscore bitslip score score', max will merge scores
		max
		\ we should be at 'modulenum bestbitslip bestscore bitslip score' again
		4 pick sdram_read_leveling_inc_bitslip		
	loop
	.( sdr_wr_lat_cal_bitslip_loop after bitslip check loop, stack: ) .s cr
	dup 3 pick >
	if
\		.( lat_cal best bitslip was: ) 3 pick . .( with score: ) 2 pick . cr
		2swap
		.( lat_cal best bitslip now: ) 3 pick . .( with score: ) 2 pick . cr
	then
	2drop
\	.( sdr_wr_lat_cal_bitslip_loop end, stack: ) .s cr
;

: sdr_wr_lat_cal_module_loop ( modulenum -- )
	.( sdr_wr_lat_cal_module_loop for module: ) dup . cr
	\ push best_bitslip
	-1
	\ push best_score
	0
	\ we should have 'modulenum 1 0'
	8 0 do
		i sdr_wr_lat_cal_bitslip_loop
	2 +loop
	\ we should be at 'modulenum bestbitslip bestscore'
	\ we don't need score anymore
	drop
	\ we should be at 'modulenum bestbitslip'
	1 2 pick << dphy_dly_sel_wr
	1 dphy_wdly_dq_bitslip_rst_wr
	.( sdr_wr_lat_cal_module_loop: best bitslip: ) dup . cr
	\ loop that consumes bestbitslip as the upper bound
	\ Forth loop always have a least one iteration
	dup 0<> if
		0 do
			1 dphy_wdly_dq_bitslip_wr	
		loop
	else drop then
	0 dphy_dly_sel_wr
	\ drop the modulenum
	drop
;

: sdram_write_latency_calibration ( -- )
	.( sdram_write_latency_calibration ) cr
	2 0 do
		i sdr_wr_lat_cal_module_loop
	loop
;

: sdram_leveling_center_module ( modulenum -- )
	.( sdram_leveling_center_module ) cr
	dup sdram_read_leveling_rst_delay
	\ push delay_min
	-1
	\ push delay
	0
	\ we should be at 'modulenum delay_min delay'
	begin
\		.( starting lvl_center loop with stack: ) .s cr
		2 pick 42 sdr_wr_rd_check_test_pattern
		.( we should be at 'modulenum delay_min delay error' stack: ) .s cr
		3 pick 84 sdr_wr_rd_check_test_pattern
		.( we should be at 'modulenum delay_min delay error error' stack: ) .s cr
		+
		\ we should be at 'modulenum delay_min delay error'
\		.( we should be at 'modulenum delay_min delay error' stack: ) .s cr
		0=
		\ we should be at 'modulenum delay_min delay working'
\		.( we should be at 'modulenum delay_min delay working' stack: ) .s cr
		2 pick 0< and
		\ we should be at 'modulenum delay_min delay {working&delay_min<0}'
\		.( we should be at 'modulenum delay_min delay {working&delay_min<0}' stack: ) .s cr
		dup if rot drop 2dup rot drop then
		not
		\ we should be at 'modulenum new_delay_min delay !{working&delay_min<0}'
\		.( we should be at 'modulenum new_delay_min delay !{working&delay_min<0}' stack: ) .s cr
		\ test delay before incrementing, if already 31 no point in continuing/incrementing
		over 31 <
\		.( we should be at 'modulenum new_delay_min delay !{working&delay_min<0} <31' stack: ) .s cr
		dup if rot 1+ -rot then
		dup if 4 pick sdram_read_leveling_inc_delay then
		\ and the conditions to signal end-of-loop
		and
\		.( we should be at 'modulenum new_delay_min delay !{working&delay_min<0}&<31' stack: ) .s cr
\		.( finishing lvl_center loop with stack: ) .s cr
	not until
	\ we should be at 'modulenum new_delay_min delay', the while has consumed the condition
	.( we should be at 'modulenum new_delay_min delay' stack: ) .s cr
	1+
	2 pick sdram_read_leveling_inc_delay
	\ build a clean stack, startin with a copy of modulenum
	2 pick
	\ push delay_max
	-1
	\ we're at 'modulenum new_delay_min delay modulenum delay_max'
	\ push delay
	2 pick
	\ we're at 'modulenum new_delay_min delay modulenum delay_max delay'
	.( we should be at 'modulenum new_delay_min delay modulenum delay_max delay ' stack: ) .s cr
	\ this is almost the same loop, except with !working instead of working and delay_max instead of delay_min
	begin
		2 pick 42 sdr_wr_rd_check_test_pattern
		3 pick 84 sdr_wr_rd_check_test_pattern
		+
		\ we should be at 'modulenum delay_max delay error'
		0<>
		\ we should be at 'modulenum delay_max delay !working'
		2 pick 0< and
		\ we should be at 'modulenum delay_max delay {!working&delay_max<0}'
		dup if rot drop 2dup rot drop then
		not
		\ we should be at 'modulenum new_delay_max delay !{!working&delay_max<0}'
		\ test delay before incrementing, if already 31 no point in continuing/incrementing
		over 31 <
		dup not if rot 1+ -rot then
		dup not if 4 pick sdram_read_leveling_inc_delay then
		\ and the conditions to signal end-of-loop
		and
	not until
	\ we should be at 'modulenum new_delay_min delay modulenum new_delay_max delay', the while has consumed the condition
	.( we should be at 'modulenum new_delay_min delay modulenum new_delay_max delay ' stack: ) .s cr
	\ keep delay if new_delay_max<0, new_delay_max otherwise
	over 0< if nip else drop then
	\ we should be at 'modulenum new_delay_min delay modulenum new_delay_max'
	nip
	nip
	\ we should be at 'modulenum new_delay_min new_delay_max'
	.( we should be at 'modulenum new_delay_min new_delay_max' stack: ) .s cr
	\ compute delay_mid
	2dup + 2/ 32 mod
	\ we should be at 'modulenum new_delay_min new_delay_max {{new_delay_min+new_delay_max}/2%32}'
	\ compute delay_range
	3dup drop swap - 2/
	\ we should be at 'modulenum new_delay_min new_delay_max {{new_delay_min+new_delay_max}/2%32} {{new_delay_max-new_delay_min}/2}'
	.( we should be at 'modulenum new_delay_min new_delay_max delay_mid delay_range ' stack: ) .s cr
	4 pick sdram_read_leveling_rst_delay
	100 cdelay
	\ Forth loop always have a least one iteration
	over 0<> if
		over 0 do
			4 pick sdram_read_leveling_inc_delay
			100 cdelay
		loop
	then
	drop
	drop
	drop
	drop
	drop
;

: sdr_rd_lvl_bitslip_loop ( modulenum bestbitslip bestscore bitslip -- modulenum bestbitslip bestscore )
\	.( sdr_rd_lvl_bitslip_loop, stack: ) .s cr
	3 pick over sdram_read_leveling_scan_module
	\ we should be at 'modulenum bestbitslip bestscore bitslip score'
	4 pick sdram_leveling_center_module
	\ preserve a bitslip for the later test
	over
	\ (we should be at 'modulenum bestbitslip bestscore bitslip score bitslip') move it out of the way
	.( we should be at 'modulenum bestbitslip bestscore bitslip score bitslip' stack: ) .s cr
	5 roll ( 'modulenum bestscore bitslip score bitslip bestbitslip' )
	5 roll ( 'modulenum bitslip score bitslip bestbitslip bestscore' )
	5 roll ( 'modulenum score bitslip bestbitslip bestscore bitslip' )
	5 roll ( 'modulenum bitslip bestbitslip bestscore bitslip score' )
	.( we should be at 'modulenum bitslip bestbitslip bestscore bitslip score' stack: ) .s cr
	\ compare the score and bestcore
	dup 3 pick >
	if
		2swap
		.( rd_lvl best bitslip now: ) 3 pick . .( with score: ) 2 pick . cr
	then
	2drop
	\ we should be at 'modulenum bitslip bestbitslip bestscore'
	rot
	\ we should be at 'modulenum bestbitslip bestscore bitslip'
	.( we should be at 'modulenum bestbitslip bestscore bitslip' stack: ) .s cr
	7 <> if 2 pick sdram_read_leveling_inc_bitslip then
;

: sdr_rd_lvl_module_loop ( modulenum -- )
	.( sdr_rd_lvl_module_loop ) cr
	1 over << sdram_read_leveling_rst_bitslip
	\ push best_bitslip
	0
	\ push best_score
	0
	\ we should have 'modulenum 0 0'
	8 0 do
		i sdr_rd_lvl_bitslip_loop
	loop
	\ don't need the score anymore
	drop
	2 pick sdram_read_leveling_rst_bitslip
	.( sdr_rd_lvl_module_loop, best bitslip: ) dup . cr
	\ Forth loop always have a least one iteration
	dup 0<> if
	\ consume best_bitslip as loop upper bound	
		0 do
			dup sdram_leveling_center_module
		loop
	else drop then
	drop
;

: sdram_read_leveling ( -- )
	.( sdram_read_leveling ) cr
	2 0 do
		i sdr_rd_lvl_module_loop
	loop
;

: sdram_leveling ( -- )
	.( sdram_leveling ) cr
	sdram_software_control_on
	2 0 do
		i sdram_read_leveling_rst_delay
		i sdram_read_leveling_rst_bitslip
	loop
	sdram_write_latency_calibration
	sdram_read_leveling
	sdram_software_control_off
;

external

: init_sdram ( -- )
	.( init_sdram ) cr
	2 dphy_rdphase_wr
	3 dphy_wrphase_wr
	sdram_software_control_on
	1 dphy_rst_wr
	1 ms
	0 dphy_rst_wr
	1 ms
	.( going to init_sequence ) cr
	init_sequence
	.( going to sdram_leveling ) cr
	sdram_leveling
	\ redundant
	sdram_software_control_off
;

: init! ( -- )
	.( init ) cr
  	map-in-mregs
  	init_sdram
  	map-out-mregs
;
