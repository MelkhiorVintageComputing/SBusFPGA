from migen import *
from migen.genlib.fifo import *

from litex.soc.interconnect.csr import *
from litex.soc.interconnect import stream
from litex.soc.interconnect import wishbone
from litex.soc.cores.code_tmds import TMDSEncoder

from litex.build.io import SDROutput, DDROutput

from litex.soc.cores.video import *

from math import ceil;

DEPTH=1

def bw2_rounded_size(hres, vres):
    mib = int(ceil(((hres * vres * DEPTH)/8 + 0) / 1048576))
    if (mib == 3):
        mib = 4
    if (mib > 4 and mib < 8):
        mib = 8
    if (mib > 8 or mib < 1):
        print(f"{mib} mebibytes framebuffer not supported")
        assert(False)
    return int(1048576 * mib)

class VideoFrameBufferBW(Module, AutoCSR):
    """Video FrameBufferBW"""
    def __init__(self, dram_port, hres=800, vres=600, base=0x00000000, fifo_depth=65536, clock_domain="sys", clock_faster_than_sys=False):
        print(f"FRAMEBUFFER: dram_port.data_width = {dram_port.data_width}, {hres}x{vres}, 0x{base:x}, in {clock_domain}, clock_faster_than_sys={clock_faster_than_sys}")
        
        self.vtg_sink  = vtg_sink = stream.Endpoint(video_timing_layout)
        self.source    = source   = stream.Endpoint(video_data_layout)
        self.underflow = Signal()
        
        # # #

        # Video DMA.
        from litedram.frontend.dma import LiteDRAMDMAReader
        self.submodules.dma = LiteDRAMDMAReader(dram_port, fifo_depth=fifo_depth//(dram_port.data_width//8), fifo_buffered=True)
        self.dma.add_csr(
            default_base   = base,
            default_length = (hres*vres*DEPTH)//8, # 1-bit B&W
            default_enable = 0,
            default_loop   = 1
        )

        # If DRAM Data Width > DEPTH-bit and Video clock is faster than sys_clk:
        if (dram_port.data_width > DEPTH) and clock_faster_than_sys:
            # Do Clock Domain Crossing first...
            self.submodules.cdc = stream.ClockDomainCrossing([("data", dram_port.data_width)], cd_from="sys", cd_to=clock_domain)
            self.comb += self.dma.source.connect(self.cdc.sink)
            # bit reverse every byte...
            self.comb += [
                self.cdc.sink.data[0:8].eq(self.dma.source.data[7::-1])
            ]
            self.comb += [
                self.cdc.sink.data[x*8:(x+1)*8].eq(self.dma.source.data[((x+1)*8)-1:(x*8)-1:-1]) for x in range(1,(dram_port.data_width//8))
            ]
            # ... and then Data-Width Conversion.
            self.submodules.conv = ClockDomainsRenamer({"sys": clock_domain})(stream.Converter(dram_port.data_width, DEPTH))
            self.comb += self.cdc.source.connect(self.conv.sink)
            video_pipe_source = self.conv.source
        # Elsif DRAM Data Width < DEPTH-bit or Video clock is slower than sys_clk:
        else: #### FIXME: bit reversal in byte missing
            # Do Data-Width Conversion first...
            self.submodules.conv = stream.Converter(dram_port.data_width, DEPTH)
            self.comb += self.dma.source.connect(self.conv.sink)
            # ... and then Clock Domain Crossing.
            self.submodules.cdc = stream.ClockDomainCrossing([("data", DEPTH)], cd_from="sys", cd_to=clock_domain)
            self.comb += self.conv.source.connect(self.cdc.sink)
            video_pipe_source = self.cdc.source

        # Video Generation.
        self.comb += [
            vtg_sink.ready.eq(1),
            If(vtg_sink.valid & vtg_sink.de,
                video_pipe_source.connect(source, keep={"valid", "ready"}),
                vtg_sink.ready.eq(source.valid & source.ready),
            ),
            vtg_sink.connect(source, keep={"de", "hsync", "vsync"}),
            # use the same bit for everything ; console is W-on-B but X11 seems OK
            source.r.eq(Replicate(video_pipe_source.data[0], 8)),
            source.g.eq(Replicate(video_pipe_source.data[0], 8)),
            source.b.eq(Replicate(video_pipe_source.data[0], 8)),
        ]

        # Underflow.
        self.comb += self.underflow.eq(~source.valid)

class bw2(Module, AutoCSR):
    def __init__(self, soc, phy=None, timings = None, clock_domain="sys"):
        name = "video_framebuffer"
        # near duplicate of plaform.add_video_framebuffer
        # Video Timing Generator.
        vtg = VideoTimingGenerator(default_video_timings=timings if isinstance(timings, str) else timings[1])
        vtg = ClockDomainsRenamer(clock_domain)(vtg)
        setattr(self.submodules, f"{name}_vtg", vtg)

        # Video FrameBuffer.
        timings = timings if isinstance(timings, str) else timings[0]
        base = soc.mem_map.get(name)
        print(f"BW2: visible memory at {base:x}")
        hres = int(timings.split("@")[0].split("x")[0])
        vres = int(timings.split("@")[0].split("x")[1])
        freq = vtg.video_timings["pix_clk"]
        print(f"BW2: using {hres} x {vres}, {freq/1e6} MHz pixclk")
        vfb = VideoFrameBufferBW(dram_port = soc.sdram.crossbar.get_port(),
                                 hres = hres,
                                 vres = vres,
                                 base = base,
                                 clock_domain = clock_domain,
                                 clock_faster_than_sys = (vtg.video_timings["pix_clk"] > soc.sys_clk_freq))
        setattr(self.submodules, name, vfb)

        # Connect Video Timing Generator to Video FrameBuffer.
        self.comb += vtg.source.connect(vfb.vtg_sink)

        # Connect Video FrameBuffer to Video PHY.
        self.comb += vfb.source.connect(phy if isinstance(phy, stream.Endpoint) else phy.sink)

        # Constants.
        soc.add_constant("VIDEO_FRAMEBUFFER_BASE", base)
        soc.add_constant("VIDEO_FRAMEBUFFER_HRES", hres)
        soc.add_constant("VIDEO_FRAMEBUFFER_VRES", vres)

        self.bus = bus = wishbone.Interface()

        # drievr uses the same struct fbcontrol for bw2 as for cg3
        
        fbc_ctrl = Signal(8, reset = 0x60) # FBC_VENAB | FBC_TIMING  # 0x10 ?
        hres_to_sense = {
            "default": 0x30, # 1152x900
            1024: 0x10,
            1152: 0x30,
            1280: 0x40,
        };
        fbc_status = Signal(8, reset = (hres_to_sense[hres] | 0x01)) # 1280x1024 color # 0x11 ?
        fbc_cursor_start = Signal(8) # 0x12 ?
        fbc_cursor_end = Signal(8) # 0x13 ?
        fbc_vcontrol = Array(Signal(8) for a in range(0, 3))

        self.submodules.wishbone_fsm = wishbone_fsm = FSM(reset_state = "Reset")
        wishbone_fsm.act("Reset",
                         NextValue(bus.ack, 0),
                         NextState("Idle"))
        wishbone_fsm.act("Idle",
                         If(bus.cyc & bus.stb & bus.we & ~bus.ack, #write
                            # FIXME: should check for prefix?
                            Case(bus.adr[0:3], {
                                # bt_addr
                                0: [],
                                # bt_cmap
                                1: [],
                                # bt_ctrl: unused ??
                                2: [],
                                # bt_omap: unused ??
                                3: [],
                                # fbc_ctrl & friends: 4 in one go
                                # should be byte-accessed
                                # CHECKME: byte ordering
                                4: [ Case(bus.sel, {
                                    8: [ NextValue(fbc_ctrl, bus.dat_w[24:32]),],
                                    4: [ NextValue(fbc_status, fbc_status & 0x7F),], #FIXME: if high bit set, cancel interrupt
                                    2: [ NextValue(fbc_cursor_start, bus.dat_w[24:32]),],
                                    1: [ NextValue(fbc_cursor_end, bus.dat_w[24:32]),],
                                }),
                                ],
                                5: [NextValue(fbc_vcontrol[0], (bus.dat_w & Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8))) | (fbc_vcontrol[0] & ~Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8)))) ],
                                6: [NextValue(fbc_vcontrol[1], (bus.dat_w & Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8))) | (fbc_vcontrol[1] & ~Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8)))) ],
                                7: [NextValue(fbc_vcontrol[2], (bus.dat_w & Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8))) | (fbc_vcontrol[2] & ~Cat(Replicate(bus.sel[3], 8), Replicate(bus.sel[2], 8), Replicate(bus.sel[1], 8), Replicate(bus.sel[0], 8)))) ],
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
                                # fbc_ctrl & friends: 4 in one go
                                # should be byte-accessed
                                # CHECKME: byte ordering
                                4: [ NextValue(bus.dat_r, Cat(fbc_cursor_end, fbc_cursor_start, fbc_status, fbc_ctrl))],
                                5: [ NextValue(bus.dat_r, fbc_vcontrol[0])],
                                6: [ NextValue(bus.dat_r, fbc_vcontrol[1])],
                                7: [ NextValue(bus.dat_r, fbc_vcontrol[2])],
                            }),
                            NextValue(bus.ack, 1),
                         ).Else(
                             NextValue(bus.ack, 0),
                         )
        )
