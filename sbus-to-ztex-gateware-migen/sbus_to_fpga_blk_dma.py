from migen import *
from migen.genlib.fifo import *
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone

# width of towrite_fifo is '32'+'burst_size * 32' (vaddr + data)
# so the SBus DMA has all the needed info
# width of fromsbus_req_fifo is 'blk_addr_width' + 'vaddr' (blk_addr + vaddr)
# width of fromsbus_fifo is 'blk_addr_width' + 'burst_size * 32' (blk_addr + data)
# the blk_addr does the round-trip to accompany the data
class ExchangeWithMem(Module, AutoCSR):
    def __init__(self, soc, tosbus_fifo, fromsbus_fifo, fromsbus_req_fifo, burst_size = 8):
        self.wishbone_r_slave = wishbone.Interface(data_width=soc.bus.data_width)
        self.wishbone_w_slave = wishbone.Interface(data_width=soc.bus.data_width)
        self.tosbus_fifo = tosbus_fifo
        self.fromsbus_fifo = fromsbus_fifo
        self.fromsbus_req_fifo = fromsbus_req_fifo

        data_width = burst_size * 4
        data_width_bits = burst_size * 32
        blk_addr_width = 32 - log2_int(data_width) # 27 for burst_size == 8
        
        self.wishbone_r_master = wishbone.Interface(data_width=data_width_bits)
        self.wishbone_w_master = wishbone.Interface(data_width=data_width_bits)

        self.submodules += wishbone.Converter(self.wishbone_r_master, self.wishbone_r_slave)
        self.submodules += wishbone.Converter(self.wishbone_w_master, self.wishbone_w_slave)

        print("ExchangeWithMem: data_width = {}, data_width_bits = {}, blk_addr_width = {}\n".format(data_width, data_width_bits, blk_addr_width))
        print("ExchangeWithMem: tosbus_fifo width = {}, fromsbus_fifo width = {}, fromsbus_req_fifo width = {}\n".format(len(tosbus_fifo.din), len(fromsbus_fifo.dout), len(fromsbus_req_fifo.din)))
        
        local_r_addr = Signal(blk_addr_width)
        dma_r_addr = Signal(32)
        #local_r_widx = Signal(log2_int(burst_size)) # so width is 3 for burst_size == 8
        #local_r_buffer = Signal(data_width_bits)
        
        local_w_addr = Signal(blk_addr_width)
        dma_w_addr = Signal(32)
        #local_w_widx = Signal(log2_int(burst_size)) # so width is 3 for burst_size == 8
        #local_w_buffer = Signal(data_width_bits)

        max_block_bits=16

        # CSRConstant do not seem to appear in the CSR Map, but they need to be accessible to the OS driver
        #self.blk_size = CSRConstant(value=data_width) # report the block size to the SW layer
        #self.blk_base = CSRConstant(value=soc.wb_mem_map["main_ram"] >> log2_int(data_width)) # report where the blk starts
        self.blk_size = CSRStatus(32) # report the block size to the SW layer
        self.blk_base = CSRStatus(32) # report where the blk starts
        self.comb += self.blk_size.status.eq(data_width)
        self.comb += self.blk_base.status.eq(soc.wb_mem_map["main_ram"] >> log2_int(data_width))
        
        self.blk_addr = CSRStorage(32, description = "SDRAM Block address to read/write from Wishbone memory (block of size {})".format(data_width))
        self.dma_addr = CSRStorage(32, description = "Host Base address where to write/read data (i.e. SPARC Virtual addr)")
        self.blk_cnt =  CSRStorage(32, write_from_dev=True, description = "How many blk to read/write (max 2^{}-1); bit 31 is RD".format(max_block_bits), reset = 0)
        self.last_blk = CSRStatus(32, description = "Last Blk addr finished on WB side")
        self.last_dma = CSRStatus(32, description = "Last DMA addr finished on WB side")
        self.blk_rem = CSRStatus(32, description = "How many block remaining; bit 31 is RD", reset = 0)
        self.dma_status = CSRStatus(32, description = "Status register")
        self.wr_tosdram =  CSRStatus(32, description = "Last address written to SDRAM")

        self.submodules.req_r_fsm = req_r_fsm = FSM(reset_state="Reset")
        self.submodules.req_w_fsm = req_w_fsm = FSM(reset_state="Reset")

        self.comb += self.dma_status.status[0:1].eq(~req_r_fsm.ongoing("Idle")) # Read FSM Busy
        self.comb += self.dma_status.status[1:2].eq(~req_w_fsm.ongoing("Idle")) # Write FSM Busy
        self.comb += self.dma_status.status[2:3].eq(self.fromsbus_fifo.readable) # Some data available to write to memory

        self.comb += self.dma_status.status[8:9].eq(req_w_fsm.ongoing("ReqToMemory"))
        self.comb += self.dma_status.status[9:10].eq(req_w_fsm.ongoing("WaitForAck"))
        
        self.comb += self.dma_status.status[16:17].eq(self.wishbone_w_master.cyc) # show the WB iface status (W)
        self.comb += self.dma_status.status[17:18].eq(self.wishbone_w_master.stb)
        self.comb += self.dma_status.status[18:19].eq(self.wishbone_w_master.we)
        self.comb += self.dma_status.status[19:20].eq(self.wishbone_w_master.ack)
        self.comb += self.dma_status.status[20:21].eq(self.wishbone_w_master.err)
        
        self.comb += self.dma_status.status[24:25].eq(self.wishbone_r_master.cyc) # show the WB iface status (R)
        self.comb += self.dma_status.status[25:26].eq(self.wishbone_r_master.stb)
        self.comb += self.dma_status.status[26:27].eq(self.wishbone_r_master.we)
        self.comb += self.dma_status.status[27:28].eq(self.wishbone_r_master.ack)
        self.comb += self.dma_status.status[28:29].eq(self.wishbone_r_master.err)
        
        req_r_fsm.act("Reset",
                    NextState("Idle")
        )
        req_r_fsm.act("Idle",
                    If(((self.blk_cnt.storage[0:max_block_bits] != 0) & # checking self.blk_cnt.re might be too transient ? -> need to auto-reset
                        (~self.blk_cnt.storage[31:32])), # !read -> write
                       NextValue(local_r_addr, self.blk_addr.storage),
                       NextValue(dma_r_addr, self.dma_addr.storage),
                       NextValue(self.blk_rem.status, Cat(self.blk_cnt.storage[0:max_block_bits], Signal(32-max_block_bits, reset = 0))),
                       NextState("ReqFromMemory")
                    ).Elif(((self.blk_cnt.storage[0:max_block_bits] != 0) & # checking self.blk_cnt.re might be too transient ? -> need to auto-reset
                            (self.blk_cnt.storage[31:32])), # read
                           NextValue(local_r_addr, self.blk_addr.storage),
                           NextValue(dma_r_addr, self.dma_addr.storage),
                           NextValue(self.blk_rem.status, Cat(self.blk_cnt.storage[0:max_block_bits], Signal(32-max_block_bits, reset = 0))),
                           NextState("QueueReqToMemory")
                    )
        )
        req_r_fsm.act("ReqFromMemory",
                    If(~self.wishbone_r_master.ack,
                       NextValue(self.wishbone_r_master.cyc, 1),
                       NextValue(self.wishbone_r_master.stb, 1),
                       NextValue(self.wishbone_r_master.sel, 2**len(self.wishbone_r_master.sel)-1),
                       NextValue(self.wishbone_r_master.we, 0),
                       NextValue(self.wishbone_r_master.adr, local_r_addr),
                       NextState("WaitForData")
                    )
        )
        req_r_fsm.act("WaitForData",
                    If(self.wishbone_r_master.ack &
                       self.tosbus_fifo.writable,
                       NextValue(self.wishbone_r_master.cyc, 0),
                       NextValue(self.wishbone_r_master.stb, 0),
                       tosbus_fifo.we.eq(1),
                       tosbus_fifo.din.eq(Cat(dma_r_addr, self.wishbone_r_master.dat_r)),
                       NextValue(self.last_blk.status, local_r_addr),
                       NextValue(self.last_dma.status, dma_r_addr),
                       NextValue(self.blk_rem.status, self.blk_rem.status - 1),
                       If(self.blk_rem.status[0:max_block_bits] <= 1,
                          self.blk_cnt.we.eq(1), ## auto-reset
                          self.blk_cnt.dat_w.eq(0),
                          NextState("Idle"),
                       ).Else(
                           NextValue(local_r_addr, local_r_addr + 1),
                           NextValue(dma_r_addr, dma_r_addr + data_width),
                           NextState("ReqFromMemory"),
                       )
                    )
        )
        req_r_fsm.act("QueueReqToMemory",
                      If(self.fromsbus_req_fifo.writable,
                         self.fromsbus_req_fifo.we.eq(1),
                         self.fromsbus_req_fifo.din.eq(Cat(local_r_addr, dma_r_addr)),
                         NextValue(self.last_blk.status, local_r_addr),
                         NextValue(self.last_dma.status, dma_r_addr),
                         NextValue(self.blk_rem.status, self.blk_rem.status - 1),
                         If(self.blk_rem.status[0:max_block_bits] <= 1,
                            self.blk_cnt.we.eq(1), ## auto-reset
                            self.blk_cnt.dat_w.eq(0),
                            NextState("Idle"),
                         ).Else(
                             NextValue(local_r_addr, local_r_addr + 1),
                             NextValue(dma_r_addr, dma_r_addr + data_width),
                             NextValue(self.blk_rem.status, self.blk_rem.status - 1),
                             NextState("QueueReqToMemory"), #redundant
                         )
                      )
        )

        
        req_w_fsm.act("Reset",
                    NextState("Idle")
        )
        req_w_fsm.act("Idle",
                    If(self.fromsbus_fifo.readable &
                       ~self.wishbone_w_master.ack,
                       self.fromsbus_fifo.re.eq(1),
                       NextValue(self.wishbone_w_master.cyc, 1),
                       NextValue(self.wishbone_w_master.stb, 1),
                       NextValue(self.wishbone_w_master.sel, 2**len(self.wishbone_w_master.sel)-1),
                       NextValue(self.wishbone_w_master.we, 1),
                       NextValue(self.wishbone_w_master.adr, self.fromsbus_fifo.dout[0:blk_addr_width]),
                       NextValue(self.wishbone_w_master.dat_w, self.fromsbus_fifo.dout[blk_addr_width:(blk_addr_width + data_width_bits)]),
                       NextValue(self.wr_tosdram.status, self.fromsbus_fifo.dout[0:blk_addr_width]),
                       NextState("WaitForAck")
                    )
        )
        req_w_fsm.act("WaitForAck",
                    If(self.wishbone_w_master.ack,
                       NextValue(self.wishbone_w_master.cyc, 0),
                       NextValue(self.wishbone_w_master.stb, 0),
                       NextState("Idle"),
                    )
        )
