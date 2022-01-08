from migen import *
from migen.genlib.fifo import *

from litex.soc.interconnect.csr import *

from litex.soc.interconnect import wishbone

#from cg6_blit import CG6Blit

class CG6Accel(Module): # AutoCSR ?
    def __init__(self, soc, base_fb, hres, vres):
        platform = soc.platform
        
        # for FBC and TEC
        self.bus = bus = wishbone.Interface()
        
        self.COORD_BITS = COORD_BITS = 12

        fbc_config = Signal(32, reset = (0x60000000)) # bit 11-12 are for resolution, see the GX manual (seem unused by drivers)
        fbc_mode = Signal(32)
        fbc_clip = Signal(32)
        fbc_s = Signal(32)
        #fbc_font = Signal(32)
        self.fbc_x = fbc_x = Array(Signal(COORD_BITS) for a in range(0, 4))
        self.fbc_y = fbc_y = Array(Signal(COORD_BITS) for a in range(0, 4))
        fbc_offx = Signal(COORD_BITS)
        fbc_offy = Signal(COORD_BITS)
        fbc_incx = Signal(COORD_BITS)
        fbc_incy = Signal(COORD_BITS)
        fbc_clipminx = Signal(COORD_BITS)
        fbc_clipminy = Signal(COORD_BITS)
        fbc_clipmaxx = Signal(COORD_BITS+1) # need the 13th bit as X11 uses 4096 for clipmaxx (console uses 4095)
        fbc_clipmaxy = Signal(COORD_BITS+1) # need the 13th bit as X11 uses 4096 for clipmaxx (console uses 4095)
        fbc_fg = Signal(8)
        fbc_bg = Signal(8)
        self.fbc_alu = fbc_alu = Signal(32)
        self.fbc_pm = fbc_pm = Signal(8)
        fbc_arectx = Signal(COORD_BITS)
        fbc_arecty = Signal(COORD_BITS)
        
        # extra stuff for the Vex core
        fbc_arectx_prev = Signal(COORD_BITS) # after fbc_arecty (600) - R/O
        fbc_arecty_prev = Signal(COORD_BITS) # after fbc_arectx_prev (601) - R/O
        self.fbc_r5_cmd = fbc_r5_cmd = Signal(32) # to communicate with Vex (602)
        fbc_r5_status = Array(Signal(32) for a in range(0, 4))
        fbc_next_font = Signal(32)
        fbc_next_x0 = Signal(COORD_BITS)
        fbc_next_x1 = Signal(COORD_BITS)
        fbc_next_y0 = Signal(COORD_BITS)

        #self.submodules.cg6_blit = CG6Blit(accel = self, soc = soc, base_fb = base_fb, hres = hres, vres = vres)

        # do-some-work flags
        fbc_do_draw = Signal()
        fbc_do_blit = Signal()

        # for GX global status register fbc_s
        GX_FULL_BIT = 29
        GX_INPROGRESS_BIT = 28
        
        font_layout = [
            ("font", 32),
            ("x0", COORD_BITS),
            ("x1", COORD_BITS),
            ("y0", COORD_BITS),
        ]
        # depth is because the current 'font' is a bit slow, so we need to buffer a lot...
        self.submodules.fbc_fifo_font = SyncFIFOBuffered(width=layout_len(font_layout),depth=2048)

        #fifo_overflow = Signal()
        #self.comb += fifo_overflow.eq(self.fbc_fifo_font.we & ~self.fbc_fifo_font.writable)

        #draw_blit_overflow = Signal()
        
        fbc_fifo_font_in = Record(font_layout)
        fbc_fifo_font_out = Record(font_layout)
        self.comb += [
            self.fbc_fifo_font.din.eq(fbc_fifo_font_in.raw_bits()),
            fbc_fifo_font_out.raw_bits().eq(self.fbc_fifo_font.dout)
        ]
        
        self.submodules.wishbone_fsm = wishbone_fsm = FSM(reset_state = "Reset")
        wishbone_fsm.act("Reset",
                         NextValue(bus.ack, 0),
                         NextState("Idle"))
        wishbone_fsm.act("Idle",
                         self.fbc_fifo_font.we.eq(0),
                         If(bus.cyc & bus.stb & bus.we & ~bus.ack, #write
                            Case(bus.adr[0:12], { # the thirteenth bit is to match the FBC but not the TEC
                                "default": [ ],
                                # 0: fbc_config R/O
                                1: [ NextValue(fbc_mode, bus.dat_w) ],
                                2: [ NextValue(fbc_clip, bus.dat_w) ],
                                # 3: <nothing>, pad2
                                4: [ # NextValue(fbc_s, bus.dat_w)
                                   ], # 0x010
                                # 5: fbc_draw R/O
                                # 6: fbc_blit R/O 
                                7: [ self.fbc_fifo_font.we.eq(1),
                                     fbc_fifo_font_in.font.eq(bus.dat_w),
                                     fbc_fifo_font_in.x0.eq(fbc_x[0]),
                                     fbc_fifo_font_in.x1.eq(fbc_x[1]),
                                     fbc_fifo_font_in.y0.eq(fbc_y[0]),
                                     NextValue(fbc_x[0], fbc_x[0] + fbc_incx),
                                     NextValue(fbc_x[1], fbc_x[1] + fbc_incx),
                                     NextValue(fbc_y[0], fbc_y[0] + fbc_incy),
                                     #NextValue(fbc_y[1], fbc_y[1] + fbc_incy),
                                ],
                                # 8-31: <nothing>, pad3
                                32: [ NextValue(fbc_x[0], bus.dat_w) ],
                                33: [ NextValue(fbc_y[0], bus.dat_w) ],
                                #34: presumably fbc_z0
                                36: [ NextValue(fbc_x[1], bus.dat_w) ],
                                37: [ NextValue(fbc_y[1], bus.dat_w) ],
                                #38: presumably fbc_z1
                                40: [ NextValue(fbc_x[2], bus.dat_w) ],
                                41: [ NextValue(fbc_y[2], bus.dat_w) ],
                                #42: presumably fbc_z2
                                44: [ NextValue(fbc_x[3], bus.dat_w) ],
                                45: [ NextValue(fbc_y[3], bus.dat_w) ],
                                #46: presumably fbc_z3
                                48: [ NextValue(fbc_offx, bus.dat_w) ],
                                49: [ NextValue(fbc_offy, bus.dat_w) ],
                                52: [ NextValue(fbc_incx, bus.dat_w) ],
                                53: [ NextValue(fbc_incy, bus.dat_w) ],
                                # 54-55: pad81
                                56: [ NextValue(fbc_clipminx, bus.dat_w) ],
                                57: [ NextValue(fbc_clipminy, bus.dat_w) ],
                                # 58-59: pad9
                                60: [ NextValue(fbc_clipmaxx, bus.dat_w) ],
                                61: [ NextValue(fbc_clipmaxy, bus.dat_w) ],
                                # 62-63: pad10
                                64: [ NextValue(fbc_fg, bus.dat_w) ],
                                65: [ NextValue(fbc_bg, bus.dat_w) ],
                                66: [ NextValue(fbc_alu, bus.dat_w) ],
                                67: [ NextValue(fbc_pm, bus.dat_w) ], # 67: planemask reg
                                # 68: pixelmask reg
                                # 69-70: <nothing>
                                # 71: pattalign reg
                                # 72-79: pattern0-7
                                # 80-543: big empty space ?
                                # 544-546, 548-550: itri[abs,rel][xyz]
                                # 560-562, 564-566: iquad[abs,rel][xyz]
                                576: [ NextValue(fbc_arectx_prev, fbc_arectx), # 900
                                       NextValue(fbc_arectx, bus.dat_w),
                                ],
                                577: [ NextValue(fbc_arecty_prev, fbc_arecty),
                                       NextValue(fbc_arecty, bus.dat_w),
                                ],
                                # 578: fbc_arectz
                                # 579: <nothing>
                                # 580-582: fbc_relrect[xyz] -> update absolute
                                580: [ NextValue(fbc_arectx_prev, fbc_arectx),
                                       NextValue(fbc_arectx, fbc_arectx + bus.dat_w[0:COORD_BITS]),
                                ],
                                581: [ NextValue(fbc_arecty_prev, fbc_arecty),
                                       NextValue(fbc_arecty, fbc_arecty + bus.dat_w[0:COORD_BITS]),
                                ],
                                # 600-601: fbc_arect[xy]next, not directly writable
                                602: [ NextValue(fbc_r5_cmd, bus.dat_w) ],
                                604: [ NextValue(fbc_r5_status[0], bus.dat_w) ], # 0x970
                                605: [ NextValue(fbc_r5_status[1], bus.dat_w) ], # 0x971
                                606: [ NextValue(fbc_r5_status[2], bus.dat_w) ], # 0x972
                                607: [ NextValue(fbc_r5_status[3], bus.dat_w) ], # 0x973
                                # 608: fbc_next_font, R/O
                            }),
                            NextValue(bus.ack, 1),
                            ).Elif(bus.cyc & bus.stb & ~bus.we & ~bus.ack, #read
                                   Case(bus.adr[0:12], { # the thirteenth bit is to match the FBC but not the TEC
                                        "default": [ NextValue(bus.dat_r, 0xDEADBEEF) ],
                                        0: [ NextValue(bus.dat_r, fbc_config) ],
                                        1: [ NextValue(bus.dat_r, fbc_mode) ],
                                        2: [ NextValue(bus.dat_r, fbc_clip) ],
                                        # 3: pad2
                                        4: [ NextValue(bus.dat_r, fbc_s),
                                             #NextValue(bus.dat_r, Replicate(fbc_s[GX_INPROGRESS_BIT] | fbc_do_draw | fbc_do_blit | self.fbc_fifo_font.readable, 32)) ],
                                        ],
                                        # 5: fbc_draw R/O -> start a "draw" on R
                                        5: [ NextValue(fbc_do_draw, ~fbc_s[GX_INPROGRESS_BIT]), # ignore command while working
                                             NextValue(bus.dat_r, fbc_s), # FIXME, returns the FULL and INPROGRESS bit only
                                             #NextValue(draw_blit_overflow, draw_blit_overflow | fbc_do_draw | fbc_do_blit),
                                             #NextValue(draw_blit_overflow, draw_blit_overflow | fbc_s[GX_INPROGRESS_BIT]),
                                        ],
                                        # 6: fbc_blit R/O -> start a "blit" on R
                                        6: [ NextValue(fbc_do_blit, ~fbc_s[GX_INPROGRESS_BIT]), # ignore command while working
                                             NextValue(bus.dat_r, fbc_s), # FIXME, returns the FULL and INPROGRESS bit only
                                             #NextValue(draw_blit_overflow, draw_blit_overflow | fbc_do_draw | fbc_do_blit),
                                             #NextValue(draw_blit_overflow, draw_blit_overflow | fbc_s[GX_INPROGRESS_BIT]),
                                        ],
                                        # 7: fbc_font W/O -> start a "font" on W
                                        # 8-31: pad3
                                        32: [ NextValue(bus.dat_r, fbc_x[0]) ], # 0x080
                                        33: [ NextValue(bus.dat_r, fbc_y[0]) ],
                                        36: [ NextValue(bus.dat_r, fbc_x[1]) ], # 0x090
                                        37: [ NextValue(bus.dat_r, fbc_y[1]) ],
                                        40: [ NextValue(bus.dat_r, fbc_x[2]) ], # 0x0a0
                                        41: [ NextValue(bus.dat_r, fbc_y[2]) ],
                                        44: [ NextValue(bus.dat_r, fbc_x[3]) ], # 0x0b0
                                        45: [ NextValue(bus.dat_r, fbc_y[3]) ], # 0x0b4
                                        48: [ NextValue(bus.dat_r, fbc_offx) ], # 0x0c0
                                        49: [ NextValue(bus.dat_r, fbc_offy) ],
                                        52: [ NextValue(bus.dat_r, fbc_incx) ], # 0x0d0
                                        53: [ NextValue(bus.dat_r, fbc_incy) ],
                                        # 54-55: pad81
                                        56: [ NextValue(bus.dat_r, fbc_clipminx) ], # 0x0e0
                                        57: [ NextValue(bus.dat_r, fbc_clipminy) ],
                                        # 58-59: pad9
                                        60: [ NextValue(bus.dat_r, fbc_clipmaxx) ], # 0x0f0
                                        61: [ NextValue(bus.dat_r, fbc_clipmaxy) ],
                                        # 62-63: pad10
                                        64: [ NextValue(bus.dat_r, fbc_fg) ], # 0x100
                                        65: [ NextValue(bus.dat_r, fbc_bg) ], # 0x104
                                        66: [ NextValue(bus.dat_r, fbc_alu) ], # 0x108
                                        67: [ NextValue(bus.dat_r, fbc_pm) ], # 0x10c # planemask
                                        #68: pixelmask (written to 0xFFFFFFFF by 510-2325 prom)
                                        #72-79: patterns (written  to 0xFFFFFFFF by 510-2325 prom)
                                        576: [ NextValue(bus.dat_r, fbc_arectx),
                                              ],
                                        577: [ NextValue(bus.dat_r, fbc_arecty),
                                              ],
                                        600: [ NextValue(bus.dat_r, fbc_arectx_prev), # 0x960
                                              ],
                                        601: [ NextValue(bus.dat_r, fbc_arecty_prev),
                                              ],
                                        602: [ NextValue(bus.dat_r, fbc_r5_cmd), # 0x968
                                              ],
                                        # 603
                                        604: [ NextValue(bus.dat_r, fbc_r5_status[0]), # 0x970
                                              ],
                                        605: [ NextValue(bus.dat_r, fbc_r5_status[1]), # 0x971
                                              ],
                                        606: [ NextValue(bus.dat_r, fbc_r5_status[2]), # 0x972
                                              ],
                                        607: [ NextValue(bus.dat_r, fbc_r5_status[3]), # 0x973
                                              ],
                                        608: [ NextValue(bus.dat_r, fbc_next_font),
                                              ],
                                        609: [ NextValue(bus.dat_r, fbc_next_x0),
                                              ],
                                        610: [ NextValue(bus.dat_r, fbc_next_x1),
                                              ],
                                        611: [ NextValue(bus.dat_r, fbc_next_y0),
                                              ],
                                        }),
                                   NextValue(bus.ack, 1),
                         ).Else(
                             NextValue(bus.ack, 0),
                         )
        )

        # also in blit.c, for r5-cmd
        FUN_MASK = 0x0000000F
        FUN_DRAW = 0x00000001
        FUN_BLIT = 0x00000002
        FUN_FONT = 0x40000004 # include FUN_FONT_NEXT_RDY_BIT
        FUN_DONE_BIT = 31
        FUN_FONT_NEXT_RDY_BIT = 30
        FUN_FONT_NEXT_REQ_BIT = 29
        FUN_FONT_NEXT_DONE_BIT = 28

        # to hold the Vex in reset
        # could be sent to fbc_s[GX_INPROGRESS_BIT] ?
        local_reset = Signal(reset = 1)
        #timeout_rst = 0xFFFFFFF
        #timeout = Signal(28, reset = timeout_rst)

        pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        self.comb += pad_SBUS_DATA_OE_LED.eq(~local_reset)
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_r5_cmd[1]) # blitting
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_pm != 0) # planemasking
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fifo_overflow)
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_s[GX_INPROGRESS_BIT])
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_s[GX_INPROGRESS_BIT])
        #self.comb += pad_SBUS_DATA_OE_LED.eq(draw_blit_overflow)
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_do_draw & fbc_s[GX_INPROGRESS_BIT])
        #self.comb += pad_SBUS_DATA_OE_LED.eq(fbc_do_blit & fbc_s[GX_INPROGRESS_BIT])
        
        #self.sync += fbc_s[GX_FULL_BIT].eq(fbc_do_draw | fbc_do_blit | self.fbc_fifo_font.readable)
        #self.sync += fbc_s[27].eq(fbc_do_draw)
        #self.sync += fbc_s[26].eq(fbc_do_blit)
        #self.sync += fbc_s[25].eq(self.fbc_fifo_font.readable)
        #self.sync += fbc_s[24].eq(~local_reset)
        #self.sync += fbc_s[0].eq(draw_blit_overflow)

        #fbc_s[GX_FULL_BIT].eq(fbc_do_draw | fbc_do_blit | self.fbc_fifo_font.readable)
        
        self.sync += [
            self.fbc_fifo_font.re.eq(0),
            If(fbc_r5_cmd[FUN_DONE_BIT],
               fbc_r5_cmd.eq(0),
               fbc_s[GX_INPROGRESS_BIT].eq(0),
               fbc_s[GX_FULL_BIT].eq(0),
               local_reset.eq(1),
               #timeout.eq(timeout_rst),
            ).Elif(self.fbc_fifo_font.readable & fbc_s[GX_INPROGRESS_BIT] & fbc_r5_cmd[FUN_FONT_NEXT_REQ_BIT] & (fbc_r5_cmd[0:4] == 0x4),
                   # the font code request the next line, and one is available: give it
                   self.fbc_fifo_font.re.eq(1),
                   fbc_next_font.eq(fbc_fifo_font_out.font),
                   fbc_next_x0.eq(fbc_fifo_font_out.x0),
                   fbc_next_x1.eq(fbc_fifo_font_out.x1),
                   fbc_next_y0.eq(fbc_fifo_font_out.y0),
                   fbc_r5_cmd[FUN_FONT_NEXT_REQ_BIT].eq(0),
                   fbc_r5_cmd[FUN_FONT_NEXT_RDY_BIT].eq(1),
                   #timeout.eq(timeout_rst),
            ).Elif(~self.fbc_fifo_font.readable & fbc_s[GX_INPROGRESS_BIT] & fbc_r5_cmd[FUN_FONT_NEXT_REQ_BIT] & (fbc_r5_cmd[0:4] == 0x4),
                   # the font code request the next line, but none is available; stop
                   fbc_r5_cmd[FUN_FONT_NEXT_REQ_BIT].eq(0),
                   fbc_r5_cmd[FUN_FONT_NEXT_DONE_BIT].eq(1),
                   #timeout.eq(timeout_rst),
            ).Elif(self.fbc_fifo_font.readable & ~fbc_s[GX_INPROGRESS_BIT],
                   self.fbc_fifo_font.re.eq(1),
                   fbc_next_font.eq(fbc_fifo_font_out.font),
                   fbc_next_x0.eq(fbc_fifo_font_out.x0),
                   fbc_next_x1.eq(fbc_fifo_font_out.x1),
                   fbc_next_y0.eq(fbc_fifo_font_out.y0),
                   fbc_r5_cmd.eq(FUN_FONT), # includes FUN_FONT_NEXT_RDY_BIT
                   fbc_s[GX_INPROGRESS_BIT].eq(1),
                   fbc_s[GX_FULL_BIT].eq(1),
                   local_reset.eq(0),
                   #timeout.eq(timeout_rst),
            ).Elif(fbc_do_draw & ~fbc_s[GX_INPROGRESS_BIT],
                   fbc_do_draw.eq(0),
                   fbc_r5_cmd.eq(FUN_DRAW),
                   fbc_s[GX_INPROGRESS_BIT].eq(1),
                   fbc_s[GX_FULL_BIT].eq(1),
                   local_reset.eq(0),
                   #timeout.eq(timeout_rst),
            ).Elif(fbc_do_blit & ~fbc_s[GX_INPROGRESS_BIT],
                   fbc_do_blit.eq(0),
                   fbc_r5_cmd.eq(FUN_BLIT),
                   fbc_s[GX_INPROGRESS_BIT].eq(1),
                   fbc_s[GX_FULL_BIT].eq(1),
                   local_reset.eq(0),
                   #timeout.eq(timeout_rst),

                   ##self.cg6_blit.go.eq(1),
            )
            #).Elif((timeout == 0) & fbc_s[GX_INPROGRESS_BIT], # OUPS
            #       fbc_r5_cmd.eq(0),
            #       fbc_s[GX_INPROGRESS_BIT].eq(0),
            #       fbc_s[GX_FULL_BIT].eq(0),
            #       local_reset.eq(1),
            #       timeout.eq(timeout_rst),
            #),
            #If(fbc_s[GX_INPROGRESS_BIT] & (timeout != 0),
            #   timeout.eq(timeout - 1)
            #)
        ]
        
        self.ibus = ibus = wishbone.Interface()
        self.dbus = dbus = wishbone.Interface()
        vex_reset = Signal()

        self.comb += vex_reset.eq(ResetSignal("sys") | local_reset)
        self.specials += Instance(self.get_netlist_name(),
                                  i_clk = ClockSignal("sys"),
                                  i_reset = vex_reset,
                                  o_iBusWishbone_CYC = ibus.cyc,
                                  o_iBusWishbone_STB = ibus.stb,
                                  i_iBusWishbone_ACK = ibus.ack,
                                  o_iBusWishbone_WE  = ibus.we,
                                  o_iBusWishbone_ADR = ibus.adr,
                                  i_iBusWishbone_DAT_MISO = ibus.dat_r,
                                  o_iBusWishbone_DAT_MOSI = ibus.dat_w,
                                  o_iBusWishbone_SEL = ibus.sel,
                                  i_iBusWishbone_ERR = ibus.err,
                                  o_iBusWishbone_CTI = ibus.cti,
                                  o_iBusWishbone_BTE = ibus.bte,
                                  o_dBusWishbone_CYC = dbus.cyc,
                                  o_dBusWishbone_STB = dbus.stb,
                                  i_dBusWishbone_ACK = dbus.ack,
                                  o_dBusWishbone_WE  = dbus.we,
                                  o_dBusWishbone_ADR = dbus.adr,
                                  i_dBusWishbone_DAT_MISO = dbus.dat_r,
                                  o_dBusWishbone_DAT_MOSI = dbus.dat_w,
                                  o_dBusWishbone_SEL = dbus.sel,
                                  i_dBusWishbone_ERR = dbus.err,
                                  o_dBusWishbone_CTI = dbus.cti,
                                  o_dBusWishbone_BTE = dbus.bte,)

        self.add_sources(platform)
                                     
    def get_netlist_name(self):
        return "VexRiscv"

    def add_sources(self, platform):
        platform.add_source("/home/dolbeau/SBusFPGA/sbus-to-ztex-gateware-migen/VexRiscv_FbAccel.v", "verilog")
