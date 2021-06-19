
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
        pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        SBUS_DATA_OE_LED_2_o = Signal()
        self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)

        data = Signal(32)
        adr = Signal(30)
        timeout = Signal(7)

        self.real_hcca = Signal(32)
        
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
                   ## need to cheat with the USB HCCA registers
                   If((self.wr_fifo.dout[0:30] == 0x00020006), ## 80018 >> 2 == HCCA register for USB
                      NextValue(SBUS_DATA_OE_LED_2_o, 1),
                      NextValue(self.real_hcca, self.wr_fifo.dout[30:62]),
                      NextValue(data, Cat(self.wr_fifo.dout[30:46], Signal(16, reset=0x000c))) ## 0x000c: are reserved for DMA bridging
                   ).Elif((self.wr_fifo.dout[0:30] >= 0x00020007) & (self.wr_fifo.dout[0:30] <= 0x0002000c) & (self.wr_fifo.dout[30:62] != 0),
                      NextValue(data, Cat(self.wr_fifo.dout[30:46], Signal(16, reset=0x000c)))
                   ).Else(
                       NextValue(data, self.wr_fifo.dout[30:62])
                   ),
                   NextValue(timeout, 127),
                   NextState("Write")
                ).Elif (rd_fifo_addr.readable & ~self.wishbone.cyc & self.rd_fifo_data.writable,
                        rd_fifo_addr.re.eq(1),
                        NextValue(adr, self.rd_fifo_addr.dout[0:30]),
                        NextValue(timeout, 127),
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
                   If((adr >= 0x00020006) & (adr <= 0x0002000c) & (self.wishbone.dat_r != 0), ## 80018 >> 2 == HCCA register for USB
                      self.rd_fifo_data.din.eq(Cat(self.wishbone.dat_r[0:16], self.real_hcca[16:32], Signal(reset = 0)))
                   ).Else(
                       self.rd_fifo_data.din.eq(Cat(self.wishbone.dat_r, Signal(reset = 0)))
                   ),
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

        self.real_hcca = self.soc.sbus_to_wishbone.real_hcca
        
        # ##### FSM: read/write from/to SBus #####
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        fsm.act("Reset",
                NextState("Idle")
        )
        fsm.act("Idle",
                If(self.wishbone.stb & self.wishbone.cyc & self.wishbone.we & self.wr_fifo.writable,
                   If((self.wishbone.adr[14:30] == 0x000c) & (self.real_hcca != 0), ## in our DMA range
                      self.wr_fifo.we.eq(1),
                      self.wr_fifo.din.eq(Cat(self.wishbone.adr[0:14], self.real_hcca[16:32], self.wishbone.dat_w[30:62]))
                   ),
                   NextState("WriteWait")
                ).Elif(self.wishbone.stb & self.wishbone.cyc & ~self.wishbone.we & self.rd_fifo_addr.writable,
                       If((self.wishbone.adr[14:30] == 0x000c) & (self.real_hcca != 0), ## in our DMA range
                          NextValue(adr, self.wishbone.adr),
                          self.rd_fifo_addr.we.eq(1),
                          self.rd_fifo_addr.din.eq(Cat(self.wishbone.adr[0:14], self.real_hcca[16:32]))
                       ),
                       NextState("ReadWait"),
                )
        )
        fsm.act("WriteWait",
                #SBUS_DATA_OE_LED_2_o.eq(1),
                If((self.wishbone.adr[14:30] == 0x000c) & (self.real_hcca != 0), ## in our DMA range
                   self.wishbone.ack.eq(1),
                ).Else(
                    self.wishbone.err.eq(1)
                ),
                If(~self.wishbone.stb,
                   NextState("Idle")
                )
        )
        fsm.act("ReadWait",
                #SBUS_DATA_OE_LED_2_o.eq(1),
                If((adr[14:30] == 0x000c) & (self.real_hcca != 0), ## in our DMA range
                   If(self.rd_fifo_data.readable,
                      self.wishbone.ack.eq(1),
                      self.rd_fifo_data.re.eq(1),
                      NextValue(data, self.rd_fifo_data.dout),
                      self.wishbone.dat_r.eq(self.rd_fifo_data.dout),
                      NextState("ReadWait2")
                    )
                ).Else(
                    self.wishbone.err.eq(1),
                    If(~self.wishbone.stb,
                       NextState("Idle")
                    )
                )
        )
        fsm.act("ReadWait2",
                #SBUS_DATA_OE_LED_2_o.eq(1),
                self.wishbone.ack.eq(1),
                self.wishbone.dat_r.eq(data),
                If(~self.wishbone.stb,
                   NextState("Idle")
                )
        )
