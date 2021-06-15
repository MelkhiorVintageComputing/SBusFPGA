
from migen import *
from litex.soc.interconnect import wishbone

class SBusToWishbone(Module):
    def __init__(self, fifo, wishbone):
        self.fifo = fifo
        self.wishbone = wishbone

        data = Signal(32)
        adr = Signal(30)
        
            # ##### Iface to WB #####
        self.submodules.wb_fsm = wb_fsm = FSM(reset_state="Reset")
        wb_fsm.act("Reset",
                   self.wishbone.we.eq(0),
                   self.wishbone.cyc.eq(0),
                   self.wishbone.stb.eq(0),
                   NextState("Idle")
        )
        wb_fsm.act("Idle",
                   If(fifo.readable & ~self.wishbone.cyc,
                      fifo.re.eq(1),
                      NextValue(adr, fifo.dout[0:30]),
                      NextValue(data, fifo.dout[30:62]),
                      NextState("Write")
                   )
        )
        wb_fsm.act("Write",
                   self.wishbone.adr.eq(adr),
                   self.wishbone.dat_w.eq(data),
                   self.wishbone.we.eq(1),
                   self.wishbone.cyc.eq(1),
                   self.wishbone.stb.eq(1),
                   self.wishbone.sel.eq(2**len(self.wishbone.sel)-1),
                   If(self.wishbone.ack == 1,
                      self.wishbone.we.eq(0),
                      self.wishbone.cyc.eq(0),
                      self.wishbone.stb.eq(0),
                      NextState("Idle")
                   )
        )
