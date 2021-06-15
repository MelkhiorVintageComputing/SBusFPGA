
from migen import *
from litex.soc.interconnect import wishbone

class SBusToWishbone(Module):
    def __init__(self, wr_fifo, rd_fifo_addr, rd_fifo_data, wishbone):
        self.wr_fifo = wr_fifo
        self.rd_fifo_addr = rd_fifo_addr
        self.rd_fifo_data = rd_fifo_data
        self.wishbone = wishbone

        data = Signal(32)
        adr = Signal(30)
        
        # ##### FSM: write to WB #####
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        fsm.act("Reset",
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
        )
        fsm.act("Idle",
                   If(self.wr_fifo.readable & ~self.wishbone.cyc,
                      self.wr_fifo.re.eq(1),
                      NextValue(adr, self.wr_fifo.dout[0:30]),
                      NextValue(data, self.wr_fifo.dout[30:62]),
                      NextState("Write")
                   ),
                   If (rd_fifo_addr.readable & ~self.wishbone.cyc & self.rd_fifo_data.writable,
                       rd_fifo_addr.re.eq(1),
                       NextValue(adr, self.rd_fifo_addr.dout[0:30]),
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
                   If(self.wishbone.ack,
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
                   If(self.wishbone.ack,
                      self.rd_fifo_data.we.eq(1),
                      self.rd_fifo_data.din.eq(self.wishbone.dat_r),
                      self.wishbone.we.eq(0),
                      self.wishbone.cyc.eq(0),
                      self.wishbone.stb.eq(0),
                      NextState("Idle")
                   )
        )
