: dphy_rst_rd ( -- csr_value )
	ddrphy-virt h# 0000 + l@
;
: dphy_half_sys8x_taps_rd ( -- csr_value )
	ddrphy-virt h# 0004 + l@
;
: dphy_wlevel_en_rd ( -- csr_value )
	ddrphy-virt h# 0008 + l@
;
: dphy_wlevel_strobe_rd ( -- csr_value )
	ddrphy-virt h# 000c + l@
;
: dphy_dly_sel_rd ( -- csr_value )
	ddrphy-virt h# 0010 + l@
;
: dphy_rdly_dq_rst_rd ( -- csr_value )
	ddrphy-virt h# 0014 + l@
;
: dphy_rdly_dq_inc_rd ( -- csr_value )
	ddrphy-virt h# 0018 + l@
;
: dphy_rdly_dq_bitslip_rst_rd ( -- csr_value )
	ddrphy-virt h# 001c + l@
;
: dphy_rdly_dq_bitslip_rd ( -- csr_value )
	ddrphy-virt h# 0020 + l@
;
: dphy_wdly_dq_bitslip_rst_rd ( -- csr_value )
	ddrphy-virt h# 0024 + l@
;
: dphy_wdly_dq_bitslip_rd ( -- csr_value )
	ddrphy-virt h# 0028 + l@
;
: dphy_rdphase_rd ( -- csr_value )
	ddrphy-virt h# 002c + l@
;
: dphy_wrphase_rd ( -- csr_value )
	ddrphy-virt h# 0030 + l@
;
: sdr_dfii_control_rd ( -- csr_value )
	sdram-virt h# 0000 + l@
;
: sdr_dfii_pi0_command_rd ( -- csr_value )
	sdram-virt h# 0004 + l@
;
: sdr_dfii_pi0_command_issue_rd ( -- csr_value )
	sdram-virt h# 0008 + l@
;
: sdr_dfii_pi0_address_rd ( -- csr_value )
	sdram-virt h# 000c + l@
;
: sdr_dfii_pi0_baddress_rd ( -- csr_value )
	sdram-virt h# 0010 + l@
;
: sdr_dfii_pi0_wrdata_rd ( -- csr_value )
	sdram-virt h# 0014 + l@
;
: sdr_dfii_pi0_rddata_rd ( -- csr_value )
	sdram-virt h# 0018 + l@
;
: sdr_dfii_pi1_command_rd ( -- csr_value )
	sdram-virt h# 001c + l@
;
: sdr_dfii_pi1_command_issue_rd ( -- csr_value )
	sdram-virt h# 0020 + l@
;
: sdr_dfii_pi1_address_rd ( -- csr_value )
	sdram-virt h# 0024 + l@
;
: sdr_dfii_pi1_baddress_rd ( -- csr_value )
	sdram-virt h# 0028 + l@
;
: sdr_dfii_pi1_wrdata_rd ( -- csr_value )
	sdram-virt h# 002c + l@
;
: sdr_dfii_pi1_rddata_rd ( -- csr_value )
	sdram-virt h# 0030 + l@
;
: sdr_dfii_pi2_command_rd ( -- csr_value )
	sdram-virt h# 0034 + l@
;
: sdr_dfii_pi2_command_issue_rd ( -- csr_value )
	sdram-virt h# 0038 + l@
;
: sdr_dfii_pi2_address_rd ( -- csr_value )
	sdram-virt h# 003c + l@
;
: sdr_dfii_pi2_baddress_rd ( -- csr_value )
	sdram-virt h# 0040 + l@
;
: sdr_dfii_pi2_wrdata_rd ( -- csr_value )
	sdram-virt h# 0044 + l@
;
: sdr_dfii_pi2_rddata_rd ( -- csr_value )
	sdram-virt h# 0048 + l@
;
: sdr_dfii_pi3_command_rd ( -- csr_value )
	sdram-virt h# 004c + l@
;
: sdr_dfii_pi3_command_issue_rd ( -- csr_value )
	sdram-virt h# 0050 + l@
;
: sdr_dfii_pi3_address_rd ( -- csr_value )
	sdram-virt h# 0054 + l@
;
: sdr_dfii_pi3_baddress_rd ( -- csr_value )
	sdram-virt h# 0058 + l@
;
: sdr_dfii_pi3_wrdata_rd ( -- csr_value )
	sdram-virt h# 005c + l@
;
: sdr_dfii_pi3_rddata_rd ( -- csr_value )
	sdram-virt h# 0060 + l@
;
: dphy_rst_wr ( value -- )
	ddrphy-virt h# 0000 + l!
;
: dphy_half_sys8x_taps_wr ( value -- )
	ddrphy-virt h# 0004 + l!
;
: dphy_wlevel_en_wr ( value -- )
	ddrphy-virt h# 0008 + l!
;
: dphy_wlevel_strobe_wr ( value -- )
	ddrphy-virt h# 000c + l!
;
: dphy_dly_sel_wr ( value -- )
	ddrphy-virt h# 0010 + l!
;
: dphy_rdly_dq_rst_wr ( value -- )
	ddrphy-virt h# 0014 + l!
;
: dphy_rdly_dq_inc_wr ( value -- )
	ddrphy-virt h# 0018 + l!
;
: dphy_rdly_dq_bitslip_rst_wr ( value -- )
	ddrphy-virt h# 001c + l!
;
: dphy_rdly_dq_bitslip_wr ( value -- )
	ddrphy-virt h# 0020 + l!
;
: dphy_wdly_dq_bitslip_rst_wr ( value -- )
	ddrphy-virt h# 0024 + l!
;
: dphy_wdly_dq_bitslip_wr ( value -- )
	ddrphy-virt h# 0028 + l!
;
: dphy_rdphase_wr ( value -- )
	ddrphy-virt h# 002c + l!
;
: dphy_wrphase_wr ( value -- )
	ddrphy-virt h# 0030 + l!
;
: sdr_dfii_control_wr ( value -- )
	sdram-virt h# 0000 + l!
;
: sdr_dfii_pi0_command_wr ( value -- )
	sdram-virt h# 0004 + l!
;
: sdr_dfii_pi0_command_issue_wr ( value -- )
	sdram-virt h# 0008 + l!
;
: sdr_dfii_pi0_address_wr ( value -- )
	sdram-virt h# 000c + l!
;
: sdr_dfii_pi0_baddress_wr ( value -- )
	sdram-virt h# 0010 + l!
;
: sdr_dfii_pi0_wrdata_wr ( value -- )
	sdram-virt h# 0014 + l!
;
: sdr_dfii_pi0_rddata_wr ( value -- )
	sdram-virt h# 0018 + l!
;
: sdr_dfii_pi1_command_wr ( value -- )
	sdram-virt h# 001c + l!
;
: sdr_dfii_pi1_command_issue_wr ( value -- )
	sdram-virt h# 0020 + l!
;
: sdr_dfii_pi1_address_wr ( value -- )
	sdram-virt h# 0024 + l!
;
: sdr_dfii_pi1_baddress_wr ( value -- )
	sdram-virt h# 0028 + l!
;
: sdr_dfii_pi1_wrdata_wr ( value -- )
	sdram-virt h# 002c + l!
;
: sdr_dfii_pi1_rddata_wr ( value -- )
	sdram-virt h# 0030 + l!
;
: sdr_dfii_pi2_command_wr ( value -- )
	sdram-virt h# 0034 + l!
;
: sdr_dfii_pi2_command_issue_wr ( value -- )
	sdram-virt h# 0038 + l!
;
: sdr_dfii_pi2_address_wr ( value -- )
	sdram-virt h# 003c + l!
;
: sdr_dfii_pi2_baddress_wr ( value -- )
	sdram-virt h# 0040 + l!
;
: sdr_dfii_pi2_wrdata_wr ( value -- )
	sdram-virt h# 0044 + l!
;
: sdr_dfii_pi2_rddata_wr ( value -- )
	sdram-virt h# 0048 + l!
;
: sdr_dfii_pi3_command_wr ( value -- )
	sdram-virt h# 004c + l!
;
: sdr_dfii_pi3_command_issue_wr ( value -- )
	sdram-virt h# 0050 + l!
;
: sdr_dfii_pi3_address_wr ( value -- )
	sdram-virt h# 0054 + l!
;
: sdr_dfii_pi3_baddress_wr ( value -- )
	sdram-virt h# 0058 + l!
;
: sdr_dfii_pi3_wrdata_wr ( value -- )
	sdram-virt h# 005c + l!
;
: sdr_dfii_pi3_rddata_wr ( value -- )
	sdram-virt h# 0060 + l!
;
