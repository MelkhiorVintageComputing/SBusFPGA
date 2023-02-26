
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
ROM_ADDR_PFX =           Signal(ADDR_PFX_LENGTH, reset = 0x000) # read only
WISHBONE_CSR_ADDR_PFX =  Signal(ADDR_PFX_LENGTH, reset = 0x004) # 0x00040000
USBOHCI_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x008)
SRAM_ADDR_PFX =          Signal(ADDR_PFX_LENGTH, reset = 0x009) # unmapped ; LE
ENGINE_ADDR_PFXA =       Signal(ADDR_PFX_LENGTH, reset = 0x00a)
ENGINE_ADDR_PFXB =       Signal(ADDR_PFX_LENGTH, reset = 0x00b)
JARETH_ADDR_PFXA =       Signal(ADDR_PFX_LENGTH, reset = 0x00c)
JARETH_ADDR_PFXB =       Signal(ADDR_PFX_LENGTH, reset = 0x00d)
CG6_BT_ADDR_PFX =        Signal(ADDR_PFX_LENGTH, reset = 0x020)
CG6_ALT_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x028)
CG6_FHC_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x030)
CG3_BT_ADDR_PFX =        Signal(ADDR_PFX_LENGTH, reset = 0x040)
FBC_ROM_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x041) # read only
#FBC_RAM_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x042) #
CG6_FBC_ADDR_PFX =       Signal(ADDR_PFX_LENGTH, reset = 0x070)


ADDR_LONG_PFX_HIGH = ADDR_PHYS_HIGH
ADDR_LONG_PFX_LOW  = 26 ## 64 MiB per prefix
ADDR_LONG_PFX_LENGTH = 2 #(1 + ADDR_LONG_PFX_HIGH - ADDR_LONG_PFX_LOW)
SPIFLASH_ADDR_LONG_PFX  = Signal(ADDR_LONG_PFX_LENGTH, reset = 0x1) # 0x04000000

wishbone_default_timeout = 120 ##
sbus_default_timeout = 50 ## must be below 255/2 (two waits)
sbus_default_master_throttle = 3

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
    def __init__(self, pads):
        n = len(pads)
        self.value = Signal(40, reset = 0x0018244281)
        old_value = Signal(40)
        self.display = Signal(8)
        self.comb += pads.eq(self.display)
        
        self.submodules.fsm = fsm = FSM(reset_state="Reset")
        time_counter = Signal(32, reset = 0)
        blink_counter = Signal(4, reset = 0)
        fsm.act("Reset",
                NextValue(time_counter, 25000000//2),
                NextValue(blink_counter, 0),
                NextValue(self.display, self.value[0:8]),
                NextValue(old_value, self.value),
                NextState("Byte0"))
        fsm.act("Quick",
                If(old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                   If(blink_counter == 0,
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
                If(old_value != self.value,
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
                If(old_value != self.value,
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
                If(old_value != self.value,
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
                If(old_value != self.value,
                    NextState("Reset")
                ).Elif(time_counter == 0,
                       NextValue(time_counter, 25000000//2),
                       NextValue(self.display, self.value[32:40]),
                       NextState("Byte4")
                ).Else(
                    NextValue(time_counter, time_counter - 1)
                )
        )
        fsm.act("Byte4",
                If(old_value != self.value,
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

LED_PARITY=0x11
LED_ADDRESS=0x12
LED_UNKNOWNREQ=0x14
LED_RERUN=0x8
LED_RERUN_WRITE=0x4
LED_RERUN_WORD=0x2
LED_RERUN_LATE=0x1

LED_M_WRITE = 0x10
LED_M_READ = 0x20
LED_M_CACHE = 0x40
        
class SBusFPGABus(Module):
    def __init__(self, soc, platform, stat, hold_reset, wishbone_slave, wishbone_master, tosbus_fifo, fromsbus_fifo, fromsbus_req_fifo, version, burst_size = 8, cg3_fb_size = 0, cg3_base=0x8ff00000 ):
        self.platform = platform
        self.hold_reset = hold_reset

        self.wishbone_slave = wishbone_slave
        self.wishbone_master = wishbone_master

        self.tosbus_fifo = tosbus_fifo
        self.fromsbus_fifo = fromsbus_fifo
        self.fromsbus_req_fifo = fromsbus_req_fifo

        
        tosbus_fifo_dout = Record(soc.tosbus_layout)
        self.comb += tosbus_fifo_dout.raw_bits().eq(self.tosbus_fifo.dout)
        
        fromsbus_req_fifo_dout = Record(soc.fromsbus_req_layout)
        self.comb += fromsbus_req_fifo_dout.raw_bits().eq(self.fromsbus_req_fifo.dout)
        
        fromsbus_fifo_din = Record(soc.fromsbus_layout)
        self.comb += self.fromsbus_fifo.din.eq(fromsbus_fifo_din.raw_bits())


        if (cg3_fb_size <= 1*1048576):
            CG3_UPPER_BITS=12
            CG3_KEPT_UPPER_BIT=20
            CG3_PIXELS_ADDR_BIGVAL = 0x08>>0
            CG3_PIXELS_ADDR_BIGPFX = Signal(8, reset = CG3_PIXELS_ADDR_BIGVAL)
        elif (cg3_fb_size == 2*1048576):
            CG3_UPPER_BITS=11
            CG3_KEPT_UPPER_BIT=21
            CG3_PIXELS_ADDR_BIGVAL = 0x08>>1
            CG3_PIXELS_ADDR_BIGPFX = Signal(7, reset = CG3_PIXELS_ADDR_BIGVAL)
        elif (cg3_fb_size == 4*1048576):
            CG3_UPPER_BITS=10
            CG3_KEPT_UPPER_BIT=22
            CG3_PIXELS_ADDR_BIGVAL = 0x08>>2
            CG3_PIXELS_ADDR_BIGPFX = Signal(6, reset = CG3_PIXELS_ADDR_BIGVAL)
        elif (cg3_fb_size == 8*1048576):
            CG3_UPPER_BITS=9
            CG3_KEPT_UPPER_BIT=23
            CG3_PIXELS_ADDR_BIGVAL = 0x08>>3
            CG3_PIXELS_ADDR_BIGPFX = Signal(5, reset = CG3_PIXELS_ADDR_BIGVAL)
        elif (cg3_fb_size == 16*1048576):
            CG3_UPPER_BITS=8
            CG3_KEPT_UPPER_BIT=24
            CG3_PIXELS_ADDR_BIGVAL = 0x10>>4
            CG3_PIXELS_ADDR_BIGPFX = Signal(4, reset = CG3_PIXELS_ADDR_BIGVAL)
        else:
            print(f"{cg3_fb_size//1048576} mebibytes framebuffer not supported")
            assert(False)
            
        ADDR_BIGPFX_HIGH = ADDR_PHYS_HIGH
        ADDR_BIGPFX_LOW = CG3_KEPT_UPPER_BIT ## x MiB per bigprefix
        ADDR_BIGPFX_LENGTH = (1 + ADDR_BIGPFX_HIGH - ADDR_BIGPFX_LOW)
        
        CG3_REMAPPED_BASE=cg3_base >> CG3_KEPT_UPPER_BIT

        print(f"CG3 remapping: {cg3_fb_size//1048576} Mib starting at prefix {CG3_REMAPPED_BASE:x} ({(CG3_REMAPPED_BASE<<CG3_KEPT_UPPER_BIT):x})")
        
        data_width = burst_size * 4
        data_width_bits = burst_size * 32
        blk_addr_width = 32 - log2_int(data_width) # 27 for burst_size == 8

        fifo_blk_addr = Signal(blk_addr_width)
        fifo_buffer = Signal(data_width_bits)
        
        #pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        #SBUS_DATA_OE_LED_o = Signal()
        #self.comb += pad_SBUS_DATA_OE_LED.eq(SBUS_DATA_OE_LED_o)
        
        ##pad_SBUS_DATA_OE_LED_2 = platform.request("SBUS_DATA_OE_LED_2")
        ##SBUS_DATA_OE_LED_2_o = Signal()
        ##self.comb += pad_SBUS_DATA_OE_LED_2.eq(SBUS_DATA_OE_LED_2_o)

        #leds = Signal(7, reset=0x00)
        #self.comb += platform.request("user_led", 0).eq(leds[0])
        #self.comb += platform.request("user_led", 1).eq(leds[1])
        #self.comb += platform.request("user_led", 2).eq(leds[2])
        #self.comb += platform.request("user_led", 3).eq(leds[3])
        #self.comb += platform.request("user_led", 4).eq(leds[4])
        #self.comb += platform.request("user_led", 5).eq(leds[5])
        #self.comb += platform.request("user_led", 6).eq(leds[6])
        ##self.comb += platform.request("user_led", 7).eq(leds[7])
        
        #pad_SBUS_3V3_CLK = platform.request("SBUS_3V3_CLK")
        pad_SBUS_3V3_ASs = platform.request("SBUS_3V3_ASs")
        pad_SBUS_3V3_BGs = platform.request("SBUS_3V3_BGs")
        pad_SBUS_3V3_BRs = platform.request("SBUS_3V3_BRs")
        pad_SBUS_3V3_ERRs = platform.request("SBUS_3V3_ERRs")
        #pad_SBUS_3V3_RSTs = platform.request("SBUS_3V3_RSTs")
        pad_SBUS_3V3_SELs = platform.request("SBUS_3V3_SELs")
        
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
        #sbus_oe_master_br = Signal(reset=0)

        sbus_last_pa = Signal(32)
        burst_index = Signal(4)
        burst_counter = Signal(4)
        burst_limit_m1 = Signal(4)

        #SBUS_3V3_CLK = Signal()
        SBUS_3V3_ASs_i = Signal(reset=1)
        self.comb += SBUS_3V3_ASs_i.eq(pad_SBUS_3V3_ASs)
        SBUS_3V3_BGs_i = Signal(reset=1)
        self.comb += SBUS_3V3_BGs_i.eq(pad_SBUS_3V3_BGs)
        SBUS_3V3_BRs_o = Signal(reset=1)
        #self.specials += Tristate(pad_SBUS_3V3_BRs, SBUS_3V3_BRs_o, sbus_oe_master_br, None)
        self.comb += pad_SBUS_3V3_BRs.eq(SBUS_3V3_BRs_o)
        SBUS_3V3_ERRs_i = Signal()
        SBUS_3V3_ERRs_o = Signal()
        self.specials += Tristate(pad_SBUS_3V3_ERRs, SBUS_3V3_ERRs_o, sbus_oe_master_in, SBUS_3V3_ERRs_i)
        #SBUS_3V3_RSTs = Signal()
        SBUS_3V3_SELs_i = Signal(reset=1)
        self.comb += SBUS_3V3_SELs_i.eq(pad_SBUS_3V3_SELs)
        
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

        p_data = Signal(32) # data to read/write in Slave mode

        # buffers when someone inside issues a DMA write request to go over SBus
        master_data = Signal(32) # could be merged with p_data
        master_addr = Signal(30) # could be meged with data_read_addr
        
        MASTER_SRC_INV = 0
        MASTER_SRC_BLKDMAFIFO = 1
        MASTER_SRC_WISHBONE = 2
        MASTER_SRC_WISHBONEBUF = 3
        master_src = Signal(2)
        master_src_retry = Signal(1) # reset after each successful master cycle
        
        master_size = Signal(4)
        master_idx = Signal(2)

        master_we = Signal()

        sbus_wishbone_le = Signal()

        wishbone_master_timeout = Signal(log2_int(wishbone_default_timeout, False))
        wishbone_slave_timeout = Signal(log2_int(wishbone_default_timeout, False))
        sbus_slave_timeout = Signal(log2_int(sbus_default_timeout, False))
        self.sync += If(sbus_slave_timeout != 0, sbus_slave_timeout.eq(sbus_slave_timeout - 1))

        sbus_master_throttle = Signal(log2_int(sbus_default_master_throttle, False))
        self.sync += If(sbus_master_throttle != 0, sbus_master_throttle .eq(sbus_master_throttle - 1))
        
        #self.submodules.led_display = LedDisplay(platform.request_all("user_led"))
        
        #self.sync += platform.request("user_led", 4).eq(self.wishbone_slave.cyc)
        #self.sync += platform.request("user_led", 5).eq(self.wishbone_slave.stb)
        #self.sync += platform.request("user_led", 6).eq(self.wishbone_slave.we)
        #self.sync += platform.request("user_led", 7).eq(self.wishbone_slave.ack)
        #self.sync += platform.request("user_led", 0).eq(self.wishbone_slave.err)
        #led4 = platform.request("user_led", 4)
        #led5 = platform.request("user_led", 5)
        #led6 = platform.request("user_led", 6)
        #led7 = platform.request("user_led", 7)

        #led0123 = Signal(4)
        #self.sync += platform.request("user_led", 0).eq(led0123[0])
        #self.sync += platform.request("user_led", 1).eq(led0123[1])
        #self.sync += platform.request("user_led", 2).eq(led0123[2])
        #self.sync += platform.request("user_led", 3).eq(led0123[3])

        #self.sync += platform.request("user_led", 0).eq(self.wishbone_master.cyc)
        #self.sync += platform.request("user_led", 1).eq(self.wishbone_master.stb)
        #self.sync += platform.request("user_led", 2).eq(self.wishbone_master.we)
        #self.sync += platform.request("user_led", 3).eq(self.wishbone_master.ack)
        #self.sync += platform.request("user_led", 4).eq(~SBUS_3V3_SELs_i)
        
        #self.sync += platform.request("user_led", 4).eq(self.wishbone_master.cyc)
        #self.sync += platform.request("user_led", 5).eq(~SBUS_3V3_ASs_i)
        #self.sync += platform.request("user_led", 6).eq(wishbone_master_timeout == 0)
        #led7 = platform.request("user_led", 7)

        #self.sync += platform.request("user_led", 5).eq(self.wishbone_slave.cyc)
        #self.sync += platform.request("user_led", 6).eq(~SBUS_3V3_BRs_o)
        #self.sync += platform.request("user_led", 7).eq(~SBUS_3V3_BGs_i)
        #self.sync += SBUS_DATA_OE_LED_o.eq(~SBUS_3V3_BGs_i),

        #cycle_counter = Signal(8, reset = 0)
        #self.sync += cycle_counter.eq(cycle_counter + 1)
        #cycle_busmaster = Signal(8, reset = 0)
        #self.sync += If(cycle_counter != 0,
        #                cycle_busmaster.eq(cycle_busmaster + ~SBUS_3V3_BGs_i)).Else(
        #                    cycle_busmaster.eq(0))
        #self.sync += If(cycle_counter == 0,
        #                platform.request("user_led", 0).eq(cycle_busmaster[4]),
        #                platform.request("user_led", 1).eq(cycle_busmaster[5]),
        #                platform.request("user_led", 2).eq(cycle_busmaster[6]),
        #                platform.request("user_led", 3).eq(cycle_busmaster[7]))

        # Read buffering when a DMA read request is issued by Wishbone
        self.master_read_buffer_data = Array(Signal(32) for a in range(4))
        self.master_read_buffer_addr = Signal(28)
        self.master_read_buffer_done = Array(Signal() for a in range(4))
        self.master_read_buffer_read = Array(Signal() for a in range(4))
        self.master_read_buffer_start = Signal(reset = 0)
        
        #self.sync += platform.request("user_led", 1).eq(self.master_read_buffer_start)

        #self.master_write_buffer_data = Array(Signal(32) for a in range(4))
        #self.master_write_buffer_addr = Signal(28)
        #self.master_write_buffer_todo = Array(Signal() for a in range(4))
        #self.master_write_buffer_start = Signal()

        self.submodules.slave_fsm = slave_fsm = FSM(reset_state="Reset")

        #self.sync += platform.request("user_led", 0).eq(slave_fsm.ongoing("Master_Translation"))
        #self.sync += platform.request("user_led", 1).eq(slave_fsm.ongoing("Master_Read") |
        #                                                slave_fsm.ongoing("Master_Read_Ack") |
        #                                                slave_fsm.ongoing("Master_Read_Finish") |
        #                                                slave_fsm.ongoing("Master_Write") |
        #                                                slave_fsm.ongoing("Master_Write_Final"))
        #self.sync += platform.request("user_led", 2).eq(slave_fsm.ongoing("Slave_Do_Read") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Burst") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Burst_Wait_For_Data") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Burst_Wait_For_Wishbone") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_HWord") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_HWord_Wait_For_Data") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_HWord_Wait_For_Wishbone") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Byte") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Byte_Wait_For_Data") |
        #                                                slave_fsm.ongoing("Slave_Ack_Read_Reg_Byte_Wait_For_Wishbone"))
        #self.sync += platform.request("user_led", 3).eq(slave_fsm.ongoing("Slave_Ack_Reg_Write_Burst") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_Final") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_Burst_Wait_For_Wishbone") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_HWord") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_HWord_Wait_For_Wishbone") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_Byte") |
        #                                                slave_fsm.ongoing("Slave_Ack_Reg_Write_Byte_Wait_For_Wishbone"))
        
        #self.sync += platform.request("user_led", 5).eq(~slave_fsm.ongoing("Idle"))
            
        
        sbus_master_last_virtual = Signal(32) # last VDMA address put on the bus in master mode

        if (stat):
            stat_slave_early_error_counter = Signal(32)
            increment_stat_slave_early_error_counter = [ NextValue(stat_slave_early_error_counter, stat_slave_early_error_counter + 1) ]
            stat_slave_start_counter = Signal(32)
            increment_stat_slave_start_counter = [ NextValue(stat_slave_start_counter, stat_slave_start_counter + 1) ]
            stat_slave_done_counter = Signal(32)
            increment_stat_slave_done_counter = [ NextValue(stat_slave_done_counter, stat_slave_done_counter + 1) ]
            stat_slave_rerun_counter = Signal(32)
            increment_stat_slave_rerun_counter = [ NextValue(stat_slave_rerun_counter, stat_slave_rerun_counter + 1) ]
        else:
            increment_stat_slave_early_error_counter = [ ]
            increment_stat_slave_start_counter = [ ]
            increment_stat_slave_done_counter = [ ]
            increment_stat_slave_rerun_counter = [ ]
            
        #self.stat_slave_rerun_last_pa = stat_slave_rerun_last_pa = Signal(32)
        #self.stat_slave_rerun_last_state = stat_slave_rerun_last_state = Signal(32)
            
        if (stat):
            print("Enabling statistics collection on the SBus FSM")
            stat_master_start_counter = Signal(32)
            increment_stat_master_start_counter = [ NextValue(stat_master_start_counter, stat_master_start_counter + 1) ]
            stat_master_done_counter = Signal(32)
            increment_stat_master_done_counter = [ NextValue(stat_master_done_counter, stat_master_done_counter + 1) ]
            stat_master_error_counter = Signal(32)
            increment_stat_master_error_counter = [ NextValue(stat_master_error_counter, stat_master_error_counter + 1) ]
            stat_master_rerun_counter = Signal(32)
            increment_stat_master_rerun_counter = [ NextValue(stat_master_rerun_counter, stat_master_rerun_counter + 1) ]
            sbus_master_error_virtual = Signal(32)
            copy_sbus_master_last_virtual_to_error = [ NextValue(sbus_master_error_virtual, sbus_master_last_virtual) ]
        else:
            increment_stat_master_start_counter = [ ]
            increment_stat_master_done_counter = [ ]
            increment_stat_master_error_counter = [ ]
            increment_stat_master_rerun_counter = [ ]
            copy_sbus_master_last_virtual_to_error = [ ]
            
        slave_fsm.act("Reset",
                      #NextValue(self.led_display.value, 0x0000000000),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(p_data, 0),
                      NextState("Start"),
                      NextValue(self.wishbone_master.we, 0),
                      NextValue(self.wishbone_master.cyc, 0),
                      NextValue(self.wishbone_master.stb, 0),
                      NextValue(self.wishbone_slave.ack, 0),
                      NextValue(self.wishbone_slave.err, 0),
                      NextValue(wishbone_master_timeout, 0),
                      NextValue(wishbone_slave_timeout, 0),
                      NextValue(sbus_slave_timeout, 0)
        )
        slave_fsm.act("Start",
                      #NextValue(self.led_display.value, 0x0FF0000000),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(p_data, 0),
                      If((self.hold_reset == 0), NextState("Idle"))
        )
        slave_fsm.act("Idle",
                      # ***** Slave (Multi-)Word Read *****
                      If(((SBUS_3V3_SELs_i == 0) &
                          (SBUS_3V3_ASs_i == 0) &
                          (siz_is_word(SBUS_3V3_SIZ_i)) &
                          (SBUS_3V3_PPRD_i == 1)),
                         NextValue(sbus_oe_master_in, 1),
                         NextValue(burst_counter, 0),
                         Case(SBUS_3V3_SIZ_i, {
                             SIZ_WORD: NextValue(burst_limit_m1, 0),
                             SIZ_BURST2: NextValue(burst_limit_m1, 1),
                             SIZ_BURST4: NextValue(burst_limit_m1, 3),
                             SIZ_BURST8: NextValue(burst_limit_m1, 7),
                             SIZ_BURST16: NextValue(burst_limit_m1, 15)}),
                         If(SBUS_3V3_PA_i[0:2] != 0,
                            NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            #NextValue(led0123, led0123 | LED_PARITY),
                            *increment_stat_slave_early_error_counter,
                            #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                            NextState("Slave_Error")
                         ).Elif(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ROM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == FBC_ROM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FBC_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == USBOHCI_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ENGINE_ADDR_PFXA) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ENGINE_ADDR_PFXB) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == JARETH_ADDR_PFXA) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == JARETH_ADDR_PFXB) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_BT_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_ALT_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FHC_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_LONG_PFX_LOW:ADDR_LONG_PFX_LOW+ADDR_LONG_PFX_LENGTH] == SPIFLASH_ADDR_LONG_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                NextValue(SBUS_3V3_ACKs_o, ACK_IDLE), # need to wait for data, don't ACK yet
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                NextValue(sbus_wishbone_le,
                                          (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                          (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                *increment_stat_slave_start_counter,
                                If(self.wishbone_master.cyc == 0,
                                   NextValue(self.wishbone_master.cyc, 1),
                                   NextValue(self.wishbone_master.stb, 1),
                                   NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                                   NextValue(self.wishbone_master.we, 0),
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:28], Signal(4, reset = 0))),
                                                     NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(wishbone_master_timeout, wishbone_default_timeout),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                   NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Data")
                                ).Else(
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Wishbone")
                                )
                         ).Else(
                             #NextValue(self.led_display.value, 0x0000000020 | 0x0000000001),
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             #NextValue(led0123, led0123 | LED_ADDRESS),
                             *increment_stat_slave_early_error_counter,
                             #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                             NextState("Slave_Error")
                         )
                      # ***** Slave Byte Read *****
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (SIZ_BYTE == SBUS_3V3_SIZ_i) &
                              (SBUS_3V3_PPRD_i == 1)),
                             NextValue(sbus_oe_master_in, 1),
                             If(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ROM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_LONG_PFX_LOW:ADDR_LONG_PFX_LOW+ADDR_LONG_PFX_LENGTH] == SPIFLASH_ADDR_LONG_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                NextValue(SBUS_3V3_ACKs_o, ACK_IDLE), # need to wait for data, don't ACK yet
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                NextValue(sbus_wishbone_le,
                                          (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                          (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                *increment_stat_slave_start_counter,
                                If(self.wishbone_master.cyc == 0,
                                   NextValue(self.wishbone_master.cyc, 1),
                                   NextValue(self.wishbone_master.stb, 1),
                                   NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                                   NextValue(self.wishbone_master.we, 0),
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:28], Signal(4, reset = 0))),
                                                     NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(wishbone_master_timeout, wishbone_default_timeout),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                   NextState("Slave_Ack_Read_Reg_Byte_Wait_For_Data")
                                ).Else(
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   NextState("Slave_Ack_Read_Reg_Byte_Wait_For_Wishbone")
                                )
                             ).Else(
                                 #NextValue(self.led_display.value, 0x0000000040 | 0x0000000001),
                                 NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                                 NextValue(SBUS_3V3_ERRs_o, 1),
                                 #NextValue(led0123, led0123 | LED_ADDRESS),
                                 *increment_stat_slave_early_error_counter,
                                 #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                                 NextState("Slave_Error")
                             )
                      # ***** Slave HalfWord Read *****
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (SIZ_HWORD == SBUS_3V3_SIZ_i) &
                              (SBUS_3V3_PPRD_i == 1)),
                         NextValue(sbus_oe_master_in, 1),
                         If(SBUS_3V3_PA_i[0:1] != 0,
                            NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                            NextValue(SBUS_3V3_ERRs_o, 1),
                            #NextValue(led0123, led0123 | LED_PARITY),
                            *increment_stat_slave_early_error_counter,
                            #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                            NextState("Slave_Error")
                         ).Elif(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ROM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FHC_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_LONG_PFX_LOW:ADDR_LONG_PFX_LOW+ADDR_LONG_PFX_LENGTH] == SPIFLASH_ADDR_LONG_PFX) |
                                 (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                NextValue(SBUS_3V3_ACKs_o, ACK_IDLE), # need to wait for data, don't ACK yet
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                NextValue(sbus_wishbone_le,
                                          (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                          (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                *increment_stat_slave_start_counter,
                                If(self.wishbone_master.cyc == 0,
                                   NextValue(self.wishbone_master.cyc, 1),
                                   NextValue(self.wishbone_master.stb, 1),
                                   NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                                   NextValue(self.wishbone_master.we, 0),
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:28], Signal(4, reset = 0))),
                                                     NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(self.wishbone_master.adr, Cat(SBUS_3V3_PA_i[2:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(wishbone_master_timeout, wishbone_default_timeout),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                   NextState("Slave_Ack_Read_Reg_HWord_Wait_For_Data")
                                ).Else(
                                   Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                       # next remap 8 MiB to Y MiB of SDRAM for CG3_PIXELS_ADDR_PFX
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                   }),
                                   NextValue(sbus_slave_timeout, sbus_default_timeout),
                                   NextState("Slave_Ack_Read_Reg_HWord_Wait_For_Wishbone")
                                )
                         ).Else(
                             #NextValue(self.led_display.value, 0x0000000040 | 0x0000000001),
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             #NextValue(led0123, led0123 | LED_ADDRESS),
                             *increment_stat_slave_early_error_counter,
                             #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                             NextState("Slave_Error")
                         )
                      # ***** Slave (Multi-)Word Write *****
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (siz_is_word(SBUS_3V3_SIZ_i)) &
                              (SBUS_3V3_PPRD_i == 0)),
                             NextValue(sbus_oe_master_in, 1),
                             NextValue(burst_counter, 0),
                             Case(SBUS_3V3_SIZ_i, {
                                 SIZ_WORD: NextValue(burst_limit_m1, 0),
                                 SIZ_BURST2: NextValue(burst_limit_m1, 1),
                                 SIZ_BURST4: NextValue(burst_limit_m1, 3),
                                 SIZ_BURST8: NextValue(burst_limit_m1, 7),
                                 SIZ_BURST16: NextValue(burst_limit_m1, 15)
                             }),
                             If(SBUS_3V3_PA_i[0:2] != 0,
                                NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                #NextValue(led0123, led0123 | LED_PARITY),
                                *increment_stat_slave_early_error_counter,
                                #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                                NextState("Slave_Error")
                             ).Elif(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FBC_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == USBOHCI_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ENGINE_ADDR_PFXA) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == ENGINE_ADDR_PFXB) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == JARETH_ADDR_PFXA) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == JARETH_ADDR_PFXB) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_BT_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_ALT_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FHC_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                    NextValue(sbus_wishbone_le,
                                              (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                              (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                    *increment_stat_slave_start_counter,
                                    Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                        # next remap 8 MiB to Y MiB of SDRAM
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                    }),
                                    If(~self.wishbone_master.cyc,
                                       NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                                       NextValue(SBUS_3V3_ERRs_o, 1),
                                       #NextValue(self.led_display.value, 0x0000000010 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                       NextValue(sbus_slave_timeout, sbus_default_timeout),
                                       NextState("Slave_Ack_Reg_Write_Burst")
                                    ).Else(
                                        NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                                        NextValue(SBUS_3V3_ERRs_o, 1),
                                        NextValue(sbus_slave_timeout, sbus_default_timeout),
                                        NextState("Slave_Ack_Reg_Write_Burst_Wait_For_Wishbone")
                                    )
                             ).Else(
                                 #NextValue(self.led_display.value, 0x0000000060 | 0x0000000001),
                                 NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                                 NextValue(SBUS_3V3_ERRs_o, 1),
                                 #NextValue(led0123, led0123 | LED_ADDRESS),
                                 *increment_stat_slave_early_error_counter,
                                 #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                                 NextState("Slave_Error")
                             )
                      # ***** Slave Byte Write *****
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (SIZ_BYTE == SBUS_3V3_SIZ_i) &
                              (SBUS_3V3_PPRD_i == 0)),
                         NextValue(sbus_oe_master_in, 1),
                         If(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                             (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                             (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                             (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                            NextValue(sbus_wishbone_le,
                                      (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                      (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                            *increment_stat_slave_start_counter,
                            Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                ],
                                # next remap 8 MiB to Y MiB of SDRAM
                                CG3_PIXELS_ADDR_BIGVAL: [
                                    NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                ],
                            }),
                            If(~self.wishbone_master.cyc,
                                NextValue(SBUS_3V3_ACKs_o, ACK_BYTE),
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                #NextValue(self.led_display.value, 0x0000000010 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                NextValue(sbus_slave_timeout, sbus_default_timeout),
                                NextState("Slave_Ack_Reg_Write_Byte")
                            ).Else(
                                NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                NextValue(sbus_slave_timeout, sbus_default_timeout),
                                NextState("Slave_Ack_Reg_Write_Byte_Wait_For_Wishbone")
                            )
                         ).Else(
                             #NextValue(self.led_display.value, 0x0000000060 | 0x0000000001),
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             #NextValue(led0123, led0123 | LED_ADDRESS),
                             *increment_stat_slave_early_error_counter,
                             #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                             NextState("Slave_Error")
                         )
                      # ***** Slave HalfWord Write *****
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0) &
                              (SIZ_HWORD == SBUS_3V3_SIZ_i) &
                              (SBUS_3V3_PPRD_i == 0)),
                             NextValue(sbus_oe_master_in, 1),
                             If(SBUS_3V3_PA_i[0:1] != 0,
                                NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                                NextValue(SBUS_3V3_ERRs_o, 1),
                                #NextValue(led0123, led0123 | LED_PARITY),
                                *increment_stat_slave_early_error_counter,
                                #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                                NextState("Slave_Error")
                             ).Elif(((SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == WISHBONE_CSR_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG6_FHC_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == CG3_BT_ADDR_PFX) |
                                     (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                    NextValue(sbus_wishbone_le,
                                              (SBUS_3V3_PA_i[ADDR_PFX_LOW:ADDR_PFX_LOW+ADDR_PFX_LENGTH] == SRAM_ADDR_PFX) |
                                              (SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH] == CG3_PIXELS_ADDR_BIGPFX)),
                                    *increment_stat_slave_start_counter,
                                    Case(SBUS_3V3_PA_i[ADDR_BIGPFX_LOW:ADDR_BIGPFX_LOW+ADDR_BIGPFX_LENGTH], {
                                        "default": [ NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                        ],
                                        # next remap 8 MiB to Y MiB of SDRAM
                                        CG3_PIXELS_ADDR_BIGVAL: [
                                            NextValue(sbus_last_pa, Cat(SBUS_3V3_PA_i[0:CG3_KEPT_UPPER_BIT], Signal(CG3_UPPER_BITS, reset = CG3_REMAPPED_BASE))),
                                        ],
                                    }),
                                    If(~self.wishbone_master.cyc,
                                       NextValue(SBUS_3V3_ACKs_o, ACK_HWORD),
                                       NextValue(SBUS_3V3_ERRs_o, 1),
                                       #NextValue(self.led_display.value, 0x0000000010 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                                       NextValue(sbus_slave_timeout, sbus_default_timeout),
                                       NextState("Slave_Ack_Reg_Write_HWord")
                                    ).Else(
                                        NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                                        NextValue(SBUS_3V3_ERRs_o, 1),
                                        NextValue(sbus_slave_timeout, sbus_default_timeout),
                                        NextState("Slave_Ack_Reg_Write_HWord_Wait_For_Wishbone")
                                    )
                             ).Else(
                                 #NextValue(self.led_display.value, 0x0000000060 | 0x0000000001),
                                 NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                                 NextValue(SBUS_3V3_ERRs_o, 1),
                                 #NextValue(led0123, led0123 | LED_ADDRESS),
                                 *increment_stat_slave_early_error_counter,
                                 #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                                 NextState("Slave_Error")
                             )
                      ).Elif(self.wishbone_slave.cyc &
                             self.wishbone_slave.stb &
                             ~self.wishbone_slave.ack &
                             ~self.wishbone_slave.err &
                             self.wishbone_slave.we &
                             (self.wishbone_slave.sel == 0) &
                             (wishbone_slave_timeout == 0),
                             ## sel == 0 so nothing to write, don't acquire the SBus
                             NextValue(self.wishbone_slave.ack, 1),
                      ).Elif(SBUS_3V3_BGs_i & ## highest priority are retries, otherwise we'd lose the data
                             master_src_retry &
                             (master_we == 0) &
                             (master_src == MASTER_SRC_BLKDMAFIFO) &
                             (sbus_master_throttle == 0),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i & ## highest priority are retries, otherwise we'd lose the data
                             master_src_retry &
                             (master_we == 0) &
                             (master_src == MASTER_SRC_BLKDMAFIFO),
                             NextValue(sbus_wishbone_le, 0), # checkme
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(SBUS_3V3_D_o, sbus_master_last_virtual),
                             NextValue(SBUS_3V3_PPRD_o, 1),
                             #*increment_stat_master_start_counter,
                             NextState("Master_Translation"),
                      ).Elif(SBUS_3V3_BGs_i &
                             self.wishbone_slave.cyc &
                             self.wishbone_slave.stb &
                             ~self.wishbone_slave.ack &
                             ~self.wishbone_slave.err &
                             self.wishbone_slave.we &
                             (sbus_master_throttle == 0) &
                             (wishbone_slave_timeout == 0),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i &
                             self.wishbone_slave.cyc &
                             self.wishbone_slave.stb &
                             ~self.wishbone_slave.ack &
                             ~self.wishbone_slave.err &
                             self.wishbone_slave.we,
                             NextValue(sbus_wishbone_le, 1), # checkme
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(burst_limit_m1, 0), ## only single word for now
                             NextValue(master_addr, self.wishbone_slave.adr),
                             NextValue(master_data, Cat(self.wishbone_slave.dat_w[24:32], ## LE
                                                        self.wishbone_slave.dat_w[16:24],
                                                        self.wishbone_slave.dat_w[ 8:16],
                                                        self.wishbone_slave.dat_w[ 0: 8])),
                             NextValue(master_src, MASTER_SRC_WISHBONE),
                             Case(self.wishbone_slave.sel, {
                                 0xf: [NextValue(burst_counter, 0),
                                       NextValue(burst_limit_m1, 0), ## only single word for now
                                       NextValue(master_size, SIZ_WORD),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_WORD),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                 ],
                                 0x1: [NextValue(master_idx, 3),
                                       NextValue(master_size, SIZ_BYTE),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_BYTE),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                 ],
                                 0x2: [NextValue(master_idx, 2),
                                       NextValue(master_size, SIZ_BYTE),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_BYTE),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 1), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 1), self.wishbone_slave.adr)),
                                 ],
                                 0x4: [NextValue(master_idx, 1),
                                       NextValue(master_size, SIZ_BYTE),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_BYTE),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 2), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 2), self.wishbone_slave.adr)),
                                 ],
                                 0x8: [NextValue(master_idx, 0),
                                       NextValue(master_size, SIZ_BYTE),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_BYTE),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 3), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 3), self.wishbone_slave.adr)),
                                 ],
                                 0x3: [NextValue(master_idx, 2),
                                       NextValue(master_size, SIZ_HWORD),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_HWORD),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 0), self.wishbone_slave.adr)),
                                 ],
                                 0xc: [NextValue(master_idx, 0),
                                       NextValue(master_size, SIZ_HWORD),
                                       NextValue(SBUS_3V3_SIZ_o, SIZ_HWORD),
                                       NextValue(SBUS_3V3_D_o, Cat(Signal(2, reset = 2), self.wishbone_slave.adr)),
                                       NextValue(sbus_master_last_virtual, Cat(Signal(2, reset = 2), self.wishbone_slave.adr)),
                                 ],
                                 "default":[NextValue(burst_counter, 0), # FIXME if it happens!
                                            NextValue(burst_limit_m1, 0), ## only single word for now
                                            NextValue(master_size, SIZ_WORD),
                                            NextValue(SBUS_3V3_SIZ_o, SIZ_WORD),
                                            #NextValue(led0123, self.wishbone_slave.sel)
                                 ]
                             }),
                             NextValue(self.wishbone_slave.ack, 1),
                             NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                             NextValue(SBUS_3V3_PPRD_o, 0),
                             NextValue(master_we, 1),
                             #NextValue(self.led_display.value, 0x0000000010 | Cat(Signal(8, reset = 0x00), self.wishbone_slave.adr)),
                             #NextValue(self.led_display.value, Cat(Signal(8, reset = LED_M_WRITE), Signal(2, reset = 0), self.wishbone_slave.adr)),
                             *increment_stat_master_start_counter,
                             NextState("Master_Translation")
                      ).Elif(SBUS_3V3_BGs_i &
                             self.master_read_buffer_start &
                             (sbus_master_throttle == 0) &
                             (wishbone_slave_timeout == 0),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i &
                             self.master_read_buffer_start,
                             NextValue(sbus_wishbone_le, 1), # checkme
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(burst_limit_m1, 3), ## only quadword word for now
                             NextValue(SBUS_3V3_D_o, Cat(Signal(4, reset = 0), self.master_read_buffer_addr)),
                             NextValue(sbus_master_last_virtual, Cat(Signal(4, reset = 0), self.master_read_buffer_addr)),
                             NextValue(master_src, MASTER_SRC_WISHBONEBUF),
                             NextValue(SBUS_3V3_PPRD_o, 1),
                             NextValue(SBUS_3V3_SIZ_o, SIZ_BURST4),
                             NextValue(master_we, 0),
                             #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0x00), self.wishbone_slave.adr)),
                             #NextValue(self.led_display.value, Cat(Signal(8, reset = LED_M_READ), Signal(2, reset = 0), self.master_read_buffer_addr)), 
                             *increment_stat_master_start_counter,
                             NextState("Master_Translation")
                      ).Elif(SBUS_3V3_BGs_i &
                             self.tosbus_fifo.readable &
                             (sbus_master_throttle == 0),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i &
                             self.tosbus_fifo.readable,
                             NextValue(sbus_wishbone_le, 0), # checkme
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(burst_limit_m1, burst_size - 1),
                             NextValue(SBUS_3V3_D_o, tosbus_fifo_dout.address),
                             NextValue(sbus_master_last_virtual, tosbus_fifo_dout.address),
                             NextValue(master_addr, tosbus_fifo_dout.address[2:32]),
                             NextValue(master_data, tosbus_fifo_dout.data[0:32]),
                             NextValue(fifo_buffer, tosbus_fifo_dout.data),
                             NextValue(master_src, MASTER_SRC_BLKDMAFIFO),
                             self.tosbus_fifo.re.eq(1),
                             Case(burst_size, {
                                 2 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST2),
                                      NextValue(master_size, SIZ_BURST2)],
                                 4 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST4),
                                      NextValue(master_size, SIZ_BURST4)],
                                 8 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST8),
                                      NextValue(master_size, SIZ_BURST8)],
                                 16 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST16),
                                       NextValue(master_size, SIZ_BURST16)],
                             }),
                             NextValue(SBUS_3V3_PPRD_o, 0),
                             NextValue(master_we, 1),
                             *increment_stat_master_start_counter,
                             NextState("Master_Translation")
                      ).Elif(SBUS_3V3_BGs_i &
                             self.fromsbus_req_fifo.readable &
                             self.fromsbus_fifo.writable &
                             (sbus_master_throttle == 0),
                             NextValue(SBUS_3V3_BRs_o, 0)
                      ).Elif(~SBUS_3V3_BGs_i &
                             self.fromsbus_req_fifo.readable &
                             self.fromsbus_fifo.writable,
                             NextValue(sbus_wishbone_le, 0), # checkme
                             NextValue(SBUS_3V3_BRs_o, 1), # relinquish the request
                             NextValue(sbus_oe_data, 1), ## output data (at least for @ during translation)
                             NextValue(sbus_oe_slave_in, 1), ## PPRD, SIZ becomes output
                             NextValue(sbus_oe_master_in, 0), ## ERRs, ACKs are input
                             NextValue(burst_counter, 0),
                             NextValue(burst_limit_m1, burst_size - 1),
                             NextValue(SBUS_3V3_D_o, fromsbus_req_fifo_dout.dmaaddress),
                             NextValue(sbus_master_last_virtual, fromsbus_req_fifo_dout.dmaaddress),
                             NextValue(fifo_blk_addr, fromsbus_req_fifo_dout.blkaddress),
                             NextValue(master_src, MASTER_SRC_BLKDMAFIFO),
                             self.fromsbus_req_fifo.re.eq(1),
                             Case(burst_size, {
                                 2 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST2),
                                      NextValue(master_size, SIZ_BURST2)],
                                 4 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST4),
                                      NextValue(master_size, SIZ_BURST4)],
                                 8 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST8),
                                      NextValue(master_size, SIZ_BURST8)],
                                 16 : [NextValue(SBUS_3V3_SIZ_o, SIZ_BURST16),
                                       NextValue(master_size, SIZ_BURST16)],
                             }),
                             NextValue(SBUS_3V3_PPRD_o, 1),
                             NextValue(master_we, 0),
                             *increment_stat_master_start_counter,
                             NextState("Master_Translation")
                      ).Elif(((SBUS_3V3_SELs_i == 0) &
                              (SBUS_3V3_ASs_i == 0)),
                             NextValue(sbus_oe_master_in, 1),
                             NextValue(SBUS_3V3_ACKs_o, ACK_ERR),
                             NextValue(SBUS_3V3_ERRs_o, 1),
                             #NextValue(self.led_display.value, 0x000000000F | Cat(Signal(8, reset = 0x00), SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, SBUS_3V3_PPRD_i)),
                             #NextValue(led0123, led0123 | LED_UNKNOWNREQ),
                             *increment_stat_slave_early_error_counter,
                             #NextValue(sbus_master_error_virtual, Cat(SBUS_3V3_PA_i, SBUS_3V3_SIZ_i, Signal(1, reset=0))),
                             NextState("Slave_Error")
                      ).Elif(~SBUS_3V3_BGs_i,
                             ### ouch we got the bus but nothing more to do ?!?
                             NextValue(SBUS_3V3_BRs_o, 1),
                      ).Else(
                          # FIXME: handle error
                      )
        )
        # ##### SLAVE READ #####
        # ## BURST (1->16 words) ##
        slave_fsm.act("Slave_Do_Read",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x04), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      If(((SBUS_3V3_ASs_i == 1) | ((SBUS_3V3_ASs_i == 0) & (SBUS_3V3_SELs_i == 1))),
                         *increment_stat_slave_done_counter,
                         NextState("Idle")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Burst",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x05), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Do_Read")
                      ).Else(
                          NextValue(burst_counter, burst_counter + 1),
                          NextValue(self.wishbone_master.cyc, 1),
                          NextValue(self.wishbone_master.stb, 1),
                          NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                          NextValue(self.wishbone_master.we, 0),
                          NextValue(wishbone_master_timeout, wishbone_default_timeout),
                          NextValue(self.wishbone_master.adr, Cat(index_with_wrap(burst_counter+1, burst_limit_m1, sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6]), # 4 bits, adr FIXME
                                                                  sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW], # 10 bits, adr
                                                                  sbus_last_pa[ADDR_PFX_LOW:32] # 16 bits, adr
                                                                  )),
                          NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                          NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Data")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Burst_Wait_For_Data",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x06), self.led_display.value[8:40])),
                      If(self.wishbone_master.ack,
                         Case(sbus_wishbone_le, {
                             0: NextValue(p_data,self.wishbone_master.dat_r),
                             1: NextValue(p_data, Cat(self.wishbone_master.dat_r[24:32],
                                                      self.wishbone_master.dat_r[16:24],
                                                      self.wishbone_master.dat_r[ 8:16],
                                                      self.wishbone_master.dat_r[ 0: 8]))
                         }),
                         NextValue(self.wishbone_master.cyc, 0),
                         NextValue(self.wishbone_master.stb, 0),
                         NextValue(wishbone_master_timeout, 0),
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                         NextState("Slave_Ack_Read_Reg_Burst")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(self.wishbone_master.cyc, 0), ## abort transaction
                             NextValue(self.wishbone_master.stb, 0),
                             NextValue(wishbone_master_timeout, 0),
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                             #NextValue(led0123, LED_RERUN | LED_RERUN_WORD | LED_RERUN_LATE),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000001),
                             NextState("Slave_Error")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Burst_Wait_For_Wishbone",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x68), self.led_display.value[8:40])),
                      If(self.wishbone_master.cyc == 0,
                         NextValue(self.wishbone_master.cyc, 1),
                         NextValue(self.wishbone_master.stb, 1),
                         NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                         NextValue(self.wishbone_master.we, 0),
                         NextValue(self.wishbone_master.adr, sbus_last_pa[2:32]),
                         NextValue(wishbone_master_timeout, wishbone_default_timeout),
                         NextValue(sbus_slave_timeout, sbus_default_timeout),
                         #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                         NextState("Slave_Ack_Read_Reg_Burst_Wait_For_Data")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN | LED_RERUN_WORD),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000002),
                             NextState("Slave_Error")
                      )
        )
        # ## HWORD
        slave_fsm.act("Slave_Ack_Read_Reg_HWord",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x05), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                      NextState("Slave_Do_Read")
        )
        slave_fsm.act("Slave_Ack_Read_Reg_HWord_Wait_For_Data",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x06), self.led_display.value[8:40])),
                      If(self.wishbone_master.ack,
                         Case(sbus_wishbone_le, {
                             0: Case(sbus_last_pa[ADDR_PHYS_LOW+1:ADDR_PHYS_LOW+2], {
                                 0: NextValue(p_data, Cat(Signal(16, reset = 0),
                                                          self.wishbone_master.dat_r[16:32])),
                                 1: NextValue(p_data, Cat(Signal(16, reset = 0),
                                                          self.wishbone_master.dat_r[ 0:16])),
                             }),
                             1: Case(sbus_last_pa[ADDR_PHYS_LOW+1:ADDR_PHYS_LOW+2], {
                                 1: NextValue(p_data, Cat(Signal(16, reset = 0),
                                                          self.wishbone_master.dat_r[24:32],
                                                          self.wishbone_master.dat_r[16:24])),
                                 0: NextValue(p_data, Cat(Signal(16, reset = 0),
                                                          self.wishbone_master.dat_r[ 8:16],
                                                          self.wishbone_master.dat_r[ 0: 8])),
                             })
                         }),
                         NextValue(self.wishbone_master.cyc, 0),
                         NextValue(self.wishbone_master.stb, 0),
                         NextValue(wishbone_master_timeout, 0),
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_HWORD),
                         NextState("Slave_Ack_Read_Reg_HWord")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(self.wishbone_master.cyc, 0), ## abort transaction
                             NextValue(self.wishbone_master.stb, 0),
                             NextValue(wishbone_master_timeout, 0),
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN | LED_RERUN_LATE),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000003),
                             NextState("Slave_Error")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_HWord_Wait_For_Wishbone",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x68), self.led_display.value[8:40])),
                      If(self.wishbone_master.cyc == 0,
                         NextValue(self.wishbone_master.cyc, 1),
                         NextValue(self.wishbone_master.stb, 1),
                         NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                         NextValue(self.wishbone_master.we, 0),
                         NextValue(self.wishbone_master.adr, sbus_last_pa[2:32]),
                         NextValue(wishbone_master_timeout, wishbone_default_timeout),
                         NextValue(sbus_slave_timeout, sbus_default_timeout),
                         #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                         NextState("Slave_Ack_Read_Reg_HWord_Wait_For_Data")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000004),
                             NextState("Slave_Error")
                      )
        )
        # ## BYTE
        slave_fsm.act("Slave_Ack_Read_Reg_Byte",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x05), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 1),
                      NextValue(SBUS_3V3_D_o, p_data),
                      NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                      NextState("Slave_Do_Read")
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Byte_Wait_For_Data",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x06), self.led_display.value[8:40])),
                      If(self.wishbone_master.ack,
                         Case(sbus_wishbone_le, {
                             0: Case(sbus_last_pa[ADDR_PHYS_LOW:ADDR_PHYS_LOW+2], {
                                 0: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[24:32])),
                                 1: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[16:24])),
                                 2: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[ 8:16])),
                                 3: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[ 0: 8])),
                             }),
                             1: Case(sbus_last_pa[ADDR_PHYS_LOW:ADDR_PHYS_LOW+2], {
                                 3: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[24:32])),
                                 2: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[16:24])),
                                 1: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[ 8:16])),
                                 0: NextValue(p_data, Cat(Signal(24, reset = 0), self.wishbone_master.dat_r[ 0: 8])),
                         })
                         }),
                         NextValue(self.wishbone_master.cyc, 0),
                         NextValue(self.wishbone_master.stb, 0),
                         NextValue(wishbone_master_timeout, 0),
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_BYTE),
                         NextState("Slave_Ack_Read_Reg_Byte")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(self.wishbone_master.cyc, 0), ## abort transaction
                             NextValue(self.wishbone_master.stb, 0),
                             NextValue(wishbone_master_timeout, 0),
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN | LED_RERUN_LATE),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000005),
                             NextState("Slave_Error")
                      )
        )
        slave_fsm.act("Slave_Ack_Read_Reg_Byte_Wait_For_Wishbone",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x68), self.led_display.value[8:40])),
                      If(self.wishbone_master.cyc == 0,
                         NextValue(self.wishbone_master.cyc, 1),
                         NextValue(self.wishbone_master.stb, 1),
                         NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                         NextValue(self.wishbone_master.we, 0),
                         NextValue(self.wishbone_master.adr, sbus_last_pa[2:32]),
                         NextValue(wishbone_master_timeout, wishbone_default_timeout),
                         NextValue(sbus_slave_timeout, sbus_default_timeout),
                         #NextValue(self.led_display.value, 0x0000000000 | Cat(Signal(8, reset = 0), SBUS_3V3_PA_i, Signal(4, reset = 0))),
                         NextState("Slave_Ack_Read_Reg_Byte_Wait_For_Data")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000006),
                             NextState("Slave_Error")
                      )
        )
        # ##### SLAVE WRITE #####
        # ## BURST (1->16 words) ##
        slave_fsm.act("Slave_Ack_Reg_Write_Burst",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x07), self.led_display.value[8:40])),
                      NextValue(self.wishbone_master.cyc, 1),
                      NextValue(self.wishbone_master.stb, 1),
                      NextValue(self.wishbone_master.sel, 2**len(self.wishbone_master.sel)-1),
                      NextValue(self.wishbone_master.adr, Cat(index_with_wrap(burst_counter, burst_limit_m1, sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6]), # 4 bits, adr FIXME
                                                              sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW], # 10 bits, adr
                                                              sbus_last_pa[ADDR_PFX_LOW:32] # 16 bits, adr
                                                              )),
                      Case(sbus_wishbone_le, {
                          0: NextValue(self.wishbone_master.dat_w, Cat(SBUS_3V3_D_i)),
                          1: NextValue(self.wishbone_master.dat_w, Cat(SBUS_3V3_D_i[24:32],
                                                                       SBUS_3V3_D_i[16:24],
                                                                       SBUS_3V3_D_i[ 8:16],
                                                                       SBUS_3V3_D_i[ 0: 8]))
                      }),
                      NextValue(self.wishbone_master.we, 1),
                      NextValue(wishbone_master_timeout, wishbone_default_timeout),
                      If((burst_counter == burst_limit_m1),
                         NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                         NextState("Slave_Ack_Reg_Write_Final")
                      ).Else(
                          NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                          NextValue(burst_counter, burst_counter + 1),
                          NextState("Slave_Ack_Reg_Write_Burst_Wait_For_Wishbone"),
                      )
        )
        slave_fsm.act("Slave_Ack_Reg_Write_Final",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x08), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      If(((SBUS_3V3_ASs_i == 1) | ((SBUS_3V3_ASs_i == 0) & (SBUS_3V3_SELs_i == 1))),
                         *increment_stat_slave_done_counter,
                         NextState("Idle")
                      )
        )
        slave_fsm.act("Slave_Ack_Reg_Write_Burst_Wait_For_Wishbone",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x68), self.led_display.value[8:40])),
                      If(self.wishbone_master.cyc == 0,
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_WORD),
                         NextState("Slave_Ack_Reg_Write_Burst")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN),
                             #NextValue(self.led_display.value, Cat(Signal(8, reset = LED_RERUN | LED_RERUN_WRITE | LED_RERUN_WORD), sbus_last_pa)),
                             #NextValue(led0123, LED_RERUN | LED_RERUN_WRITE | LED_RERUN_WORD),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000007),
                             NextState("Slave_Error")
                      )
        )
        # ## HWORD
        slave_fsm.act("Slave_Ack_Reg_Write_HWord",
                      NextValue(self.wishbone_master.cyc, 1),
                      NextValue(self.wishbone_master.stb, 1),
                      Case(sbus_wishbone_le, {
                          0: Case(sbus_last_pa[ADDR_PHYS_LOW+1:ADDR_PHYS_LOW+2], {
                              0: NextValue(self.wishbone_master.sel, 0xc),
                              1: NextValue(self.wishbone_master.sel, 0x3),
                          }),
                          1: Case(sbus_last_pa[ADDR_PHYS_LOW+1:ADDR_PHYS_LOW+2], {
                              1: NextValue(self.wishbone_master.sel, 0xc),
                              0: NextValue(self.wishbone_master.sel, 0x3),
                          }),
                      }),
                      NextValue(self.wishbone_master.adr, Cat(sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6], # 4 bits, adr FIXME
                                                              sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW], # 10 bits, adr
                                                              sbus_last_pa[ADDR_PFX_LOW:32] # 16 bits, adr
                                                              )),
                      Case(sbus_wishbone_le, {
                          0: NextValue(self.wishbone_master.dat_w, Cat(SBUS_3V3_D_i[16:32],
                                                                       SBUS_3V3_D_i[16:32])),
                          1: NextValue(self.wishbone_master.dat_w, Cat(SBUS_3V3_D_i[24:32],
                                                                       SBUS_3V3_D_i[16:24],
                                                                       SBUS_3V3_D_i[24:32],
                                                                       SBUS_3V3_D_i[16:24])),
                      }),
                      NextValue(self.wishbone_master.we, 1),
                      NextValue(wishbone_master_timeout, wishbone_default_timeout),
                      NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                      NextState("Slave_Ack_Reg_Write_Final")
        )
        slave_fsm.act("Slave_Ack_Reg_Write_HWord_Wait_For_Wishbone",
                      If(self.wishbone_master.cyc == 0,
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_HWORD),
                         NextState("Slave_Ack_Reg_Write_HWord")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN | LED_RERUN_WRITE),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000008),
                             NextState("Slave_Error")
                      )
        )
        # ## BYTE
        slave_fsm.act("Slave_Ack_Reg_Write_Byte",
                      NextValue(self.wishbone_master.cyc, 1),
                      NextValue(self.wishbone_master.stb, 1),
                      Case(sbus_wishbone_le, {
                          0: Case(sbus_last_pa[ADDR_PHYS_LOW:ADDR_PHYS_LOW+2], {
                              0: NextValue(self.wishbone_master.sel, 0x8),
                              1: NextValue(self.wishbone_master.sel, 0x4),
                              2: NextValue(self.wishbone_master.sel, 0x2),
                              3: NextValue(self.wishbone_master.sel, 0x1),
                          }),
                          1: Case(sbus_last_pa[ADDR_PHYS_LOW:ADDR_PHYS_LOW+2], {
                              3: NextValue(self.wishbone_master.sel, 0x8),
                              2: NextValue(self.wishbone_master.sel, 0x4),
                              1: NextValue(self.wishbone_master.sel, 0x2),
                              0: NextValue(self.wishbone_master.sel, 0x1),
                          }),
                      }),
                      NextValue(self.wishbone_master.adr, Cat(sbus_last_pa[ADDR_PHYS_LOW+2:ADDR_PHYS_LOW+6], # 4 bits, adr FIXME
                                                              sbus_last_pa[ADDR_PHYS_LOW+6:ADDR_PFX_LOW], # 10 bits, adr
                                                              sbus_last_pa[ADDR_PFX_LOW:32] # 16 bits, adr
                                                              )),
                      NextValue(self.wishbone_master.dat_w, Cat(SBUS_3V3_D_i[24:32], # LE/BE identical
                                                                SBUS_3V3_D_i[24:32],
                                                                SBUS_3V3_D_i[24:32],
                                                                SBUS_3V3_D_i[24:32])),
                      NextValue(self.wishbone_master.we, 1),
                      NextValue(wishbone_master_timeout, wishbone_default_timeout),
                      NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                      NextState("Slave_Ack_Reg_Write_Final")
        )
        slave_fsm.act("Slave_Ack_Reg_Write_Byte_Wait_For_Wishbone",
                      If(self.wishbone_master.cyc == 0,
                         NextValue(sbus_slave_timeout, 0),
                         NextValue(SBUS_3V3_ACKs_o, ACK_BYTE),
                         NextState("Slave_Ack_Reg_Write_Byte")
                      ).Elif(sbus_slave_timeout == 0, ### this is taking too long
                             NextValue(SBUS_3V3_ACKs_o, ACK_RERUN), 
                             #NextValue(led0123, LED_RERUN | LED_RERUN_WRITE),
                             *increment_stat_slave_rerun_counter,
                             #NextValue(stat_slave_rerun_last_pa, sbus_last_pa),
                             #NextValue(stat_slave_rerun_last_state, 0x00000009),
                             NextState("Slave_Error")
                      )
        )
        # ##### SLAVE ERROR #####
        slave_fsm.act("Slave_Error",
                      NextValue(SBUS_3V3_ACKs_o, ACK_IDLE),
                      #NextValue(self.led_display.value, 0x0000000080 | self.led_display.value),
                      If(((SBUS_3V3_ASs_i == 1) | ((SBUS_3V3_ASs_i == 0) & (SBUS_3V3_SELs_i == 1))),
                         NextValue(sbus_oe_data, 0),
                         NextValue(sbus_oe_slave_in, 0),
                         NextValue(sbus_oe_master_in, 0),
                         NextValue(sbus_slave_timeout, 0),
                         NextState("Idle")
                      )
        )
        # ##### MASTER #####
        slave_fsm.act("Master_Translation",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x09), self.led_display.value[8:40])),
                      If(master_we,
                         NextValue(sbus_oe_data, 1),
                         Case(master_size, {
                             SIZ_BURST2: NextValue(SBUS_3V3_D_o, master_data),
                             SIZ_BURST4: NextValue(SBUS_3V3_D_o, master_data),
                             SIZ_BURST8: NextValue(SBUS_3V3_D_o, master_data),
                             SIZ_BURST16: NextValue(SBUS_3V3_D_o, master_data),
                             SIZ_WORD: NextValue(SBUS_3V3_D_o, master_data),
                             SIZ_BYTE: Case(master_idx, {
                                 0: NextValue(SBUS_3V3_D_o, Cat(master_data[ 0: 8],
                                                                master_data[ 0: 8],
                                                                master_data[ 0: 8],
                                                                master_data[ 0: 8],)),
                                 1: NextValue(SBUS_3V3_D_o, Cat(master_data[ 8:16],
                                                                master_data[ 8:16],
                                                                master_data[ 8:16],
                                                                master_data[ 8:16],)),
                                 2: NextValue(SBUS_3V3_D_o, Cat(master_data[16:24],
                                                                master_data[16:24],
                                                                master_data[16:24],
                                                                master_data[16:24],)),
                                 3: NextValue(SBUS_3V3_D_o, Cat(master_data[24:32],
                                                                master_data[24:32],
                                                                master_data[24:32],
                                                                master_data[24:32],)),
                                 }),
                             SIZ_HWORD: Case(master_idx, {
                                 0: NextValue(SBUS_3V3_D_o, Cat(master_data[ 0:16],
                                                                master_data[ 0:16],)),
                                 2: NextValue(SBUS_3V3_D_o, Cat(master_data[16:32],
                                                                master_data[16:32],)),
                                 })
                             }),
                         Case(master_src, {
                             MASTER_SRC_BLKDMAFIFO:
                             [NextValue(master_data, fifo_buffer[32:64]), # 0:32 is on the bus already
                              ],
                         }),
                      ).Else(
                         NextValue(sbus_oe_data, 0)
                      ),
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_ERR: ## ouch
                          [Case(master_src, {
                               MASTER_SRC_WISHBONE:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                               MASTER_SRC_WISHBONEBUF:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                           }),
                           NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_error_counter,
                           *copy_sbus_master_last_virtual_to_error,
                           NextState("Idle")],
                          ACK_RERUN: ### dunno how to handle that yet,
                          [Case(master_src, {
                               MASTER_SRC_WISHBONE:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                               MASTER_SRC_WISHBONEBUF:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                           }),
                           NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_rerun_counter,
                           NextState("Idle")],
                          ACK_IDLE:
                          [If(master_we,
                              NextState("Master_Write"),
                              ## FIXME: in burst mode, should update master_data with the next value
                              ## FIXME: we don't do burst mode yet
                              ## FIXME: actually now from FIFO is handled above
                          ).Else(
                              NextState("Master_Read")
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
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x0a), self.led_display.value[8:40])),
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_WORD:
                          [NextState("Master_Read_Ack")
                          ],
                          ACK_IDLE:
                          [NextState("Master_Read") ## redundant
                          ],
                          ACK_RERUN: ### burst not handled
                          [Case(master_src, {
                              MASTER_SRC_WISHBONE:
                              [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                               NextValue(self.wishbone_slave.err, 1),
                              ],
                              MASTER_SRC_WISHBONEBUF:
                              [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                               NextValue(self.wishbone_slave.err, 1),
                              ],
                              MASTER_SRC_BLKDMAFIFO:
                              [NextValue(master_src_retry, 1),
                              ],
                          }),
                           NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_rerun_counter,
                           NextState("Idle")
                          ],
                          ACK_ERR: ## ### burst not handled
                          [Case(master_src, {
                              MASTER_SRC_WISHBONE:
                              [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                               NextValue(self.wishbone_slave.err, 1),
                              ],
                              MASTER_SRC_WISHBONEBUF:
                              [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                               NextValue(self.wishbone_slave.err, 1),
                              ],
                              MASTER_SRC_BLKDMAFIFO:
                              [NextValue(master_src_retry, ~master_src_retry), # only retry if this wasn't a retry
                              ],
                           }),
                           NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_error_counter,
                           *copy_sbus_master_last_virtual_to_error,
                           NextState("Idle")
                          ],
                          "default": ## other ### burst not handled
                          [Case(master_src, {
                               MASTER_SRC_WISHBONE:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                               MASTER_SRC_WISHBONEBUF:
                               [NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                NextValue(self.wishbone_slave.err, 1),
                               ],
                           }),
                           NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_error_counter,
                           NextState("Idle")
                          ],
                      })
        )
        slave_fsm.act("Master_Read_Ack",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x0b), self.led_display.value[8:40])),
                      Case(master_src, {
                          MASTER_SRC_BLKDMAFIFO:
                          [Case(burst_counter, { ## FIXME !!!! burst_size
                              0: NextValue(fifo_buffer[0:32], SBUS_3V3_D_i),
                              1: NextValue(fifo_buffer[32:64], SBUS_3V3_D_i),
                              2: NextValue(fifo_buffer[64:96], SBUS_3V3_D_i),
                              3: NextValue(fifo_buffer[96:128], SBUS_3V3_D_i),
                              4: NextValue(fifo_buffer[128:160], SBUS_3V3_D_i),
                              5: NextValue(fifo_buffer[160:192], SBUS_3V3_D_i),
                              6: NextValue(fifo_buffer[192:224], SBUS_3V3_D_i),
                              7: NextValue(fifo_buffer[224:256], SBUS_3V3_D_i),
#                             8: NextValue(fifo_buffer[256:288], SBUS_3V3_D_i),
#                             9: NextValue(fifo_buffer[288:320], SBUS_3V3_D_i),
#                             10: NextValue(fifo_buffer[320:352], SBUS_3V3_D_i),
#                             11: NextValue(fifo_buffer[352:384], SBUS_3V3_D_i),
#                             12: NextValue(fifo_buffer[384:416], SBUS_3V3_D_i),
#                             13: NextValue(fifo_buffer[416:448], SBUS_3V3_D_i),
#                             14: NextValue(fifo_buffer[448:480], SBUS_3V3_D_i),
#                             15: NextValue(fifo_buffer[480:512], SBUS_3V3_D_i),
                          }),
                          ],
                          MASTER_SRC_WISHBONEBUF:
                          [NextValue(self.master_read_buffer_data[burst_counter[0:2]], SBUS_3V3_D_i),
                           NextValue(self.master_read_buffer_done[burst_counter[0:2]], 1),
                          ],
                      }),
                      NextValue(burst_counter, burst_counter + 1),
                      If(burst_counter == burst_limit_m1,
                         Case(master_src, {
                             MASTER_SRC_WISHBONEBUF:
                             [NextValue(self.master_read_buffer_start, 0),
                             ],
                         }),
                         NextState("Master_Read_Finish")
                      ).Else(
                          Case(SBUS_3V3_ACKs_i, {
                              ACK_WORD: NextState("Master_Read_Ack"), ## redundant
                              ACK_IDLE: NextState("Master_Read"),
                              ACK_RERUN: ### dunno how to handle that yet
                              [NextValue(sbus_oe_data, 0),
                               NextValue(sbus_oe_slave_in, 0),
                               NextValue(sbus_oe_master_in, 0),
                               *increment_stat_master_rerun_counter,
                               NextState("Idle")
                              ],
                              ACK_ERR:
                              [NextValue(sbus_oe_data, 0),
                               NextValue(sbus_oe_slave_in, 0),
                               NextValue(sbus_oe_master_in, 0),
                               *increment_stat_master_error_counter,
                               *copy_sbus_master_last_virtual_to_error,
                               NextState("Idle")
                              ],
                              "default":
                              [NextValue(sbus_oe_data, 0),
                               NextValue(sbus_oe_slave_in, 0),
                               NextValue(sbus_oe_master_in, 0),
                               *increment_stat_master_error_counter,
                               NextState("Idle")
                              ],
                          }),
                      )
        )
        slave_fsm.act("Master_Read_Finish", ## missing the handling of late error
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x0c), self.led_display.value[8:40])),
                      Case(master_src, {
                          MASTER_SRC_BLKDMAFIFO:
                          [fromsbus_fifo.we.eq(1),
                           fromsbus_fifo_din.blkaddress.eq(fifo_blk_addr),
                           fromsbus_fifo_din.data.eq(fifo_buffer),
                          ],
                      }),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_master_throttle, sbus_default_master_throttle),
                      *increment_stat_master_done_counter,
                      NextValue(master_src_retry, 0),
                      NextState("Idle")
        )
        slave_fsm.act("Master_Write",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x0d), self.led_display.value[8:40])),
                      Case(SBUS_3V3_ACKs_i, {
                          ACK_WORD: # FIXME: check againt master_size ?
                          [If(burst_counter == burst_limit_m1,
                              NextState("Master_Write_Final"),
                          ).Else(
                              NextValue(SBUS_3V3_D_o, master_data),
                              NextValue(burst_counter, burst_counter + 1),
                              Case(master_src, {
                                  MASTER_SRC_BLKDMAFIFO:
                                  [Case(burst_counter, { #0:32 just ack'd, 32:64 is on the bus now, burst_counter will only increment for the next cycle, so we're two steps ahead
                                       ## FIXME !!!! burst_size
                                      0: NextValue(master_data, fifo_buffer[64:96]),
                                      1: NextValue(master_data, fifo_buffer[96:128]),
                                      2: NextValue(master_data, fifo_buffer[128:160]),
                                      3: NextValue(master_data, fifo_buffer[160:192]),
                                      4: NextValue(master_data, fifo_buffer[192:224]),
                                      5: NextValue(master_data, fifo_buffer[224:256]),
#                                     6: NextValue(master_data, fifo_buffer[256:288]),
#                                     7: NextValue(master_data, fifo_buffer[288:320]),
#                                     8: NextValue(master_data, fifo_buffer[320:352]),
#                                     9: NextValue(master_data, fifo_buffer[352:384]),
#                                     10: NextValue(master_data, fifo_buffer[384:416]),
#                                     11: NextValue(master_data, fifo_buffer[416:448]),
#                                     12: NextValue(master_data, fifo_buffer[448:480]),
#                                     13: NextValue(master_data, fifo_buffer[480:512]),
                                     #14: NextValue(master_data, fifo_buffer[512:544]),
                                     #15: NextValue(master_data, fifo_buffer[544:576]),
                                     "default": NextValue(master_data, 0),
                                  })
                                  ],
                              }),
                          )],
                          ACK_BYTE: # FIXME: check againt master_size ?
                          [NextState("Master_Write_Final"),
                          ],
                          ACK_HWORD: # FIXME: check againt master_size ?
                          [NextState("Master_Write_Final"),
                          ],
                          ACK_IDLE:
                          [NextState("Master_Write") ## redundant
                          ],
                          ACK_RERUN: ### dunno how to handle that yet
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_rerun_counter,
                           NextState("Idle")
                          ],
                          ACK_ERR: ## ACK_ERRS or other
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_error_counter,
                           *copy_sbus_master_last_virtual_to_error,
                           NextState("Idle"),
                          ],
                          "default": ##  other
                          [NextValue(sbus_oe_data, 0),
                           NextValue(sbus_oe_slave_in, 0),
                           NextValue(sbus_oe_master_in, 0),
                           *increment_stat_master_error_counter,
                           NextState("Idle"),
                          ],
                      })
        )
        slave_fsm.act("Master_Write_Final",
                      #NextValue(self.led_display.value, Cat(Signal(8, reset = 0x0e), self.led_display.value[8:40])),
                      NextValue(sbus_oe_data, 0),
                      NextValue(sbus_oe_slave_in, 0),
                      NextValue(sbus_oe_master_in, 0),
                      NextValue(sbus_master_throttle, sbus_default_master_throttle),
                      *increment_stat_master_done_counter,
                      NextValue(master_src_retry, 0),
                      NextState("Idle")
        )
        # ##### FINISHED #####


        # ##### FSMs to finish wishbone transactions asynchronously
        
        self.submodules.wishbone_master_wait_fsm = wishbone_master_wait_fsm = FSM(reset_state="Reset")
        wishbone_master_wait_fsm.act("Reset",
                                     NextState("Idle")
        )
        wishbone_master_wait_fsm.act("Idle",
                        If(wishbone_master_timeout != 0,
                            NextValue(wishbone_master_timeout, wishbone_master_timeout -1)
                        ),
                        If(self.wishbone_master.cyc & self.wishbone_master.stb & self.wishbone_master.we,
                           If(self.wishbone_master.ack,# | (wishbone_master_timeout == 0),
                              #If(~self.wishbone_master.ack,
                              #    NextValue(led7, 1)
                              #),
                              NextValue(self.wishbone_master.cyc, 0),
                              NextValue(self.wishbone_master.stb, 0),
                              NextValue(self.wishbone_master.we, 0),
                              NextValue(wishbone_master_timeout, 0)
                           )
                        )
        )

        
        self.submodules.wishbone_slave_wait_fsm = wishbone_slave_wait_fsm = FSM(reset_state="Reset")
        wishbone_slave_wait_fsm.act("Reset",
                                    NextState("Idle")
        )
        wishbone_slave_wait_fsm.act("Idle",
                        If(wishbone_slave_timeout != 0,
                            NextValue(wishbone_slave_timeout, wishbone_slave_timeout -1)
                        ),
                        If(self.wishbone_slave.ack & self.wishbone_slave.we,
                           #If((~self.wishbone_slave.stb), # | (wishbone_slave_timeout == 0), #~self.wishbone_slave.cyc & 
                              NextValue(self.wishbone_slave.ack, 0),
                              NextValue(wishbone_slave_timeout, 0)
                           #)
                        ),
                        If(self.wishbone_slave.ack & ~self.wishbone_slave.we,
                           #If((~self.wishbone_slave.stb), # | (wishbone_slave_timeout == 0), #~self.wishbone_slave.cyc & 
                              NextValue(self.wishbone_slave.ack, 0),
                              NextValue(wishbone_slave_timeout, 0)
                           #)
                        ),
                        If(self.wishbone_slave.err,
                           #If((~self.wishbone_slave.stb), # | (wishbone_slave_timeout == 0), #~self.wishbone_slave.cyc & 
                              NextValue(self.wishbone_slave.err, 0),
                              NextValue(wishbone_slave_timeout, 0)
                           #)
                        )
        )

        #self.submodules.sbus_slave_wait_fsm = sbus_slave_wait_fsm = FSM(reset_state="Reset")
        #sbus_slave_wait_fsm.act("Reset",
        #                NextState("Idle")
        #)
        #sbus_slave_wait_fsm.act("Idle",
        #                If(sbus_slave_timeout != 0,
        #                    NextValue(sbus_slave_timeout, sbus_slave_timeout -1)
        #                ),
        #)

        # ##### FIXME: debug only?
        #self.submodules.sbus_master_throttle_fsm = sbus_master_throttle_fsm = FSM(reset_state="Reset")
        #sbus_master_throttle_fsm.act("Reset",
        #                NextState("Idle")
        #)
        #sbus_master_throttle_fsm.act("Idle",
        #                If(sbus_master_throttle != 0,
        #                    NextValue(sbus_master_throttle, sbus_master_throttle -1)
        #                ),
        #)

        # ##### Slave read buffering FSM ####
        last_read_word_idx = Signal(2)
        self.submodules.wishbone_slave_read_buffering_fsm = wishbone_slave_read_buffering_fsm = FSM(reset_state="Reset")
        #self.sync += platform.request("user_led", 0).eq(~wishbone_slave_read_buffering_fsm.ongoing("Idle"))
        #self.sync += platform.request("user_led", 1).eq(self.master_read_buffer_done[last_read_word_idx])
        wishbone_slave_read_buffering_fsm.act("Reset",
                                              NextState("Idle")
        )
        wishbone_slave_read_buffering_fsm.act("Idle",
                                         If(self.wishbone_slave.cyc &
                                            self.wishbone_slave.stb &
                                            ~self.wishbone_slave.ack &
                                            ~self.wishbone_slave.err &
                                            ~self.wishbone_slave.we &
                                            (wishbone_slave_timeout == 0),
                                            #led3.eq(1),
                                            If((self.master_read_buffer_addr == self.wishbone_slave.adr[2:30]) &
                                               (self.master_read_buffer_done[self.wishbone_slave.adr[0:2]]) &
                                               (~self.master_read_buffer_read[self.wishbone_slave.adr[0:2]]),
                                               ## use cache
                                               NextValue(self.wishbone_slave.ack, 1),
                                               NextValue(self.wishbone_slave.dat_r, Cat(self.master_read_buffer_data[self.wishbone_slave.adr[0:2]][24:32], # LE
                                                                                        self.master_read_buffer_data[self.wishbone_slave.adr[0:2]][16:24],
                                                                                        self.master_read_buffer_data[self.wishbone_slave.adr[0:2]][ 8:16],
                                                                                        self.master_read_buffer_data[self.wishbone_slave.adr[0:2]][ 0: 8])),
#                                               NextValue(self.wishbone_slave.dat_r, self.master_read_buffer_data[self.wishbone_slave.adr[0:2]]),
                                               #NextValue(self.led_display.value, Cat(Signal(8, reset = LED_M_READ | LED_M_CACHE), Signal(2, reset = 0), self.wishbone_slave.adr)), 
                                               NextValue(self.master_read_buffer_read[self.wishbone_slave.adr[0:2]], 1),
                                               NextValue(wishbone_slave_timeout, wishbone_default_timeout)
                                            ).Elif(~self.master_read_buffer_start,
                                                   #led2.eq(1),
                                                   NextValue(self.master_read_buffer_addr, self.wishbone_slave.adr[2:30]),
                                                   NextValue(self.master_read_buffer_done[0], 0),
                                                   NextValue(self.master_read_buffer_done[1], 0),
                                                   NextValue(self.master_read_buffer_done[2], 0),
                                                   NextValue(self.master_read_buffer_done[3], 0),
                                                   NextValue(self.master_read_buffer_read[0], 0),
                                                   NextValue(self.master_read_buffer_read[1], 0),
                                                   NextValue(self.master_read_buffer_read[2], 0),
                                                   NextValue(self.master_read_buffer_read[3], 0),
                                                   NextValue(last_read_word_idx, self.wishbone_slave.adr[0:2]),
                                                   NextValue(self.master_read_buffer_start, 1),
                                                   NextState("WaitForData")
                                            ).Else(
                                                #led1.eq(self.master_read_buffer_start)
                                            )
                                         )
        )
        wishbone_slave_read_buffering_fsm.act("WaitForData",
                                         #led2.eq(1),
                                         If(self.master_read_buffer_done[last_read_word_idx],
                                            NextValue(self.wishbone_slave.ack, 1),
                                            NextValue(self.wishbone_slave.dat_r, Cat(self.master_read_buffer_data[last_read_word_idx][24:32], # LE
                                                                                     self.master_read_buffer_data[last_read_word_idx][16:24],
                                                                                     self.master_read_buffer_data[last_read_word_idx][ 8:16],
                                                                                     self.master_read_buffer_data[last_read_word_idx][ 0: 8])),
#                                            NextValue(self.wishbone_slave.dat_r, self.master_read_buffer_data[last_read_word_idx]),
                                            NextValue(self.master_read_buffer_read[last_read_word_idx], 1),
                                            NextValue(wishbone_slave_timeout, wishbone_default_timeout),
                                            NextState("Idle")
                                         ),
                                         If(self.wishbone_slave.err,
                                            NextState("Idle")
                                         )
        )
        
        
        #last_write_word_idx = Signal(2)
        #last_write_timeout = Signal(3)
        #self.submodules.wishbone_slave_write_buffering_fsm = wishbone_slave_write_buffering_fsm = FSM(reset_state="Reset")
        #wishbone_slave_write_buffering_fsm.act("Reset",
        #                                       NextState("Idle")
        #)
        #wishbone_slave_write_buffering_fsm.act("Idle",
        #                                       If(self.wishbone_slave.cyc &
        #                                          self.wishbone_slave.stb &
        #                                          ~self.wishbone_slave.ack &
        #                                          ~self.wishbone_slave.err &
        #                                          (self.wishbone_slave.sel == 0xf) & # Full Words Only
        #                                          self.wishbone_slave.we,
        #                                          NextValue(self.master_write_buffer_addr, self.wishbone_slave.adr[2:30]),
        #                                          NextValue(self.master_write_buffer_data[self.wishbone_slave.adr[0:2]],
        #                                                    Cat(self.wishbone_slave.dat_w[24:32], # LE
        #                                                        self.wishbone_slave.dat_w[16:24],
        #                                                        self.wishbone_slave.dat_w[ 8:16],
        #                                                        self.wishbone_slave.dat_w[ 0: 8])),
        #                                          NextValue(self.master_write_buffer_todo[self.wishbone_slave.adr[0:2]], 1),
        #                                          NextValue(self.wishbone_slave.ack, 1),
        #                                          NextValue(last_write_word_idx, self.wishbone_slave.adr[0:2]),
        #                                          NextValue(wishbone_slave_timeout, wishbone_default_timeout),
        #                                          If(self.wishbone_slave.adr[0:2] == 0,
        #                                             NextValue(last_write_timeout, 5), # CHECKME: 5 is arbitrary
        #                                             NextState("WaitForMoreData"),
        #                                          ).Else(
        #                                              NextValue(self.master_write_buffer_start, 1),
        #                                              NextState("WaitForWrite"),
        #                                          )
        #                                       )
        #)
        #wishbone_slave_write_buffering_fsm.act("WaitForMoreData",
        #                                       If(last_write_timeout > 0,
        #                                          NextValue(last_write_timeout, last_write_timeout - 1),
        #                                       ),
        #                                       If(self.wishbone_slave.cyc &
        #                                          self.wishbone_slave.stb &
        #                                          ~self.wishbone_slave.ack &
        #                                          ~self.wishbone_slave.err &
        #                                          self.wishbone_slave.we,
        #                                          If(((self.wishbone_slave.adr[2:30] != self.master_write_buffer_addr) |
        #                                              (self.wishbone_slave.sel != 0xf)),
        #                                             NextValue(self.master_write_buffer_start, 1),
        #                                             NextState("WaitForWrite"),
        #                                          ).Else(
        #                                              NextValue(self.master_write_buffer_data[self.wishbone_slave.adr[0:2]],
        #                                                        Cat(self.wishbone_slave.dat_w[24:32], # LE
        #                                                            self.wishbone_slave.dat_w[16:24],
        #                                                            self.wishbone_slave.dat_w[ 8:16],
        #                                                            self.wishbone_slave.dat_w[ 0: 8])),
        #                                              NextValue(self.master_write_buffer_todo[self.wishbone_slave.adr[0:2]], 1),
        #                                              NextValue(self.wishbone_slave.ack, 1),
        #                                              NextValue(last_write_word_idx, self.wishbone_slave.adr[0:2]),
        #                                              NextValue(wishbone_slave_timeout, wishbone_default_timeout),
        #                                              NextValue(last_write_timeout, 5), # CHECKME: 5 is arbitrary
        #                                          )
        #                                       ).Elif(self.master_write_buffer_todo[0] &
        #                                              self.master_write_buffer_todo[1] &
        #                                              self.master_write_buffer_todo[2] &
        #                                              self.master_write_buffer_todo[3],
        #                                              NextValue(self.master_write_buffer_start, 1),
        #                                              NextState("WaitForWrite"),
        #                                       ).Elif(last_write_timeout == 0,
        #                                              NextValue(self.master_write_buffer_start, 1),
        #                                              NextState("WaitForWrite"),
        #                                       )
        #)
        #wishbone_slave_write_buffering_fsm.act("WaitForWrite",
        #                                       If(self.master_write_buffer_start == 0,
        #                                          NextState("Idle"),
        #                                       )
        #)

        if (stat):
            self.stat_cycle_counter = Signal(32)
            self.buf_stat_cycle_counter = Signal(32)
            self.buf_stat_slave_start_counter = Signal(32)
            self.buf_stat_slave_done_counter = Signal(32)
            self.buf_stat_slave_rerun_counter = Signal(32)
            self.buf_stat_slave_early_error_counter = Signal(32)
            self.buf_stat_master_start_counter = Signal(32)
            self.buf_stat_master_done_counter = Signal(32)
            self.buf_stat_master_error_counter = Signal(32)
            self.buf_stat_master_rerun_counter = Signal(32)
            self.buf_sbus_master_error_virtual = Signal(32)
            self.stat_update = Signal()
            stat_update_prev = Signal()
            
            self.sync += stat_update_prev.eq(self.stat_update)
            
            self.sync += self.stat_cycle_counter.eq(self.stat_cycle_counter + 1)
            self.sync += If(~stat_update_prev & self.stat_update, ## raising edge: copy to buffer and reset active
                            self.buf_stat_cycle_counter.eq(self.stat_cycle_counter),
                            self.buf_stat_slave_start_counter.eq(stat_slave_start_counter),
                            self.buf_stat_slave_done_counter.eq(stat_slave_done_counter),
                            self.buf_stat_slave_rerun_counter.eq(stat_slave_rerun_counter),
                            self.buf_stat_slave_early_error_counter.eq(stat_slave_early_error_counter),
                            self.buf_stat_master_start_counter.eq(stat_master_start_counter),
                            self.buf_stat_master_done_counter.eq(stat_master_done_counter),
                            self.buf_stat_master_error_counter.eq(stat_master_error_counter),
                            self.buf_stat_master_rerun_counter.eq(stat_master_rerun_counter),
                            self.buf_sbus_master_error_virtual.eq(sbus_master_error_virtual),
                            self.stat_cycle_counter.eq(0),
                            stat_slave_start_counter.eq(0),
                            stat_slave_done_counter.eq(0),
                            stat_slave_rerun_counter.eq(0),
                            stat_slave_early_error_counter.eq(0),
                            stat_master_start_counter.eq(0),
                            stat_master_done_counter.eq(0),
                            stat_master_error_counter.eq(0),
                            stat_master_rerun_counter.eq(0),
                            sbus_master_error_virtual.eq(0),
            )
            self.sync += If(stat_update_prev & ~self.stat_update, ## falling edge: reset buffer
                            self.buf_stat_cycle_counter.eq(0),
                            self.buf_stat_slave_start_counter.eq(0),
                            self.buf_stat_slave_done_counter.eq(0),
                            self.buf_stat_slave_rerun_counter.eq(0),
                            self.buf_stat_slave_early_error_counter.eq(0),
                            self.buf_stat_master_start_counter.eq(0),
                            self.buf_stat_master_done_counter.eq(0),
                            self.buf_stat_master_error_counter.eq(0),
                            self.buf_stat_master_rerun_counter.eq(0),
                            self.buf_sbus_master_error_virtual.eq(0),
            )
            
