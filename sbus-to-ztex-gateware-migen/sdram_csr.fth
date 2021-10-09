: dphy_rst_rd ( -- csr_value )
	mregs-virt h# 1000 + l@
;
: dphy_half_sys8x_taps_rd ( -- csr_value )
	mregs-virt h# 1004 + l@
;
: dphy_wlevel_en_rd ( -- csr_value )
	mregs-virt h# 1008 + l@
;
: dphy_wlevel_strobe_rd ( -- csr_value )
	mregs-virt h# 100c + l@
;
: dphy_dly_sel_rd ( -- csr_value )
	mregs-virt h# 1010 + l@
;
: dphy_rdly_dq_rst_rd ( -- csr_value )
	mregs-virt h# 1014 + l@
;
: dphy_rdly_dq_inc_rd ( -- csr_value )
	mregs-virt h# 1018 + l@
;
: dphy_rdly_dq_bitslip_rst_rd ( -- csr_value )
	mregs-virt h# 101c + l@
;
: dphy_rdly_dq_bitslip_rd ( -- csr_value )
	mregs-virt h# 1020 + l@
;
: dphy_wdly_dq_bitslip_rst_rd ( -- csr_value )
	mregs-virt h# 1024 + l@
;
: dphy_wdly_dq_bitslip_rd ( -- csr_value )
	mregs-virt h# 1028 + l@
;
: dphy_rdphase_rd ( -- csr_value )
	mregs-virt h# 102c + l@
;
: dphy_wrphase_rd ( -- csr_value )
	mregs-virt h# 1030 + l@
;
: sdr_dfii_control_rd ( -- csr_value )
	mregs-virt h# 2000 + l@
;
: sdr_dfii_pi0_command_rd ( -- csr_value )
	mregs-virt h# 2004 + l@
;
: sdr_dfii_pi0_command_issue_rd ( -- csr_value )
	mregs-virt h# 2008 + l@
;
: sdr_dfii_pi0_address_rd ( -- csr_value )
	mregs-virt h# 200c + l@
;
: sdr_dfii_pi0_baddress_rd ( -- csr_value )
	mregs-virt h# 2010 + l@
;
: sdr_dfii_pi0_wrdata_rd ( -- csr_value )
	mregs-virt h# 2014 + l@
;
: sdr_dfii_pi0_rddata_rd ( -- csr_value )
	mregs-virt h# 2018 + l@
;
: sdr_dfii_pi1_command_rd ( -- csr_value )
	mregs-virt h# 201c + l@
;
: sdr_dfii_pi1_command_issue_rd ( -- csr_value )
	mregs-virt h# 2020 + l@
;
: sdr_dfii_pi1_address_rd ( -- csr_value )
	mregs-virt h# 2024 + l@
;
: sdr_dfii_pi1_baddress_rd ( -- csr_value )
	mregs-virt h# 2028 + l@
;
: sdr_dfii_pi1_wrdata_rd ( -- csr_value )
	mregs-virt h# 202c + l@
;
: sdr_dfii_pi1_rddata_rd ( -- csr_value )
	mregs-virt h# 2030 + l@
;
: sdr_dfii_pi2_command_rd ( -- csr_value )
	mregs-virt h# 2034 + l@
;
: sdr_dfii_pi2_command_issue_rd ( -- csr_value )
	mregs-virt h# 2038 + l@
;
: sdr_dfii_pi2_address_rd ( -- csr_value )
	mregs-virt h# 203c + l@
;
: sdr_dfii_pi2_baddress_rd ( -- csr_value )
	mregs-virt h# 2040 + l@
;
: sdr_dfii_pi2_wrdata_rd ( -- csr_value )
	mregs-virt h# 2044 + l@
;
: sdr_dfii_pi2_rddata_rd ( -- csr_value )
	mregs-virt h# 2048 + l@
;
: sdr_dfii_pi3_command_rd ( -- csr_value )
	mregs-virt h# 204c + l@
;
: sdr_dfii_pi3_command_issue_rd ( -- csr_value )
	mregs-virt h# 2050 + l@
;
: sdr_dfii_pi3_address_rd ( -- csr_value )
	mregs-virt h# 2054 + l@
;
: sdr_dfii_pi3_baddress_rd ( -- csr_value )
	mregs-virt h# 2058 + l@
;
: sdr_dfii_pi3_wrdata_rd ( -- csr_value )
	mregs-virt h# 205c + l@
;
: sdr_dfii_pi3_rddata_rd ( -- csr_value )
	mregs-virt h# 2060 + l@
;
: dphy_rst_wr ( value -- )
	mregs-virt h# 1000 + l!
;
: dphy_half_sys8x_taps_wr ( value -- )
	mregs-virt h# 1004 + l!
;
: dphy_wlevel_en_wr ( value -- )
	mregs-virt h# 1008 + l!
;
: dphy_wlevel_strobe_wr ( value -- )
	mregs-virt h# 100c + l!
;
: dphy_dly_sel_wr ( value -- )
	mregs-virt h# 1010 + l!
;
: dphy_rdly_dq_rst_wr ( value -- )
	mregs-virt h# 1014 + l!
;
: dphy_rdly_dq_inc_wr ( value -- )
	mregs-virt h# 1018 + l!
;
: dphy_rdly_dq_bitslip_rst_wr ( value -- )
	mregs-virt h# 101c + l!
;
: dphy_rdly_dq_bitslip_wr ( value -- )
	mregs-virt h# 1020 + l!
;
: dphy_wdly_dq_bitslip_rst_wr ( value -- )
	mregs-virt h# 1024 + l!
;
: dphy_wdly_dq_bitslip_wr ( value -- )
	mregs-virt h# 1028 + l!
;
: dphy_rdphase_wr ( value -- )
	mregs-virt h# 102c + l!
;
: dphy_wrphase_wr ( value -- )
	mregs-virt h# 1030 + l!
;
: sdr_dfii_control_wr ( value -- )
	mregs-virt h# 2000 + l!
;
: sdr_dfii_pi0_command_wr ( value -- )
	mregs-virt h# 2004 + l!
;
: sdr_dfii_pi0_command_issue_wr ( value -- )
	mregs-virt h# 2008 + l!
;
: sdr_dfii_pi0_address_wr ( value -- )
	mregs-virt h# 200c + l!
;
: sdr_dfii_pi0_baddress_wr ( value -- )
	mregs-virt h# 2010 + l!
;
: sdr_dfii_pi0_wrdata_wr ( value -- )
	mregs-virt h# 2014 + l!
;
: sdr_dfii_pi0_rddata_wr ( value -- )
	mregs-virt h# 2018 + l!
;
: sdr_dfii_pi1_command_wr ( value -- )
	mregs-virt h# 201c + l!
;
: sdr_dfii_pi1_command_issue_wr ( value -- )
	mregs-virt h# 2020 + l!
;
: sdr_dfii_pi1_address_wr ( value -- )
	mregs-virt h# 2024 + l!
;
: sdr_dfii_pi1_baddress_wr ( value -- )
	mregs-virt h# 2028 + l!
;
: sdr_dfii_pi1_wrdata_wr ( value -- )
	mregs-virt h# 202c + l!
;
: sdr_dfii_pi1_rddata_wr ( value -- )
	mregs-virt h# 2030 + l!
;
: sdr_dfii_pi2_command_wr ( value -- )
	mregs-virt h# 2034 + l!
;
: sdr_dfii_pi2_command_issue_wr ( value -- )
	mregs-virt h# 2038 + l!
;
: sdr_dfii_pi2_address_wr ( value -- )
	mregs-virt h# 203c + l!
;
: sdr_dfii_pi2_baddress_wr ( value -- )
	mregs-virt h# 2040 + l!
;
: sdr_dfii_pi2_wrdata_wr ( value -- )
	mregs-virt h# 2044 + l!
;
: sdr_dfii_pi2_rddata_wr ( value -- )
	mregs-virt h# 2048 + l!
;
: sdr_dfii_pi3_command_wr ( value -- )
	mregs-virt h# 204c + l!
;
: sdr_dfii_pi3_command_issue_wr ( value -- )
	mregs-virt h# 2050 + l!
;
: sdr_dfii_pi3_address_wr ( value -- )
	mregs-virt h# 2054 + l!
;
: sdr_dfii_pi3_baddress_wr ( value -- )
	mregs-virt h# 2058 + l!
;
: sdr_dfii_pi3_wrdata_wr ( value -- )
	mregs-virt h# 205c + l!
;
: sdr_dfii_pi3_rddata_wr ( value -- )
	mregs-virt h# 2060 + l!
;
