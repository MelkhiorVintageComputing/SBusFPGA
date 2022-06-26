from migen import *
from migen.genlib.fifo import *

import litex
from litex.soc.interconnect import wishbone

from migen.genlib.cdc import BusSynchronizer

class WishboneDomainCrossingMaster(Module, wishbone.Interface):
    """Wishbone Clock Domain Crossing [Master]"""
    def __init__(self, platform, slave, cd_master="sys", cd_slave="sys", force_delay = 0):
        # Same Clock Domain, direct connection.
        wishbone.Interface.__init__(self, data_width=slave.data_width, adr_width=slave.adr_width)
        if cd_master == cd_slave:
            raise NameError("Don't use domain crossing for the same domains.")
        # Clock Domain Crossing.
        else:
            self.add_sources(platform)

            delay_stb = Signal()
            if (force_delay == 0):
                self.comb += [ delay_stb.eq(self.stb), ]
            else:
                counter = Signal(max=force_delay+1)
                last_stb = Signal()
                master_sync = getattr(self.sync, cd_master)
                master_sync += [
                    If(counter != 0,
                       counter.eq(counter - 1),
                    ),
                    last_stb.eq(self.stb),
                    If(~self.stb & last_stb, # falling edge, force timeout
                       counter.eq(force_delay),
                    ),
                ]
                self.comb += [ delay_stb.eq(self.stb & (counter == 0)) ]

            #fixme: parameters
            self.specials += Instance(self.get_netlist_name(),
                                      # master side
                                      i_wbm_clk = ClockSignal(cd_master),
                                      i_wbm_rst = ResetSignal(cd_master),
                                      i_wbm_adr_i = self.adr,
                                      i_wbm_dat_i = self.dat_w,
                                      o_wbm_dat_o = self.dat_r,
                                      i_wbm_we_i = self.we,
                                      i_wbm_sel_i = self.sel,
                                      i_wbm_stb_i = delay_stb,
                                      o_wbm_ack_o = self.ack,
                                      o_wbm_err_o = self.err,
                                      o_wbm_rty_o = Signal(),
                                      i_wbm_cyc_i = self.cyc,
                                      # slave side
                                      i_wbs_clk = ClockSignal(cd_slave),
                                      i_wbs_rst = ResetSignal(cd_slave),
                                      o_wbs_adr_o = slave.adr,
                                      o_wbs_dat_o = slave.dat_w,
                                      i_wbs_dat_i = slave.dat_r,
                                      o_wbs_we_o = slave.we,
                                      o_wbs_sel_o = slave.sel,
                                      o_wbs_stb_o = slave.stb,
                                      i_wbs_ack_i = slave.ack,
                                      i_wbs_err_i = slave.err,
                                      i_wbs_rty_i = Signal(),
                                      o_wbs_cyc_o = slave.cyc)
                
    def get_netlist_name(self):
        return "wb_async_reg"

    def add_sources(self, platform):
        platform.add_source("/home/dolbeau/SBusFPGA/sbus-to-ztex-gateware-migen/wb_async_reg.v", "verilog")
