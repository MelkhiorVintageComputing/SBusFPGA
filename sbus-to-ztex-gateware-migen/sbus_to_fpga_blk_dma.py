from migen import *
from migen.genlib.fifo import *
from migen.genlib.cdc import BusSynchronizer
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone

# width of towrite_fifo is '32'+'burst_size * 32' (vaddr + data)
# so the SBus DMA has all the needed info
# width of fromsbus_req_fifo is 'blk_addr_width' + 'vaddr' (blk_addr + vaddr)
# width of fromsbus_fifo is 'blk_addr_width' + 'burst_size * 32' (blk_addr + data)
# the blk_addr does the round-trip to accompany the data
# mem_size in MiB, might be weird if some space is reserved for other use (e.g. FrameBuffer)
class ExchangeWithMem(Module, AutoCSR):
    def __init__(self, soc, tosbus_fifo, fromsbus_fifo, fromsbus_req_fifo, dram_dma_writer, dram_dma_reader, mem_size=256, burst_size = 8, do_checksum = False):
        #self.wishbone_r_slave = wishbone.Interface(data_width=soc.bus.data_width)
        #self.wishbone_w_slave = wishbone.Interface(data_width=soc.bus.data_width)
        self.tosbus_fifo = tosbus_fifo
        self.fromsbus_fifo = fromsbus_fifo
        self.fromsbus_req_fifo = fromsbus_req_fifo
        self.dram_dma_writer = dram_dma_writer
        self.dram_dma_reader = dram_dma_reader

        print(f"Configuring the SDRAM for {mem_size} MiB\n")

        data_width = burst_size * 4
        data_width_bits = burst_size * 32
        blk_addr_width = 32 - log2_int(data_width) # 27 for burst_size == 8

        assert(len(self.dram_dma_writer.sink.data) == data_width_bits)
        assert(len(self.dram_dma_reader.source.data) == data_width_bits)
        
        #self.wishbone_r_master = wishbone.Interface(data_width=data_width_bits)
        #self.wishbone_w_master = wishbone.Interface(data_width=data_width_bits)

        #self.submodules += wishbone.Converter(self.wishbone_r_master, self.wishbone_r_slave)
        #self.submodules += wishbone.Converter(self.wishbone_w_master, self.wishbone_w_slave)

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
        self.mem_size = CSRStatus(32) # report how much memory we have
        self.comb += self.blk_size.status.eq(data_width)
        self.comb += self.blk_base.status.eq(soc.wb_mem_map["main_ram"] >> log2_int(data_width))
        self.comb += self.mem_size.status.eq((mem_size * 1024 * 1024) >> log2_int(data_width))

        self.irqctrl = CSRStorage(write_from_dev=True, fields = [CSRField("irq_enable", 1, description = "Enable interrupt"),
                                                                 CSRField("irq_clear", 1, description = "Clear interrupt"),
                                                                 CSRField("reserved", 30, description = "Reserved"),
        ])
        self.blk_addr =   CSRStorage(32, description = "SDRAM Block address to read/write from Wishbone memory (block of size {})".format(data_width))
        self.dma_addr =   CSRStorage(32, description = "Host Base address where to write/read data (i.e. SPARC Virtual addr)")
        #self.blk_cnt =    CSRStorage(32, write_from_dev=True, description = "How many blk to read/write (max 2^{}-1); bit 31 is RD".format(max_block_bits), reset = 0)
        self.blk_cnt = CSRStorage(write_from_dev=True, fields = [CSRField("blk_cnt", max_block_bits, description = "How many blk to read/write (max 2^{}-1)".format(max_block_bits)),
                                                                 CSRField("rsvd", 32 - (max_block_bits + 1), description = "Reserved"),
                                                                 CSRField("rd_wr", 1, description = "Read/Write selector"),
        ])
        self.last_blk =   CSRStatus(32, description = "Last Blk addr finished on WB side")
        self.last_dma =   CSRStatus(32, description = "Last DMA addr finished on WB side")
        self.dma_wrdone = CSRStatus(32, description = "DMA Block written to SDRAM", reset = 0)
        self.blk_rem =    CSRStatus(32, description = "How many block remaining; bit 31 is RD", reset = 0)
        self.dma_status = CSRStatus(fields = [CSRField("rd_fsm_busy", 1, description = "Read FSM is doing some work"),
                                              CSRField("wr_fsm_busy", 1, description = "Write FSM is doing some work"),
                                              CSRField("has_wr_data", 1, description = "Data available to write to SDRAM"),
                                              CSRField("has_requests", 1, description = "There's outstanding requests to the SBus"),
                                              CSRField("has_rd_data", 1, description = "Data available to write to SBus"),
        ])
        self.wr_tosdram = CSRStatus(32, description = "Last address written to SDRAM")
        
        #if (do_checksum):
        self.checksum = CSRStorage(data_width_bits, write_from_dev=True, description = "checksum (XOR)");

        self.submodules.req_r_fsm = req_r_fsm = FSM(reset_state="Reset")
        self.submodules.req_w_fsm = req_w_fsm = FSM(reset_state="Reset")

        self.comb += self.dma_status.fields.rd_fsm_busy.eq(~req_r_fsm.ongoing("Idle")) # Read FSM Busy
        self.comb += self.dma_status.fields.wr_fsm_busy.eq(~req_w_fsm.ongoing("Idle")) # Write FSM Busy
        self.comb += self.dma_status.fields.has_wr_data.eq(self.fromsbus_fifo.readable) # Some data available to write to memory
        
        # The next two status bits reflect stats in the SBus clock domain
        self.submodules.fromsbus_req_fifo_readable_sync = BusSynchronizer(width = 1, idomain = "sbus", odomain = "sys")
        fromsbus_req_fifo_readable_in_sys = Signal()
        self.comb += self.fromsbus_req_fifo_readable_sync.i.eq(self.fromsbus_req_fifo.readable)
        self.comb += fromsbus_req_fifo_readable_in_sys.eq(self.fromsbus_req_fifo_readable_sync.o)

        # w/o this extra delay, the driver sees an outdated checksum for some reason...
        # there's probably a more fundamental issue :-(
        # note: replaced PulseSynchronizer with BusSynchronizer, should I retry w/o this ?
        fromsbus_req_fifo_readable_in_sys_cnt = Signal(5)
        self.sync += If(fromsbus_req_fifo_readable_in_sys,
                        fromsbus_req_fifo_readable_in_sys_cnt.eq(0x1F)
                     ).Else(
                         If(fromsbus_req_fifo_readable_in_sys_cnt > 0,
                            fromsbus_req_fifo_readable_in_sys_cnt.eq(fromsbus_req_fifo_readable_in_sys_cnt - 1)
                         )
                     )
        #self.comb += self.dma_status.fields.has_requests.eq(fromsbus_req_fifo_readable_in_sys) # we still have outstanding requests
        self.comb += self.dma_status.fields.has_requests.eq(fromsbus_req_fifo_readable_in_sys | (fromsbus_req_fifo_readable_in_sys_cnt != 0)) # we still have outstanding requests, or had recently
        
        self.submodules.tosbus_fifo_readable_sync = BusSynchronizer(width = 1, idomain = "sbus", odomain = "sys")
        tosbus_fifo_readable_in_sys = Signal()
        self.comb += self.tosbus_fifo_readable_sync.i.eq(self.tosbus_fifo.readable)
        self.comb += tosbus_fifo_readable_in_sys.eq(self.tosbus_fifo_readable_sync.o)
        self.comb += self.dma_status.fields.has_rd_data.eq(tosbus_fifo_readable_in_sys)  # there's still data to be sent to memory; this will drop before the last SBus Master Cycle is finished, but then the SBus is busy so the host won't be able to read the status before the cycle is finished so we're good

        ongoing_m1 = Signal()
        ongoing = Signal()
        self.irq = irq = Signal()

        self.sync += ongoing_m1.eq(ongoing)
        self.sync += ongoing.eq(self.dma_status.fields.rd_fsm_busy |
                                self.dma_status.fields.wr_fsm_busy |
                                self.dma_status.fields.has_wr_data |
                                self.dma_status.fields.has_requests |
                                self.dma_status.fields.has_rd_data |
                                (self.blk_cnt.storage[0:max_block_bits] != 0)
        )
        self.sync += irq.eq(((~ongoing & ongoing_m1) & self.irqctrl.fields.irq_enable) | # irq on falling edge of ongoing
                            (self.irq & ~self.irqctrl.fields.irq_clear & ~(ongoing & ~ongoing_m1))) # keep irq until cleared or rising edge of ongoing

        self.sync += If(self.irqctrl.fields.irq_clear,
                        self.irqctrl.we.eq(1),
                        self.irqctrl.dat_w.eq(self.irqctrl.storage & 0xFFFFFFFD)) ## auto-reset irq_clear
        
        #self.comb += self.dma_status.status[16:17].eq(self.wishbone_w_master.cyc) # show the WB iface status (W)
        #self.comb += self.dma_status.status[17:18].eq(self.wishbone_w_master.stb)
        #self.comb += self.dma_status.status[18:19].eq(self.wishbone_w_master.we)
        #self.comb += self.dma_status.status[19:20].eq(self.wishbone_w_master.ack)
        #self.comb += self.dma_status.status[20:21].eq(self.wishbone_w_master.err)
        
        #self.comb += self.dma_status.status[24:25].eq(self.wishbone_r_master.cyc) # show the WB iface status (R)
        #self.comb += self.dma_status.status[25:26].eq(self.wishbone_r_master.stb)
        #self.comb += self.dma_status.status[26:27].eq(self.wishbone_r_master.we)
        #self.comb += self.dma_status.status[27:28].eq(self.wishbone_r_master.ack)
        #self.comb += self.dma_status.status[28:29].eq(self.wishbone_r_master.err)
        
        req_r_fsm.act("Reset",
                    NextState("Idle")
        )
        req_r_fsm.act("Idle",
                    If(((self.blk_cnt.fields.blk_cnt != 0) & # checking self.blk_cnt.re might be too transient ? -> need to auto-reset
                        (~self.blk_cnt.fields.rd_wr)), # !read -> write
                       NextValue(local_r_addr, self.blk_addr.storage),
                       NextValue(dma_r_addr, self.dma_addr.storage),
                       NextValue(self.blk_rem.status, Cat(self.blk_cnt.fields.blk_cnt, Signal(32-max_block_bits, reset = 0))),
                       NextState("ReqFromMemory")
                    ).Elif(((self.blk_cnt.fields.blk_cnt != 0) & # checking self.blk_cnt.re might be too transient ? -> need to auto-reset
                            (self.blk_cnt.fields.rd_wr)), # read
                           NextValue(local_r_addr, self.blk_addr.storage),
                           NextValue(dma_r_addr, self.dma_addr.storage),
                           NextValue(self.blk_rem.status, Cat(self.blk_cnt.fields.blk_cnt, Signal(32-max_block_bits, reset = 0))),
                           NextState("QueueReqToMemory")
                    )
        )
        req_r_fsm.act("ReqFromMemory",
                      self.dram_dma_reader.sink.address.eq(local_r_addr),
                      self.dram_dma_reader.sink.valid.eq(1),
                      If(self.dram_dma_reader.sink.ready,
                         NextState("WaitForData")
                      )
        )
        req_r_fsm.act("WaitForData",
                      If(self.dram_dma_reader.source.valid & self.tosbus_fifo.writable,
                         self.tosbus_fifo.we.eq(1),
                         self.tosbus_fifo.din.eq(Cat(dma_r_addr, self.dram_dma_reader.source.data)),
                         If(do_checksum,
                            self.checksum.we.eq(1),
                            self.checksum.dat_w.eq(self.checksum.storage ^ self.dram_dma_reader.source.data),
                         ),
                         self.dram_dma_reader.source.ready.eq(1),
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

        
#        req_w_fsm.act("Reset",
#                    NextState("Idle")
#        )
#        req_w_fsm.act("Idle",
#                    If(self.fromsbus_fifo.readable &
#                       ~self.wishbone_w_master.ack,
#                       self.fromsbus_fifo.re.eq(1),
#                       NextValue(self.wishbone_w_master.cyc, 1),
#                       NextValue(self.wishbone_w_master.stb, 1),
#                       NextValue(self.wishbone_w_master.sel, 2**len(self.wishbone_w_master.sel)-1),
#                       NextValue(self.wishbone_w_master.we, 1),
#                       NextValue(self.wishbone_w_master.adr, self.fromsbus_fifo.dout[0:blk_addr_width]),
#                       NextValue(self.wishbone_w_master.dat_w, self.fromsbus_fifo.dout[blk_addr_width:(blk_addr_width + data_width_bits)]),
#                       NextValue(self.wr_tosdram.status, self.fromsbus_fifo.dout[0:blk_addr_width]),
#                       NextState("WaitForAck")
#                    )
#        )
#        req_w_fsm.act("WaitForAck",
#                    If(self.wishbone_w_master.ack,
#                       NextValue(self.wishbone_w_master.cyc, 0),
#                       NextValue(self.wishbone_w_master.stb, 0),
#                       NextState("Idle"),
#                    )
#        )

        req_w_fsm.act("Reset",
                    NextState("Idle")
        )
        req_w_fsm.act("Idle",
                      If(self.fromsbus_fifo.readable,
                         self.dram_dma_writer.sink.address.eq(self.fromsbus_fifo.dout[0:blk_addr_width]),
                         self.dram_dma_writer.sink.data.eq(self.fromsbus_fifo.dout[blk_addr_width:(blk_addr_width + data_width_bits)]),
                         self.dram_dma_writer.sink.valid.eq(1),
                         NextValue(self.wr_tosdram.status, self.fromsbus_fifo.dout[0:blk_addr_width]),
                         If(self.dram_dma_writer.sink.ready,
                            self.fromsbus_fifo.re.eq(1),
                            NextValue(self.dma_wrdone.status, self.dma_wrdone.status + 1),
                            If(do_checksum,
                               self.checksum.we.eq(1),
                               self.checksum.dat_w.eq(self.checksum.storage ^ self.fromsbus_fifo.dout[blk_addr_width:(blk_addr_width + data_width_bits)]),
                            )
                         )
                      )
        )
