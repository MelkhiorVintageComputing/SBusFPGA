import os
import argparse
from migen import *
import litex
from litex.build.generic_platform import *
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict
from litex.soc.integration.soc import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.clock import *
from litex.soc.cores.led import LedChaser
from litex_boards.platforms import ztex213

from sbus_to_fpga_slave import *;

_sbus_sbus = [
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
# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys       = ClockDomain()
        self.clock_domains.cd_native    = ClockDomain(reset_less=True)
        #self.clock_domains.cd_sbus      = ClockDomain()
        self.clock_domains.cd_por       = ClockDomain()

        # # #
        clk48 = platform.request("clk48")
        self.cd_native.clk = clk48
        clk_sbus = platform.request("SBUS_3V3_CLK")
        self.cd_sys.clk = clk_sbus
        rst_sbus = platform.request("SBUS_3V3_RSTs")

        #self.submodules.pll = pll = S7MMCM(speedgrade=-1)
        #pll.register_clkin(clk48, 48e6)
        #pll.create_clkout(self.cd_sys, sys_clk_freq)

        #self.comb += self.cd_sbus.clk.eq(clk_sbus)
        #self.comb += self.cd_sbus.rst.eq(~rst_sbus)
        
        #self.comb += self.cd_sys.clk.eq(clk_sbus)
        self.comb += self.cd_sys.rst.eq(~rst_sbus)

        #self.comb += self.cd_native.clk.eq(clk48)

        #platform.add_false_path_constraints(self.cd_native.clk, self.cd_sbus.clk)
        platform.add_false_path_constraints(self.cd_native.clk, self.cd_sys.clk)
        platform.add_false_path_constraints(self.cd_sys.clk, self.cd_native.clk)
        
        # Power on reset, 20 seconds
        #por_count = Signal(30, reset=20*48*1000000)
        #por_done  = Signal()
        #self.comb += self.cd_por.clk.eq(clk48)
        #self.comb += por_done.eq(por_count == 0)
        #self.sync.por += If(~por_done, por_count.eq(por_count - 1))
        #self.comb += pll.reset.eq(~por_done)
        
class SBusFPGA(SoCCore):
    def __init__(self, **kwargs):

        kwargs["cpu_type"] = "None"
        kwargs["integrated_sram_size"] = 0
        kwargs["with_uart"] = True
        kwargs["with_timer"] = False
        
        self.sys_clk_freq = sys_clk_freq = 25e6 # SBus max
    
        self.platform = platform = ztex213.Platform(variant="ztex2.13a", expansion="sbus")
        self.platform.add_extension(_sbus_sbus)
        SoCCore.__init__(self, platform=platform, sys_clk_freq=sys_clk_freq, clk_freq=sys_clk_freq, **kwargs)
        wb_mem_map = {
            "prom": 0x00000000,
            "csr" : 0x00040000,
        }
        self.mem_map.update(wb_mem_map)
        self.submodules.crg = _CRG(platform=platform, sys_clk_freq=sys_clk_freq)
        self.platform.add_period_constraint(self.platform.lookup_request("SBUS_3V3_CLK", loose=True), 1e9/25e6)

        self.submodules.leds = LedChaser(
            pads         = platform.request_all("user_led"),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")

        prom_file = "prom_mini.fc"
        prom_data = soc_core.get_mem_data(prom_file, "big")
        prom = Array(prom_data)
        #print("\n****************************************\n")
        #for i in range(len(prom)):
        #    print(hex(prom[i]))
        #print("\n****************************************\n")
        self.add_ram("prom", origin=self.mem_map["prom"], size=2**16, contents=prom_data, mode="r") # for show
        #getattr(self,"prom").mem.init = prom_data
        #getattr(self,"prom").mem.depth = 2**14

        # don't enable anything on the SBus side for 20 seconds after power up
        # this avoids FPGA initialization messing with the cold boot process
        # requires us to reset the SPARCstation afterward so the FPGA board
        # is properly identified
        hold_reset_ctr = Signal(30, reset=960000000)
        self.sync.native += If(hold_reset_ctr>0, hold_reset_ctr.eq(hold_reset_ctr - 1))
        hold_reset = Signal(reset=1)
        self.comb += hold_reset.eq(~(hold_reset_ctr == 0))
        
        #self.submodules.sbus_slave = ClockDomainsRenamer("sbus")(SBusFPGASlave(platform=self.platform, soc=self, prom=prom, hold_reset=hold_reset))
        self.submodules.sbus_slave = SBusFPGASlave(platform=self.platform,
                                                   prom=prom,
                                                   hold_reset=hold_reset,
                                                   wishbone=wishbone.Interface(data_width=self.bus.data_width, adr_width=self.bus.address_width),
                                                   chaser=self.leds)

        self.bus.add_master(name="SBusBridgeToWishbone", master=self.sbus_slave.wishbone)
        
 #       self.soc = Module()
 #       self.soc.mem_regions = self.mem_regions = {}
 #       region = litex.soc.integration.soc.SoCRegion(origin=0x0, size=0x0)
 #       region.length = 0
 #       self.mem_regions['csr'] = region
 #       self.soc.constants = self.constants = {}
 #       self.soc.csr_regions = self.csr_regions = {}
 #       self.soc.cpu_type = self.cpu_type = None

#    def do_finalize(self):
#        self.platform.add_period_constraint(self.platform.lookup_request("SBUS_3V3_CLK", loose=True), 1e9/25e6)

def main():
    parser = argparse.ArgumentParser(description="SbusFPGA")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    builder_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()
    
    soc = SBusFPGA(**soc_core_argdict(args))
    #soc.add_uart(name="uart", baudrate=115200, fifo_depth=16)
    
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

if __name__ == "__main__":
    main()
