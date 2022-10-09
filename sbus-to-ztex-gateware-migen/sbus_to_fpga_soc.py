import os
import argparse
from migen import *
from migen.genlib.fifo import *
from migen.fhdl.specials import Tristate

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

from litedram.modules import MT41J128M16
from litedram.phy import s7ddrphy

from sbus_to_fpga_fsm import *
from sbus_to_fpga_fsmstat import *
from sbus_to_fpga_blk_dma import *
from sbus_to_fpga_trng import *

from engine import Engine
from migen.genlib.cdc import BusSynchronizer
from migen.genlib.resetsync import AsyncResetSynchronizer

# betrusted-io/gateware
from gateware.i2c import *

import sbus_to_fpga_export
import sbus_to_fpga_prom

from litex.soc.cores.video import VideoVGAPHY
import bw2_fb
import cg3_fb
import cg6_fb
import cg6_accel
import goblin_fb
import goblin_accel

# Wishbone stuff
from sbus_wb import WishboneDomainCrossingMaster

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    def __init__(self, platform, sys_clk_freq,
                 usb=False,
                 usb_clk_freq=48e6,
                 engine=False,
                 i2c=False,
                 framebuffer=False,
                 pix_clk=0):
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
        if (engine):
            self.clock_domains.cd_clk50     = ClockDomain() # 50 MHz (gated) for curve25519engine  -> eng_clk
            #self.clock_domains.cd_clk100    = ClockDomain() # 100 MHz for curve25519engine -> sys_clk
            self.clock_domains.cd_clk200    = ClockDomain() # 200 MHz (gated) for curve25519engine -> rf_clk
        self.clock_domains.cd_clk100_gated = ClockDomain() # 100 MHz (gated) for curve25519engine -> mul_clk # aways created, along sysclk
        if (framebuffer):
            self.clock_domains.cd_vga       = ClockDomain(reset_less=True)

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
        if (clk_sbus is None):
            print(" ***** ERROR ***** Can't find the SBus Clock !!!!\n");
            assert(false)
        self.cd_sbus.clk = clk_sbus
        rst_sbus = platform.request("SBUS_3V3_RSTs")
        self.comb += self.cd_sbus.rst.eq(~rst_sbus)
        platform.add_platform_command("create_clock -name SBUS_3V3_CLK -period 40.0 [get_nets SBUS_3V3_CLK]")
        ##self.cd_sys.clk = clk_sbus
        ##self.comb += self.cd_sys.rst.eq(~rst_sbus)
        
        self.curve25519_on = Signal()

        num_adv = 0
        num_clk = 0

        self.submodules.pll = pll = S7MMCM(speedgrade=platform.speedgrade)
        #pll.register_clkin(clk48, 48e6)
        pll.register_clkin(self.clk48_bufg, 48e6)
        pll.create_clkout(self.cd_sys,       sys_clk_freq, gated_replicas={self.cd_clk100_gated : pll.locked & self.curve25519_on})
        platform.add_platform_command("create_generated_clock -name sysclk [get_pins {{{{MMCME2_ADV/CLKOUT{}}}}}]".format(num_clk))
        num_clk = num_clk + 1
        pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
        platform.add_platform_command("create_generated_clock -name sys4xclk [get_pins {{{{MMCME2_ADV/CLKOUT{}}}}}]".format(num_clk))
        num_clk = num_clk + 1
        pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
        platform.add_platform_command("create_generated_clock -name sys4x90clk [get_pins {{{{MMCME2_ADV/CLKOUT{}}}}}]".format(num_clk))
        num_clk = num_clk + 1
        self.comb += pll.reset.eq(~rst_sbus) # | ~por_done 
        platform.add_false_path_constraints(self.cd_native.clk, self.cd_sbus.clk) # FIXME?
        platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_native.clk) # FIXME?
        #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_sbus.clk)
        #platform.add_false_path_constraints(self.cd_sbus.clk, self.cd_sys.clk)
        ##platform.add_false_path_constraints(self.cd_native.clk, self.cd_sys.clk)
        if (engine):
            pll.create_clkout(self.cd_clk50, sys_clk_freq/2, ce=pll.locked & self.curve25519_on)
            platform.add_platform_command("create_generated_clock -name clk50 [get_pins {{{{MMCME2_ADV/CLKOUT{}}}}}]".format(num_clk))
            num_clk = num_clk + 1
            pll.create_clkout(self.cd_clk200, sys_clk_freq*2, ce=pll.locked & self.curve25519_on)
            platform.add_platform_command("create_generated_clock -name clk200 [get_pins {{{{MMCME2_ADV/CLKOUT{}}}}}]".format(num_clk))
            num_clk = num_clk + 1

        num_adv = num_adv + 1
        num_clk = 0
        
        #self.submodules.curve25519_pll = curve25519_pll = S7MMCM(speedgrade=platform.speedgrade)
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
            self.submodules.usb_pll = usb_pll = S7MMCM(speedgrade=platform.speedgrade)
            #usb_pll.register_clkin(clk48, 48e6)
            usb_pll.register_clkin(self.clk48_bufg, 48e6)
            usb_pll.create_clkout(self.cd_usb, usb_clk_freq, margin = 0)
            platform.add_platform_command("create_generated_clock -name usbclk [get_pins {{{{MMCME2_ADV_{}/CLKOUT{}}}}}]".format(num_adv, num_clk))
            num_clk = num_clk + 1
            self.comb += usb_pll.reset.eq(~rst_sbus) # | ~por_done 
            platform.add_false_path_constraints(self.cd_sys.clk, self.cd_usb.clk) # FIXME?
            num_adv = num_adv + 1
            num_clk = 0

        self.submodules.pll_idelay = pll_idelay = S7MMCM(speedgrade=platform.speedgrade)
        #pll_idelay.register_clkin(clk48, 48e6)
        pll_idelay.register_clkin(self.clk48_bufg, 48e6)
        pll_idelay.create_clkout(self.cd_idelay, 200e6, margin = 0)
        platform.add_platform_command("create_generated_clock -name idelayclk [get_pins {{{{MMCME2_ADV_{}/CLKOUT{}}}}}]".format(num_adv, num_clk))
        num_clk = num_clk + 1
        self.comb += pll_idelay.reset.eq(~rst_sbus) # | ~por_done
        self.submodules.idelayctrl = S7IDELAYCTRL(self.cd_idelay)
        num_adv = num_adv + 1
        num_clk = 0
        
        if (framebuffer):
            self.submodules.video_pll = video_pll = S7MMCM(speedgrade=platform.speedgrade)
            video_pll.register_clkin(self.clk48_bufg, 48e6)
            video_pll.create_clkout(self.cd_vga, pix_clk, margin = 0.0005)
            platform.add_platform_command("create_generated_clock -name vga_clk [get_pins {{{{MMCME2_ADV_{}/CLKOUT{}}}}}]".format(num_adv, num_clk))
            num_clk = num_clk + 1
            self.comb += video_pll.reset.eq(~rst_sbus)
            #platform.add_false_path_constraints(self.cd_sys.clk, self.cd_vga.clk)
            platform.add_false_path_constraints(self.cd_sys.clk, video_pll.clkin)
            num_adv = num_adv + 1
            num_clk = 0
            
        
        
class SBusFPGA(SoCCore):
    # Add USB Host
    def add_usb_host_custom(self, name="usb_host", pads=None, usb_clk_freq=48e6, single_dvma_master=False):
        from litex.soc.cores.usb_ohci import USBOHCI
        self.submodules.usb_host = USBOHCI(platform=self.platform, pads=pads, usb_clk_freq=usb_clk_freq, dma_data_width=32)
        usb_host_region_size = 0x10000
        usb_host_region = SoCRegion(origin=self.mem_map.get(name, None), size=usb_host_region_size, cached=False)
        self.bus.add_slave("usb_host_ctrl", self.usb_host.wb_ctrl, region=usb_host_region)
        if (not single_dvma_master):
            self.bus.add_master("usb_host_dma", master=self.usb_host.wb_dma)
        #if self.irq.enabled:
            #self.irq.add(name, use_loc_if_exists=True)
            
    def __init__(self, variant, version, sys_clk_freq, trng, stat, usb, sdram, engine, i2c, bw2, cg3, cg6, goblin, cg3_res, sdcard, jareth, **kwargs):
        framebuffer = (bw2 or cg3 or cg6 or goblin)
        
        print(f"Building SBusFPGA for board version {version}")
        print(f"Summary: variant={variant} sys_clk_freq={sys_clk_freq} trng={trng} stat={stat} usb={usb} sdram={sdram} engine={engine} i2c={i2c} bw2={bw2} cg3={cg3} cg6={cg6} goblin={goblin} (framebuffer={framebuffer}) fb_res={cg3_res} sdcard={sdcard} jareth={jareth}")
        
        kwargs["cpu_type"] = "None"
        kwargs["integrated_sram_size"] = 0
        kwargs["with_uart"] = False
        kwargs["with_timer"] = False
        
        self.sys_clk_freq = sys_clk_freq
    
        self.platform = platform = ztex213_sbus.Platform(variant = variant, version = version)

        if (framebuffer and (version == "V1.2")):
            platform.add_extension(ztex213_sbus._vga_pmod_io_v1_2)

        if (framebuffer):
            hres = int(cg3_res.split("@")[0].split("x")[0])
            vres = int(cg3_res.split("@")[0].split("x")[1])
            cg3_fb_size = 0
            if (bw2):
                cg3_fb_size = bw2_fb.bw2_rounded_size(hres, vres)
            elif (cg3 or cg6):
                cg3_fb_size = cg3_fb.cg3_rounded_size(hres, vres)
            elif (goblin):
                cg3_fb_size = goblin_fb.goblin_rounded_size(hres, vres, "SBus")
            print(f"Reserving {cg3_fb_size} bytes ({cg3_fb_size//1048576} MiB) for the Framebuffer")
        else:
            hres = 0
            vres = 0
            cg3_fb_size = 0
        litex.soc.cores.video.video_timings.update(cg3_fb.cg3_timings)

        # if there's just one DVMA bus master in the design,
        # then we'll connect it directly to the wishbone interface
        # in the FSM rather than to the system Wishbone bus
        # sdcard has two by itself, so never a single_dvma_master
        single_dvma_master = False
        if (usb and not engine and not sdcard): # fixme: others?
            single_dvma_master = True
        if (engine and not usb and not sdcard): # fixme: others?
            single_dvma_master = True
        
        SoCCore.__init__(self,
                         platform=platform,
                         sys_clk_freq=sys_clk_freq,
                         clk_freq=sys_clk_freq,
                         csr_paging=0x1000, #  default is 0x800
                         **kwargs)

        # *** This mem-map is also exposed in the FSM (matched prefixes) ***
        # and in the PROM (to tell NetBSD where everything is)
        # Currently it is a straight mapping between the two:
        # the physical address here are used as offset in the SBus
        # reserved area of 256 MiB
        # Anything at 0x10000000 is therefore unreachable directly
        # The position of the 'dvma_bridge' is so it overlaps
        # the virtual address space used by NetBSD DMA allocators
        # (themselves constrained by the SBus MMU capabilities)
        # ... on the SS20. It seems NetBSD 9.0 on the SS IPX behave
        # differently.
        self.wb_mem_map = wb_mem_map = {
            "prom":             0x00000000, # 256 Kib ought to be enough for anybody (we're using < 8 Kib now...)
            "csr" :             0x00040000,
            "usb_host":         0x00080000, # OHCI registers are here, not in CSR
            #"usb_shared_mem":   0x00090000, # unused ATM
            "curve25519engine": 0x000a0000, # includes microcode (4 KiB@0) and registers (16 KiB @ 64 KiB)
            "jareth":           0x000c0000, # a.k.a. goblin_accel (now)
            "cg6_bt":           0x00200000, # required for compatibility, bt_regs for cg6 and goblin
            #"cg6_dhc":          0x00240000, # required for compatibility, unused
            "cg6_alt":          0x00280000, # required for compatibility
            "cg6_fhc":          0x00300000, # required for compatibility
            #"cg6_thc":          0x00301000, # required for compatibility
            "cg3_bt":           0x00400000, # required for compatibility, bt_regs for cg3 & bw2
            "cg6_accel_rom":    0x00410000, # R5 microcode # also "jareth"
            "cg6_accel_ram":    0x00420000, # R5 microcode working space (stack) # also "jareth"
            "cg6_fbc":          0x00700000, # required for compatibility
            #"cg6_tec":          0x00701000, # required for compatibility
            "cg3_pixels":       0x00800000, # required for compatibility, 1/2/4/8 MiB for now (up to 0x00FFFFFF inclusive) (bw2, cg3 and cg6 idem)
            "goblin_pixels":    0x01000000, # base address for 16 MiB Goblin Framebuffer
            "main_ram":         0x80000000, # not directly reachable from SBus mapping (only 0x0 - 0x10000000 is accessible),
            "video_framebuffer":0x80000000 + 0x10000000 - cg3_fb_size, # Updated later
            "dvma_bridge":      0xf0000000, # required to match DVMA virtual addresses
        }
        self.mem_map.update(wb_mem_map)
        self.submodules.crg = _CRG(platform=platform, sys_clk_freq=sys_clk_freq, usb=usb, usb_clk_freq=48e6, engine=engine, framebuffer=framebuffer, pix_clk=litex.soc.cores.video.video_timings[cg3_res]["pix_clk"])
            
        
        #self.platform.add_period_constraint(self.platform.lookup_request("SBUS_3V3_CLK", loose=True), 1e9/25e6) # SBus max

        ## add our custom timings after the clocks have been defined
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
                    #print(fix_line)
                    platform.add_platform_command(fix_line)

        if (version == "V1.0"):
            self.submodules.leds = LedChaser(
                pads         = platform.request("SBUS_DATA_OE_LED_2"),
                sys_clk_freq = sys_clk_freq)
            self.add_csr("leds")
        
        if (usb):
            self.add_usb_host_custom(pads=platform.request("usb"), usb_clk_freq=48e6, single_dvma_master=single_dvma_master)
            pad_usb_interrupt = platform.get_irq(irq_req=3, device="usb_host", next_down=True, next_up=False)
            if (pad_usb_interrupt is None):
                print(" ***** ERROR ***** USB requires an interrupt")
                assert(False)
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

        prom_file = "prom_{}.fc".format(version.replace(".", "_"))
        #prom_file = "SUNW,501-2325.bin" # real TGX
        #prom_file = "SUNW,501-1415.bin" # real cg3
        #prom_file = "SUNW,501-2253.bin" # real TGX+
        prom_data = soc_core.get_mem_data(filename_or_regions=prom_file, endianness="big")
        # prom = Array(prom_data)
        #print("\n****************************************\n")
        #for i in range(len(prom)):
        #    print(hex(prom[i]))
        #print("\n****************************************\n")
        prom_len = 4*len(prom_data);
        rounded_prom_len = 2**log2_int(prom_len, False)
        print(f"ROM is {prom_len} bytes, using {rounded_prom_len}")
        assert(rounded_prom_len <= 2**16)
        self.add_ram("prom", origin=self.mem_map["prom"], size=rounded_prom_len, contents=prom_data, mode="r")
        #getattr(self,"prom").mem.init = prom_data
        #getattr(self,"prom").mem.depth = 2**15

        self.submodules.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
                                                   memtype        = "DDR3",
                                                   nphases        = 4,
                                                   sys_clk_freq   = sys_clk_freq)
        self.add_sdram("sdram",
                       phy           = self.ddrphy,
                       module        = MT41J128M16(sys_clk_freq, "1:4"),
                       l2_cache_size = 0,
        )
        avail_sdram = self.bus.regions["main_ram"].size
        ###from sdram_init import DDR3FBInit
        ###self.submodules.sdram_init = DDR3FBInit(sys_clk_freq=sys_clk_freq, bitslip=1, delay=25) # for 100 MHz sysclk
        ###self.bus.add_master(name="DDR3Init", master=self.sdram_init.bus)

        base_fb = self.wb_mem_map["main_ram"] + avail_sdram - 1048576 # placeholder
        if (framebuffer):
            if (avail_sdram >= cg3_fb_size):
                avail_sdram = avail_sdram - cg3_fb_size
                base_fb = self.wb_mem_map["main_ram"] + avail_sdram
                self.wb_mem_map["video_framebuffer"] = base_fb
                print(f"Base FrameBuffer address is {base_fb:x}")
            else:
                print("***** ERROR ***** Can't have a FrameBuffer without main ram\n")
                assert(False)
    
        # don't enable anything on the SBus side for 20 seconds after power up
        # this avoids FPGA initialization messing with the cold boot process
        # requires us to reset the SPARCstation afterward so the FPGA board
        # is properly identified - or to 'probe-slot'
        # This is in the 'native' ClockDomain that is never reset
        hold_reset_ctr = Signal(30, reset=960000000)
        self.sync.native += If(hold_reset_ctr>0, hold_reset_ctr.eq(hold_reset_ctr - 1))
        hold_reset = Signal(reset=1)
        self.comb += hold_reset.eq(~(hold_reset_ctr == 0))

        # Interface SBus to wishbone
        # we need to cross clock domains
        wishbone_slave_sbus = wishbone.Interface(data_width=self.bus.data_width)
        wishbone_master_sys = wishbone.Interface(data_width=self.bus.data_width)
        self.submodules.wishbone_master_sbus = WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_master_sys, cd_master="sbus", cd_slave="sys")
        self.submodules.wishbone_slave_sys   = WishboneDomainCrossingMaster(platform=self.platform, slave=wishbone_slave_sbus, cd_master="sys", cd_slave="sbus")

        # SPARCstation 20 slave interface to the main memory are limited to 32-bytes burst (32-bits wide, 8 word long)
        # burst_size=16 should work on Ultra systems, but then they probably should go for 64-bits ET as well...
        # Older systems are probably limited to burst_size=4, (it should always be available)
        burst_size=8
        
        data_width = burst_size * 4
        data_width_bits = burst_size * 32
        blk_addr_width = 32 - log2_int(data_width)
        print(f"Burst configuration for DMA: burst_size = {burst_size} data_width = {data_width} data_width_bits = {data_width_bits} blk_addr_width = {blk_addr_width}\n");

        self.tosbus_layout = [
            ("address", 32),
            ("data", data_width_bits),
        ]
        self.fromsbus_layout = [
            ("blkaddress", blk_addr_width),
            ("data", data_width_bits),
        ]
        self.fromsbus_req_layout = [
            ("blkaddress", blk_addr_width),
            ("dmaaddress", 32),
        ]
        
        self.submodules.tosbus_fifo = ClockDomainsRenamer({"read": "sbus", "write": "sys"})(AsyncFIFOBuffered(width=layout_len(self.tosbus_layout), depth=burst_size))
        self.submodules.fromsbus_fifo = ClockDomainsRenamer({"write": "sbus", "read": "sys"})(AsyncFIFOBuffered(width=layout_len(self.fromsbus_layout), depth=burst_size))
        self.submodules.fromsbus_req_fifo = ClockDomainsRenamer({"read": "sbus", "write": "sys"})(AsyncFIFOBuffered(width=layout_len(self.fromsbus_req_layout), depth=burst_size))
        if (sdram):
            #self.submodules.dram_dma_writer = LiteDRAMDMAWriter(port=self.sdram.crossbar.get_port(mode="write", data_width=data_width_bits),
            #                                                    fifo_depth=4,
            #                                                    fifo_buffered=True)
            #
            #self.submodules.dram_dma_reader = LiteDRAMDMAReader(port=self.sdram.crossbar.get_port(mode="read", data_width=data_width_bits),
            #                                                    fifo_depth=4,
            #                                                    fifo_buffered=True)
            
            self.submodules.exchange_with_mem = ExchangeWithMem(soc=self,
                                                                platform=platform,
                                                                tosbus_fifo=self.tosbus_fifo,
                                                                fromsbus_fifo=self.fromsbus_fifo,
                                                                fromsbus_req_fifo=self.fromsbus_req_fifo,
                                                                #dram_dma_writer=self.dram_dma_writer,
                                                                #dram_dma_reader=self.dram_dma_reader,
                                                                dram_native_r=self.sdram.crossbar.get_port(mode="read", data_width=data_width_bits),
                                                                dram_native_w=self.sdram.crossbar.get_port(mode="write", data_width=data_width_bits),
                                                                mem_size=avail_sdram//1048576,
                                                                burst_size=burst_size,
                                                                do_checksum = False)
            pad_sdram_interrupt = platform.get_irq(irq_req=4, device="sdram", next_down=True, next_up=False)
            if (pad_sdram_interrupt is None):
                print(" ***** ERROR ***** sdram requires an interrupt")
                assert(False)
            sig_sdram_interrupt = Signal(reset=1)
            # the 74LVC2G07 takes care of the Z state: 1 -> Z on the bus, 0 -> 0 on the bus (asserted interrupt)
            self.comb += pad_sdram_interrupt.eq(sig_sdram_interrupt)
            self.comb += sig_sdram_interrupt.eq(~self.exchange_with_mem.irq) ##
        
        _sbus_bus = SBusFPGABus(soc=self,
                                platform=self.platform,
                                stat=stat,
                                hold_reset=hold_reset,
                                wishbone_slave=wishbone_slave_sbus,
                                wishbone_master=self.wishbone_master_sbus,
                                tosbus_fifo=self.tosbus_fifo,
                                fromsbus_fifo=self.fromsbus_fifo,
                                fromsbus_req_fifo=self.fromsbus_req_fifo,
                                version=version,
                                burst_size=burst_size,
                                cg3_fb_size=cg3_fb_size,
                                cg3_base=base_fb)
        #self.submodules.sbus_bus = _sbus_bus
        self.submodules.sbus_bus = ClockDomainsRenamer("sbus")(_sbus_bus)

        if (stat):
            self.submodules.sbus_bus_stat = SBusFPGABusStat(soc = self, sbus_bus = self.sbus_bus)

        self.bus.add_master(name="SBusBridgeToWishbone", master=wishbone_master_sys)

        if (usb):
            if (single_dvma_master):
                self.comb += self.usb_host.wb_dma.connect(self.wishbone_slave_sys)

        if (sdcard):
            self.add_sdcard()
            #pad_sdcard_interrupt = platform.get_irq(irq_req=2, device="sdcard", next_down=True, next_up=False)
            #if (pad_sdcard_interrupt is None):
            #    print(" ***** ERROR ***** sdcard requires an interrupt")
            #    assert(False)
            #sig_sdcard_interrupt = Signal(reset=1)
            ## the 74LVC2G07 takes care of the Z state: 1 -> Z on the bus, 0 -> 0 on the bus (asserted interrupt)
            #self.comb += pad_sdcard_interrupt.eq(sig_sdcard_interrupt)
            #self.comb += sig_sdcard_interrupt.eq(~self.sdirq.irq) ##

        if (usb or engine or sdcard or jareth): # jareth only for testing
            if (not single_dvma_master):
                self.bus.add_slave(name="dvma_bridge", slave=self.wishbone_slave_sys, region=SoCRegion(origin=self.mem_map.get("dvma_bridge", None), size=0x0fffffff, cached=False))

        if (trng):
            self.submodules.trng = NeoRV32TrngWrapper(platform=platform)

        # beware the naming, as 'clk50' 'sysclk' 'clk200' are used in the original platform constraints
        # the local engine.py was slightly modified to have configurable names, so we can have 'clk50', 'clk100', 'clk200'
        # Beware that Engine implicitely runs in 'sys' by default, need to rename that one as well
        # Actually renaming 'sys' doesn't work - unless we can CDC the CSRs as well
        if (engine):
            self.submodules.curve25519engine = ClockDomainsRenamer({"eng_clk":"clk50", "rf_clk":"clk200", "mul_clk":"clk100_gated"})(Engine(platform=platform,prefix=self.mem_map.get("curve25519engine", None))) # , "sys":"clk100"
            self.bus.add_slave("curve25519engine", self.curve25519engine.bus, SoCRegion(origin=self.mem_map.get("curve25519engine", None), size=0x20000, cached=False))
            if (not single_dvma_master):
                self.bus.add_master(name="curve25519engineLS", master=self.curve25519engine.busls)
            else:
                self.comb += self.curve25519engine.busls.connect(self.wishbone_slave_sys)
            self.comb += self.crg.curve25519_on.eq(self.curve25519engine.power.fields.on)
            
        if (i2c):
            self.submodules.i2c = RTLI2C(platform, pads=platform.request("i2c"))

        if (framebuffer):
            self.submodules.videophy = VideoVGAPHY(platform.request("vga"), clock_domain="vga")
            if (bw2):
                self.submodules.bw2 = bw2_fb.bw2(soc=self, phy=self.videophy, timings=cg3_res, clock_domain="vga") # clock_domain for the VGA side, bw2 is running in cd_sys
                self.bus.add_slave("bw2_bt", self.bw2.bus, SoCRegion(origin=self.mem_map.get("cg3_bt", None), size=0x1000, cached=False)) # bw2 uses cg3_bt
            elif (cg3):
                self.submodules.cg3 = cg3_fb.cg3(soc=self, phy=self.videophy, timings=cg3_res, clock_domain="vga") # clock_domain for the VGA side, cg3 is running in cd_sys
                self.bus.add_slave("cg3_bt", self.cg3.bus, SoCRegion(origin=self.mem_map.get("cg3_bt", None), size=0x1000, cached=False))
            elif (cg6):
                self.submodules.cg6 = cg6_fb.cg6(soc=self, phy=self.videophy, timings=cg3_res, clock_domain="vga") # clock_domain for the VGA side, cg6 is running in cd_sys
                self.bus.add_slave("cg6_bt", self.cg6.bus, SoCRegion(origin=self.mem_map.get("cg6_bt", None), size=0x1000, cached=False))
            elif (goblin):
                self.submodules.goblin = goblin_fb.goblin(soc=self, phy=self.videophy, timings=cg3_res, clock_domain="vga", irq_line=Signal(), endian="big", hwcursor=True, truecolor=True) # clock_domain for the VGA side, goblin is running in cd_sys
                self.bus.add_slave("goblin_bt", self.goblin.bus, SoCRegion(origin=self.mem_map.get("cg6_bt", None), size=0x1000, cached=False))
                #pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
                #SBUS_DATA_OE_LED_o = Signal()
                #self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
                #self.comb += SBUS_DATA_OE_LED_o.eq(self.goblin.video_framebuffer_vtg.enable)
                
            if (cg6):
                self.submodules.cg6_accel = cg6_accel.CG6Accel(soc = self, base_fb = base_fb, hres = hres, vres = vres)
                self.bus.add_slave("cg6_fbc", self.cg6_accel.bus, SoCRegion(origin=self.mem_map.get("cg6_fbc", None), size=0x2000, cached=False))
                self.bus.add_slave("cg6_fhc", self.cg6.bus2, SoCRegion(origin=self.mem_map.get("cg6_fhc", None), size=0x2000, cached=False))
                self.bus.add_slave("cg6_alt", self.cg6.bus3, SoCRegion(origin=self.mem_map.get("cg6_alt", None), size=0x2000, cached=False))
                self.bus.add_master(name="cg6_accel_r5_i", master=self.cg6_accel.ibus)
                self.bus.add_master(name="cg6_accel_r5_d", master=self.cg6_accel.dbus)
                cg6_rom_file = "blit_cg6.raw"
                cg6_rom_data = soc_core.get_mem_data(filename_or_regions=cg6_rom_file, endianness="little")
                cg6_rom_len = 4*len(cg6_rom_data);
                rounded_cg6_rom_len = 2**log2_int(cg6_rom_len, False)
                print(f"CG6 ROM is {cg6_rom_len} bytes, using {rounded_cg6_rom_len}")
                assert(rounded_cg6_rom_len <= 2**16)
                self.add_ram("cg6_accel_rom", origin=self.mem_map["cg6_accel_rom"], size=rounded_cg6_rom_len, contents=cg6_rom_data, mode="r")
                self.add_ram("cg6_accel_ram", origin=self.mem_map["cg6_accel_ram"], size=2**12, mode="rw")

            if (jareth):
                self.submodules.goblin_accel = goblin_accel.GoblinAccelSBus(soc = self)
                self.bus.add_slave("goblin_accel", self.goblin_accel.bus, SoCRegion(origin=self.mem_map.get("jareth", None), size=0x1000, cached=False))
                self.bus.add_master(name="goblin_accel_r5_i", master=self.goblin_accel.ibus)
                self.bus.add_master(name="goblin_accel_r5_d", master=self.goblin_accel.dbus)
                goblin_rom_file = "blit_goblin.raw"
                goblin_rom_data = soc_core.get_mem_data(filename_or_regions=goblin_rom_file, endianness="little")
                goblin_rom_len = 4*len(goblin_rom_data);
                rounded_goblin_rom_len = 2**log2_int(goblin_rom_len, False)
                print(f"GOBLIN ROM is {goblin_rom_len} bytes, using {rounded_goblin_rom_len}")
                assert(rounded_goblin_rom_len <= 2**16)
                self.add_ram("goblin_accel_rom", origin=self.mem_map["cg6_accel_rom"], size=rounded_goblin_rom_len, contents=goblin_rom_data, mode="r")
                self.add_ram("goblin_accel_ram", origin=self.mem_map["cg6_accel_ram"], size=2**12, mode="rw")
                
        print("IRQ to Device map:\n")
        print(platform.irq_device_map)
        print("Device to IRQ map:\n")
        print(platform.device_irq_map)

        #disable remaining IRQs
        if (version == "V1.0"):
            platform.avail_irqs.add(7)
            
        for irq in platform.avail_irqs:
            pad_int = platform.request(f"SBUS_3V3_INT{irq}s")
            oe_int = Signal(reset = 0)
            val_int = Signal(reset = 1)
            self.specials += Tristate(pad_int, val_int, oe_int, None)
        
def main():
    parser = argparse.ArgumentParser(description="SbusFPGA")
    parser.add_argument("--build", action="store_true", help="Build bitstream")
    parser.add_argument("--variant", default="ztex2.13a", help="ZTex board variant (default ztex2.13a)")
    parser.add_argument("--version", default="V1.2", help="SBusFPGA board version (default V1.2)")
    parser.add_argument("--stat", action="store_true", help="device with some SBus FSM statistics for debug [all]")
    parser.add_argument("--sys-clk-freq", default=100e6, help="SBusFPGA system clock (default 100e6 = 100 MHz)")
    parser.add_argument("--trng", action="store_true", help="add true random number generator [all]")
    parser.add_argument("--sdram", action="store_true", help="expose the sdram to the host [all]")
    parser.add_argument("--usb", action="store_true", help="add a USB OHCI controller [V1.2]")
    parser.add_argument("--engine", action="store_true", help="add a Engine crypto core [all]")
    parser.add_argument("--i2c", action="store_true", help="add an I2C bus [V1.2+custom temp. pmod]")
    parser.add_argument("--bw2", action="store_true", help="add a BW2 framebuffer [V1.2+VGA_RGB222 pmod]")
    parser.add_argument("--cg3", action="store_true", help="add a CG3 framebuffer [V1.2+VGA_RGB222 pmod]")
    parser.add_argument("--cg3-res", default="1152x900@76Hz", help="Specify the CG3/CG6 resolution")
    parser.add_argument("--cg6", action="store_true", help="add a CG6 framebuffer [V1.2+VGA_RGB222 pmod]")
    parser.add_argument("--goblin", action="store_true", help="add a Goblin framebuffer [V1.2+VGA_RGB222 pmod]")
    parser.add_argument("--sdcard", action="store_true", help="add a sdcard controller [all]")
    parser.add_argument("--jareth", action="store_true", help="add a Jareth vector core [all]")
    builder_args(parser)
    vivado_build_args(parser)
    args = parser.parse_args()

    if (args.sdram == False):
        print(" ***** WARNING ***** : not enabling the SDRAM still adds a controller, but doesn't add the DMA engines\n")
    if (args.usb and (args.version == "V1.0")):
        print(" ***** WARNING ***** : USB on V1.0 is an ugly hack \n");
    if (args.i2c):
        print(" ***** WARNING ***** : I2C on V1.x is for testing the core \n");
    if ((args.bw2 or args.cg3 or args.cg6 or args.goblin) and (args.version == "V1.0")):
        print(" ***** ERROR ***** : VGA not supported on V1.0\n")
        assert(False)
    fbcount = 0
    if (args.bw2):
        fbcount = fbcount + 1
    if (args.cg3):
        fbcount = fbcount + 1
    if (args.cg6):
        fbcount = fbcount + 1
    if (args.goblin):
        fbcount = fbcount + 1
    if (fbcount > 1):
        print(" ***** ERROR ***** : can't have more than one of BW2, CG3, CG6 and Goblin\n")
        assert(False)
    if ((fbcount > 0) and args.i2c):
        print(" ***** ERROR ***** : Framebuffers and I2C are incompatible in V1.2\n")
    
    soc = SBusFPGA(**soc_core_argdict(args),
                   variant=args.variant,
                   version=args.version,
                   sys_clk_freq=int(float(args.sys_clk_freq)),
                   stat=args.stat,
                   trng=args.trng,
                   sdram=args.sdram,
                   usb=args.usb,
                   engine=args.engine,
                   i2c=args.i2c,
                   bw2=args.bw2,
                   cg3=args.cg3,
                   cg6=args.cg6,
                   goblin=args.goblin,
                   cg3_res=args.cg3_res,
                   sdcard=args.sdcard,
                   jareth=args.jareth)
    #soc.add_uart(name="uart", baudrate=115200, fifo_depth=16)

    version_for_filename = args.version.replace(".", "_")

    soc.platform.name += "_" + version_for_filename
    
    builder = Builder(soc, **builder_argdict(args))
    builder.build(**vivado_build_argdict(args), run=args.build)

    # Generate modified CSR registers definitions/access functions to netbsd_csr.h.
    # should be split per-device (and without base) to still work if we have identical devices in different configurations on multiple boards
    # now it is split
    #csr_contents = sbus_to_fpga_export.get_csr_header(
    #    regions   = soc.csr_regions,
    #    constants = soc.constants,
    #    csr_base  = soc.mem_regions['csr'].origin)
    #write_to_file(os.path.join("netbsd_csr.h"), csr_contents)

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
        device_irq_map = soc.platform.device_irq_map,
        constants = soc.constants,
        csr_base  = soc.mem_regions['csr'].origin)
    write_to_file(os.path.join(f"prom_csr_{version_for_filename}.fth"), csr_forth_contents)

    prom_content = sbus_to_fpga_prom.get_prom(soc=soc, version=args.version, sys_clk_freq=int(float(args.sys_clk_freq)),
                                              stat=args.stat,
                                              trng=args.trng,
                                              usb=args.usb,
                                              sdram=args.sdram,
                                              engine=args.engine,
                                              i2c=args.i2c,
                                              bw2=args.bw2,
                                              cg3=args.cg3,
                                              cg6=args.cg6,
                                              goblin=args.goblin,
                                              cg3_res=args.cg3_res,
                                              sdcard=args.sdcard,
                                              jareth=args.jareth)
    write_to_file(os.path.join(f"prom_{version_for_filename}.fth"), prom_content)
    
    
if __name__ == "__main__":
    main()
