import os
import argparse
from migen import *
import litex
from litex.build.generic_platform import *
from litex.build.xilinx.vivado import vivado_build_args, vivado_build_argdict
from litex.soc.integration.soc import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.interconnect import wishbone
from litex.soc.cores.clock import *
from litex.soc.cores.led import LedChaser
import ztex213_sbus
from migen.genlib.fifo import *

from litedram.modules import MT41J128M16
from litedram.phy import s7ddrphy

from sbus_to_fpga_fsm import *;

import sbus_to_fpga_export;

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys       = ClockDomain() # 100 MHz PLL, reset'ed by SBus (via pll), SoC/Wishbone main clock
        self.clock_domains.cd_sys4x     = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys4x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay    = ClockDomain()
##        self.clock_domains.cd_sys       = ClockDomain() #  16.67-25 MHz SBus, reset'ed by SBus, native SBus & SYS clock domain
        self.clock_domains.cd_native    = ClockDomain(reset_less=True) # 48MHz native, non-reset'ed (for power-on long delay, never reset, we don't want the delay after a warm reset)
        self.clock_domains.cd_sbus      = ClockDomain() # 16.67-25 MHz SBus, reset'ed by SBus, native SBus clock domain
#        self.clock_domains.cd_por       = ClockDomain() # 48 MHz native, reset'ed by SBus, power-on-reset timer
        self.clock_domains.cd_usb       = ClockDomain() # 48 MHZ PLL, reset'ed by SBus (via pll), for USB controller

        # # #
        clk48 = platform.request("clk48")
        self.cd_native.clk = clk48
        clk_sbus = platform.request("SBUS_3V3_CLK")
        self.cd_sbus.clk = clk_sbus
        rst_sbus = platform.request("SBUS_3V3_RSTs")
        self.comb += self.cd_sbus.rst.eq(~rst_sbus)
        ##self.cd_sys.clk = clk_sbus
        ##self.comb += self.cd_sys.rst.eq(~rst_sbus)

        self.submodules.pll = pll = S7MMCM(speedgrade=-1)
        pll.register_clkin(clk48, 48e6)
        pll.create_clkout(self.cd_sys, sys_clk_freq)
        pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
        pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
        self.comb += pll.reset.eq(~rst_sbus) # | ~por_done 
        platform.add_false_path_constraints(self.cd_native.clk, self.cd_sbus.clk)
        platform.add_false_path_constraints(self.cd_sys.clk, self.cd_sbus.clk)
        platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_native.clk)
        platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_sys.clk)
        ##platform.add_false_path_constraints(self.cd_native.clk, self.cd_sys.clk)
        
        # Power on reset, reset propagate from SBus to SYS
#        por_count = Signal(16, reset=2**16-1)
#        por_done  = Signal()
#        self.comb += self.cd_por.clk.eq(clk48)
#        self.comb += por_done.eq(por_count == 0)
#        self.sync.por += If(~por_done, por_count.eq(por_count - 1))
#        self.comb += self.cd_por.rst.eq(~rst_sbus)
#        self.comb += pll.reset.eq(~por_done | ~rst_sbus)

        # USB
        self.submodules.usb_pll = usb_pll = S7MMCM(speedgrade=-1)
        usb_pll.register_clkin(clk48, 48e6)
        usb_pll.create_clkout(self.cd_usb, 48e6, margin = 0)
        self.comb += usb_pll.reset.eq(~rst_sbus) # | ~por_done 
        platform.add_false_path_constraints(self.cd_sys.clk, self.cd_usb.clk)

        self.submodules.pll_idelay = pll_idelay = S7PLL(speedgrade=-1)
        pll_idelay.register_clkin(clk48, 48e6)
        pll_idelay.create_clkout(self.cd_idelay, 200e6, margin = 0)
        self.comb += pll_idelay.reset.eq(~rst_sbus) # | ~por_done 

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)
        
class SBusFPGA(SoCCore):
    def __init__(self, **kwargs):

        kwargs["cpu_type"] = "None"
        kwargs["integrated_sram_size"] = 0
        kwargs["with_uart"] = False
        kwargs["with_timer"] = False
        
        self.sys_clk_freq = sys_clk_freq = 100e6 ## 25e6
    
        self.platform = platform = ztex213_sbus.Platform(variant="ztex2.13a")
        
        self.platform.add_extension(ztex213_sbus._usb_io)
        SoCCore.__init__(self,
                         platform=platform,
                         sys_clk_freq=sys_clk_freq,
                         clk_freq=sys_clk_freq,
                         csr_paging=0x1000, #  default is 0x800
                         **kwargs)

        # This mem-map is also exposed in the FSM (matched prefixes)
        # and in the PROM (to tell NetBSD where everything is)
        # Currently it is a straight mapping between the two:
        # the physical address here are used as offset in the SBus
        # reserved area of 256 MiB
        # Anything at 0x10000000 is therefore unreachable directly
        # The position of the 'usb_fake_dma' is so it overlaps
        # the virtual address space used by NetBSD DMA allocators
        wb_mem_map = {
            "prom":           0x00000000,
            "csr" :           0x00040000,
            "usb_host":       0x00080000,
            "usb_shared_mem": 0x00090000,
            "main_ram":       0x80000000,
            "usb_fake_dma":   0xfc000000,
        }
        self.mem_map.update(wb_mem_map)
        self.submodules.crg = _CRG(platform=platform, sys_clk_freq=sys_clk_freq)
        self.platform.add_period_constraint(self.platform.lookup_request("SBUS_3V3_CLK", loose=True), 1e9/25e6) # SBus max

        self.submodules.leds = LedChaser(
            pads         = platform.request("SBUS_DATA_OE_LED_2"), #platform.request("user_led", 7),
            sys_clk_freq = sys_clk_freq)
        self.add_csr("leds")
        
        self.add_usb_host(pads=platform.request("usb"), usb_clk_freq=48e6)
        #self.comb += self.cpu.interrupt[16].eq(self.usb_host.interrupt) #fixme: need to deal with interrupts

        # self.add_ram(name="usb_shared_mem", origin=self.mem_map["usb_shared_mem"], size=2**16)
        
        pad_SBUS_3V3_INT1s = platform.request("SBUS_3V3_INT1s")
        SBUS_3V3_INT1s_o = Signal(reset=1)
        # the 74LVC2G07 takes care of the Z state: 1 -> Z on the bus, 0 -> 0 on the bus (asserted interrupt)
        self.comb += pad_SBUS_3V3_INT1s.eq(SBUS_3V3_INT1s_o)
        self.comb += SBUS_3V3_INT1s_o.eq(~self.usb_host.interrupt) ##
        
        
        #pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        #SBUS_DATA_OE_LED_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
        #pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        #SBUS_DATA_OE_LED_2_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)
        #self.comb += SBUS_DATA_OE_LED_o.eq(~SBUS_3V3_INT1s_o)

        prom_file = "prom_migen.fc"
        prom_data = soc_core.get_mem_data(prom_file, "big")
        # prom = Array(prom_data)
        #print("\n****************************************\n")
        #for i in range(len(prom)):
        #    print(hex(prom[i]))
        #print("\n****************************************\n")
        self.add_ram("prom", origin=self.mem_map["prom"], size=2**16, contents=prom_data, mode="r")
        #getattr(self,"prom").mem.init = prom_data
        #getattr(self,"prom").mem.depth = 2**14

        # don't enable anything on the SBus side for 20 seconds after power up
        # this avoids FPGA initialization messing with the cold boot process
        # requires us to reset the SPARCstation afterward so the FPGA board
        # is properly identified
        # This is in the 'native' ClockDomain that is never reset
        hold_reset_ctr = Signal(30, reset=960000000)
        self.sync.native += If(hold_reset_ctr>0, hold_reset_ctr.eq(hold_reset_ctr - 1))
        hold_reset = Signal(reset=1)
        self.comb += hold_reset.eq(~(hold_reset_ctr == 0))

        # Interface SBus to wishbone
        # we need to cross clock domains
        wishbone_slave_sbus = wishbone.Interface(data_width=self.bus.data_width)
        wishbone_master_sys = wishbone.Interface(data_width=self.bus.data_width)
        self.submodules.wishbone_master_sbus = wishbone.WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_master_sys, cd_master="sbus", cd_slave="sys")
        self.submodules.wishbone_slave_sys   = wishbone.WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_slave_sbus, cd_master="sys", cd_slave="sbus")
        
        _sbus_bus = SBusFPGABus(platform=self.platform,
                                hold_reset=hold_reset,
                                wishbone_slave=wishbone_slave_sbus,
                                wishbone_master=self.wishbone_master_sbus)
        #self.submodules.sbus_bus = _sbus_bus
        self.submodules.sbus_bus = ClockDomainsRenamer("sbus")(_sbus_bus)

        self.bus.add_master(name="SBusBridgeToWishbone", master=wishbone_master_sys)
        self.bus.add_slave(name="usb_fake_dma", slave=self.wishbone_slave_sys, region=SoCRegion(origin=self.mem_map.get("usb_fake_dma", None), size=0x03ffffff, cached=False))

        self.submodules.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
                                                   memtype        = "DDR3",
                                                   nphases        = 4,
                                                   sys_clk_freq   = sys_clk_freq)
        self.add_sdram("sdram",
                       phy           = self.ddrphy,
                       module        = MT41J128M16(sys_clk_freq, "1:4"),
                       l2_cache_size = 0
        )
        
        self.add_sdcard()

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

    # Generate modified CSR registers definitions/access functions to netbsd_csr.h.
    csr_contents = sbus_to_fpga_export.get_csr_header(
        regions   = soc.csr_regions,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    write_to_file(os.path.join("netbsd_csr.h"), csr_contents)

    # tells the prom where to find what
    csr_forth_contents = sbus_to_fpga_export.get_csr_forth_header(
        csr_regions   = soc.csr_regions,
        mem_regions   = soc.mem_regions,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    write_to_file(os.path.join("prom_csr.fth"), csr_forth_contents)
    
if __name__ == "__main__":
    main()
