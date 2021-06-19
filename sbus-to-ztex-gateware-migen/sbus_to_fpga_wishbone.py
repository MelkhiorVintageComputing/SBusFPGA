
from migen import *
from litex.soc.interconnect import wishbone

# ********************************************************************************************************
class SBusToWishbone(Module):
    def __init__(self, platform, wr_fifo, rd_fifo_addr, rd_fifo_data, wishbone):
        self.platform = platform
        self.wr_fifo = wr_fifo
        self.rd_fifo_addr = rd_fifo_addr
        self.rd_fifo_data = rd_fifo_data
        self.wishbone = wishbone
        
        #pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        #SBUS_DATA_OE_LED_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
        #pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        #SBUS_DATA_OE_LED_2_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)

        data = Signal(32)
        adr = Signal(30)
        timeout = Signal(9)
        
        # ##### FSM: read/write from/to WB #####
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        fsm.act("Reset",
                self.wishbone.we.eq(0),
                self.wishbone.cyc.eq(0),
                self.wishbone.stb.eq(0),
                NextState("Idle")
        )
        fsm.act("Idle",
                # write first, we don't want a read to pass before a previous write
                If(self.wr_fifo.readable & ~self.wishbone.cyc,
                   self.wr_fifo.re.eq(1),
                   NextValue(adr, self.wr_fifo.dout[0:30]),
                   NextValue(data, self.wr_fifo.dout[30:62]),
                   NextValue(timeout, 511),
                   NextState("Write")
                ).Elif (rd_fifo_addr.readable & ~self.wishbone.cyc & self.rd_fifo_data.writable,
                        rd_fifo_addr.re.eq(1),
                        NextValue(adr, self.rd_fifo_addr.dout[0:30]),
                        NextValue(timeout, 511),
                        NextState("Read")
                )
        )
        fsm.act("Write",
                self.wishbone.adr.eq(adr),
                self.wishbone.dat_w.eq(data),
                self.wishbone.we.eq(1),
                self.wishbone.cyc.eq(1),
                self.wishbone.stb.eq(1),
                self.wishbone.sel.eq(2**len(self.wishbone.sel)-1),
                NextValue(timeout, timeout - 1),
                If(self.wishbone.ack,
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
                ).Elif(timeout == 0, # fixme, what to do to signal a problem ?
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
                )
        )
        fsm.act("Read",
                self.wishbone.adr.eq(adr),
                self.wishbone.we.eq(0),
                self.wishbone.cyc.eq(1),
                self.wishbone.stb.eq(1),
                self.wishbone.sel.eq(2**len(self.wishbone.sel)-1),
                NextValue(timeout, timeout - 1),
                If(self.wishbone.ack,
                   self.rd_fifo_data.we.eq(1),
                   self.rd_fifo_data.din.eq(Cat(self.wishbone.dat_r, Signal(reset = 0))),
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
                ).Elif(timeout == 0,
                   self.rd_fifo_data.we.eq(1),
                   self.rd_fifo_data.din.eq(Cat(Signal(32, reset = 0xDEADBEEF), Signal(reset = 1))),
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
                )
        )

# ********************************************************************************************************
class WishboneToSBus(Module):
    def __init__(self, platform, soc, wr_fifo, rd_fifo_addr, rd_fifo_data, wishbone):
        self.platform = platform
        self.wr_fifo = wr_fifo
        self.rd_fifo_addr = rd_fifo_addr
        self.rd_fifo_data = rd_fifo_data
        self.wishbone = wishbone
        self.soc = soc

        #pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        #SBUS_DATA_OE_LED_2_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)

        data = Signal(32)
        adr = Signal(30)
        timeout = Signal(9)
        
        # ##### FSM: read/write from/to SBus #####
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        fsm.act("Reset",
                NextState("Idle")
        )
        fsm.act("Idle",
                If(self.wishbone.stb & self.wishbone.cyc & self.wishbone.we & self.wr_fifo.writable,
                   If(self.wishbone.adr[24:30] == 0x3f, ## in our DMA range (3f == fc>>2)
                      self.wr_fifo.we.eq(1),
                      self.wr_fifo.din.eq(Cat(self.wishbone.adr[0:30], self.wishbone.dat_w[0:32]))
                   ),
                   NextValue(timeout, 511),
                   NextState("WriteWait")
                ).Elif(self.wishbone.stb & self.wishbone.cyc & ~self.wishbone.we & self.rd_fifo_addr.writable,
                       If(self.wishbone.adr[24:30] == 0x3f, ## in our DMA range
                          NextValue(adr, self.wishbone.adr),
                          self.rd_fifo_addr.we.eq(1),
                          self.rd_fifo_addr.din.eq(self.wishbone.adr[0:30])
                       ),
                       NextValue(timeout, 511),
                       NextState("ReadWait"),
                )
        )
        fsm.act("WriteWait",
                If(self.wishbone.adr[24:30] == 0x3f, ## in our DMA range
                   self.wishbone.ack.eq(1)
                ).Else(
                    self.wishbone.err.eq(1)
                ),
                NextValue(timeout, timeout - 1),
                If(~self.wishbone.stb,
                   NextState("Idle")
                ).Elif(timeout == 0, # fixme, what to do to signal a problem ?
                   NextState("Idle")
                )
        )
        fsm.act("ReadWait",
                NextValue(timeout, timeout - 1),
                If(adr[24:30] == 0x3f, ## in our DMA range
                   If(self.rd_fifo_data.readable,
                      If(self.rd_fifo_data.dout[32] == 0,
                         self.wishbone.ack.eq(1),
                         self.rd_fifo_data.re.eq(1),
                         NextValue(data, self.rd_fifo_data.dout),
                         self.wishbone.dat_r.eq(self.rd_fifo_data.dout[0:32]),
                         NextState("ReadWait2")
                      ).Else(
                          self.wishbone.err.eq(1),
                          self.rd_fifo_data.re.eq(1),
                          NextState("ReadWaitErr")
                      )
                    ).Elif(timeout == 0, # fixme, what to do to signal a problem ?
                           NextState("Idle")
                    )
                ).Else(
                    self.wishbone.err.eq(1),
                    If(~self.wishbone.stb,
                       NextState("Idle")
                    )
                )
        )
        fsm.act("ReadWait2",
                NextValue(timeout, timeout - 1),
                self.wishbone.ack.eq(1),
                self.wishbone.dat_r.eq(data),
                If(~self.wishbone.stb,
                   NextState("Idle")
                ).Elif(timeout == 0, # fixme, what to do to signal a problem ?
                       NextState("Idle")
                )
        )
        fsm.act("ReadWaitErr",
                NextValue(timeout, timeout - 1),
                self.wishbone.err.eq(1),
                If(~self.wishbone.stb,
                   NextState("Idle")
                ).Elif(timeout == 0, # fixme, what to do to signal a problem ?
                       NextState("Idle")
                )
        )
