
from migen import *
from litex.soc.interconnect import wishbone

class SBusToWishbone(Module):
    def __init__(self, platform, wr_fifo, rd_fifo_addr, rd_fifo_data, wishbone):
        self.platform = platform
        self.wr_fifo = wr_fifo
        self.rd_fifo_addr = rd_fifo_addr
        self.rd_fifo_data = rd_fifo_data
        self.wishbone = wishbone
        
        pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        SBUS_DATA_OE_LED_2_o = Signal()
        self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)

        data = Signal(32)
        adr = Signal(30)
        timeout = Signal(7)
        
        # ##### FSM: write to WB #####
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        fsm.act("Reset",
                self.wishbone.we.eq(0),
                self.wishbone.cyc.eq(0),
                self.wishbone.stb.eq(0),
                NextState("Idle")
        )
        fsm.act("Idle",
                If (rd_fifo_addr.readable & ~self.wishbone.cyc & self.rd_fifo_data.writable,
                    rd_fifo_addr.re.eq(1),
                    NextValue(adr, self.rd_fifo_addr.dout[0:30]),
                    NextValue(timeout, 127),
                    NextState("Read")
                ).Elif(self.wr_fifo.readable & ~self.wishbone.cyc,
                       self.wr_fifo.re.eq(1),
                       NextValue(adr, self.wr_fifo.dout[0:30]),
                       NextValue(data, self.wr_fifo.dout[30:62]),
                    NextValue(timeout, 127),
                       NextState("Write")
                )
        )
        fsm.act("Write",
                SBUS_DATA_OE_LED_2_o.eq(1),
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
                SBUS_DATA_OE_LED_2_o.eq(1),
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
