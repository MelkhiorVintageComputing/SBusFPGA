#!/usr/bin/env python3
from migen import *

from wb_master import *
from wb_master import _WRITE_CMD, _WAIT_CMD, _DONE_CMD


dfii_control_sel     = 0x01
dfii_control_cke     = 0x02
dfii_control_odt     = 0x04
dfii_control_reset_n = 0x08

dfii_command_cs     = 0x01
dfii_command_we     = 0x02
dfii_command_cas    = 0x04
dfii_command_ras    = 0x08
dfii_command_wrdata = 0x10
dfii_command_rddata = 0x20

# /!\ keep up to date with csr /!\
sdram_dfii_base = 0x00043000
sdram_dfii_control =           sdram_dfii_base + 0x000
sdram_dfii_pi0_command  =      sdram_dfii_base + 0x004
sdram_dfii_pi0_command_issue = sdram_dfii_base + 0x008
sdram_dfii_pi0_address  =      sdram_dfii_base + 0x00c
sdram_dfii_pi0_baddress =      sdram_dfii_base + 0x010

# /!\ keep up to date with csr /!\
ddrphy_base = 0x00041000
ddrphy_rst                 = ddrphy_base + 0x000
ddrphy_dly_sel             = ddrphy_base + 0x010
ddrphy_rdly_dq_rst         = ddrphy_base + 0x014
ddrphy_rdly_dq_inc         = ddrphy_base + 0x018
ddrphy_rdly_dq_bitslip_rst = ddrphy_base + 0x01c
ddrphy_rdly_dq_bitslip     = ddrphy_base + 0x020
ddrphy_wdly_dq_bitslip_rst = ddrphy_base + 0x024
ddrphy_wdly_dq_bitslip     = ddrphy_base + 0x028
ddrphy_rdphase             = ddrphy_base + 0x02c
ddrphy_wdphase             = ddrphy_base + 0x030


def period_to_cycles(sys_clk_freq, period):
    return int(period*sys_clk_freq)

def ddr3_init_instructions(sys_clk_freq):
    return [
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.001),
    # phase
    _WRITE_CMD, ddrphy_rdphase, 2,
    _WRITE_CMD, ddrphy_wdphase, 3,
        
    # software control
    _WRITE_CMD, sdram_dfii_control, dfii_control_reset_n | dfii_control_odt | dfii_control_cke,

    # reset
    _WRITE_CMD, ddrphy_rst, 1,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.001),
    _WRITE_CMD, ddrphy_rst, 0,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.001),

    # release reset
    _WRITE_CMD, sdram_dfii_pi0_address, 0x0,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 0,
    _WRITE_CMD, sdram_dfii_control, dfii_control_odt|dfii_control_reset_n,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.005),

    # bring cke high
    _WRITE_CMD, sdram_dfii_pi0_address, 0x0,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 0,
    _WRITE_CMD, sdram_dfii_control, dfii_control_cke|dfii_control_odt|dfii_control_reset_n,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.001),

        # load mode register 2, CWL = 5
    _WRITE_CMD, sdram_dfii_pi0_address, 0x200,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 2,
    _WRITE_CMD, sdram_dfii_pi0_command, dfii_command_ras|dfii_command_cas|dfii_command_we|dfii_command_cs,
    _WRITE_CMD, sdram_dfii_pi0_command_issue, 1,

    # load mode register 3
    _WRITE_CMD, sdram_dfii_pi0_address, 0x0,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 3,
    _WRITE_CMD, sdram_dfii_pi0_command, dfii_command_ras|dfii_command_cas|dfii_command_we|dfii_command_cs,
    _WRITE_CMD, sdram_dfii_pi0_command_issue, 1,

    # load mode register 1
    _WRITE_CMD, sdram_dfii_pi0_address, 0x6,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 1,
    _WRITE_CMD, sdram_dfii_pi0_command, dfii_command_ras|dfii_command_cas|dfii_command_we|dfii_command_cs,
    _WRITE_CMD, sdram_dfii_pi0_command_issue, 1,

    # load mode register 0, CL=6, BL=8
    _WRITE_CMD, sdram_dfii_pi0_address, 0x920,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 0,
    _WRITE_CMD, sdram_dfii_pi0_command, dfii_command_ras|dfii_command_cas|dfii_command_we|dfii_command_cs,
    _WRITE_CMD, sdram_dfii_pi0_command_issue, 1,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.0002),

    # zq calibration
    _WRITE_CMD, sdram_dfii_pi0_address, 0x400,
    _WRITE_CMD, sdram_dfii_pi0_baddress, 0,
    _WRITE_CMD, sdram_dfii_pi0_command, dfii_command_we|dfii_command_cs,
    _WRITE_CMD, sdram_dfii_pi0_command_issue, 1,
    _WAIT_CMD | period_to_cycles(sys_clk_freq, 0.0002),

    # hardware control
    _WRITE_CMD, sdram_dfii_control, dfii_control_sel,
]


def ddr3_config_instructions(bitslip, delay):
    r = []
    for module in range(2):
        r += [_WRITE_CMD, ddrphy_dly_sel, 1<<module ]
        r += [_WRITE_CMD, ddrphy_wdly_dq_bitslip_rst, 1<<module ]
        r += [_WRITE_CMD, ddrphy_dly_sel, 0 ]
    for module in range(2):
        r += [_WRITE_CMD, ddrphy_dly_sel, 1<<module ]
        r += [_WRITE_CMD, ddrphy_rdly_dq_bitslip_rst, 1]
        for i in range(bitslip):
            r += [_WRITE_CMD, ddrphy_rdly_dq_bitslip, 1]
        r += [_WRITE_CMD, ddrphy_rdly_dq_rst, 1]
        for i in range(delay):
            r += [_WRITE_CMD, ddrphy_rdly_dq_inc, 1]
        r += [_WRITE_CMD, ddrphy_dly_sel, 0 ]
    return r

class DDR3Init(WishboneMaster):
    def __init__(self, sys_clk_freq, bitslip, delay):
        WishboneMaster.__init__(self,
            ddr3_init_instructions(sys_clk_freq) +
            ddr3_config_instructions(bitslip, delay) +
            [_DONE_CMD])

# /!\ keep up to date with csr /!\
cg6_video_framebuffer_base = 0x00040000
cg6_video_framebuffer_vtg_enable = cg6_video_framebuffer_base + 0x000
cg6_video_framebuffer_dma_enable = cg6_video_framebuffer_base + 0x02c

def fbc_reset_instructions():
    r = []
    r += [_WRITE_CMD, cg6_video_framebuffer_vtg_enable, 0 ]
    r += [_WRITE_CMD, cg6_video_framebuffer_dma_enable, 0 ]
    r += [_WRITE_CMD, cg6_video_framebuffer_vtg_enable, 1 ]
    r += [_WRITE_CMD, cg6_video_framebuffer_dma_enable, 1 ]
    return r

class DDR3FBInit(WishboneMaster):
    def __init__(self, sys_clk_freq, bitslip, delay):
        WishboneMaster.__init__(self,
            ddr3_init_instructions(sys_clk_freq) +
            ddr3_config_instructions(bitslip, delay) +
            fbc_reset_instructions() +
            [_DONE_CMD])
