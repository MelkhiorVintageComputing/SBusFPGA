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
from litex_boards.platforms import ztex213
from migen.genlib.fifo import *

from sbus_to_fpga_fsm import *;
from sbus_to_fpga_wishbone import *;

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

_usb_io = [
    ("usb", 0,
     Subsignal("dp", Pins("V9")), # Serial TX
     Subsignal("dm", Pins("U9")), # Serial RX
     IOStandard("LVCMOS33"))
]
# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq):
        self.clock_domains.cd_sys       = ClockDomain() # 100 MHz PLL, reset'ed by SBus (via pll), SoC/Wishbone main clock
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
        
class SBusFPGA(SoCCore):
    def __init__(self, **kwargs):

        kwargs["cpu_type"] = "None"
        kwargs["integrated_sram_size"] = 0
        kwargs["with_uart"] = False
        kwargs["with_timer"] = False
        
        self.sys_clk_freq = sys_clk_freq = 100e6 ## 25e6
    
        self.platform = platform = ztex213.Platform(variant="ztex2.13a", expansion="sbus")
        self.platform.add_extension(_sbus_sbus)
        self.platform.add_extension(_usb_io)
        SoCCore.__init__(self, platform=platform, sys_clk_freq=sys_clk_freq, clk_freq=sys_clk_freq, **kwargs)
        wb_mem_map = {
            "prom":           0x00000000,
            "csr" :           0x00040000,
            "usb_host":       0x00080000,
            "usb_shared_mem": 0x00090000,
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

        self.add_ram(name="usb_shared_mem", origin=self.mem_map["usb_shared_mem"], size=2**16)
        
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
        prom = Array(prom_data)
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

        
        # FIFO to send data & address from SBus to the Wishbone
        ##sbus_to_wishbone_wr_fifo = AsyncFIFOBuffered(width=32+30, depth=16)
        ##sbus_to_wishbone_wr_fifo = ClockDomainsRenamer({"write": "sbus", "read": "sys"})(sbus_to_wishbone_wr_fifo)
        ##self.submodules += sbus_to_wishbone_wr_fifo

        # FIFOs to send address / receive data from SBus to the Wishbone
        ##sbus_to_wishbone_rd_fifo_addr = AsyncFIFOBuffered(width=30, depth=16)
        ##sbus_to_wishbone_rd_fifo_addr = ClockDomainsRenamer({"write": "sbus", "read": "sys"})(sbus_to_wishbone_rd_fifo_addr)
        ##self.submodules += sbus_to_wishbone_rd_fifo_addr
        ##sbus_to_wishbone_rd_fifo_data = AsyncFIFOBuffered(width=32+1, depth=16)
        ##sbus_to_wishbone_rd_fifo_data = ClockDomainsRenamer({"write": "sys", "read": "sbus"})(sbus_to_wishbone_rd_fifo_data)
        ##self.submodules += sbus_to_wishbone_rd_fifo_data

        # SBus to Wishbone, 'Slave' on the SBus side, 'Master' on the Wishbone side
        ##self.submodules.sbus_to_wishbone = SBusToWishbone(platform=self.platform,
        ##                                                  wr_fifo=sbus_to_wishbone_wr_fifo,
        ##                                                  rd_fifo_addr=sbus_to_wishbone_rd_fifo_addr,
        ##                                                  rd_fifo_data=sbus_to_wishbone_rd_fifo_data,
        ##                                                  wishbone=wishbone.Interface(data_width=self.bus.data_width))


        # FIFO to send data & address from Wishbone to the SBus
        ##wishbone_to_sbus_wr_fifo = AsyncFIFOBuffered(width=32+30, depth=16)
        ##wishbone_to_sbus_wr_fifo = ClockDomainsRenamer({"write": "sys", "read": "sbus"})(wishbone_to_sbus_wr_fifo)
        ##self.submodules += wishbone_to_sbus_wr_fifo

        # FIFOs to send address / receive data from Wishbone to the SBus
        ##wishbone_to_sbus_rd_fifo_addr = AsyncFIFOBuffered(width=30, depth=4)
        ##wishbone_to_sbus_rd_fifo_addr = ClockDomainsRenamer({"write": "sys", "read": "sbus"})(wishbone_to_sbus_rd_fifo_addr)
        ##self.submodules += wishbone_to_sbus_rd_fifo_addr
        ##wishbone_to_sbus_rd_fifo_data = AsyncFIFOBuffered(width=32+1, depth=4)
        ##wishbone_to_sbus_rd_fifo_data = ClockDomainsRenamer({"write": "sbus", "read": "sys"})(wishbone_to_sbus_rd_fifo_data)
        ##self.submodules += wishbone_to_sbus_rd_fifo_data

        # Wishbone to SBus, 'Master' on the SBus side, 'Slave' on the Wishbone side
        ##self.submodules.wishbone_to_sbus = WishboneToSBus(platform=self.platform,
        ##                                                  soc=self,
        ##                                                  wr_fifo=wishbone_to_sbus_wr_fifo,
        ##                                                  rd_fifo_addr=wishbone_to_sbus_rd_fifo_addr,
        ##                                                  rd_fifo_data=wishbone_to_sbus_rd_fifo_data,
        ##                                                  wishbone=wishbone.Interface(data_width=self.bus.data_width))

        ##_sbus_bus = SBusFPGABus(platform=self.platform,
        ##                        prom=prom,
        ##                        hold_reset=hold_reset,
        ##                        wr_fifo=sbus_to_wishbone_wr_fifo,
        ##                        rd_fifo_addr=sbus_to_wishbone_rd_fifo_addr,
        ##                        rd_fifo_data=sbus_to_wishbone_rd_fifo_data,
        ##                        master_wr_fifo=wishbone_to_sbus_wr_fifo,
        ##                        master_rd_fifo_addr=wishbone_to_sbus_rd_fifo_addr,
        ##                        master_rd_fifo_data=wishbone_to_sbus_rd_fifo_data)
        ##self.submodules.sbus_bus = ClockDomainsRenamer("sbus")(_sbus_bus)
        
        #wishbone_slave = wishbone.Interface(data_width=self.bus.data_width)
        #wishbone_master = wishbone.Interface(data_width=self.bus.data_width)

        #wishbone_slave = wishbone.Interface(data_width=self.bus.data_width)
        #wishbone_master = wishbone.Interface(data_width=self.bus.data_width)

        wishbone_slave_sbus = wishbone.Interface(data_width=self.bus.data_width)
        wishbone_master_sys = wishbone.Interface(data_width=self.bus.data_width)
        self.submodules.wishbone_master_sbus = wishbone.WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_master_sys, cd_master="sbus", cd_slave="sys")
        self.submodules.wishbone_slave_sys   = wishbone.WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_slave_sbus, cd_master="sys", cd_slave="sbus")
        
        _sbus_bus = SBusFPGABus(platform=self.platform,
                                prom=prom,
                                hold_reset=hold_reset,
                                wishbone_slave=wishbone_slave_sbus,
                                wishbone_master=self.wishbone_master_sbus)
        #self.submodules.sbus_bus = _sbus_bus
        self.submodules.sbus_bus = ClockDomainsRenamer("sbus")(_sbus_bus)

        ##self.bus.add_master(name="SBusBridgeToWishbone", master=self.sbus_to_wishbone.wishbone)
        ##self.bus.add_slave(name="usb_fake_dma", slave=self.wishbone_to_sbus.wishbone, region=SoCRegion(origin=self.mem_map.get("usb_fake_dma", None), size=0x03ffffff, cached=False))
        
        #self.bus.add_master(name="SBusBridgeToWishbone", master=self.sbus_bus.wishbone_master)
        #self.bus.add_slave(name="usb_fake_dma", slave=self.sbus_bus.wishbone_slave, region=SoCRegion(origin=self.mem_map.get("usb_fake_dma", None), size=0x03ffffff, cached=False))
        self.bus.add_master(name="SBusBridgeToWishbone", master=wishbone_master_sys)
        #self.bus.add_slave(name="usb_fake_dma", slave=self.wishbone_slave_sys, region=SoCRegion(origin=self.mem_map.get("usb_fake_dma", None), size=0x03ffffff, cached=False))    

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
