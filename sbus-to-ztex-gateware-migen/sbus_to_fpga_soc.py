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

from sbus_to_fpga_fsm import *
from sbus_to_fpga_fsmstat import *
from sbus_to_fpga_blk_dma import *
from sbus_to_fpga_trng import *

from litedram.frontend.dma import *

from engine import Engine;
from migen.genlib.cdc import BusSynchronizer
from migen.genlib.resetsync import AsyncResetSynchronizer;

import sbus_to_fpga_export;

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq, usb=True):
        self.clock_domains.cd_sys       = ClockDomain() # 100 MHz PLL, reset'ed by SBus (via pll), SoC/Wishbone main clock
        self.clock_domains.cd_sys4x     = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys4x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_idelay    = ClockDomain()
##        self.clock_domains.cd_sys       = ClockDomain() #  16.67-25 MHz SBus, reset'ed by SBus, native SBus & SYS clock domain
        self.clock_domains.cd_native    = ClockDomain(reset_less=True) # 48MHz native, non-reset'ed (for power-on long delay, never reset, we don't want the delay after a warm reset)
        self.clock_domains.cd_sbus      = ClockDomain() # 16.67-25 MHz SBus, reset'ed by SBus, native SBus clock domain
#        self.clock_domains.cd_por       = ClockDomain() # 48 MHz native, reset'ed by SBus, power-on-reset timer
        if (usb):
            self.clock_domains.cd_usb       = ClockDomain() # 48 MHZ PLL, reset'ed by SBus (via pll), for USB controller
        self.clock_domains.cd_clk50     = ClockDomain() # 50 MHz (gated) for curve25519engine  -> eng_clk
        #self.clock_domains.cd_clk100    = ClockDomain() # 100 MHz for curve25519engine -> sys_clk
        self.clock_domains.cd_clk100_gated = ClockDomain() # 100 MHz (gated) for curve25519engine -> mul_clk
        self.clock_domains.cd_clk200    = ClockDomain() # 200 MHz (gated) for curve25519engine -> rf_clk

        # # #
        clk48 = platform.request("clk48")
        ###### explanations from betrusted-io/betrusted-soc/betrusted_soc.py
        # Note: below feature cannot be used because Litex appends this *after* platform commands! This causes the generated
        # clock derived constraints immediately below to fail, because .xdc file is parsed in-order, and the main clock needs
        # to be created before the derived clocks. Instead, we use the line afterwards.
        platform.add_platform_command("create_clock -name clk48 -period 20.8333 [get_nets clk48]")
        # The above constraint must strictly proceed the below create_generated_clock constraints in the .XDC file
        # This allows PLLs/MMCMEs to be placed anywhere and reference the input clock
        self.clk48_bufg = Signal()
        self.specials += Instance("BUFG", i_I=clk48, o_O=self.clk48_bufg)
        self.comb += self.cd_native.clk.eq(self.clk48_bufg)                
        #self.cd_native.clk = clk48
        
        clk_sbus = platform.request("SBUS_3V3_CLK")
        self.cd_sbus.clk = clk_sbus
        rst_sbus = platform.request("SBUS_3V3_RSTs")
        self.comb += self.cd_sbus.rst.eq(~rst_sbus)
        ##self.cd_sys.clk = clk_sbus
        ##self.comb += self.cd_sys.rst.eq(~rst_sbus)
        
        self.curve25519_on = Signal()

        self.submodules.pll = pll = S7MMCM(speedgrade=-1)
        #pll.register_clkin(clk48, 48e6)
        pll.register_clkin(self.clk48_bufg, 48e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq, gated_replicas={self.cd_clk100_gated : pll.locked & self.curve25519_on})
        platform.add_platform_command("create_generated_clock -name sysclk [get_pins {{MMCME2_ADV/CLKOUT0}}]")
        pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
        platform.add_platform_command("create_generated_clock -name sys4xclk [get_pins {{MMCME2_ADV/CLKOUT1}}]")
        pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
        platform.add_platform_command("create_generated_clock -name sys4x90clk [get_pins {{MMCME2_ADV/CLKOUT2}}]")
        self.comb += pll.reset.eq(~rst_sbus) # | ~por_done 
        platform.add_false_path_constraints(self.cd_native.clk, self.cd_sbus.clk)
        platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_native.clk)
        #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_sbus.clk)
        #platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_sys.clk)
        ##platform.add_false_path_constraints(self.cd_native.clk, self.cd_sys.clk)
        
        pll.create_clkout(self.cd_clk50, sys_clk_freq/2, ce=pll.locked & self.curve25519_on)
        platform.add_platform_command("create_generated_clock -name clk50 [get_pins {{MMCME2_ADV/CLKOUT3}}]")
        pll.create_clkout(self.cd_clk200, sys_clk_freq*2, ce=pll.locked & self.curve25519_on)
        platform.add_platform_command("create_generated_clock -name clk200 [get_pins {{MMCME2_ADV/CLKOUT4}}]")
        
        #self.submodules.curve25519_pll = curve25519_pll = S7MMCM(speedgrade=-1)
        #curve25519_clk_freq = 90e6
        ##self.curve25519_on = Signal()
        ##curve25519_pll.register_clkin(clk48, 48e6)
        #curve25519_pll.register_clkin(self.clk48_bufg, 48e6)
        #curve25519_pll.create_clkout(self.cd_clk50,     curve25519_clk_freq/2, margin=0, ce=curve25519_pll.locked & self.curve25519_on)
        #platform.add_platform_command("create_generated_clock -name clk50 [get_pins {{MMCME2_ADV_1/CLKOUT0}}]")
        #curve25519_pll.create_clkout(self.cd_clk100,    curve25519_clk_freq, margin=0,   ce=curve25519_pll.locked,
        #                             gated_replicas={self.cd_clk100_gated : curve25519_pll.locked & self.curve25519_on})
        #platform.add_platform_command("create_generated_clock -name clk100 [get_pins {{MMCME2_ADV_1/CLKOUT1}}]")
        #curve25519_pll.create_clkout(self.cd_clk200,    curve25519_clk_freq*2, margin=0, ce=curve25519_pll.locked & self.curve25519_on)
        #platform.add_platform_command("create_generated_clock -name clk200 [get_pins {{MMCME2_ADV_1/CLKOUT2}}]")
        ##self.comb += curve25519_pll.reset.eq(~rst_sbus) # | ~por_done 
        #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_clk50.clk)
        #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_clk100.clk)
        #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_clk200.clk)
        #platform.add_false_path_constraints(self.cd_clk50.clk, self.cd_sys.clk)
        #platform.add_false_path_constraints(self.cd_clk100.clk, self.cd_sys.clk)
        #platform.add_false_path_constraints(self.cd_clk200.clk, self.cd_sys.clk)
        
        # Power on reset, reset propagate from SBus to SYS
#        por_count = Signal(16, reset=2**16-1)
#        por_done  = Signal()
#        self.comb += self.cd_por.clk.eq(clk48)
#        self.comb += por_done.eq(por_count == 0)
#        self.sync.por += If(~por_done, por_count.eq(por_count - 1))
#        self.comb += self.cd_por.rst.eq(~rst_sbus)
#        self.comb += pll.reset.eq(~por_done | ~rst_sbus)

        # USB
        if (usb):
            self.submodules.usb_pll = usb_pll = S7MMCM(speedgrade=-1)
            #usb_pll.register_clkin(clk48, 48e6)
            usb_pll.register_clkin(self.clk48_bufg, 48e6)
            usb_pll.create_clkout(self.cd_usb, 48e6, margin = 0)
            platform.add_platform_command("create_generated_clock -name usbclk [get_pins {{MMCME2_ADV_2/CLKOUT0}}]")
            self.comb += usb_pll.reset.eq(~rst_sbus) # | ~por_done 
            platform.add_false_path_constraints(self.cd_sys.clk, self.cd_usb.clk)
        
        self.submodules.pll_idelay = pll_idelay = S7MMCM(speedgrade=-1)
        #pll_idelay.register_clkin(clk48, 48e6)
        pll_idelay.register_clkin(self.clk48_bufg, 48e6)
        pll_idelay.create_clkout(self.cd_idelay, 200e6, margin = 0)
        platform.add_platform_command("create_generated_clock -name idelayclk [get_pins {{MMCME2_ADV_3/CLKOUT0}}]")
        self.comb += pll_idelay.reset.eq(~rst_sbus) # | ~por_done

        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)
        
class SBusFPGA(SoCCore):
    def __init__(self, version, usb, **kwargs):
        print(f"Building SBusFPGA for board version {version}")
        
        kwargs["cpu_type"] = "None"
        kwargs["integrated_sram_size"] = 0
        kwargs["with_uart"] = False
        kwargs["with_timer"] = False
        
        self.sys_clk_freq = sys_clk_freq = 100e6 ## 25e6
    
        self.platform = platform = ztex213_sbus.Platform(variant="ztex2.13a", version = version)

        xdc_timings_filename = None;
        if (version == "V1.0"):
            xdc_timings_filename = "/home/dolbeau/SBusFPGA/sbus-to-ztex-gateware/sbus-to-ztex-timings.xdc"
            self.platform.add_extension(ztex213_sbus._usb_io_v1_0)
        elif (version == "V1.2"):
            xdc_timings_filename = "/home/dolbeau/SBusFPGA/sbus-to-ztex-gateware/sbus-to-ztex-timings-V1_2.xdc"

        if (xdc_timings_filename != None):
            xdc_timings_file = open(xdc_timings_filename)
            xdc_timings_lines = xdc_timings_file.readlines()
            for line in xdc_timings_lines:
                if (line[0:3] == "set"):
                    fix_line = line.strip().replace("{", "{{").replace("}", "}}")
                    print(fix_line)
                    platform.add_platform_command(fix_line)
        
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
        # (themselves constrained by the SBus MMU capabilities)
        self.wb_mem_map = wb_mem_map = {
            "prom":             0x00000000,
            "csr" :             0x00040000,
            "usb_host":         0x00080000,
            "usb_shared_mem":   0x00090000, # unused
            "curve25519engine": 0x000a0000,
            "main_ram":         0x80000000,
            "usb_fake_dma":     0xfc000000,
        }
        self.mem_map.update(wb_mem_map)
        self.submodules.crg = _CRG(platform=platform, sys_clk_freq=sys_clk_freq, usb=usb)
        self.platform.add_period_constraint(self.platform.lookup_request("SBUS_3V3_CLK", loose=True), 1e9/25e6) # SBus max

        if (version == "V1.0"):
            self.submodules.leds = LedChaser(
                pads         = platform.request("SBUS_DATA_OE_LED_2"),
                sys_clk_freq = sys_clk_freq)
            self.add_csr("leds")

        if (usb):
            self.add_usb_host(pads=platform.request("usb"), usb_clk_freq=48e6)
            if (version == "V1.0"):
                pad_usb_interrupt = platform.request("SBUS_3V3_INT1s") ## only one usable
            elif (version == "V1.2"):
                pad_usb_interrupt = platform.request("SBUS_3V3_INT3s") ## can be 1-6, beware others
            sig_usb_interrupt = Signal(reset=1)
            # the 74LVC2G07 takes care of the Z state: 1 -> Z on the bus, 0 -> 0 on the bus (asserted interrupt)
            self.comb += pad_usb_interrupt.eq(sig_usb_interrupt)
            self.comb += sig_usb_interrupt.eq(~self.usb_host.interrupt) ##
            
        
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

        self.submodules.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
                                                   memtype        = "DDR3",
                                                   nphases        = 4,
                                                   sys_clk_freq   = sys_clk_freq)
        self.add_sdram("sdram",
                       phy           = self.ddrphy,
                       module        = MT41J128M16(sys_clk_freq, "1:4"),
                       l2_cache_size = 0,
        )
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

        # SPARCstation 20 slave interface to the main memory are limited to 32-bytes burst (32-bits wide, 8 word long)
        # burst_size=16 should work on Ultra systems, but then they probably should go for 64-bits ET as well...
        # Older systems are probably limited to burst_size=4, (it should always be available)
        burst_size=8
        self.submodules.tosbus_fifo = ClockDomainsRenamer({"read": "sbus", "write": "sys"})(AsyncFIFOBuffered(width=(32+burst_size*32), depth=burst_size))
        self.submodules.fromsbus_fifo = ClockDomainsRenamer({"write": "sbus", "read": "sys"})(AsyncFIFOBuffered(width=((30-log2_int(burst_size))+burst_size*32), depth=burst_size))
        self.submodules.fromsbus_req_fifo = ClockDomainsRenamer({"read": "sbus", "write": "sys"})(AsyncFIFOBuffered(width=((30-log2_int(burst_size))+32), depth=burst_size))

        self.submodules.dram_dma_writer = LiteDRAMDMAWriter(port=self.sdram.crossbar.get_port(mode="write", data_width=burst_size*32),
                                                            fifo_depth=4,
                                                            fifo_buffered=True)

        self.submodules.dram_dma_reader = LiteDRAMDMAReader(port=self.sdram.crossbar.get_port(mode="read", data_width=burst_size*32),
                                                            fifo_depth=4,
                                                            fifo_buffered=True)

        self.submodules.exchange_with_mem = ExchangeWithMem(soc=self,
                                                            tosbus_fifo=self.tosbus_fifo,
                                                            fromsbus_fifo=self.fromsbus_fifo,
                                                            fromsbus_req_fifo=self.fromsbus_req_fifo,
                                                            dram_dma_writer=self.dram_dma_writer,
                                                            dram_dma_reader=self.dram_dma_reader,
                                                            burst_size=burst_size,
                                                            do_checksum = True)
        
        _sbus_bus = SBusFPGABus(platform=self.platform,
                                hold_reset=hold_reset,
                                wishbone_slave=wishbone_slave_sbus,
                                wishbone_master=self.wishbone_master_sbus,
                                tosbus_fifo=self.tosbus_fifo,
                                fromsbus_fifo=self.fromsbus_fifo,
                                fromsbus_req_fifo=self.fromsbus_req_fifo,
                                version=version,
                                burst_size=burst_size)
        #self.submodules.sbus_bus = _sbus_bus
        self.submodules.sbus_bus = ClockDomainsRenamer("sbus")(_sbus_bus)
        self.submodules.sbus_bus_stat = SBusFPGABusStat(sbus_bus = self.sbus_bus)

        self.bus.add_master(name="SBusBridgeToWishbone", master=wishbone_master_sys)

        if (usb):
            self.bus.add_slave(name="usb_fake_dma", slave=self.wishbone_slave_sys, region=SoCRegion(origin=self.mem_map.get("usb_fake_dma", None), size=0x03ffffff, cached=False))
        #self.bus.add_master(name="mem_read_master", master=self.exchange_with_mem.wishbone_r_slave)
        #self.bus.add_master(name="mem_write_master", master=self.exchange_with_mem.wishbone_w_slave)
        
        #self.add_sdcard()

        self.submodules.trng = NeoRV32TrngWrapper(platform=platform)

        # beware the naming, as 'clk50' 'sysclk' 'clk200' are used in the original platform constraints
        # the local engine.py was slightly modified to have configurable names, so we can have 'clk50', 'clk100', 'clk200'
        # Beware that Engine implicitely runs in 'sys' by default, need to rename that one as well
        # Actually renaming 'sys' doesn't work - unless we can CDC the CSRs as well
        self.submodules.curve25519engine = ClockDomainsRenamer({"eng_clk":"clk50", "rf_clk":"clk200", "mul_clk":"clk100_gated"})(Engine(platform=platform,prefix=self.mem_map.get("curve25519engine", None))) # , "sys":"clk100"
        #self.submodules.curve25519engine_wishbone_cdc = wishbone.WishboneDomainCrossingMaster(platform=self.platform, slave=self.curve25519engine.bus, cd_master="sys", cd_slave="clk100")
        #self.bus.add_slave("curve25519engine", self.curve25519engine_wishbone_cdc, SoCRegion(origin=self.mem_map.get("curve25519engine", None), size=0x20000, cached=False))
        self.bus.add_slave("curve25519engine", self.curve25519engine.bus, SoCRegion(origin=self.mem_map.get("curve25519engine", None), size=0x20000, cached=False))
        self.bus.add_master(name="curve25519engineLS", master=self.curve25519engine.busls)
        #self.submodules.curve25519_on_sync = BusSynchronizer(width = 1, idomain = "clk100", odomain = "sys")
        #self.comb += self.curve25519_on_sync.i.eq(self.curve25519engine.power.fields.on)
        #self.comb += self.crg.curve25519_on.eq(self.curve25519_on_sync.o)
        self.comb += self.crg.curve25519_on.eq(self.curve25519engine.power.fields.on)
        
def main():
    parser = argparse.ArgumentParser(description="SbusFPGA")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--version", default="V1.0", help="SBusFPGA board version (default V1.0)")
    parser.add_argument("--usb", action="store_true", help="add a USB OHCI controller")
    builder_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()
    
    soc = SBusFPGA(**soc_core_argdict(args),
                   version=args.version,
                   usb=args.usb)
    #soc.add_uart(name="uart", baudrate=115200, fifo_depth=16)
    
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

    # Generate modified CSR registers definitions/access functions to netbsd_csr.h.
    # should be split per-device (and without base) to still work if we have identical devices in different configurations on multiple boards
    csr_contents = sbus_to_fpga_export.get_csr_header(
        regions   = soc.csr_regions,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    write_to_file(os.path.join("netbsd_csr.h"), csr_contents)

    csr_contents_dict = sbus_to_fpga_export.get_csr_header_split(
        regions   = soc.csr_regions,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    for name in csr_contents_dict.keys():
        write_to_file(os.path.join("sbusfpga_csr_{}.h".format(name)), csr_contents_dict[name])
    

    # tells the prom where to find what
    # just one, as that is board-specific
    # BEWARE! then need to run 'forth_to_migen_rom.sh' *and* regenerate the bitstream with the proper PROM built-in!
    # (there's surely a better way...)
    csr_forth_contents = sbus_to_fpga_export.get_csr_forth_header(
        csr_regions   = soc.csr_regions,
        mem_regions   = soc.mem_regions,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    write_to_file(os.path.join("prom_csr.fth"), csr_forth_contents)
    
if __name__ == "__main__":
    main()
