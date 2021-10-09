from migen import *
from migen.genlib.fifo import *
from litex.soc.interconnect.csr import *

class NeoRV32TrngWrapper(Module, AutoCSR):
    def __init__(self, platform):
        self.add_sources(platform)

        rden_i = Signal()
        wren_i = Signal()
        data_i = Signal(32)
        data_o = Signal(32)

        self.ctrl = CSRStorage(32, description = "CTRL register; bit 0 : disable ; bit 1 : enable")
        self.data = CSRStatus(32, description = "Rnd Data or 0")

        self.submodules.ctrl_fsm = ctrl_fsm = FSM(reset_state = "Reset")
        ctrl_fsm.act("Reset",
                     NextState("Idle")
        )
        ctrl_fsm.act("Idle",
                     If(self.ctrl.re, # someone has written control
                        If(self.ctrl.storage[0],
                           data_i.eq(0),
                           wren_i.eq(1),
                        ).Elif(self.ctrl.storage[1],
                               data_i.eq(0xffffffff),
                               wren_i.eq(1),
                        )
                     ),
                     If(self.data.we, # someone has read the data, reset so that the same value is never read twice
                        NextValue(self.data.status, 0),
                     )
        )

        # fill out an intermediate buffer, one byte every 11 cycles
        # then copy the 4 bytes to data CST and do it all over again
        buf = Array(Signal(8) for a in range(4))
        idx = Signal(2)
        cnt = Signal(4)
        self.submodules.upd_fsm = upd_fsm = FSM(reset_state = "Reset")
        upd_fsm.act("Reset",
                    NextValue(cnt, 11),
                    NextValue(idx, 0),
                    NextState("ByteWait")
        )
        upd_fsm.act("ByteWait",
                    If(cnt == 0,
                       rden_i.eq(1),
                       NextState("ByteWrite"),
                    ).Else(
                        NextValue(cnt, cnt - 1)
                    )
        )
        upd_fsm.act("ByteWrite",
                    If (data_o[31] & data_o[30],
                        NextValue(buf[idx], data_o[0:8]),
                        NextValue(cnt, 11),
                        NextValue(idx, idx + 1),
                        If(idx == 3,
                            NextState("Copy"),
                        ).Else(
                            NextState("ByteWait"),
                        )
                    ).Else( # try again
                        NextValue(cnt, 11),
                        NextState("ByteWait"),
                    )
        )
        upd_fsm.act("Copy",
                    NextValue(self.data.status, Cat(buf[0], buf[1], buf[2], buf[3])),
                    NextValue(buf[0], 0),
                    NextValue(buf[1], 0),
                    NextValue(buf[2], 0),
                    NextValue(buf[3], 0),
                    NextState("ByteWait")
        )
                    
        
        
        
        self.specials += Instance(self.get_netlist_name(),
                                  i_clk_i = ClockSignal("sys"),
                                  i_rden_i = rden_i,
                                  i_wren_i = wren_i,
                                  i_data_i = data_i,
                                  o_data_o = data_o)
        
    def get_netlist_name(self):
        return "neorv32_trng"
        
    def add_sources(self, platform):
        platform.add_source("neorv32_trng_patched.vhd", "vhdl")
            
