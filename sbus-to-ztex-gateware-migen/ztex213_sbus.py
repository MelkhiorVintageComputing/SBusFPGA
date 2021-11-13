#
# This file is part of LiteX-Boards.
#
# Support for the ZTEX USB-FGPA Module 2.13:
# <https://www.ztex.de/usb-fpga-2/usb-fpga-2.13.e.html>
# With (no-so-optional) expansion, either the ZTEX Debug board:
# <https://www.ztex.de/usb-fpga-2/debug.e.html>
# Or the SBusFPGA adapter board:
# <https://github.com/rdolbeau/SBusFPGA>
#
# Copyright (c) 2015 Yann Sionneau <yann.sionneau@gmail.com>
# Copyright (c) 2015-2019 Florent Kermarrec <florent@enjoy-digital.fr>
# Copyright (c) 2020-2021 Romain Dolbeau <romain@dolbeau.org>
# SPDX-License-Identifier: BSD-2-Clause

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform
from litex.build.openocd import OpenOCD

# IOs ----------------------------------------------------------------------------------------------

# FPGA daughterboard I/O

_io = [
    ## 48 MHz clock reference
    ("clk48", 0, Pins("P15"), IOStandard("LVCMOS33")),
    ## embedded 256 MiB DDR3 DRAM
    ("ddram", 0,
        Subsignal("a", Pins("C5 B6 C7 D5 A3 E7 A4 C6", "A6 D8 B2 A5 B3 B7"),
            IOStandard("SSTL135")),
        Subsignal("ba",    Pins("E5 A1 E6"), IOStandard("SSTL135")),
        Subsignal("ras_n", Pins("E3"), IOStandard("SSTL135")),
        Subsignal("cas_n", Pins("D3"), IOStandard("SSTL135")),
        Subsignal("we_n",  Pins("D4"), IOStandard("SSTL135")),
#        Subsignal("cs_n",  Pins(""), IOStandard("SSTL135")),
        Subsignal("dm", Pins("G1 G6"), IOStandard("SSTL135")),
        Subsignal("dq", Pins(
            "H1 F1 E2 E1 F4 C1 F3 D2",
            "G4 H5 G3 H6 J2 J3 K1 K2"),
            IOStandard("SSTL135"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("dqs_p", Pins("H2 J4"),
            IOStandard("DIFF_SSTL135"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("dqs_n", Pins("G2 H4"),
            IOStandard("DIFF_SSTL135"),
            Misc("IN_TERM=UNTUNED_SPLIT_40")),
        Subsignal("clk_p", Pins("C4"), IOStandard("DIFF_SSTL135")),
        Subsignal("clk_n", Pins("B4"), IOStandard("DIFF_SSTL135")),
        Subsignal("cke",   Pins("B1"), IOStandard("SSTL135")),
        Subsignal("odt",   Pins("F5"), IOStandard("SSTL135")),
        Subsignal("reset_n", Pins("J5"), IOStandard("SSTL135")),
        Misc("SLEW=FAST"),
    ),
]

# SBusFPGA I/O

_sbus_io_v1_0 = [
    ## leds on the SBus board
    ("user_led", 0, Pins("U8"),  IOStandard("lvcmos33")), #LED0
    ("user_led", 1, Pins("U7"),  IOStandard("lvcmos33")), #LED1
    ("user_led", 2, Pins("U6"),  IOStandard("lvcmos33")), #LED2
    ("user_led", 3, Pins("T8"),  IOStandard("lvcmos33")), #LED3
    ("user_led", 4, Pins("P4"),  IOStandard("lvcmos33")), #LED4
    ("user_led", 5, Pins("P3"),  IOStandard("lvcmos33")), #LED5
    ("user_led", 6, Pins("T1"),  IOStandard("lvcmos33")), #LED6
    ("user_led", 7, Pins("R1"),  IOStandard("lvcmos33")), #LED7
    #("user_led", 8, Pins("U1"),  IOStandard("lvcmos33")), #SBUS_DATA_OE_LED
    #("user_led", 9, Pins("T3"),  IOStandard("lvcmos33")), #SBUS_DATA_OE_LED_2
    ## serial header for console
    ("serial", 0,
     Subsignal("tx", Pins("V9")), # FIXME: might be the other way round
     Subsignal("rx", Pins("U9")),
     IOStandard("LVCMOS33")
    ),
    ## sdcard connector
    ("spisdcard", 0,
        Subsignal("clk",  Pins("R8")),
        Subsignal("mosi", Pins("T5"), Misc("PULLUP True")),
        Subsignal("cs_n", Pins("V6"), Misc("PULLUP True")),
        Subsignal("miso", Pins("V5"), Misc("PULLUP True")),
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS33"),
    ),
    ("sdcard", 0,
        Subsignal("data", Pins("V5 V4 V7 V6"), Misc("PULLUP True")),
        Subsignal("cmd",  Pins("T5"), Misc("PULLUP True")),
        Subsignal("clk",  Pins("R8")),
        #Subsignal("cd",   Pins("V6")),
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS33"),
    ),
]

_sbus_io_v1_2 = [
    ## leds on the SBus board
    ## serial header for console
    ("serial", 0,
     Subsignal("tx", Pins("V9")), # FIXME: might be the other way round
     Subsignal("rx", Pins("U9")),
     IOStandard("LVCMOS33")
    ),
    ## sdcard connector
    ("spisdcard", 0,
        Subsignal("clk",  Pins("R8")),
        Subsignal("mosi", Pins("T5"), Misc("PULLUP True")),
        Subsignal("cs_n", Pins("V6"), Misc("PULLUP True")),
        Subsignal("miso", Pins("V5"), Misc("PULLUP True")),
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS33"),
    ),
    ("sdcard", 0,
        Subsignal("data", Pins("V5 V4 V7 V6"), Misc("PULLUP True")),
        Subsignal("cmd",  Pins("T5"), Misc("PULLUP True")),
        Subsignal("clk",  Pins("R8")),
        #Subsignal("cd",   Pins("V6")),
        Misc("SLEW=FAST"),
        IOStandard("LVCMOS33"),
    ),
    ## USB
    ("usb", 0,
     Subsignal("dp", Pins("U8")), # Serial TX
     Subsignal("dm", Pins("U7")), # Serial RX
     IOStandard("LVCMOS33"))
]

_sbus_sbus_v1_0 = [
    ("SBUS_3V3_CLK",       0, Pins("D15"), IOStandard("lvttl")),
    ("SBUS_3V3_ASs",       0, Pins("T4"),  IOStandard("lvttl")),
    ("SBUS_3V3_BGs",       0, Pins("T6"),  IOStandard("lvttl")),
    ("SBUS_3V3_BRs",       0, Pins("R6"),  IOStandard("lvttl")),
    ("SBUS_3V3_ERRs",      0, Pins("V2"),  IOStandard("lvttl")),
    ("SBUS_DATA_OE_LED",   0, Pins("U1"),  IOStandard("lvttl")),
    ("SBUS_DATA_OE_LED_2", 0, Pins("T3"),  IOStandard("lvttl")),
    ("SBUS_3V3_RSTs",      0, Pins("U2"),  IOStandard("lvttl")),
    ("SBUS_3V3_SELs",      0, Pins("K6"),  IOStandard("lvttl")),
    ("SBUS_3V3_INT1s",     0, Pins("R3"),  IOStandard("lvttl")),
    ("SBUS_3V3_INT7s",     0, Pins("N5"),  IOStandard("lvttl")),
    ("SBUS_3V3_PPRD",      0, Pins("N6"),  IOStandard("lvttl")),
    ("SBUS_OE",            0, Pins("P5"),  IOStandard("lvttl")),
    ("SBUS_3V3_ACKs",      0, Pins("M6 L6 N4"),  IOStandard("lvttl")),
    ("SBUS_3V3_SIZ",       0, Pins("R7 U3 V1"),  IOStandard("lvttl")),
    ("SBUS_3V3_D",         0, Pins("J18 K16 J17 K15 K13 J15 J13 J14 H14 H17 G14 G17 G16 G18 H16 F18 F16 E18 F15 D18 E17 G13 D17 F13 F14 E16 E15 C17 C16 A18 B18 C15"),  IOStandard("lvttl")),
    ("SBUS_3V3_PA",        0, Pins("B16 B17 D14 C14 D12 A16 A15 B14 B13 B12 C12 A14 A13 B11 A11  M4  R2  M3  P2  M2  N2  K5  N1  L4  M1  L3  L1  K3"),  IOStandard("lvttl")),
]

_sbus_sbus_v1_2 = [
    ("SBUS_3V3_CLK",       0, Pins("D15"), IOStandard("lvttl")),
    ("SBUS_3V3_ASs",       0, Pins("T4"),  IOStandard("lvttl")),
    ("SBUS_3V3_BGs",       0, Pins("R7"),  IOStandard("lvttl")), # moved
    ("SBUS_3V3_BRs",       0, Pins("R6"),  IOStandard("lvttl")),
    ("SBUS_3V3_ERRs",      0, Pins("D13"),  IOStandard("lvttl")), # moved
    ("SBUS_DATA_OE_LED",   0, Pins("U1"),  IOStandard("lvttl")),
    #("SBUS_DATA_OE_LED_2", 0, Pins("T3"),  IOStandard("lvttl")),
    ("SBUS_3V3_RSTs",      0, Pins("U2"),  IOStandard("lvttl")),
    ("SBUS_3V3_SELs",      0, Pins("K6"),  IOStandard("lvttl")),
    ("SBUS_3V3_INT1s",     0, Pins("R5"),  IOStandard("lvttl")), # moved
    ("SBUS_3V3_INT2s",     0, Pins("H15"),  IOStandard("lvttl")), # added
    ("SBUS_3V3_INT3s",     0, Pins("R3"),  IOStandard("lvttl")), # added
    ("SBUS_3V3_INT4s",     0, Pins("N5"),  IOStandard("lvttl")), # added
    ("SBUS_3V3_INT5s",     0, Pins("L5"),  IOStandard("lvttl")), # added
    ("SBUS_3V3_INT6s",     0, Pins("V2"),  IOStandard("lvttl")), # added
    #("SBUS_3V3_INT7s",     0, Pins(""),  IOStandard("lvttl")), # removed
    ("SBUS_3V3_PPRD",      0, Pins("N6"),  IOStandard("lvttl")),
    ("SBUS_OE",            0, Pins("P5"),  IOStandard("lvttl")),
    ("SBUS_3V3_ACKs",      0, Pins("M6 L6 N4"),  IOStandard("lvttl")),
    ("SBUS_3V3_SIZ",       0, Pins("T6 U3 V1"),  IOStandard("lvttl")), # 0 moved
    ("SBUS_3V3_D",         0, Pins("J18 K16 J17 K15 K13 J15 J13 J14 H14 H17 G14 G17 G16 G18 H16 F18 F16 E18 F15 D18 E17 G13 D17 F13 F14 E16 E15 C17 C16 A18 B18 C15"),  IOStandard("lvttl")),
    ("SBUS_3V3_PA",        0, Pins("B16 B17 D14 C14 D12 A16 A15 B14 B13 B12 C12 A14 A13 B11 A11  M4  R2  M3  P2  M2  N2  K5  N1  L4  M1  L3  L1  K3"),  IOStandard("lvttl")),
]

# reusing the UART pins !!!
_usb_io_v1_0 = [
    ("usb", 0,
     Subsignal("dp", Pins("V9")), # Serial TX
     Subsignal("dm", Pins("U9")), # Serial RX
     IOStandard("LVCMOS33"))
]

# Connectors ---------------------------------------------------------------------------------------

_connectors_v1_0 = [
]
_connectors_v1_2 = [
    ("P1", "T8 P3 T1 R1 U6 P4 U4 T3"), # swapped line?
]

# I2C ----------------------------------------------------------------------------------------------

# reusing the UART pins !!!
_i2c_v1_0 = [
    ("i2c", 0,
    Subsignal("scl", Pins("V9")),
    Subsignal("sda", Pins("U9")),
    IOStandard("LVCMOS33"))
]
# reusing the UART pins !!!
_i2c_v1_2 = [
    ("i2c", 0,
    Subsignal("scl", Pins("V9")),
    Subsignal("sda", Pins("U9")),
    IOStandard("LVCMOS33"))
]

# VGA ----------------------------------------------------------------------------------------------

def vga_rgb222_pmod_io(pmod):
    return [
        ("vga", 0,
            Subsignal("hsync", Pins(f"{pmod}:3")),
            Subsignal("vsync", Pins(f"{pmod}:7")),
            Subsignal("b", Pins(f"{pmod}:0 {pmod}:4")),
            Subsignal("g", Pins(f"{pmod}:1 {pmod}:5")),
            Subsignal("r", Pins(f"{pmod}:2 {pmod}:6")),
            IOStandard("LVCMOS33"),
        ),
]
_vga_pmod_io_v1_2 = vga_rgb222_pmod_io("P1")
   
# Platform -----------------------------------------------------------------------------------------

class Platform(XilinxPlatform):
    default_clk_name   = "clk48"
    default_clk_period = 1e9/48e6

    def get_irq(self, device, irq_req, next_down=True, next_up=False):
        irq = irq_req
        if (irq in self.avail_irqs):
            self.avail_irqs.remove(irq)
            self.irq_device_map[irq] = device
            self.device_irq_map[device] = irq
            print("~~~~~ A Requesting SBUS_3V3_INT{}s".format(irq))
            return self.request("SBUS_3V3_INT{}s".format(irq))
        if (next_down):
            for irq in range(irq_req, 0, -1):
                if (irq in self.avail_irqs):
                    self.avail_irqs.remove(irq)
                    self.irq_device_map[irq] = device
                    self.device_irq_map[device] = irq
                    print("~~~~~ B Requesting SBUS_3V3_INT{}s".format(irq))
                    return self.request("SBUS_3V3_INT{}s".format(irq))
        if (next_up):
            for irq in range(irq_req, 7, 1):
                if (irq in self.avail_irqs):
                    self.avail_irqs.remove(irq)
                    self.irq_device_map[irq] = device
                    self.device_irq_map[device] = irq
                    print("~~~~~ C Requesting SBUS_3V3_INT{}s".format(irq))
                    return self.request("SBUS_3V3_INT{}s".format(irq))
        return None

    def __init__(self, variant="ztex2.13a", version="V1.0"):
        device = {
            "ztex2.13a":  "xc7a35tcsg324-1",
            "ztex2.13b":  "xc7a50tcsg324-1", #untested
            "ztex2.13b2": "xc7a50tcsg324-1", #untested
            "ztex2.13c":  "xc7a75tcsg324-2", #untested
            "ztex2.13d":  "xc7a100tcsg324-2" #untested
        }[variant]
        sbus_io = {
            "V1.0" : _sbus_io_v1_0,
            "V1.2" : _sbus_io_v1_2,
        }[version]
        sbus_sbus = {
            "V1.0" : _sbus_sbus_v1_0,
            "V1.2" : _sbus_sbus_v1_2,
        }[version]
        connectors = {
            "V1.0" : _connectors_v1_0,
            "V1.2" : _connectors_v1_2,
        }[version]
        i2c = {
            "V1.0" : _i2c_v1_0,
            "V1.2" : _i2c_v1_2,
        }[version]
        self.avail_irqs = {
            "V1.0" : { 1 }, # don't add 7 here, too risky
            "V1.2" : { 1, 2, 3, 4, 5, 6 },
        }[version]
        self.irq_device_map = dict()
        self.device_irq_map = dict()
        self.speedgrade = -1
        if (device[-1] == '2'):
            self.speedgrade = -2
        
        XilinxPlatform.__init__(self, device, _io, connectors, toolchain="vivado")
        self.add_extension(sbus_io)
        self.add_extension(sbus_sbus)
        self.add_extension(i2c)
        
        self.toolchain.bitstream_commands = \
            ["set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR No [current_design]",
             "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]",
             "set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]",
             "set_property BITSTREAM.GENERAL.COMPRESS true [current_design]",
             "set_property BITSTREAM.GENERAL.CRC DISABLE [current_design]",
             "set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]",
             "set_property CONFIG_VOLTAGE 3.3 [current_design]",
             "set_property CFGBVS VCCO [current_design]"
#             , "set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE AreaOptimized_high [get_runs synth_1]"
             ]

    def create_programmer(self):
        bscan_spi = "bscan_spi_xc7a35t.bit"
        return OpenOCD("openocd_xc7_ft2232.cfg", bscan_spi) #FIXME

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)
        #self.add_period_constraint(self.lookup_request("clk48", loose=True), 1e9/48e6)
