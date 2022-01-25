fload sdram_csr.fth

\ useful stuff

\ : popcnt ( n -- u)
\    0 swap
\    BEGIN dup WHILE tuck 1 AND +  swap 1 rshift REPEAT
\    DROP
\ ;

: cdelay ( count -- )
	\ Forth loop always have a least one iteration
	dup 0<> if
		0 do noop loop
	else drop then
;

\ helpers

: sdram_software_control_on ( -- )
	sdr_dfii_control_rd
	h# e <> if h# e sdr_dfii_control_wr then
;

: sdram_software_control_off ( -- )
	sdr_dfii_control_rd
	h# 1 <> if h# 1 sdr_dfii_control_wr then
;

\ only p0 is really used

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

\ init for 2.13a (might need change for others?)

: init_sequence ( -- )
	\ .( init_sequence ) cr
	\ Release reset
	h# 0 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# c sdr_dfii_control_wr
	5 ms

	\ Bring CKE high
	h# 0 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# e sdr_dfii_control_wr
	1 ms

	\ Load Mode register 2, CWL=5
	h# 200 sdr_dfii_pi0_address_wr
	h# 2 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	\ Load Mode register 3
	h# 0 sdr_dfii_pi0_address_wr
	h# 3 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	\ Load Mode Register 1
	h# 6 sdr_dfii_pi0_address_wr
	h# 1 sdr_dfii_pi0_baddress_wr
	h# f command_p0

	\ Load Mode Register 0, CL=6, BL=8
	h# 920 sdr_dfii_pi0_address_wr
	h# 0 sdr_dfii_pi0_baddress_wr
	h# f command_p0
	200 cdelay

	\ ZQ Calibration
	h# 400 sdr_dfii_pi0_address_wr
	0 sdr_dfii_pi0_baddress_wr
	h# 3 command_p0
	200 cdelay
;

: init_sdram ( -- )
	\ .( init_sdram ) cr
	2 dphy_rdphase_wr
	3 dphy_wrphase_wr
	sdram_software_control_on
	1 dphy_rst_wr
	1 ms
	0 dphy_rst_wr
	1 ms
	\ .( going to init_sequence ) cr
	init_sequence
	\ .( hw ctrl ) cr
	sdram_software_control_off
	
	\ .( config module 0 write ) cr
	1 dphy_dly_sel_wr
	1 dphy_wdly_dq_bitslip_rst_wr
	\ 0 bitslip
	0 dphy_dly_sel_wr
	
	\ .( config module 1 write ) cr
	2 dphy_dly_sel_wr
	1 dphy_wdly_dq_bitslip_rst_wr
	\ 0 bitslip
	0 dphy_dly_sel_wr
	
	\ .( config module 0 read ) cr
	1 dphy_dly_sel_wr
	1 dphy_rdly_dq_bitslip_rst_wr
	m0_bitslip 0 do
		1 0 do 1 dphy_rdly_dq_bitslip_wr loop
	loop
	1 dphy_rdly_dq_rst_wr
	m0_delay 0 do
	   1 dphy_rdly_dq_inc_wr
	loop
	
	\ .( config module 1 read ) cr
	2 dphy_dly_sel_wr
	1 dphy_rdly_dq_bitslip_rst_wr
	m1_bitslip 0 do
		1 0 do 1 dphy_rdly_dq_bitslip_wr loop
	loop
	1 dphy_rdly_dq_rst_wr
	m1_delay 0 do
	   1 dphy_rdly_dq_inc_wr
	loop
	\ .( finish ) cr
	0 dphy_dly_sel_wr
	\ .( done ) cr
;

: init! ( -- )
	\ .( init ) cr
  	map-in-mregs
  	init_sdram
  	map-out-mregs
;

