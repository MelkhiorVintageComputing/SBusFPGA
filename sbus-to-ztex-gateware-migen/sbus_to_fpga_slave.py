
from migen import *
from migen.genlib.fifo import SyncFIFOBuffered
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

def siz_is_word(siz):
    return (SIZ_WORD == siz) or (SIZ_BURST2 == siz) or (SIZ_BURST4 == siz) or (SIZ_BURST8 == siz) or (SIZ_BURST16 == siz)

def index_with_wrap(counter, limit_m1, value):
    if (limit_m1 == 0):
        return value[0:4]
    elif (limit_m1 == 1):
        return Cat((value + counter)[0:1], value[1:4])
    elif (limit_m1 == 3):
        return Cat((value + counter)[0:2], value[2:4])
    elif (limit_m1 == 7):
        return Cat((value + counter)[0:3], value[3:4])
    elif (limit_m1 == 15):
        return (value + counter)[0:4]
    return value[0:4]

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

#       siz_to_burst_size_m1 = {
#            SIZ_WORD: 0,
#            SIZ_BURST2: 1,
#            SIZ_BURST4: 3,
#            SIZ_BURST8: 7,
#            SIZ_BURST16: 15
#        };

class SBusFPGASlave(Module):
    def __init__(self, platform, soc, prom, hold_reset):

        self.hold_reset = hold_reset
        
        #pad_SBUS_3V3_CLK = platform.request("SBUS_3V3_CLK")
        pad_SBUS_3V3_ASs = platform.request("SBUS_3V3_ASs")
        pad_SBUS_3V3_BGs = platform.request("SBUS_3V3_BGs")
        pad_SBUS_3V3_BRs = platform.request("SBUS_3V3_BRs")
        pad_SBUS_3V3_ERRs = platform.request("SBUS_3V3_ERRs")
        pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        #pad_SBUS_3V3_RSTs = platform.request("SBUS_3V3_RSTs")
        pad_SBUS_3V3_SELs = platform.request("SBUS_3V3_SELs")
        pad_SBUS_3V3_INT1s = platform.request("SBUS_3V3_INT1s")
        pad_SBUS_3V3_INT7s = platform.request("SBUS_3V3_INT7s")
        pad_SBUS_3V3_PPRD = platform.request("SBUS_3V3_PPRD")
        pad_SBUS_OE = platform.request("SBUS_OE")
        pad_SBUS_3V3_ACKs = platform.request("SBUS_3V3_ACKs")
        pad_SBUS_3V3_SIZ = platform.request("SBUS_3V3_SIZ")
        pad_SBUS_3V3_D = platform.request("SBUS_3V3_D")
        pad_SBUS_3V3_PA = platform.request("SBUS_3V3_PA")

        leds = Signal(8, reset=0xF0)
        self.comb += platform.request("user_led", 0).eq(leds[0])
        self.comb += platform.request("user_led", 1).eq(leds[1])
        self.comb += platform.request("user_led", 2).eq(leds[2])
        self.comb += platform.request("user_led", 3).eq(leds[3])
        self.comb += platform.request("user_led", 4).eq(leds[4])
        self.comb += platform.request("user_led", 5).eq(leds[5])
        self.comb += platform.request("user_led", 6).eq(leds[6])
        self.comb += platform.request("user_led", 7).eq(leds[7])

        sbus_oe_data = Signal(reset=0)
        sbus_oe_slave_in = Signal(reset=0)
        sbus_oe_master_in = Signal(reset=0)
        sbus_oe_int1 = Signal(reset=0)
        sbus_oe_int7 = Signal(reset=0)
        sbus_oe_master_br = Signal(reset=0)

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
        self.specials += Tristate(pad_SBUS_3V3_BRs, SBUS_3V3_BRs_o, sbus_oe_master_br, None)
        SBUS_3V3_ERRs_i = Signal()
        SBUS_3V3_ERRs_o = Signal()
        self.specials += Tristate(pad_SBUS_3V3_ERRs, SBUS_3V3_ERRs_o, sbus_oe_master_in, SBUS_3V3_ERRs_i)
        SBUS_DATA_OE_LED_o = Signal()
        self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
        SBUS_DATA_OE_LED_2_o = Signal()
        self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)
        #SBUS_3V3_RSTs = Signal()
        SBUS_3V3_SELs_i = Signal()
        self.comb += SBUS_3V3_SELs_i.eq(pad_SBUS_3V3_SELs)
        SBUS_3V3_INT1s_o = Signal(reset=1)
        self.specials += Tristate(pad_SBUS_3V3_INT1s, SBUS_3V3_INT1s_o, sbus_oe_int1, None)
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

        self.submodules.slave_fsm = slave_fsm = FSM(reset_state="Reset")

        p_data = Signal(32) # prom data

        slave_fsm.act("Reset",
                      NextValue(SBUS_DATA_OE_LED_o, 0),
                      NextValue(SBUS_DATA_OE_LED_2_o, 0),
                      NextValue(sbus_oe_int1, 0),
                      NextValue(sbus_oe_int7, 0),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_oe_master_br, 0),
                      NextValue(p_data, 0),
                      NextValue(leds, 0x0F),
                      NextState("Start")
        )
        slave_fsm.act("Start",
                      NextValue(SBUS_DATA_OE_LED_o, 0),
                      NextValue(SBUS_DATA_OE_LED_2_o, 0),
                      NextValue(sbus_oe_int1, 0),
                      NextValue(sbus_oe_int7, 0),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_oe_master_br, 0),
                      NextValue(p_data, 0),
                      NextValue(leds, 0x01),
                      If((self.hold_reset == 0), NextState("Idle"))
        )
        slave_fsm.act("Idle",
                      #NextValue(leds, 0x11),
                      If(((SBUS_3V3_SELs_i == 0) and
                          (SBUS_3V3_ASs_i == 0) and
                          (siz_is_word(SBUS_3V3_SIZ_i)) and
                          (SBUS_3V3_PPRD_i == 1)),
                         NextValue(SBUS_DATA_OE_LED_o, 1),
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(sbus_last_pa, SBUS_3V3_PA_i),
                         NextValue(burst_counter, 0),
                         NextValue(burst_limit_m1, siz_to_burst_size_m1(SBUS_3V3_SIZ_i)),
                         If((SBUS_3V3_PA_i[16:28] == 0x000),
                            NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextValue(p_data, prom[SBUS_3V3_PA_i[2:16]]),
                            NextState("Slave_Ack_Read_Prom_Burst")
                         ).Else(
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             NextState("Slave_Error")
                         )
                      ).Elif(((SBUS_3V3_SELs_i == 0) and
                          (SBUS_3V3_ASs_i == 0) and
                          (SIZ_BYTE == SBUS_3V3_SIZ_i) and
                          (SBUS_3V3_PPRD_i == 1)),
                         NextValue(SBUS_DATA_OE_LED_2_o, 1),
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(sbus_last_pa, SBUS_3V3_PA_i),
                         If((SBUS_3V3_PA_i[16:28] == 0x000),
                            NextValue(SBUS_3V3_ACKs_o, ACK_BYTE),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            NextValue(p_data, prom[SBUS_3V3_PA_i[2:16]]),
                            NextState("Slave_Ack_Read_Prom_Byte")
                         ).Else(
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             NextState("Slave_Error")
                         )
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Prom_Burst",
                      NextValue(leds, 0x03),
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      #NextValue(burst_index, index_with_wrap((burst_counter+1), burst_limit_m1, sbus_last_pa[2:6])),
                      NextValue(p_data, prom[Cat(index_with_wrap((burst_counter+1), burst_limit_m1, sbus_last_pa[2:6]), sbus_last_pa[6:16])]),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Do_Read")
                      ).Else(
                          NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                          NextValue(burst_counter, burst_counter + 1)
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Prom_Byte",
                      NextValue(leds, 0x0c),
                      NextValue(sbus_oe_data, 1),
                      If((sbus_last_pa[0:2] == 0x0),
                         NextValue(SBUS_3V3_D_o, Cat(C(0)[0:24], p_data[24:32]))
                      ).Elif((sbus_last_pa[0:2] == 0x1),
                         NextValue(SBUS_3V3_D_o, Cat(C(0)[0:24], p_data[16:24]))
                      ).Elif((sbus_last_pa[0:2] == 0x2),
                         NextValue(SBUS_3V3_D_o, Cat(C(0)[0:24], p_data[8:16]))
                      ).Elif((sbus_last_pa[0:2] == 0x3),
                         NextValue(SBUS_3V3_D_o, Cat(C(0)[0:24], p_data[0:8]))
                      ),
                      NextState("Slave_Do_Read")
        )
        slave_fsm.act("Slave_Do_Read",
                      NextValue(leds, 0x30),
                      NextValue(sbus_oe_int1, 0),
                      NextValue(sbus_oe_int7, 0),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_oe_master_br, 0),
                      If((SBUS_3V3_ASs_i == 1),
                         NextState("Idle")
                      )
        )
        slave_fsm.act("Slave_Error",
                      NextValue(leds, 0xc0),
                      NextValue(sbus_oe_int1, 0),
                      NextValue(sbus_oe_int7, 0),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_oe_master_br, 0),
                      If((SBUS_3V3_ASs_i == 1),
                         NextState("Idle")
                      )
        )
