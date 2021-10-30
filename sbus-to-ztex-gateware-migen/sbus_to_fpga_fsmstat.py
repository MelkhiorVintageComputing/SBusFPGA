from migen import *
from migen.genlib.cdc import BusSynchronizer
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone

class SBusFPGABusStat(Module, AutoCSR):
    def __init__(self, soc, sbus_bus):
        self.stat_ctrl = CSRStorage(fields = [CSRField("update", 1, description = "update")])
        self.submodules.sync_update = BusSynchronizer(width = 1, idomain="sys", odomain="sbus")
        self.comb += self.sync_update.i.eq(self.stat_ctrl.fields.update)
        self.comb += sbus_bus.stat_update.eq(self.sync_update.o)
        
        self.live_stat_cycle_counter = CSRStatus(32, description="live_stat_cycle_counter")
        self.stat_cycle_counter = CSRStatus(32, description="stat_cycle_counter")
        self.stat_slave_start_counter = CSRStatus(32, description="stat_slave_start_counter")
        self.stat_slave_done_counter = CSRStatus(32, description="stat_slave_done_counter")
        self.stat_slave_rerun_counter = CSRStatus(32, description="stat_slave_rerun_counter")
        #self.stat_slave_rerun_last_pa = CSRStatus(32, description="stat_slave_rerun_last_pa")
        #self.stat_slave_rerun_last_state = CSRStatus(32, description="stat_slave_rerun_last_state")
        self.stat_slave_early_error_counter = CSRStatus(32, description="stat_slave_early_error_counter")
        self.stat_master_start_counter = CSRStatus(32, description="stat_master_start_counter")
        self.stat_master_done_counter = CSRStatus(32, description="stat_master_done_counter")
        self.stat_master_error_counter = CSRStatus(32, description="stat_master_error_counter")
        self.stat_master_rerun_counter = CSRStatus(32, description="stat_master_rerun_counter")
        self.sbus_master_error_virtual = CSRStatus(32, description="sbus_master_error_virtual")
 
        self.submodules.sync_live_stat_cycle_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys")
        self.comb += self.sync_live_stat_cycle_counter.i.eq(sbus_bus.stat_cycle_counter)
        self.comb += self.live_stat_cycle_counter.status.eq(self.sync_live_stat_cycle_counter.o)
 
        self.submodules.sync_stat_cycle_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys")
        self.comb += self.sync_stat_cycle_counter.i.eq(sbus_bus.buf_stat_cycle_counter)
        self.comb += self.stat_cycle_counter.status.eq(self.sync_stat_cycle_counter.o)
        
        self.submodules.sync_stat_slave_start_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_slave_start_counter.i.eq(sbus_bus.buf_stat_slave_start_counter)
        self.comb += self.stat_slave_start_counter.status.eq(self.sync_stat_slave_start_counter.o)
        self.submodules.sync_stat_slave_done_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_slave_done_counter.i.eq(sbus_bus.buf_stat_slave_done_counter)
        self.comb += self.stat_slave_done_counter.status.eq(self.sync_stat_slave_done_counter.o)
        self.submodules.sync_stat_slave_rerun_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_slave_rerun_counter.i.eq(sbus_bus.buf_stat_slave_rerun_counter)
        self.comb += self.stat_slave_rerun_counter.status.eq(self.sync_stat_slave_rerun_counter.o)
        #self.submodules.sync_stat_slave_rerun_last_pa = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        #self.comb += self.sync_stat_slave_rerun_last_pa.i.eq(sbus_bus.stat_slave_rerun_last_pa) # no 'buf_'
        #self.comb += self.stat_slave_rerun_last_pa.status.eq(self.sync_stat_slave_rerun_last_pa.o)
        #self.submodules.sync_stat_slave_rerun_last_state = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        #self.comb += self.sync_stat_slave_rerun_last_state.i.eq(sbus_bus.stat_slave_rerun_last_state) # no 'buf_'
        #self.comb += self.stat_slave_rerun_last_state.status.eq(self.sync_stat_slave_rerun_last_state.o)
        
        self.submodules.sync_stat_slave_early_error_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_slave_early_error_counter.i.eq(sbus_bus.buf_stat_slave_early_error_counter)
        self.comb += self.stat_slave_early_error_counter.status.eq(self.sync_stat_slave_early_error_counter.o)
        self.submodules.sync_stat_master_start_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_master_start_counter.i.eq(sbus_bus.buf_stat_master_start_counter)
        self.comb += self.stat_master_start_counter.status.eq(self.sync_stat_master_start_counter.o)
        self.submodules.sync_stat_master_done_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_master_done_counter.i.eq(sbus_bus.buf_stat_master_done_counter)
        self.comb += self.stat_master_done_counter.status.eq(self.sync_stat_master_done_counter.o)
        self.submodules.sync_stat_master_error_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_master_error_counter.i.eq(sbus_bus.buf_stat_master_error_counter)
        self.comb += self.stat_master_error_counter.status.eq(self.sync_stat_master_error_counter.o)
        self.submodules.sync_stat_master_rerun_counter = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_stat_master_rerun_counter.i.eq(sbus_bus.buf_stat_master_rerun_counter)
        self.comb += self.stat_master_rerun_counter.status.eq(self.sync_stat_master_rerun_counter.o)
        self.submodules.sync_sbus_master_error_virtual = BusSynchronizer(width = 32, idomain="sbus", odomain="sys");
        self.comb += self.sync_sbus_master_error_virtual.i.eq(sbus_bus.buf_sbus_master_error_virtual)
        self.comb += self.sbus_master_error_virtual.status.eq(self.sync_sbus_master_error_virtual.o)
