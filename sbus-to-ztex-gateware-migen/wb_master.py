#!/usr/bin/env python3
from migen import *

from litex.soc.interconnect import wishbone

_WRITE_CMD = 0x10000000
_WAIT_CMD  = 0x20000000
_DONE_CMD  = 0x30000000


def cmd_decoder(instruction, cmd):
    return instruction[28:] == (cmd >> 28)


class WishboneMaster(Module):
    def __init__(self, instructions):
        self.bus = bus = wishbone.Interface()

        self.run = Signal()
        self.done = Signal()
        self.error = Signal()

        # # #
        mem = Memory(32, len(instructions), init=instructions)
        port = mem.get_port(async_read=True)
        self.specials += mem, port

        wait_counter = Signal(32)

        fsm = FSM(reset_state="IDLE")
        self.submodules += fsm
        fsm.act("IDLE",
            self.run.eq(1),
            NextState("CMD")
        )
        fsm.act("CMD",
            self.run.eq(1),
            If(cmd_decoder(port.dat_r, _WRITE_CMD),
                NextValue(port.adr, port.adr + 1),
                NextState("WRITE_ADR")
            ).Elif(cmd_decoder(port.dat_r, _WAIT_CMD),
                NextValue(wait_counter, port.dat_r[:28]),
                NextState("WAIT")
            ).Elif(cmd_decoder(port.dat_r, _DONE_CMD),
                NextState("DONE")
            ).Else(
                NextState("ERROR")
            )
        )
        fsm.act("WAIT",
            self.run.eq(1),
            NextValue(wait_counter, wait_counter - 1),
            If(wait_counter == 0,
                NextValue(port.adr, port.adr + 1),
                NextState("CMD")
            )
        )
        fsm.act("WRITE_ADR",
            self.run.eq(1),
            NextValue(bus.adr, port.dat_r[2:]),
            NextValue(port.adr, port.adr + 1),
            NextState("WRITE_DATA")
        )
        fsm.act("WRITE_DATA",
            self.run.eq(1),
            NextValue(bus.dat_w, port.dat_r),
            NextValue(port.adr, port.adr + 1),
            NextState("WRITE")
        )
        fsm.act("WRITE",
            self.run.eq(1),
            bus.stb.eq(1),
            bus.cyc.eq(1),
            bus.we.eq(1),
            bus.sel.eq(0xf),
            If(bus.ack,
                If(bus.err,
                    NextState("ERROR"),
                ).Else(
                    NextState("CMD")
                )
            )
        )
        fsm.act("ERROR", self.error.eq(1))
        fsm.act("DONE", self.done.eq(1))


if __name__ == "__main__":
    instructions = [
        _WRITE_CMD,
        0x12340000,
        0x0000A5A5,
        _WAIT_CMD | 0x20,
        _WRITE_CMD,
        0x00001234,
        0xDEADBEEF,
        _DONE_CMD
    ]

    dut = WishboneMaster(instructions)

    def dut_tb(dut):
        yield dut.bus.ack.eq(1)
        for i in range(1024):
            yield

    run_simulation(dut, dut_tb(dut), vcd_name="wb_master.vcd")

