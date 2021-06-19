
from migen import *
from migen.fhdl.specials import Tristate

SIZ_WORD = 0x0
SIZ_BYTE = 0x1
SIZ_HWORD = 0x2
SIZ_EXT = 0x3
SIZ_BURST4 = 0x4
SIZ_BURST8 = 0x5
SIZ_BURST16 = 0x6
SIZ_BURST2 = 0x7

ACK_IDLE = 0x7
ACK_ERR = 0x6
ACK_BYTE = 0x5
ACK_RERUN = 0x4
ACK_WORD = 0x3
ACK_DWORD = 0x2
ACK_HWORD = 0x1
ACK_RECV = 0x0

ADDR_PHYS_HIGH = 27
ADDR_PHYS_LOW = 0
ADDR_PFX_HIGH = ADDR_PHYS_HIGH
ADDR_PFX_LOW = 16 ## 64 KiB per prefix
ADDR_PFX_LENGTH = 12 #(1 + ADDR_PFX_HIGH - ADDR_PFX_LOW)
ROM_ADDR_PFX = Signal(12, reset = 0)
WISHBONE_CSR_ADDR_PFX = Signal(12, reset = 4)
USBOHCI_ADDR_PFX = Signal(12, reset = 8)

def siz_is_word(siz):
    return (SIZ_WORD == siz) | (SIZ_BURST2 == siz) | (SIZ_BURST4 == siz) | (SIZ_BURST8 == siz) | (SIZ_BURST16 == siz)

# FIXME: this doesn't work. Verilog aways use value[0:4]
#def _index_with_wrap(counter, limit_m1, value):
#    if (limit_m1 == 0):
#        return value[0:4]
#    elif (limit_m1 == 1):
#        return Cat((value + counter)[0:1], value[1:4])
#    elif (limit_m1 == 3):
#        return Cat((value + counter)[0:2], value[2:4])
#    elif (limit_m1 == 7):
#        return Cat((value + counter)[0:3], value[3:4])
#    elif (limit_m1 == 15):
#        return (value + counter)[0:4]
#    return value[0:4]

def index_with_wrap(counter, limit_m1, value):
    return ((value+counter) & limit_m1)[0:4] | (value&(~limit_m1))[0:4]

# FIXME: this doesn't work. Verilog aways use 1
def siz_to_burst_size_m1(siz):
    if (SIZ_WORD == siz):
        return 0
    elif (SIZ_BURST2 == siz):
        return 1
    elif (SIZ_BURST4 == siz):
        return 3
    elif (SIZ_BURST8 == siz):
        return 7
    elif (SIZ_BURST16 == siz):
        return 15
    return 1

class LedDisplay(Module):
    def __init__(self): #, pads
        #n = len(pads)
        n = 8
        self.value = Signal(32, reset = 0x18244281)
        old_value = Signal(32)
        self.display = Signal(8)
        #self.comb += pads.eq(self.display)
        
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        time_counter = Signal(32, reset = 0)
        blink_counter = Signal(4, reset = 0)
        fsm.act("Reset",
                NextValue(time_counter, 25000000//10),
                NextValue(blink_counter, 10),
                NextValue(self.display, 0x00),
                NextValue(old_value, self.value),
                NextState("Quick"))
        fsm.act("Quick",
                If (old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                   If (blink_counter == 0,
                       NextValue(time_counter, 25000000//2),
                       NextValue(self.display, self.value[0:8]),
                       NextState("Byte0")
                   ).Else(
                       NextValue(self.display, ~self.display),
                       NextValue(time_counter, 25000000//10),
                       NextValue(blink_counter, blink_counter - 1)
                   )
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        fsm.act("Byte0",
                If (old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                    NextValue(time_counter, 25000000//2),
                    NextValue(self.display, self.value[8:16]),
                    NextState("Byte1")
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        fsm.act("Byte1",
                If (old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                    NextValue(time_counter, 25000000//2),
                    NextValue(self.display, self.value[16:24]),
                    NextState("Byte2")
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        fsm.act("Byte2",
                If (old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                    NextValue(time_counter, 25000000//2),
                    NextValue(self.display, self.value[24:32]),
                    NextState("Byte3")
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        fsm.act("Byte3",
                If (old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                       NextValue(time_counter, 25000000//10),
                       NextValue(blink_counter, 10),
                       NextValue(self.display, 0x00),
                    NextState("Quick")
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        
class SBusFPGABus(Module):
    def __init__(self, platform, prom, hold_reset, wr_fifo, rd_fifo_addr, rd_fifo_data, master_wr_fifo, master_rd_fifo_addr, master_rd_fifo_data):
        self.platform = platform
        self.hold_reset = hold_reset
        self.wr_fifo = wr_fifo
        self.rd_fifo_addr = rd_fifo_addr
        self.rd_fifo_data = rd_fifo_data

        self.master_wr_fifo = master_wr_fifo
        self.master_rd_fifo_addr = master_rd_fifo_addr
        self.master_rd_fifo_data = master_rd_fifo_data
        
        ##pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        ##SBUS_DATA_OE_LED_o = Signal()
        ##self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
        ##pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        ##SBUS_DATA_OE_LED_2_o = Signal()
        ##self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)
        
        #self.comb += SBUS_DATA_OE_LED_o.eq(~rd_fifo_addr.writable)
        #self.comb += SBUS_DATA_OE_LED_2_o.eq(rd_fifo_data.readable)
        
        #pad_SBUS_3V3_CLK = platform.request("SBUS_3V3_CLK")
        pad_SBUS_3V3_ASs = platform.request("SBUS_3V3_ASs")
        pad_SBUS_3V3_BGs = platform.request("SBUS_3V3_BGs")
        pad_SBUS_3V3_BRs = platform.request("SBUS_3V3_BRs")
        pad_SBUS_3V3_ERRs = platform.request("SBUS_3V3_ERRs")
        #pad_SBUS_3V3_RSTs = platform.request("SBUS_3V3_RSTs")
        pad_SBUS_3V3_SELs = platform.request("SBUS_3V3_SELs")
        #pad_SBUS_3V3_INT1s = platform.request("SBUS_3V3_INT1s")
        pad_SBUS_3V3_INT7s = platform.request("SBUS_3V3_INT7s")
        pad_SBUS_3V3_PPRD = platform.request("SBUS_3V3_PPRD")
        pad_SBUS_OE = platform.request("SBUS_OE")
        pad_SBUS_3V3_ACKs = platform.request("SBUS_3V3_ACKs")
        pad_SBUS_3V3_SIZ = platform.request("SBUS_3V3_SIZ")
        pad_SBUS_3V3_D = platform.request("SBUS_3V3_D")
        pad_SBUS_3V3_PA = platform.request("SBUS_3V3_PA")
        assert len(pad_SBUS_3V3_D) == 32, "len(pad_SBUS_3V3_D) should be 32"
        assert len(pad_SBUS_3V3_PA) == 28, "len(pad_SBUS_3V3_PA) should be 28"

        sbus_oe_data = Signal(reset=0)
        sbus_oe_slave_in = Signal(reset=0)
        sbus_oe_master_in = Signal(reset=0)
        #sbus_oe_int1 = Signal(reset=0)
        sbus_oe_int7 = Signal(reset=0)
        #sbus_oe_master_br = Signal(reset=0)

        sbus_last_pa = Signal(28)
        burst_index = Signal(4)
        burst_counter = Signal(4)
        burst_limit_m1 = Signal(4)

        #SBUS_3V3_CLK = Signal()
        SBUS_3V3_ASs_i = Signal()
        self.comb += SBUS_3V3_ASs_i.eq(pad_SBUS_3V3_ASs)
        SBUS_3V3_BGs_i = Signal()
        self.comb += SBUS_3V3_BGs_i.eq(pad_SBUS_3V3_BGs)
        SBUS_3V3_BRs_o = Signal(reset=1)
        #self.specials += Tristate(pad_SBUS_3V3_BRs, SBUS_3V3_BRs_o, sbus_oe_master_br, None)
        self.comb += pad_SBUS_3V3_BRs.eq(SBUS_3V3_BRs_o)
        SBUS_3V3_ERRs_i = Signal()
        SBUS_3V3_ERRs_o = Signal()
        self.specials += Tristate(pad_SBUS_3V3_ERRs, SBUS_3V3_ERRs_o, sbus_oe_master_in, SBUS_3V3_ERRs_i)
        #SBUS_3V3_RSTs = Signal()
        SBUS_3V3_SELs_i = Signal()
        self.comb += SBUS_3V3_SELs_i.eq(pad_SBUS_3V3_SELs)
        #SBUS_3V3_INT1s_o = Signal(reset=1)
        #self.specials += Tristate(pad_SBUS_3V3_INT1s, SBUS_3V3_INT1s_o, sbus_oe_int1, None)
        SBUS_3V3_INT7s_o = Signal(reset=1)
        self.specials += Tristate(pad_SBUS_3V3_INT7s, SBUS_3V3_INT7s_o, sbus_oe_int7, None)
        SBUS_3V3_PPRD_i = Signal()
        SBUS_3V3_PPRD_o = Signal()
        self.specials += Tristate(pad_SBUS_3V3_PPRD, SBUS_3V3_PPRD_o, sbus_oe_slave_in, SBUS_3V3_PPRD_i)
        #SBUS_OE_o = Signal()
        self.comb += pad_SBUS_OE.eq(self.hold_reset)
        SBUS_3V3_ACKs_i = Signal(3)
        SBUS_3V3_ACKs_o = Signal(3)
        self.specials += Tristate(pad_SBUS_3V3_ACKs, SBUS_3V3_ACKs_o, sbus_oe_master_in, SBUS_3V3_ACKs_i)
        SBUS_3V3_SIZ_i = Signal(3)
        SBUS_3V3_SIZ_o = Signal(3)
        self.specials += Tristate(pad_SBUS_3V3_SIZ, SBUS_3V3_SIZ_o, sbus_oe_slave_in, SBUS_3V3_SIZ_i)
        SBUS_3V3_D_i = Signal(32)
        SBUS_3V3_D_o = Signal(32)
        self.specials += Tristate(pad_SBUS_3V3_D, SBUS_3V3_D_o, sbus_oe_data, SBUS_3V3_D_i)
        SBUS_3V3_PA_i = Signal(28)
        self.comb += SBUS_3V3_PA_i.eq(pad_SBUS_3V3_PA)

        p_data = Signal(32) # data to read/write

        data_read_addr = Signal(30) # first addr of req. when reading from WB
        data_read_enable = Signal() # start enqueuing req. to read from WB
        data_read_timeout = Signal(7)
        data_read_stale = Signal(5, reset = 0)

        master_data = Signal(32) # could be merged with p_data
        master_addr = Signal(30) # could be meged with data_read_addr

        master_we = Signal();

#        self.submodules.led_display = LedDisplay()
#        #self.comb += self.led_display.value.eq(Cat(Signal(2, reset=0), master_addr))
#        self.comb += self.led_display.value.eq(p_data)
#        old_display = Signal(8)
#        self.sync += old_display.eq(self.led_display.display)
#        self.submodules.display_fsm = display_fsm = FSM(reset_state="Reset")
#        display_fsm.act("Reset",
#                         NextState("Idle"))
#        display_fsm.act("Idle",
#                        If(old_display != self.led_display.display,
#                           NextState("Update")))
#        display_fsm.act("Update",
#                        If(self.wr_fifo.writable & SBUS_3V3_ASs_i, ## available space and not in a slave cycle
#                           self.wr_fifo.we.eq(1),
#                           self.wr_fifo.din.eq(Cat(Signal(30, reset=0x00040000), self.led_display.display, Signal(24, reset=0))),
#                           NextState("Idle")))

        # clean the read FIFO from stale data
        self.submodules.cleaning_fsm = cleaning_fsm = FSM(reset_state="Reset")
        cleaning_fsm.act("Reset",
                         NextState("Idle"))
        cleaning_fsm.act("Idle",
                         If(self.rd_fifo_data.readable & (data_read_stale != 0),
                            self.rd_fifo_data.re.eq(1),
                            NextValue(data_read_stale, data_read_stale - 1)))
        #self.comb += SBUS_DATA_OE_LED_o.eq(data_read_stale != 0)

        self.submodules.slave_fsm = slave_fsm = FSM(reset_state="Reset")

        slave_fsm.act("Reset",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(p_data, 0),
                      NextState("Start")
        )
        slave_fsm.act("Start",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(p_data, 0),
                      If((self.hold_reset == 0), NextState("Idle"))
        )
        slave_fsm.act("Idle",
                      If(((SBUS_3V3_SELs_i == 0) &
                          (SBUS_3V3_ASs_i == 0) &
                          (data_read_stale != 0)), ## refuse access until we've cleaned up the mess
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                         NextValue(SBUS_3V3_ERRs_o, 1),
                         NextState("Slave_Error")
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                          (SBUS_3V3_ASs_i == 0) &
                          (siz_is_word(SBUS_3V3_SIZ_i)) &
                          (SBUS_3V3_PPRD_i == 1) &
                          (SBUS_3V3_PA_i[0:2] == 0)),
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(sbus_last_pa, SBUS_3V3_PA_i),
                         NextValue(burst_counter, 0),
                         Case(SBUS_3V3_SIZ_i, {
                             SIZ_WORD: NextValue(burst_limit_m1, 0),
                             SIZ_BURST2: NextValue(burst_limit_m1, 1),
                             SIZ_BURST4: NextValue(burst_limit_m1, 3),
                             SIZ_BURST8: NextValue(burst_limit_m1, 7),
                             SIZ_BURST16: NextValue(burst_limit_m1, 15)}),
                         If((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ROM_ADDR_PFX),
                            NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextValue(p_data, prom[SBUS_3V3_PA_i[ADDR_PHYS_LOW+2:ADDR_PFX_LOW]]),
                            NextState("Slave_Ack_Read_Prom_Burst")
                         ).Elif(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == USBOHCI_ADDR_PFX)),
                            NextValue(SBUS_3V3_ACKs_o, ACK_IDLE), # need to wait for data, don't ACK yet
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextValue(p_data, 0xDEADBEEF),
                            NextValue(data_read_addr, (Cat(SBUS_3V3_PA_i[2:], Signal(4, reset=0)))), # enqueue all the request to the wishbone
                            NextValue(data_read_enable, 1), # enqueue all the request to the wishbone
                            NextValue(data_read_timeout, 0x7F),
                            NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Data")
                         ).Else(
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             NextState("Slave_Error")
                         )
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (SIZ_BYTE == SBUS_3V3_SIZ_i) &
                              (SBUS_3V3_PPRD_i == 1)),
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(sbus_last_pa, SBUS_3V3_PA_i),
                         If((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ROM_ADDR_PFX),
                            NextValue(SBUS_3V3_ACKs_o, ACK_BYTE),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextValue(p_data, prom[SBUS_3V3_PA_i[ADDR_PHYS_LOW+2:ADDR_PFX_LOW]]),
                            NextState("Slave_Ack_Read_Prom_Byte")
                         ).Else(
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             NextState("Slave_Error")
                         )
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (siz_is_word(SBUS_3V3_SIZ_i)) &
                              (SBUS_3V3_PPRD_i == 0) &
                              (SBUS_3V3_PA_i[0:2] == 0) &
                              (self.wr_fifo.writable)), # maybe we should check for enough space? not that we'll encounter write burst...
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(sbus_last_pa, SBUS_3V3_PA_i),
                         NextValue(burst_counter, 0),
                         Case(SBUS_3V3_SIZ_i, {
                             SIZ_WORD: NextValue(burst_limit_m1, 0),
                             SIZ_BURST2: NextValue(burst_limit_m1, 1),
                             SIZ_BURST4: NextValue(burst_limit_m1, 3),
                             SIZ_BURST8: NextValue(burst_limit_m1, 7),
                             SIZ_BURST16: NextValue(burst_limit_m1, 15)}),
                         If(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                             (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == USBOHCI_ADDR_PFX)),
                            NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextState("Slave_Ack_Reg_Write_Burst")
                         ).Else(
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             NextState("Slave_Error")
                         )
                      ).Elif(SBUS_3V3_BGs_i &
                             (self.master_wr_fifo.readable | self.master_rd_fifo_addr.readable),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i &
                             (self.master_wr_fifo.readable | self.master_rd_fifo_addr.readable),
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(burst_limit_m1, 0), ## only single word for now
                             If(self.master_wr_fifo.readable,
                                NextValue(master_addr, self.master_wr_fifo.dout[0:30]),
                                NextValue(master_data, self.master_wr_fifo.dout[30:32]),
                                self.master_wr_fifo.re.eq(1),
                                NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 0), self.master_wr_fifo.dout[0:30])),
                                NextValue(SBUS_3V3_PPRD_o, 0),
                                NextValue(master_we, 1),
                                NextState("Master_Translation")
                             ).Elif(self.master_rd_fifo_addr.readable,
                                NextValue(master_addr, self.master_rd_fifo_addr.dout),
                                self.master_rd_fifo_addr.re.eq(1),
                                NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 0), self.master_rd_fifo_addr.dout[0:30])),
                                NextValue(SBUS_3V3_PPRD_o, 1),
                                NextValue(master_we, 0),
                                NextState("Master_Translation")
                            ).Else(
                                # FIXME: handle error
                            )
                                    
                      )
        )
        # ##### SLAVE READ #####
        slave_fsm.act("Slave_Ack_Read_Prom_Burst",
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      NextValue(p_data, prom[Cat(index_with_wrap((burst_counter+1), burst_limit_m1, sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6]), sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW])]),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Do_Read")
                      ).Else(
                          NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                          NextValue(burst_counter, burst_counter + 1)
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Prom_Byte",
                      NextValue(sbus_oe_data, 1),
                      If((sbus_last_pa[0:2] == 0x0),
                         NextValue(SBUS_3V3_D_o, Cat(Signal(24), p_data[24:32]))
                      ).Elif((sbus_last_pa[0:2] == 0x1),
                         NextValue(SBUS_3V3_D_o, Cat(Signal(24), p_data[16:24]))
                      ).Elif((sbus_last_pa[0:2] == 0x2),
                         NextValue(SBUS_3V3_D_o, Cat(Signal(24), p_data[ 8:16]))
                      ).Elif((sbus_last_pa[0:2] == 0x3),
                         NextValue(SBUS_3V3_D_o, Cat(Signal(24), p_data[ 0: 8]))
                      ),
                      NextState("Slave_Do_Read")
        )
        slave_fsm.act("Slave_Do_Read",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      If((SBUS_3V3_ASs_i == 1),
                         NextState("Idle")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Burst",
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Do_Read")
                      ).Else(
                          NextValue(burst_counter, burst_counter + 1),
                          If(self.rd_fifo_data.readable,
                             If(self.rd_fifo_data.dout[32] == 0,
                                NextValue(p_data, self.rd_fifo_data.dout),
                                self.rd_fifo_data.re.eq(1),
                                NextValue(SBUS_3V3_ACKs_o, ACK_WORD)
                             ).Else(
                                 self.rd_fifo_data.re.eq(1),
                                 NextValue(p_data, self.rd_fifo_data.dout),
                                 NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                                 NextValue(data_read_stale, burst_limit_m1 - burst_counter),
                                 NextState("Slave_Do_Read"),
                             )
                          ).Else(
                              NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                              NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Data")
                          )
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Burst_Wait_For_Data",
                      NextValue(data_read_timeout, data_read_timeout - 1),
                      If(self.rd_fifo_data.readable,
                             If(self.rd_fifo_data.dout[32] == 0,
                                NextValue(p_data, self.rd_fifo_data.dout),
                                self.rd_fifo_data.re.eq(1),
                                NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                                NextState("Slave_Ack_Read_Reg_Burst")
                             ).Else(
                                 self.rd_fifo_data.re.eq(1),
                                 NextValue(p_data, self.rd_fifo_data.dout),
                                 NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                                 NextValue(data_read_stale, burst_limit_m1 - burst_counter),
                                 NextState("Slave_Do_Read"),
                             )
                      ).Elif(data_read_timeout == 0,
                             NextValue(p_data, 0x00C0FFEE),
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                             NextValue(data_read_stale, 1 + burst_limit_m1 - burst_counter),
                             NextState("Slave_Do_Read")
                      )
        )
        # ##### SLAVE WRITE #####
        slave_fsm.act("Slave_Ack_Reg_Write_Burst",
                      self.wr_fifo.din.eq(Cat(index_with_wrap(burst_counter, burst_limit_m1, sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6]), # 4 bits, adr FIXME
                                      sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW], # 10 bits, adr
                                      sbus_last_pa[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH], # 12 bits, adr
                                      Signal(4, reset = 0), # 4 bits, adr (could be removed)
                                      SBUS_3V3_D_i)), # 32 bits, data
                      self.wr_fifo.we.eq(1),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Ack_Reg_Write_Final")
                      ).Else(
                          NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                          NextValue(burst_counter, burst_counter + 1)
                      )
        )
        slave_fsm.act("Slave_Ack_Reg_Write_Final",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      If((SBUS_3V3_ASs_i == 1),
                         NextState("Idle")
                      )
        )
        # ##### SLAVE ERROR #####
        slave_fsm.act("Slave_Error",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      If((SBUS_3V3_ASs_i == 1),
                         NextState("Idle")
                      )
        )
        # ##### MASTER #####
        slave_fsm.act("Master_Translation",
                      If(master_we,
                         NextValue(sbus_oe_data, 1),
                         NextValue(SBUS_3V3_D_o, master_data)
                      ).Else(
                         NextValue(sbus_oe_data, 0)
                      ),
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_ERR: ## ouch
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")],
                          ACK_RERUN: ### dunno how to handle that yet, maybe delay the fifo re(1)?
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")],
                          ACK_IDLE:
                          [If(master_we,
                              NextState("Master_Write"),
                              ## FIXME: in burst mode, should update master_data with the next value
                              ## FIXME: we don't do burst mode yet
                          ).Else(
                              NextState("Master_Read"),
                          )],
                          "default":
                          [If(SBUS_3V3_BGs_i, ## oups, we lost our bus access without error ?!?
                              NextValue(sbus_oe_data, 0),
                              NextValue(sbus_oe_slave_in, 0),
                              NextValue(sbus_oe_master_in, 0),
                              NextState("Idle")
                          )],
                      })
        )
        slave_fsm.act("Master_Read",
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_WORD:
                          [NextState("Master_Read_Ack")
                          ],
                          ACK_IDLE:
                          [NextState("Master_Read") ## redundant
                          ],
                          ACK_RERUN: ### dunno how to handle that yet, maybe delay the fifo re(1)?
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")
                          ],
                          "default": ## ACK_ERRS or other
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")
                          ],
                      })
        )
        slave_fsm.act("Master_Read_Ack",
                      self.master_rd_fifo_data.we.eq(1),
                      NextValue(self.master_rd_fifo_data.din, SBUS_3V3_D_i),
                      NextValue(burst_counter, burst_counter + 1),
                      If(burst_counter == burst_limit_m1,
                         NextState("Master_Read_Finish")
                      ).Else(
                          Case(SBUS_3V3_ACKs_i, {
                              ACK_WORD: NextState("Master_Read_Ack"), ## redundant
                              ACK_IDLE: NextState("Master_Read"),
                              ACK_RERUN: ### dunno how to handle that yet, maybe delay the fifo re(1)?
                              [NextValue(sbus_oe_data, 0),
                               NextValue(sbus_oe_slave_in, 0),
                               NextValue(sbus_oe_master_in, 0),
                               NextState("Idle")
                              ],
                              "default":
                              [NextValue(sbus_oe_data, 0),
                               NextValue(sbus_oe_slave_in, 0),
                               NextValue(sbus_oe_master_in, 0),
                               NextState("Idle")
                              ],
                          }),
                      )
        )
        slave_fsm.act("Master_Read_Finish", ## missing the handling of late error
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextState("Idle")
        )
        slave_fsm.act("Master_Write",
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_WORD:
                          [If(burst_counter == burst_limit_m1,
                              NextState("Master_Write_Final"),
                          ).Else(
                              NextValue(SBUS_3V3_D_o, master_data), ## FIXME: we're not updating master_data for burst mode yet
                              NextValue(burst_counter, burst_counter + 1),
                          )],
                          ACK_IDLE:
                          [NextState("Master_Write") ## redundant
                          ],
                          ACK_RERUN: ### dunno how to handle that yet, maybe delay the fifo re(1)?
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")
                          ],
                          "default": ## ACK_ERRS or other
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           NextState("Idle")
                          ],
                      })
        )
        slave_fsm.act("Master_Write_Final",
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextState("Idle")
        )
        # ##### FINISHED #####

        self.submodules.request_fsm = request_fsm = FSM(reset_state="Reset")
        req_counter = Signal(4)
        req_limit_m1 = Signal(4)
        request_fsm.act("Reset",
                        NextState("Idle")
        )
        request_fsm.act("Idle",
                        If(data_read_enable,
                           NextValue(data_read_enable, 0),
                           self.rd_fifo_addr.we.eq(1),
                           self.rd_fifo_addr.din.eq(data_read_addr),
                           If (burst_limit_m1 != burst_counter, # 0 the first time
                               NextValue(req_counter, burst_counter + 1),
                               NextValue(req_limit_m1, burst_limit_m1),
                               NextState("Queue")
                           )
                        )
        )
        request_fsm.act("Queue",
                        self.rd_fifo_addr.we.eq(1),
                        self.rd_fifo_addr.din.eq(Cat(index_with_wrap(req_counter, req_limit_m1, data_read_addr[0:4]), data_read_addr[4:])),
                        If(req_limit_m1 != req_counter,
                            NextValue(req_counter, req_counter + 1),
                        ).Else(
                            NextState("Idle")
                        )
        )
