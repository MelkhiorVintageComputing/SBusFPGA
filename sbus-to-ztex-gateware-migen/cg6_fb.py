from migen import *
from migen.genlib.fifo import *

from litex.soc.interconnect.csr import *
from litex.soc.interconnect import stream
from litex.soc.interconnect import wishbone
from litex.soc.cores.code_tmds import TMDSEncoder

from litex.build.io import SDROutput, DDROutput

from litex.soc.cores.video import *

from math import ceil;

# reuse the simple 8-bits DAC from cg3
import cg3_fb;

# a lot of that is identical to cg3_fb.cg3
class cg6(Module, AutoCSR):
    def __init__(self, soc, phy=None, timings = None, clock_domain="sys"):

        # 2 bits for color (0/r, 1/g, 2/b), 8 for @ and 8 for value
        self.submodules.upd_cmap_fifo = upd_cmap_fifo = ClockDomainsRenamer({"read": "vga", "write": "sys"})(AsyncFIFOBuffered(width=layout_len(cg3_fb.cmap_layout), depth=8))
        upd_cmap_fifo_din = Record(cg3_fb.cmap_layout)
        self.comb += self.upd_cmap_fifo.din.eq(upd_cmap_fifo_din.raw_bits())
        
        self.submodules.upd_overlay_fifo = upd_overlay_fifo = ClockDomainsRenamer({"read": "vga", "write": "sys"})(AsyncFIFOBuffered(width=1+5+32, depth=8))
        
        self.submodules.upd_omap_fifo = upd_omap_fifo = ClockDomainsRenamer({"read": "vga", "write": "sys"})(AsyncFIFOBuffered(width=layout_len(cg3_fb.omap_layout), depth=8))
        upd_omap_fifo_din = Record(cg3_fb.omap_layout)
        self.comb += self.upd_omap_fifo.din.eq(upd_omap_fifo_din.raw_bits())
        
        name = "video_framebuffer"
        # near duplicate of plaform.add_video_framebuffer
        # Video Timing Generator.
        vtg = VideoTimingGenerator(default_video_timings=timings if isinstance(timings, str) else timings[1], hwcursor=True)
        vtg = ClockDomainsRenamer(clock_domain)(vtg)
        setattr(self.submodules, f"{name}_vtg", vtg)

        # Video FrameBuffer.
        timings = timings if isinstance(timings, str) else timings[0]
        base = soc.mem_map.get(name)
        print(f"CG6: visible memory at {base:x}")
        hres = int(timings.split("@")[0].split("x")[0])
        vres = int(timings.split("@")[0].split("x")[1])
        freq = vtg.video_timings["pix_clk"]
        print(f"CG6: using {hres} x {vres}, {freq/1e6} MHz pixclk")
        vfb = cg3_fb.VideoFrameBuffer256c(dram_port = soc.sdram.crossbar.get_port(),
                                          upd_clut_fifo = upd_cmap_fifo,
                                          hres = hres,
                                          vres = vres,
                                          base = base,
                                          clock_domain = clock_domain,
                                          clock_faster_than_sys = (vtg.video_timings["pix_clk"] > soc.sys_clk_freq),
                                          hwcursor = True,
                                          upd_overlay_fifo = upd_overlay_fifo,
                                          upd_omap_fifo = upd_omap_fifo)
        setattr(self.submodules, name, vfb)

        # Connect Video Timing Generator to Video FrameBuffer.
        self.comb += vtg.source.connect(vfb.vtg_sink)

        # Connect Video FrameBuffer to Video PHY.
        self.comb += vfb.source.connect(phy if isinstance(phy, stream.Endpoint) else phy.sink)

        # Constants.
        soc.add_constant("VIDEO_FRAMEBUFFER_BASE", base)
        soc.add_constant("VIDEO_FRAMEBUFFER_HRES", hres)
        soc.add_constant("VIDEO_FRAMEBUFFER_VRES", vres)

        # cg6 ramdac registers - same as cg3, but used a bit differently...
        # struct bt_regs {
        # 	u_int	bt_addr;		/* map address register */
        # 	u_int	bt_cmap;		/* colormap data register */
        # 	u_int	bt_ctrl;		/* control register */
        # 	u_int	bt_omap;		/* overlay (cursor) map register */
        # };

        # for BT
        self.bus = bus = wishbone.Interface()

        bt_addr = Signal(8)
        bt_cmap_state = Signal(2)

        # the CG6 takes 32 bits write but only use the top 8 bits, for bt_addr & bt_cmap
        # alto it uses the BT HW cursor (though probably not in the console?)

        self.submodules.wishbone_fsm = wishbone_fsm = FSM(reset_state = "Reset")
        wishbone_fsm.act("Reset",
                         NextValue(bus.ack, 0),
                         NextState("Idle"))
        wishbone_fsm.act("Idle",
                         If(bus.cyc & bus.stb & bus.we & ~bus.ack & upd_cmap_fifo.writable, #write
                            # FIXME: should check for prefix?
                            Case(bus.adr[0:3], {
                                # bt_addr
                                0: [ NextValue(bt_addr, bus.dat_w[24:32]),
                                     NextValue(bt_cmap_state, 0),
                                ],
                                # bt_cmap
                                1: [ upd_cmap_fifo.we.eq(1),
                                     upd_cmap_fifo_din.color.eq(bt_cmap_state),
                                     upd_cmap_fifo_din.address.eq(bt_addr),
                                     upd_cmap_fifo_din.data.eq(bus.dat_w[24:32]),
                                     Case(bt_cmap_state, {
                                         0: [ NextValue(bt_cmap_state, 1), ],
                                         1: [ NextValue(bt_cmap_state, 2), ],
                                         2: [ NextValue(bt_cmap_state, 0), NextValue(bt_addr, (bt_addr+1) & 0xFF), ],
                                         "default":  NextValue(bt_cmap_state, 0),
                                     }),
                                ],
                                # bt_ctrl
                                # NetBSD driver adds 0x03<<24 to enable the cursor
                                2: [],
                                # bt_omap
                                # NetBSD driver write the cursor color in there 
                                3: [ upd_omap_fifo.we.eq(1),
                                     upd_omap_fifo_din.color.eq(bt_cmap_state),
                                     upd_omap_fifo_din.address.eq(bt_addr[0:2]),
                                     upd_omap_fifo_din.data.eq(bus.dat_w[24:32]),
                                     Case(bt_cmap_state, {
                                         0: [ NextValue(bt_cmap_state, 1), ],
                                         1: [ NextValue(bt_cmap_state, 2), ],
                                         2: [ NextValue(bt_cmap_state, 0), NextValue(bt_addr, (bt_addr+1) & 0xFF), ],
                                         "default":  NextValue(bt_cmap_state, 0),
                                     }),
                                ],
                                "default": [],
                            }),
                            NextValue(bus.ack, 1),
                         ).Elif(bus.cyc & bus.stb & ~bus.we & ~bus.ack, #read
                                Case(bus.adr[0:3], {
                                    # bt_addr
                                    0: [ NextValue(bus.dat_r, 0) ],
                                    # bt_cmap
                                    1: [ NextValue(bus.dat_r, 0)],
                                    # bt_ctrl: unused ??
                                    2: [ NextValue(bus.dat_r, 0)],
                                    # bt_omap: unused ??
                                    3: [ NextValue(bus.dat_r, 0)],
                                    "default": [],
                                }),
                                NextValue(bus.ack, 1),
                         ).Else(
                             NextValue(bus.ack, 0),
                         )
        )

        

        # for FHC/THC
        # fhc @ 0x300000
        # thc @ 0x301000
        # thc_cursxy # 0x8fc from THC
        # thc_cursmask[32] @ 0x900 from THC
        # thc_cursbits[32] @ 0x980 from THC

        hwcursor_x = Signal(12)
        hwcursor_y = Signal(12)

        self.comb += vtg.hwcursor_x.eq(hwcursor_x)
        self.comb += vtg.hwcursor_y.eq(hwcursor_y)

        #pad_SBUS_DATA_OE_LED = soc.platform.request("SBUS_DATA_OE_LED")
        #self.comb += pad_SBUS_DATA_OE_LED.eq((hwcursor_x < 1280) & (hwcursor_y < 1024));

        # FHC / THC
        self.bus2 = bus2 = wishbone.Interface()
        self.submodules.wishbone_fsm2 = wishbone_fsm2 = FSM(reset_state = "Reset")
        wishbone_fsm2.act("Reset",
                         NextValue(bus2.ack, 0),
                         NextState("Idle"))
        wishbone_fsm2.act("Idle",
                         If(bus2.cyc & bus2.stb & bus2.we & ~bus2.ack, #write
                            Case(bus2.adr[0:12], {
                                "default": [ ],
                                1599: [ NextValue(hwcursor_x, bus2.dat_w[16:28]),
                                        NextValue(hwcursor_y, bus2.dat_w[ 0:12]),
                                ],
                            }),
                            Case(bus2.adr[5:12], {
                                "default": [ ],
                                50 : [ upd_overlay_fifo.we.eq(1), # 50*32 = 1600..1631
                                       upd_overlay_fifo.din.eq(Cat(Signal(1, reset = 0), 31-bus2.adr[0:5], bus2.dat_w))
                                ],
                                51 : [ upd_overlay_fifo.we.eq(1), # 51*32 = 1632..1663
                                       upd_overlay_fifo.din.eq(Cat(Signal(1, reset = 1), 31-bus2.adr[0:5], bus2.dat_w))
                                ],
                            }),
                            NextValue(bus2.ack, 1),
                         ).Elif(bus2.cyc & bus2.stb & ~bus2.we & ~bus2.ack, #read
                                Case(bus2.adr[0:12], {
                                    "default": [ NextValue(bus2.dat_r, 0xDEADBEEF) ],
                                    # my TGX+ is 0x64b009ff as a console in 1152x900
                                    #0: [ NextValue(bus2.dat_r, 0x64b009ff) ], # claim revision 11 (TurboGX), that's the 0xb<<20
                                    0: [ NextValue(bus2.dat_r, 0x64b509ff) ], # claim revision 11 (TurboGX), that's the 0xb<<20
                                }),
                                NextValue(bus2.ack, 1),
                         ).Else(
                             NextValue(bus2.ack, 0),
                         )
        )

        # ALT catch-all
        self.bus3 = bus3 = wishbone.Interface()
        self.submodules.wishbone_fsm3 = wishbone_fsm3 = FSM(reset_state = "Reset")
        wishbone_fsm3.act("Reset",
                         NextValue(bus3.ack, 0),
                         NextState("Idle"))
        wishbone_fsm3.act("Idle",
                         If(bus3.cyc & bus3.stb & bus3.we & ~bus3.ack, #write
                            NextValue(bus3.ack, 1),
                         ).Elif(bus3.cyc & bus3.stb & ~bus3.we & ~bus3.ack, #read
                                NextValue(bus3.dat_r, 0xDEADBEEF),
                                NextValue(bus3.ack, 1),
                         ).Else(
                             NextValue(bus3.ack, 0),
                         )
        )
        
