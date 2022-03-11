from migen import *
from migen.genlib.cdc import MultiReg

from litex.soc.interconnect.csr import *
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect import wishbone
from litex.soc.interconnect.csr_eventmanager import *

prime_string = "$2^{{255}}-19$"  # 2\ :sup:`255`-19
field_latex = "$\mathbf{{F}}_{{{{2^{{255}}}}-19}}$"

opcode_bits = 5  # number of bits used to encode the opcode field
opcodes = {  # mnemonic : [bit coding, docstring] ; if bit 6 (0x20) is set, shift a
    "UDF" : [-1, "Placeholder for undefined opcodes"],
    "PSA" : [0, "Wd $\gets$ Ra  // pass A"],
    "PSB" : [1, "Wd $\gets$ Rb  // pass B"],
    # 2 MSK
    "XOR" : [3, "Wd $\gets$ Ra ^ Rb  // bitwise XOR"],
    "NOT" : [4, "Wd $\gets$ ~Ra   // binary invert"],
    "ADD32" : [5, "Wd[x..x+32] $\gets$ Ra[x..x+32] + Rb[x..x+32] // vector 32-bit binary add"],
    "SUB32" : [6, "Wd[x..x+32] $\gets$ Ra[x..x+32] - Rb[x..x+32] // vector 32-bit binary add"],
    #"ADD" : [5, "Wd $\gets$ Ra + Rb  // 256-bit binary add"],
    #"SUB" : [6, "Wd $\gets$ Ra - Rb  // 256-bit binary subtraction"],
    "AND" : [7, "Wd $\gets$ Ra & Rb  // bitwise AND"], # replace MUL
    "BRNZ" : [8, "If Ra != 0 then mpc[9:0] $\gets$ mpc[9:0] + immediate[9:0] + 1, else mpc $\gets$ mpc + 1  // Branch if non-zero"], # replace TRD
    "BRZ" : [9, "If Ra == 0 then mpc[9:0] $\gets$ mpc[9:0] + immediate[9:0] + 1, else mpc $\gets$ mpc + 1  // Branch if zero"],
    "FIN" : [10, "halt execution and assert interrupt to host CPU that microcode execution is done"],
    "SHL" : [11, "Wd $\gets$ Ra << 1  // shift Ra left by one and store in Wd"],
    # 12 XBT
    # for MEM, bit #31 (imm[8]) indicates both lanes are needed; imm[31] == 0 faster as the second access is not done ;
    "GETM": [17, "GETM: getmask" ],
    "ADR": [18, "ADR: set or recover addresses, Wd $\gets$ ADR (for GETADR) or Wd $\gets$ 0 (for SETADR)" ],
    "MEM" : [19, "MEM: imm[8] == 1 for 256 imm[7] == 0 for LOAD, imm[7] == 1 for STORE (beware, store zeroes the output reg); post-inc in imm[6], address in addr[imm[0...]]" ],
    "SETM" : [20, "SETMx: Wd $\gets$ 0, masking for x = imm[1:0] set to start Ra[0:4], length Rb[0:5] ; using imm[1:0]==3 reset all (alias resm)" ],
    "LOADH" : [21, "LOADH: imm[7] == 0 for LOAD, address in addr[imm[0...]], high->low & load a+16 into high" ],
    "MAX" : [22, "Maximum opcode number (for bounds checking)"],
}

num_registers = 32
instruction_layout = [
    ("opcode", opcode_bits, "opcode to be executed"),
    ("shift", 1, "should A & Q be shifted"),
    ("ra", log2_int(num_registers), "operand A read register"),
    ("ca", 1, "set to substitute constant table value for A"),
    ("rb", log2_int(num_registers), "operand B read register"),
    ("cb", 1, "set to substitute constant table value for B"),
    ("wd", log2_int(num_registers), "write register"),
    ("immediate", 9, "Used by jumps to load the next PC value")
]

class RegisterFile(Module, AutoDoc):
    def __init__(self, depth=512, width=256, bypass=False):
        reset_cycles = 4
        self.intro = ModuleDoc(title="Register File", body="""
This implements the register file for the Jareth engine. It's implemented using
7-series specific block RAMs in order to take advantage of architecture-specific features
to ensure a compact and performant implementation.

The core primitive is the RAMB36E1. This can be configured as a 64/72-bit wide memory
but only if used in "SDP" (simple dual port) mode. In SDP, you have one read, one write port.
However, the register file needs to produce two operands per cycle, while accepting up to
one operand per cycle.

In order to do this, we stipulate that the RF runs at `rf_clk` (200MHz), but uses four phases
to produce/consume data. "Engine clock" `eng_clk` (50MHz) runs at a lower rate to accommodate
large-width arithmetic in a single cycle.

The phasing is defined as follows:

Phase 0:
  - read from port A
Phase 1:
  - read from port B
Phase 2:
  - write data
Phase 3:
  - quite cycle, used to create extra setup time for next stage (requires multicycle-path constraints)

The writing of data is done in the second phase means that write happen to the same address
as being read, you get the old value. For pipelined operation, it could be desirable to shift
the write to happen before the reads, but as of now the implementation is not pipelined.

The register file is unavailable for {} `eng_clk` cycles after reset.

When configured as a 64 bit memory, the depth of the block is 512 bits, corresponding to
an address width of 9 bits.

        """.format(reset_cycles))

        instruction = Record(instruction_layout)
        phase = Signal(2)  # internal phase
        self.phase = Signal()  # external phase
        self.comb += self.phase.eq(phase[1]) # divide down internal phase so slower modules can capture it

        # these are the signals in and out of the register file
        self.ra_dat = Signal(width) # this is passed in from outside the module because we want to mux with e.g. memory bus
        self.ra_adr = Signal(log2_int(depth))
        self.rb_dat = Signal(width)
        self.rb_adr = Signal(log2_int(depth))

        # register file pipelines the write target address, going to the exec units; also needs the window to be complete
        # window is assumed to be static and does not change throughout a give program run, so it's not pipelined
        self.instruction_pipe_in = Signal(len(instruction))
        self.instruction_pipe_out = Signal(len(instruction))
        self.window = Signal(max(1, log2_int(depth) - log2_int(num_registers)))

        # this is the immediate data to write in, coming from the exec units
        self.wd_dat = Signal(width)
        self.wd_adr = Signal(log2_int(depth))
        self.wd_bwe = Signal(width//8)  # byte masks for writing
        self.we = Signal()
        self.clear = Signal()

        self.running = Signal() # used for activity gating to RAM

        eng_sync = Signal(reset=1)

        rf_adr = Signal(log2_int(depth))
        self.comb += [
            If(phase == 0,
                rf_adr.eq(self.ra_adr),
            ).Elif(phase == 1,
                rf_adr.eq(self.rb_adr),
            )
        ]
        rf_dat = Signal(width)
        self.sync.eng_clk += [
            # TODO: check that this is in sync with expected values
            self.instruction_pipe_out.eq(self.instruction_pipe_in),
        ]
        # unfortunately, -1L speed grade is too slow to support pipeline bypassing of the register file:
        # bypass path closes at about 5.4ns, which fails to meet the 5ns cycle time target for the four-phase RF
        if bypass:
            self.sync.rf_clk += [
                If(phase == 1,
                    If((self.wd_adr != self.ra_adr) | ~self.we,
                        self.ra_dat.eq(rf_dat),
                       ).Else(
                        self.ra_dat.eq(self.wd_dat),
                    ),
                    self.rb_dat.eq(self.rb_dat),
                   ).Elif(phase == 2,
                    self.ra_dat.eq(self.ra_dat),
                    If((self.wd_adr != self.rb_adr) | ~self.we,
                        self.rb_dat.eq(rf_dat),
                       ).Else(
                        self.rb_dat.eq(self.wd_dat),
                    )
                          ).Else(
                    self.ra_dat.eq(self.ra_dat),
                    self.rb_dat.eq(self.rb_dat),
                ),
            ]
        else:
            self.sync.rf_clk += [
                If(phase == 1,
                    self.ra_dat.eq(rf_dat),
                    self.rb_dat.eq(self.rb_dat),
                ).Elif(phase == 2,
                    self.ra_dat.eq(self.ra_dat),
                    self.rb_dat.eq(rf_dat),
                ).Else(
                    self.ra_dat.eq(self.ra_dat),
                    self.rb_dat.eq(self.rb_dat),
                ),
            ]
        wren_pipe = Signal() # do not change this variable name, it is constrained in the XDC
        self.sync.rf_clk += [
            If(eng_sync,
                phase.eq(0),
            ).Else(
                phase.eq(phase + 1),
            ),
            wren_pipe.eq((phase == 1) & self.we),  # we want wren to hit on phase==2, but we pipeline it to relax timing. so capture the input to the pipe on phase == 1
        ]
        wd_bwe_pipe = Signal(width//8)
        self.sync.rf_clk += [
            # add a register to relax timing on wd_bwe. This offsets the signal by one rf_clk (clk200) period,
            # but because write happens on phase 2 and the signal is valid on eng_clk (clk50) edges, this will
            # not affect the functionality
            wd_bwe_pipe.eq(self.wd_bwe)
        ]

        for word in range(int(256/64)):
            self.specials += Instance("BRAM_SDP_MACRO", name="RF_RAMB" + str(word),
                p_BRAM_SIZE = "36Kb",
                p_DEVICE = "7SERIES",
                p_WRITE_WIDTH = 64,
                p_READ_WIDTH = 64,
                p_DO_REG = 0,
                p_INIT_FILE = "NONE",
                p_SIM_COLLISION_CHECK = "ALL", # "WARNING_ONLY", "GENERATE_X_ONLY", "NONE"
                p_SRVAL = 0,
                p_WRITE_MODE = "READ_FIRST",
                i_RDCLK = ClockSignal("rf_clk"),
                i_WRCLK = ClockSignal("rf_clk"),
                i_RDADDR = rf_adr,
                i_WRADDR = self.wd_adr,
                i_DI = self.wd_dat[word*64 : word*64 + 64],
                o_DO = rf_dat[word*64 : word*64 + 64],
                i_RDEN = self.running, # reduce power when not running
                i_WREN = wren_pipe, # (phase == 2) & self.we, but pipelined one stage
                i_RST = ResetSignal("rf_clk"),
                i_WE = wd_bwe_pipe[word*8 : word*8 + 8],

                i_REGCE = 1, # should be ignored, but added to quiet down simulation warnings
            )

        # create an internal reset signal that synchronizes the "eng" to the "rf" domains
        # it will also reset the register file on demand
        reset_counter = Signal(log2_int(reset_cycles), reset=reset_cycles - 1)
        self.sync.eng_clk += [
            If(self.clear,
                reset_counter.eq(reset_cycles - 1),
                eng_sync.eq(1),
            ).Else(
                If(reset_counter != 0,
                   reset_counter.eq(reset_counter - 1),
                    eng_sync.eq(1),
                ).Else(
                   eng_sync.eq(0)
                ),
            )
        ]

class JarethConst(Module, AutoDoc):
    def __init__(self, insert_docs=False):
        global did_const_doc
        constant_defs = {
            0: [0, "zero", "The number zero"],
            1: [1, "one", "The number one"],
            2: [2, "two", "The number two"],
            #3: [3, "three", "The number three"],
            #4: [4, "four", "The number four"],
            #5: [5, "five", "The number five"],
            5: [32, "thirty-two", "The number thirty-two"],
            #6: [6, "six", "The number six"],
            #7: [7, "seven", "The number seven"],
            #8: [8, "eight", "The number eight"],
            15: [15, "sixteen", "The number fifteen"],
            16: [16, "sixteen", "The number sixteen"],
        }
        self.adr = Signal(5)
        self.const = Signal(256)
        constant_str = "This module encodes the constants that can be substituted for any register value. Therefore, up to 32 constants can be encoded.\n\n"
        for code, const in constant_defs.items():
            self.comb += [
                If(self.adr == code,
                    self.const.eq(const[0]),
                )
            ]
            constant_str += """
**{}**

  Substitute register {} with {}: {}\n""".format(const[1], code, const[2], const[0])
        if insert_docs:
            self.constants = ModuleDoc(title="Jareth Constants", body=constant_str)

# ------------------------------------------------------------------------ EXECUTION UNITS
class ExecUnit(Module, AutoDoc):
    def __init__(self, width=256, opcode_list=["UDF"], insert_docs=False):
        if insert_docs:
            self.intro = ModuleDoc(title="ExecUnit class", body="""
    ExecUnit is the superclass template for execution units.

    Configuration Arguments:
      - `opcode_list` is the list of opcodes that an ExecUnit can process
      - `width` is the bit-width of the execution pathway

    Signal API for an exec unit:
      - `a` and `b` are the inputs.
      - `instruction_in` is the instruction corresponding to the currently present `a` and `b` inputs
      - `start` is a single-clock signal which indicates processing should start
      - `q` is the output
      - `instruction_out` is the instruction for the result present at the `q` output
      - `q_valid` is a single cycle pulse that indicates that the `q` result and `wa_out` value is valid


            """)
        self.instruction = Record(instruction_layout)

        self.a = Signal(width) # raw or shifted
        self.b = Signal(width) # shifted
        self.q = Signal(width) # shifted
        self.start = Signal()
        self.q_valid = Signal()
        # pipeline the instruction
        self.instruction_in = Signal(len(self.instruction))
        self.instruction_out = Signal(len(self.instruction))

        self.opcode_list = opcode_list
        self.comb += [
            self.instruction.raw_bits().eq(self.instruction_in)
        ]

class ExecLogic(ExecUnit):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["XOR", "NOT", "PSA", "SHL", "AND"])
        self.intro = ModuleDoc(title="Logic ExecUnit Subclass", body=f"""
This execution unit implements bit-wise logic operations: XOR, NOT, and
passthrough.

* XOR returns the result of A^sB
* NOT returns the result of !A
* PSA returns the value of A
* SHL returns A << 1
* AND returns the result of A&sB

""")

        zeros = Signal(255, reset=0)
        self.sync.eng_clk += [
            self.q_valid.eq(self.start),
            self.instruction_out.eq(self.instruction_in),
        ]
        self.comb += [
            If(self.instruction.opcode == opcodes["XOR"][0],
               self.q.eq(self.a ^ self.b)
            ).Elif(self.instruction.opcode == opcodes["NOT"][0],
               self.q.eq(~self.a)
            ).Elif(self.instruction.opcode == opcodes["PSA"][0],
                self.q.eq(self.a),
            ).Elif(self.instruction.opcode == opcodes["PSB"][0],
                self.q.eq(self.b),
            ).Elif(self.instruction.opcode == opcodes["SHL"][0],
                self.q.eq(Cat(0, self.a[:255])),
            ).Elif(self.instruction.opcode == opcodes["AND"][0],
                self.q.eq(self.a & self.b),
            ),
        ]

class ExecAddSub(ExecUnit, AutoDoc):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["ADD32", "SUB32"])
        self.notes = ModuleDoc(title="Add/Sub ExecUnit Subclass", body=f"""
        """)

        self.sync.eng_clk += [
            self.q_valid.eq(self.start),
            self.instruction_out.eq(self.instruction_in),
        ]
        self.comb += [
            If(self.instruction.opcode == opcodes["ADD32"][0],
                   [ self.q[x*32:(x+1)*32].eq(self.a[x*32:(x+1)*32] + self.b[x*32:(x+1)*32]) for x in range(0, width//32) ],
            ).Elif(self.instruction.opcode == opcodes["SUB32"][0],
                   [ self.q[x*32:(x+1)*32].eq(self.a[x*32:(x+1)*32] - self.b[x*32:(x+1)*32]) for x in range(0, width//32) ],
            ),
        ]

class ExecLS(ExecUnit, AutoDoc):
    def __init__(self, width=256, interface=None, r_dat_f=None, r_dat_m=None, granule=0):
        ExecUnit.__init__(self, width, ["MEM", "SETM", "ADR", "LOADH", "GETM"])
        
        self.notes = ModuleDoc(title=f"Load/Store ExecUnit Subclass", body=f"""
        """)

        self.sync.eng_clk += [ # pipeline the instruction
            self.instruction_out.eq(self.instruction_in),
        ]

        assert(width == 256) # fixme
        assert(len(interface.sel) == 16) # 128 bits Wishbone

        start_pipe = Signal()
        self.sync.mul_clk += start_pipe.eq(self.start) # break critical path of instruction decode -> SETUP_A state muxes
        self.submodules.lsseq = lsseq = ClockDomainsRenamer("mul_clk")(FSM(reset_state="IDLE"))
        cpar = Signal() # to keep track of the odd-ness of our cycle, so we can align 2 mul_clk cycles of output on 1 eng_clk cycle
        lbuf = Signal(width)
        timeout = Signal(11)
        #tries = Signal()
        self.has_failure = Signal(2)
        self.has_timeout = Signal(2)

        self.sync.mul_clk += If(timeout > 0, timeout.eq(timeout - 1))

        granule_bits = log2_int(granule)
        granule_num = width//granule
        granule_num_bits = log2_int(granule_num)
        
        offset = Signal(granule_num_bits-1, reset = 0)
        max_size_bits=28 # 256 MiB
        offsetpsize = Signal(max_size_bits+1, reset = 0)

        addresses = Array(Signal(28) for x in range(width//32)) # 128-bits chunk, so 16-bytes chunk, so low 4 bits are ignored

        lsseq.act("IDLE",
                  If(start_pipe,
                     If(self.instruction.opcode == opcodes["MEM"][0],
                        NextValue(cpar, 0),
                        NextValue(self.has_timeout, 0),
                        NextValue(self.has_failure, 0),
                        NextValue(interface.cyc, 1),
                        NextValue(interface.stb, 1),
                        NextValue(interface.sel, 2**len(interface.sel)-1),
                        NextValue(interface.adr, addresses[self.instruction.immediate[0:log2_int(width//32)]]),
                        NextValue(interface.we, self.instruction.immediate[7]),
                        NextValue(timeout, 2047),
                        If(self.instruction.immediate[7], # do we need those tests or could we always update dat_w/dat_r ?
                           NextValue(interface.dat_w, self.b[0:128])),
                        NextState("MEMl") # MEMl
                     ).Elif(self.instruction.opcode == opcodes["LOADH"][0],
                            NextValue(cpar, 0),
                            NextValue(self.has_timeout, 0),
                            NextValue(self.has_failure, 0),
                            NextValue(interface.cyc, 1),
                            NextValue(interface.stb, 1),
                            NextValue(interface.sel, 2**len(interface.sel)-1),
                            NextValue(interface.adr, addresses[self.instruction.immediate[0:log2_int(width//32)]]),
                            NextValue(interface.we, self.instruction.immediate[7]),
                            NextValue(timeout, 2047),
                            NextValue(lbuf[0:128], self.b[128:256]),
                            NextState("MEMh") # MEMl
                     ).Elif(self.instruction.opcode == opcodes["SETM"][0],
                            Case(self.instruction.immediate[0:2],
                                 { 0x3 : [ NextValue(r_dat_f[0], 0),
                                           NextValue(r_dat_f[1], 0),
                                           NextValue(r_dat_f[2], 0),
                                           NextValue(r_dat_m[0], (1<<len(r_dat_m[0]))-1),
                                           NextValue(r_dat_m[1], (1<<len(r_dat_m[1]))-1),
                                           NextValue(r_dat_m[2], (1<<len(r_dat_m[2]))-1),
                                           NextState("MEM_ODD") ],
                                   0x2 : [ NextValue(r_dat_f[2],  self.a[(granule_bits-3):len(r_dat_f[2])]),
                                           NextValue(offset,      self.a[(granule_bits-3):len(r_dat_f[2])]),
                                           NextValue(offsetpsize, self.b[0:max_size_bits] + ((self.a[(granule_bits-3):len(r_dat_f[2])]) << (granule_bits-3)) ),
                                           NextState("GENMASK_R0"),
                                   ],
                                   0x1 : [ NextValue(r_dat_f[1],        self.a[(granule_bits-3):len(r_dat_f[1])]),
                                                 NextValue(offset, 0),
                                                 NextValue(offsetpsize, self.b[0:max_size_bits]),
                                                 NextState("GENMASK_R0"),
                                   ],
                                   0x0 : [ NextValue(r_dat_f[0],        self.a[(granule_bits-3):len(r_dat_f[0])]),
                                                 NextValue(offset, 0),
                                                 NextValue(offsetpsize, self.b[0:max_size_bits]),
                                                 NextState("GENMASK_R0"),
                                   ],
                                 }),
                     ).Elif(self.instruction.opcode == opcodes["ADR"][0],
                            If(self.instruction.immediate[7],
                               [ NextValue(addresses[x], self.a[x*32+4:(x+1)*32]) for x in range(width//32) ],
                            ),
                            NextState("MEM_ODD")
                     ).Elif(self.instruction.opcode == opcodes["GETM"][0],
                            NextState("MEM_ODD")
                     )
                  )
        )
        for X in range(0, granule_num):
            lsseq.act("GENMASK_R" + str(X),
                      NextValue(cpar, cpar ^ 1),
                      If((offsetpsize > X) & (X >= offset),
                         NextValue(r_dat_m[self.instruction.immediate[0:2]][X], 1),
                      ).Else(
                         NextValue(r_dat_m[self.instruction.immediate[0:2]][X], 0),
                      ),
                      If(X == (granule_num-1),
                         If(cpar, ## checkme
                            NextState("MEM_ODD")
                         ).Else(
                             NextState("MEM_EVEN1")
                         )
                      ).Else(
                          NextState("GENMASK_R" + str(X+1)),
                      ),
            )
        lsseq.act("GENMASK_R"+str(granule_num), # avoids MiGen complaining, unreachable
                  NextValue(cpar, cpar ^ 1),
                  If(cpar, ## checkme
                     NextState("MEM_ODD")
                  ).Else(
                      NextState("MEM_EVEN1")
                  )
        )
            
        lsseq.act("MEMl",
                  NextValue(cpar, cpar ^ 1),
                  If(interface.ack,
                     If(~self.instruction.immediate[7],
                        NextValue(lbuf[0:128], interface.dat_r)),
                     NextValue(interface.cyc, 0),
                     NextValue(interface.stb, 0),
                     NextState("MEMl2")
                  ).Elif(interface.err,
                         NextValue(self.has_failure[0], 1),
                         NextValue(interface.cyc, 0),
                         NextValue(interface.stb, 0),
                         NextState("ERR"),
                  ).Elif(timeout == 0,
                         NextValue(self.has_timeout[0], 1),
                         NextValue(interface.cyc, 0),
                         NextValue(interface.stb, 0),
                         NextState("ERR"),
                  ))
        lsseq.act("MEMl2",
                  NextValue(cpar, cpar ^ 1),
                  If(~interface.ack,
                     If(self.instruction.immediate[6], # post-inc
                        NextValue(addresses[self.instruction.immediate[0:log2_int(width//32)]], addresses[self.instruction.immediate[0:log2_int(width//32)]] + 1),
                     ),
                     If(self.instruction.immediate[8],
                        NextValue(interface.cyc, 1),
                        NextValue(interface.stb, 1),
                        NextValue(interface.sel, 2**len(interface.sel)-1),
                        NextValue(interface.adr, (addresses[self.instruction.immediate[0:log2_int(width//32)]]) + 1),
                        NextValue(interface.we, self.instruction.immediate[7]),
                        NextValue(timeout, 2047),
                        If(self.instruction.immediate[7],
                           NextValue(interface.dat_w, self.b[128:256])),
                        NextState("MEMh")
                     ).Else(
                         NextValue(lbuf[128:256], 0),
                         If(cpar, ## checkme
                            NextState("MEM_ODD")
                         ).Else(
                             NextState("MEM_EVEN1")
                         )
                     )
                  ))
        lsseq.act("MEMh",
                  NextValue(cpar, cpar ^ 1),
                  If(interface.ack,
                     If(~self.instruction.immediate[7],
                        NextValue(lbuf[128:256], interface.dat_r)),
                     NextValue(interface.cyc, 0),
                     NextValue(interface.stb, 0),
                     NextState("MEMh2")
                  ).Elif(interface.err,
                         NextValue(self.has_failure[1], 1),
                         NextValue(interface.cyc, 0),
                         NextValue(interface.stb, 0),
                         NextState("ERR"),
                  ).Elif(timeout == 0,
                         NextValue(self.has_timeout[1], 1),
                         NextValue(interface.cyc, 0),
                         NextValue(interface.stb, 0),
                         NextState("ERR"),
                  ))
        lsseq.act("MEMh2",
                  NextValue(cpar, cpar ^ 1),
                  If(~interface.ack,
                     If(self.instruction.immediate[6], # post-inc
                        NextValue(addresses[self.instruction.immediate[0:log2_int(width//32)]], addresses[self.instruction.immediate[0:log2_int(width//32)]] + 1),
                     ),
                     #NextValue(tries, 0),
                     If(cpar, ## checkme
                        NextState("MEM_ODD")
                     ).Else(
                        NextState("MEM_EVEN1")
                     )
                  ))
        lsseq.act("MEM_ODD", # clock alignement cycle
                  NextState("MEM_EVEN1"))
        lsseq.act("MEM_EVEN1",
                  NextState("MEM_EVEN2"))
        lsseq.act("MEM_EVEN2",
                  NextValue(cpar, 0),
                  NextValue(self.has_failure, 0),
                  NextValue(self.has_timeout, 0),
                  NextState("IDLE"))
        lsseq.act("ERR",
                  #If(~tries, # second attempt
                  #   NextValue(cpar, 0),
                  #   NextValue(tries, 1),
                  #   NextState("IDLE")
                  #).Else(NextValue(tries, 0), # no third attempt, give up
                         If(cpar, ## checkme
                            NextState("MEM_ODD")
                         ).Else(
                             NextState("MEM_EVEN1")
                         )
                  #)
        )
        self.sync.mul_clk += [
            If(lsseq.ongoing("MEM_EVEN1") | lsseq.ongoing("MEM_EVEN2"),
               self.q_valid.eq(1),
               If((self.instruction.opcode == opcodes["MEM"][0]) | (self.instruction.opcode == opcodes["LOADH"][0]),
                  If(~self.instruction.immediate[7],
                     self.q.eq(lbuf),
                  ).Else(
                      self.q.eq(0), #self.a
                  )
               ).Elif(self.instruction.opcode == opcodes["SETM"][0],
                   self.q.eq(0), #self.a
               ).Elif(self.instruction.opcode == opcodes["ADR"][0],
                      If(~self.instruction.immediate[7],
                         [ self.q[x*32:(x+1)*32].eq(Cat(Signal(4, reset = 0), addresses[x])) for x in range(width//32) ],
                      ).Else(
                          self.q.eq(0),
                      )
               ).Elif(self.instruction.opcode == opcodes["GETM"][0],
                      self.q.eq(Cat(Cat(r_dat_f[0], Signal(28, reset = 0)),
                                    r_dat_m[0],
                                    Cat(r_dat_f[1], Signal(28, reset = 0)),
                                    r_dat_m[1],
                                    Cat(r_dat_f[2], Signal(28, reset = 0)),
                                    r_dat_m[2],
                                    Cat(r_dat_f[3], Signal(28, reset = 0)),
                                    r_dat_m[3])),
               ).Else(
                   self.q.eq(0xBADD0000_BADD0000_BADD0000_BADD0000_BADD0000_BADD0000_BADD0000_BADD0000),
               ),
            ).Else(
                self.q_valid.eq(0),
            )
        ]

        self.state = Signal(32)
        self.sync.mul_clk += self.state[0].eq(lsseq.ongoing("IDLE"))
        self.sync.mul_clk += self.state[1].eq(lsseq.ongoing("MEMl"))
        self.sync.mul_clk += self.state[2].eq(lsseq.ongoing("MEMl2"))
        self.sync.mul_clk += self.state[3].eq(lsseq.ongoing("MEMh"))
        self.sync.mul_clk += self.state[4].eq(lsseq.ongoing("MEMh2"))
        self.sync.mul_clk += self.state[5].eq(lsseq.ongoing("MEM_ODD"))
        self.sync.mul_clk += self.state[6].eq(lsseq.ongoing("MEM_EVEN1"))
        self.sync.mul_clk += self.state[7].eq(lsseq.ongoing("MEM_EVEN2"))
        self.sync.mul_clk += self.state[8].eq(lsseq.ongoing("MEM_ERR"))
        self.sync.mul_clk += self.state[28:30].eq((self.state[28:30] & Replicate(~start_pipe, 2)) | self.has_timeout)
        self.sync.mul_clk += self.state[30:32].eq((self.state[30:32] & Replicate(~start_pipe, 2)) | self.has_failure)

        
class Jareth(Module, AutoCSR, AutoDoc):
    def __init__(self, platform, prefix, sim=False, build_prefix=""):
        opdoc = "\n"
        for mnemonic, description in opcodes.items():
            opdoc += f" * **{mnemonic}** ({str(description[0])}) -- {description[1]} \n"

        self.intro = ModuleDoc(title="Jareth", body="""
Jareth is a vector computational engine based on the Curve25519 Engine.

The Engine loosely resembles a Harvard architecture microcoded CPU, with a single
512-entry, 256-bit wide 2R1W windowed-register file, a handful of execution units, and a "mailbox"
unit (like a load/store, but transactional to wishbone). The Engine's microcode is
contained in a 1k-entry, 32-bit wide microcode block. Microcode procedures are written to
the block, and execution will start from the `mpstart` offset when the `go` bit is set.
Execution will stop after either one of two conditions are met: either a `FIN` instruction
is executed, or the microcode program counter (mpc) goes past the stop threshold, computed
as `mpstart` + `mplen`.

The register file is "windowed". A single window consists of 32x256-bit wide registers,
and there are up to 16 windows. The concept behind windows is that core routines, such
as point doubling and point addition, are codable using no more than 32 intermediate
registers. The same microcode can be used, then, to serve point operations to up to
16 different clients, selectable by setting the appropriate window. Note that the register
file will stripe across four 4kiB pages, which means that memory protection can be
enforced at page-level boundaries by hardware (with the help of the OS) for up to four
separate clients, each getting four register windows.

Every register read can be overridden from a constant ROM, by asserting `ca` or `cb` for
registers a and b respectively. When either of these bits are asserted, the respective
register address is fed into a "constants" lookup table, and the result of that table lookup is
replaced for the constant value. This means up to 32 commonly used constants may be stored
in the hardware for quick retrieval.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/block_diagram.png
   :alt: High-level block diagram of the Curev25519 engine

Above is a high-level block diagram of the Curve25519 engine. Four clocks are present
in this microarchitecture, and they are phase-aligned thanks to the 7-Series MMCM
and low-skew global clock network. `eng_clk` is 50MHz, `mul_clk` is 100MHz, and
`rf_clk` is 200MHz. The slowest 50MHz `eng_clk` clock controls the `seq` state machine, whose
state names are listed on the left. A 50MHz base clock is chosen because this allows a
single-cycle 256-bit add/sub using hardware carry chains in the Spartan7 -1L speed grade,
greatly simplifying most of the arithmetic blocks. Faster clocks are used to pump the microcode
RAM (100MHz) and register file (200MHz), so that we are wasting less time fetching instructions
and operands. In particular, the register file uses four phases because we are emulating
a three-port register file (2R1W) using a single-port memory primitive, and the microcode RAM
runs at 100MHz (sysclk) for convenience of reading/writing instructions from the Wishbone bus.
Not shown in the diagram are the global "window" register bits, or the multiplexers that
switch off the datapaths when the system is not running allowing Wishbone full access to
the machine state.

Execution units are subclasses of "ExecUnit", and their instantiation is controlled by
inclusion in the `exec_units` dictionary. Likewise, opcodes are defined in the `opcodes`,
dictionary, and opcodes are bound to ExecUnits by passing them as the `opcode_list` argument
to the execution units.

Note that execution units can take an arbitrary amount of time to complete. Most will complete
in one cycle, but for example, the multiplier takes 52 cycles @ 100MHz, or 26 `eng_clk` cycles.
The current implementation does not allow pipelined operation; registered stages are provided
to break combinational paths and bring up the base clock rate, but every instruction must go through
the entire FETCH-EXEC-WAIT_DONE cycle before the next one can issue.

The design is partially outfitted with registers to facilitate pipelining in the future, but
the current simplified implementation is expected to provide adequate speedup. It's
probably not worth the additional resources to do e.g. pipeline bypassing and hazard checking,
as the target FPGA design is nearly at capacity.

A conservative implementation (no optimization of intermediate values, immediate reduction of
every add/sub operation) of Montgomery scalar multiplication using Engine25519
completes one scalar multiply operation in 2.270ms, compared to 103ms in software.
This does not include the time required to do the final affine inversion (done in software,
with significant overhead -- about 100ms), or the time to load the microcode and operands (about 5us).
The affine inversion can also be microcoded, it just hasn't been done yet.

The Engine address space is divided up as follows (expressed as offset from base)::

 0x0_0000 - 0x0_0fff: microcode (one 4k byte page)
 0x1_0000 - 0x1_3fff: memory-mapped register file (4 x 4k pages = 16kbytes)

Here are the currently implemented opcodes for The Engine:
{}
        """.format(opdoc))

        microcode_width = 32
        microcode_depth = 1024
        running = Signal() # asserted when microcode is running

        instruction = Record(instruction_layout) # current instruction to execute
        illegal_opcode = Signal()
        abort = Signal();

        ### register file
        rf_depth_raw = num_registers * 1 # total # or registers
        rf_width_raw = 256 # width of a register
        granule = 8
        granule_bits = log2_int(granule)
        granule_num = rf_width_raw//granule
        granule_num_bits = log2_int(granule_num)
        
        self.submodules.rf = rf = RegisterFile(depth=rf_depth_raw, width=rf_width_raw)
        self.window = CSRStorage(fields=[
            CSRField("window", size=max(1, log2_int(rf_depth_raw) - log2_int(num_registers)), description="Selects the current register window to use"),
        ])

        self.mpstart = CSRStorage(fields=[
            CSRField("mpstart", size=log2_int(microcode_depth), description="Where to start execution")
        ])
        self.mplen = CSRStorage(fields=[
            CSRField("mplen", size=log2_int(microcode_depth), description="Length of the current microcode program. Thus valid code must be in the range of [mpstart, mpstart + mplen]"),
        ])
        self.control = CSRStorage(fields=[
            CSRField("go", size=1, pulse=True, description="Writing to this puts the engine in `run` mode, and it will execute mplen microcode instructions starting at mpstart"),
        ])
        self.mpresume = CSRStatus(fields=[
            CSRField("mpresume", size=log2_int(microcode_depth), description="Where to resume execution after a pause")
        ])

        self.power = CSRStorage(fields=[
            CSRField("on", size=1, reset=0,
                description="Writing `1` turns on the clocks to this block, `0` stops the clocks (for power savings). The handling of the clock gate is in a different module, this is just a flag to that block."),
            CSRField("pause_req", size=1, description="Writing a `1` to this block will pause execution at the next micro-op, and allow for read-out of data from RF/microcode. Must check pause_gnt to confirm the pause has happened. Used to interrupt flow for suspend/resume."),
        ])
        # bring pause into the eng_clk domain
        pause_req = Signal()
        self.sync.eng_clk += pause_req.eq(self.power.fields.pause_req)
        # re-sync the eng_clk phase to the RF phase whenever clocks are re-applied. We don't guarantee that the clocks start exactly
        # at the same time, so you can get phase shift...
        power_on_delay = Signal(max=16, reset=15)
        eng_powered_on = Signal()
        self.sync += [ # stretch out any power on pulse so we can process a reset in the clk50 domain after its enable has been switched on
            If(~self.power.fields.on,
                power_on_delay.eq(15)
            ).Elif(power_on_delay > 0,
                power_on_delay.eq(power_on_delay - 1)
            ).Else(
                power_on_delay.eq(0)
            ),
            eng_powered_on.eq(power_on_delay == 0), # make a signal that specifies that the engine is powered on that happens 16 cycles after the clocks are turned on
            # note that this signal drops only *after* the power has been toggled, because when the clock is cut,
            # the downstream "eng_clk" domain signals won't capture the latest state. So, once the power comes on,
            # eng_powered_on must drop for a few cycles, then come back up again, which properly triggers a synchronization of the RF.
        ]
        eng_on_50 = Signal()
        eng_on_50_r = Signal()
        self.specials += MultiReg(eng_powered_on, eng_on_50, "eng_clk")
        self.sync.eng_clk += eng_on_50_r.eq(eng_on_50)
        rf_reset_clear = Signal()
        self.specials += MultiReg(ResetSignal("eng_clk"), rf_reset_clear, "eng_clk") # sync up the register file's fast clock to our slow clock
        self.comb += rf.clear.eq(rf_reset_clear | (eng_on_50 & ~eng_on_50_r))

        self.status = CSRStatus(fields=[
            CSRField("running", size=1, description="When set, the microcode engine is running. All wishbone access to RF and microcode memory areas will stall until this bit is clear"),
            CSRField("mpc", size=log2_int(microcode_depth), description="Current location of the microcode program counter. Mostly for debug."),
            CSRField("pause_gnt", size=1, description="When set, the engine execution has been paused, and the RF & microcode ROM can be read out for suspend/resume"),
            CSRField("sigill", size=1, description="Illegal Instruction"),
            CSRField("abort", size=1, description="Abort from failure"),
            CSRField("finished", size=1, description="Finished"),
        ])
        pause_gnt = Signal()
        mpc = Signal(log2_int(microcode_depth))  # the microcode program counter
        running_r = Signal()
        self.sync += [
            self.status.fields.running.eq(running),
            self.status.fields.pause_gnt.eq(pause_gnt),
            self.status.fields.mpc.eq(mpc),
            self.status.fields.sigill.eq(illegal_opcode),
            self.status.fields.abort.eq(abort),
            self.status.fields.finished.eq(((~running & running_r) | self.status.fields.finished) & (~(running & ~running_r))),
        ]

        self.submodules.ev = EventManager()
        self.ev.finished = EventSourcePulse(description="Microcode run finished execution")
        self.ev.illegal_opcode = EventSourcePulse(description="Illegal opcode encountered")
        self.ev.finalize()
        ill_op_r = Signal()
        self.sync += [
        running_r.eq(running),
            ill_op_r.eq(illegal_opcode),
        ]
        self.comb += [
            self.ev.finished.trigger.eq(~running & running_r), # falling edge pulse on running
            self.ev.illegal_opcode.trigger.eq(~ill_op_r & illegal_opcode),
        ]

        ### microcode memory - 1rd/1wr dedicated to wishbone, 1rd for execution
        microcode = Memory(microcode_width, microcode_depth)
        self.specials += microcode
        micro_wrport = microcode.get_port(write_capable=True, mode=READ_FIRST) # READ_FIRST allows BRAM inference
        self.specials += micro_wrport
        micro_rdport = microcode.get_port(mode=READ_FIRST)
        self.specials += micro_rdport
        micro_runport = microcode.get_port(mode=READ_FIRST) # , clock_domain="eng_clk"
        self.specials += micro_runport

        self.comb += [
            micro_runport.adr.eq(mpc),
            instruction.raw_bits().eq(micro_runport.dat_r),  # mapping should follow the record definition *exactly*
            instruction.eq(micro_runport.dat_r),
        ]
        instruction_fields = []
        for opcode, bits, description in instruction_layout:
            instruction_fields.append(CSRField(opcode, size=bits, description=description))
        self.instruction = CSRStatus(description="Current instruction being executed by the engine. The format of this register exactly reflects the binary layout of an Engine instruction.", fields=instruction_fields)
        self.comb += [
            self.instruction.status.eq(micro_runport.dat_r)
        ]

        self.ls_status = CSRStatus(32, description="Status of the L/S unit")

        ### wishbone bus interface: decode the two address spaces and dispatch accordingly
        self.bus = bus = wishbone.Interface()
        wdata = Signal(32)
        wadr = Signal(log2_int(rf_depth_raw) + 3) # wishbone bus is 32-bits wide, so 3 extra bits to select the sub-words out of the 256-bit registers
        wmask = Signal(4)
        wdata_we = Signal()
        rdata_re = Signal()
        rdata_ack = Signal()
        rdata_req = Signal()
        radr = Signal(log2_int(rf_depth_raw) + 3)

        micro_rd_waitstates = 2
        micro_rdack = Signal(max=(micro_rd_waitstates+1))
        self.sync += [
            If( ((bus.adr & ((0xFFFF_C000) >> 2)) >= ((prefix | 0x1_0000) >> 2)) & (((bus.adr & ((0xFFFF_C000) >> 2)) < ((prefix | 0x1_4000) >> 2))),
                # fully decode register file address to avoid aliasing
                If(bus.cyc & bus.stb & bus.we & ~bus.ack,
                    If(~running | pause_gnt,
                        wdata.eq(bus.dat_w),
                        wadr.eq(bus.adr[:wadr.nbits]),
                        wmask.eq(bus.sel),
                        wdata_we.eq(1),
                        If(rf.phase,
                            bus.ack.eq(1),
                        ).Else(
                            bus.ack.eq(0),
                        ),
                    ).Else(
                        wdata_we.eq(0),
                        bus.ack.eq(0),
                    )
                ).Elif(bus.cyc & bus.stb & ~bus.we & ~bus.ack,
                    If(~running | pause_gnt,
                        radr.eq(bus.adr[:radr.nbits]),
                        rdata_re.eq(1),
                        bus.dat_r.eq( rf.ra_dat >> ((radr & 0x7) * 32) ),
                        bus.ack.eq(rdata_ack),
                        rdata_req.eq(1),
                    ).Else(
                        rdata_re.eq(0),
                        bus.ack.eq(0),
                        rdata_req.eq(0),
                    )
                ).Else(
                    wdata_we.eq(0),
                    bus.ack.eq(0),
                    rdata_req.eq(0),
                    rdata_re.eq(0),
                )
            ).Elif( (bus.adr & ((0xFFFF_F000) >> 2)) == ((0x0 | prefix) >> 2),
                # fully decode microcode address to avoid aliasing
                If(bus.cyc & bus.stb & bus.we & ~bus.ack,
                    micro_wrport.adr.eq(bus.adr),
                    micro_wrport.dat_w.eq(bus.dat_w),
                    micro_wrport.we.eq(1),
                    bus.ack.eq(1),
                ).Elif(bus.cyc & bus.stb & ~bus.we & ~bus.ack,
                    micro_wrport.we.eq(0),
                    micro_rdport.adr.eq(bus.adr),
                    bus.dat_r.eq(micro_rdport.dat_r),

                    If(micro_rdack == 0, # 1 cycle delay for read to occur
                        bus.ack.eq(1),
                    ).Else(
                        bus.ack.eq(0),
                        micro_rdack.eq(micro_rdack - 1),
                    )
                ).Else(
                    micro_wrport.we.eq(0),
                    micro_rdack.eq(micro_rd_waitstates),
                    bus.ack.eq(0),
                )
            ).Else(
                # handle all mis-target reads not explicitly decoded
                If(bus.cyc & bus.stb & ~bus.we & ~bus.ack,
                    bus.dat_r.eq(0xC0DE_BADD),
                    bus.ack.eq(1),
                ).Elif(bus.cyc & bus.stb & bus.we & ~bus.ack,
                    bus.ack.eq(1), # ignore writes -- but don't hang the bus
                ).Else(
                    bus.ack.eq(0),
                )

            )
        ]

        ### execution path signals to register file
        ra_dat = Signal(rf_width_raw)
        ra_adr = Signal(log2_int(num_registers))
        ra_const = Signal()
        r_shift = Signal()
        rb_dat = Signal(rf_width_raw)
        rb_adr = Signal(log2_int(num_registers))
        rb_const = Signal()
        wd_dat = Signal(rf_width_raw)
        wd_adr = Signal(log2_int(num_registers))
        wd_bwe = Signal(rf_width_raw//8, reset = 0xFFFF_FFFF)
        rf_write = Signal()

        r_dat_f = Array(Signal(granule_num_bits-1, reset = 0) for x in range(4)) ## FIXME: mem ctrl is 256/2=128 bits so 1 fewer bits
        r_dat_m = Array(Signal(granule_num, reset = ((1<<(granule_num))-1)) for x in range(4))

        self.submodules.ra_const_rom = JarethConst(insert_docs=True)
        self.submodules.rb_const_rom = JarethConst()

        ### merge execution path signals with host access paths
        self.comb += [
            ra_const.eq(instruction.ca),
            rb_const.eq(instruction.cb),
            ra_adr.eq(instruction.ra),
            rb_adr.eq(instruction.rb),
            self.ra_const_rom.adr.eq(ra_adr),
            self.rb_const_rom.adr.eq(rb_adr),
            rf.window.eq(self.window.fields.window),
            r_shift.eq(instruction.shift),

            If(running & ~pause_gnt,
                rf.ra_adr.eq(Cat(ra_adr, self.window.fields.window)),
                rf.rb_adr.eq(Cat(rb_adr, self.window.fields.window)),
                rf.instruction_pipe_in.eq(instruction.raw_bits()),
                rf.wd_adr.eq(Cat(wd_adr, self.window.fields.window)),
                rf.wd_dat.eq(wd_dat),
                rf.wd_bwe.eq(wd_bwe),
                rf.we.eq(rf_write),
            ).Else(
                rf.ra_adr.eq(radr >> 3),
                rf.wd_adr.eq(wadr >> 3),
                rf.wd_dat.eq(Cat(wdata,wdata,wdata,wdata,wdata,wdata,wdata,wdata)), # replicate; use byte-enable to multiplex
                rf.wd_bwe.eq(0xF << ((wadr & 0x7) * 4)), # select the byte
                rf.we.eq(wdata_we),
            ),
            If(~ra_const,
               #ra_dat.eq((rf.ra_dat >> (Cat(Signal(granule_bits, reset = 0), r_dat_f[0]))) & Cat(Replicate(r_dat_m[0][0], 8), Replicate(r_dat_m[0][1], 8), Replicate(r_dat_m[0][2], 8), Replicate(r_dat_m[0][3], 8), Replicate(r_dat_m[0][4], 8), Replicate(r_dat_m[0][5], 8), Replicate(r_dat_m[0][6], 8), Replicate(r_dat_m[0][7], 8), Replicate(r_dat_m[0][8], 8), Replicate(r_dat_m[0][9], 8), Replicate(r_dat_m[0][10], 8), Replicate(r_dat_m[0][11], 8), Replicate(r_dat_m[0][12], 8), Replicate(r_dat_m[0][13], 8), Replicate(r_dat_m[0][14], 8), Replicate(r_dat_m[0][15], 8), Replicate(r_dat_m[0][16], 8), Replicate(r_dat_m[0][17], 8), Replicate(r_dat_m[0][18], 8), Replicate(r_dat_m[0][19], 8), Replicate(r_dat_m[0][20], 8), Replicate(r_dat_m[0][21], 8), Replicate(r_dat_m[0][22], 8), Replicate(r_dat_m[0][23], 8), Replicate(r_dat_m[0][24], 8), Replicate(r_dat_m[0][25], 8), Replicate(r_dat_m[0][26], 8), Replicate(r_dat_m[0][27], 8), Replicate(r_dat_m[0][28], 8), Replicate(r_dat_m[0][29], 8), Replicate(r_dat_m[0][30], 8), Replicate(r_dat_m[0][31], 8)))
               If(~r_shift,
                  ra_dat.eq(rf.ra_dat),
               ).Else(
                   ra_dat.eq((rf.ra_dat >> (Cat(Signal(granule_bits, reset = 0), r_dat_f[0]))) & Cat([Replicate(r_dat_m[0][x], granule) for x in range(0, granule_num)]))
               )
            ).Else(
                ra_dat.eq(self.ra_const_rom.const),
            ),
            If(~rb_const,
               # rb_dat.eq(rf.rb_dat[8*r_dat_f[1]:8+8*r_dat_l[1]]),
               #Case(r_dat_f[1],
                #     {x: Case(r_dat_l[1], { y: rb_dat.eq(rf.rb_dat[x*8:(y+1)*8]) for y in range(x, 32) } ) for x in range(0, 32) }
               #)
               #rb_dat.eq((rf.rb_dat >> (Cat(Signal(granule_bits, reset = 0), r_dat_f[1]))) & Cat(Replicate(r_dat_m[1][0], 8), Replicate(r_dat_m[1][1], 8), Replicate(r_dat_m[1][2], 8), Replicate(r_dat_m[1][3], 8), Replicate(r_dat_m[1][4], 8), Replicate(r_dat_m[1][5], 8), Replicate(r_dat_m[1][6], 8), Replicate(r_dat_m[1][7], 8), Replicate(r_dat_m[1][8], 8), Replicate(r_dat_m[1][9], 8), Replicate(r_dat_m[1][10], 8), Replicate(r_dat_m[1][11], 8), Replicate(r_dat_m[1][12], 8), Replicate(r_dat_m[1][13], 8), Replicate(r_dat_m[1][14], 8), Replicate(r_dat_m[1][15], 8), Replicate(r_dat_m[1][16], 8), Replicate(r_dat_m[1][17], 8), Replicate(r_dat_m[1][18], 8), Replicate(r_dat_m[1][19], 8), Replicate(r_dat_m[1][20], 8), Replicate(r_dat_m[1][21], 8), Replicate(r_dat_m[1][22], 8), Replicate(r_dat_m[1][23], 8), Replicate(r_dat_m[1][24], 8), Replicate(r_dat_m[1][25], 8), Replicate(r_dat_m[1][26], 8), Replicate(r_dat_m[1][27], 8), Replicate(r_dat_m[1][28], 8), Replicate(r_dat_m[1][29], 8), Replicate(r_dat_m[1][30], 8), Replicate(r_dat_m[1][31], 8)))
               If(~r_shift,
                  rb_dat.eq(rf.rb_dat),
               ).Else(
                   rb_dat.eq((rf.rb_dat >> (Cat(Signal(granule_bits, reset = 0), r_dat_f[1]))) & Cat([Replicate(r_dat_m[1][x], granule) for x in range(0, granule_num)])),
               )
            ).Else(
                rb_dat.eq(self.rb_const_rom.const)
            )
        ]
        # simple machine to wait 2 RF clock cycles for data to propagate out of the register file and back to the host
        rd_wait_states=4
        bus_rd_wait = Signal(max=(rd_wait_states+1))
        self.sync.rf_clk += [
            If(rdata_req,
                If(~running | pause_gnt,
                    If(bus_rd_wait != 0,
                        bus_rd_wait.eq(bus_rd_wait-1),
                    ).Else(
                        rdata_ack.eq(1),
                    )
                )
            ).Else(
                rdata_ack.eq(0),
                bus_rd_wait.eq(rd_wait_states),
            )
        ]

        sext_immediate = Signal(log2_int(microcode_depth))
        self.comb += sext_immediate.eq(Cat(instruction.immediate, instruction.immediate[8])) # migen signed math failed us. so manually sign extend. this breaks the configurability of the code.

        ### Microcode sequencer. Very simple: it can only run linear sections of microcode. Feature not bug;
        ### constant time operation is a defense against timing attacks.

        # pulse-stretch the go from sys->eng_clk. Don't use Migen CDC primitives, as they add latency; a BlindTransfer
        # primitive on its own will take about as much time as a couple instructions on The Engine.
        engine_go = Signal()
        go_stretch = Signal(2)
        self.sync += [ # note that we will miss this if the system throttles our clocks when this pulse arrives
            If(self.control.fields.go,
                go_stretch.eq(2)
            ).Else(
                If(go_stretch != 0,
                   go_stretch.eq(go_stretch - 1),
                )
            )
        ]
        self.comb += engine_go.eq(self.control.fields.go | (go_stretch != 0))

        self.submodules.seq = seq = ClockDomainsRenamer("eng_clk")(FSM(reset_state="IDLE"))
        mpc_stop = Signal(log2_int(microcode_depth))
        window_latch = Signal(self.window.fields.window.size)
        exec = Signal()  # indicates to execution units to start running
        done = Signal()  # indicates when the given execution units are done (as-muxed from subunits)
        self.comb += rf.running.eq(~seq.ongoing("IDLE") | rdata_re),  # let the RF know when we're not executing, so it can idle to save power
        seq.act("IDLE",
            NextValue(pause_gnt, 0),
            If(engine_go,
                If(pause_req,
                    NextValue(mpc, self.mpresume.fields.mpresume)
                ).Else(
                    NextValue(mpc, self.mpstart.fields.mpstart)
                ),
                NextValue(mpc_stop, self.mpstart.fields.mpstart + self.mplen.fields.mplen - 1),
                NextValue(window_latch, self.window.fields.window),
                NextValue(running, 1),
                NextState("FETCH"),
            ).Else(
                NextValue(running, 0),
            )
        )
        seq.act("FETCH",
            If(pause_req,
                NextState("PAUSED"),
                NextValue(pause_gnt, 1),
            ).Else(
                # one cycle latency for instruction fetch
                NextState("EXEC"),
                NextValue(pause_gnt, 0),
            )
        )
        seq.act("EXEC", # not a great name. This is actually where the register file fetches its contents.
            If(instruction.opcode == opcodes["BRZ"][0],
                NextState("DO_BRZ"),
            ).Elif(instruction.opcode == opcodes["BRNZ"][0],
                NextState("DO_BRNZ"),
            ).Elif(instruction.opcode == opcodes["FIN"][0],
                NextState("IDLE"),
                NextValue(running, 0),
            ).Elif(instruction.opcode < opcodes["MAX"][0], # check if the opcode is legal before running it
                exec.eq(1),
                NextState("WAIT_DONE"),
            ).Else(
                NextState("ILLEGAL_OPCODE"),
            )
        )
        seq.act("WAIT_DONE", # this is where the actual instruction execution happens.
            If(done, # TODO: for now, we just wait for each instruction to finish; but the foundations are around for pipelining...
                If(mpc < mpc_stop,
                   NextState("FETCH"),
                   NextValue(mpc, mpc + 1),
                ).Else(
                    NextState("IDLE"),
                    NextValue(running, 0),
                )
            )
        )
        seq.act("ILLEGAL_OPCODE",
            NextState("IDLE"),
            NextValue(running, 0),
            illegal_opcode.eq(1),
        )
        seq.act("DO_BRZ",
            If(ra_dat == 0,
                If( (sext_immediate + mpc + 1 < mpc_stop) & (sext_immediate + mpc + 1 >= self.mpstart.fields.mpstart), # validate new PC is in range
                    NextState("FETCH"),
                    NextValue(mpc, sext_immediate + mpc + 1),
                ).Else(
                    NextState("IDLE"),
                    NextValue(running, 0),
                )
            ).Else(
                If(abort,
                    NextState("IDLE"),
                    NextValue(running, 0),
                ).Elif(mpc < mpc_stop,
                    NextState("FETCH"),
                    NextValue(mpc, mpc + 1),
                ).Else(
                    NextState("IDLE"),
                    NextValue(running, 0),
                )
            ),
        )
        seq.act("DO_BRNZ",
            If(ra_dat != 0,
                If( (sext_immediate + mpc + 1 < mpc_stop) & (sext_immediate + mpc + 1 >= self.mpstart.fields.mpstart), # validate new PC is in range
                    NextState("FETCH"),
                    NextValue(mpc, sext_immediate + mpc + 1),
                ).Else(
                    NextState("IDLE"),
                    NextValue(running, 0),
                )
            ).Else(
                If(abort,
                    NextState("IDLE"),
                    NextValue(running, 0),
                ).Elif(mpc < mpc_stop,
                    NextState("FETCH"),
                    NextValue(mpc, mpc + 1),
                ).Else(
                    NextState("IDLE"),
                    NextValue(running, 0),
                )
            ),
        )
        seq.act("PAUSED",
            If(~pause_req,
                NextValue(pause_gnt, 0),
                NextState("FETCH"), # could probably go directly to "EXEC", but, this is a minor detail recovering from pause
            )
        )
        
        #pad_SBUS_DATA_OE_LED = platform.request("SBUS_DATA_OE_LED")
        #led = Signal(reset = 1)
        #self.comb += pad_SBUS_DATA_OE_LED.eq(led)
        self.busls = wishbone.Interface(data_width = 128, adr_width = 28) # FIXME: hardwired (here and elsewhere)
        exec_units = {
            "exec_logic"     : ExecLogic(width=rf_width_raw),
            "exec_addsub"    : ExecAddSub(width=rf_width_raw),
            "exec_ls"        : ExecLS(width=rf_width_raw, interface=self.busls, r_dat_f=r_dat_f, r_dat_m=r_dat_m, granule=granule),
        }
        exec_units_shift = {
            "exec_logic": True,
            "exec_addsub": False,
            "exec_ls": False,
        }
        exec_unit_shift_num = { }
        index = 0
        
        for name, unit in exec_units.items():
            setattr(self.submodules, name, unit);
            setattr(self, "done" + str(index), Signal(name="done"+str(index)))
            setattr(self, "unit_q" + str(index), Signal(wd_dat.nbits, name="unit_q"+str(index)))
            setattr(self, "unit_sel" + str(index), Signal(name="unit_sel"+str(index)))
            setattr(self, "unit_wd" + str(index), Signal(log2_int(num_registers), name="unit_wd"+str(index)))
            if (exec_units_shift[name]):
                setattr(self, "unit_shift" + str(index), Signal(name="unit_shift"+str(index)))
            subdecode = Signal()
            for op in unit.opcode_list:
                self.comb += [
                    If(instruction.opcode == opcodes[op][0],
                        subdecode.eq(1)
                    )
                ]
            instruction_out = Record(instruction_layout)
            self.comb += [
                instruction_out.raw_bits().eq(unit.instruction_out)
            ]
            self.comb += [
                unit.start.eq(exec & subdecode),
                getattr(self, "done" + str(index)).eq(unit.q_valid),
                unit.a.eq(ra_dat),
                unit.b.eq(rb_dat),
                unit.instruction_in.eq(instruction.raw_bits()),
                getattr(self, "unit_q" + str(index)).eq(unit.q),
                getattr(self, "unit_sel" + str(index)).eq(subdecode),
                getattr(self, "unit_wd" + str(index)).eq(instruction_out.wd),
            ]
            if (exec_units_shift[name]):
                self.comb += [ getattr(self, "unit_shift" + str(index)).eq(instruction_out.shift), ]
            exec_unit_shift_num[index] = exec_units_shift[name]
            index += 1

        for i in range(index):
            if (exec_unit_shift_num[i]):
                self.comb += [
                    If(getattr(self, "done" + str(i)),
                       done.eq(1),  # TODO: for proper pipelining, handle case of two units done simultaneously!
                       If(getattr(self, "unit_shift" + str(i)),
                          wd_dat.eq(getattr(self, "unit_q" + str(i)) << (Cat(Signal(granule_bits, reset = 0), r_dat_f[2]))),
                          wd_adr.eq(getattr(self, "unit_wd" + str(i))),
                          wd_bwe.eq(Cat([Replicate(r_dat_m[2][x], granule//8) for x in range(0, granule_num)])),
                       ).Else(
                           wd_dat.eq(getattr(self, "unit_q" + str(i))),
                           wd_adr.eq(getattr(self, "unit_wd" + str(i))),
                           wd_bwe.eq(0xFFFF_FFFF),
                       )
                    ).Elif(seq.ongoing("IDLE"),
                           done.eq(0),
                    )
                ]
            else:
                self.comb += [
                    If(getattr(self, "done" + str(i)),
                       done.eq(1),  # TODO: for proper pipelining, handle case of two units done simultaneously!
                           wd_dat.eq(getattr(self, "unit_q" + str(i))),
                           wd_adr.eq(getattr(self, "unit_wd" + str(i))),
                           wd_bwe.eq(0xFFFF_FFFF),
                    ).Elif(seq.ongoing("IDLE"),
                           done.eq(0),
                    )
                ]

        self.comb += [
            rf_write.eq(done),
        ]
        
        self.sync += abort.eq((abort & ~engine_go) | (self.exec_ls.has_failure[0] | self.exec_ls.has_failure[1] | self.exec_ls.has_timeout[0] | self.exec_ls.has_timeout[1]))
        self.comb += self.ls_status.status.eq(self.exec_ls.state)

        ##### TIMING CONSTRAINTS -- you want these. Trust me.

        clk50 = "clk50"
        #clk100 = "clk100"
        clk100 = "sysclk"
        clk200 = "clk200"
        # registered exec units need this set of rules
        ### clk200->clk50 multi-cycle paths:
        # we architecturally guarantee extra setup time from the register file to the point of consumption:
        # read data is stable by the 3rd phase of the RF fetch cycle, and so it is in fact ready even before
        # the other signals that trigger the execute mode, hence 4+1 cycles total setup time
        platform.add_platform_command("set_multicycle_path 5 -setup -start -from [get_clocks " + clk200 + "] -to [get_clocks " + clk50 + "] -through [get_cells *rf_r*_dat_reg*]")
        platform.add_platform_command("set_multicycle_path 4 -hold -end -from [get_clocks " + clk200 + "] -to [get_clocks " + clk50 + "] -through [get_cells *rf_r*_dat_reg*]")
        ### clk200->clk100 multi-cycle paths:
        # same as above, but for the multiplier path.
        platform.add_platform_command("set_multicycle_path 3 -setup -start -from [get_clocks " + clk200 + "] -to [get_clocks " + clk100 + "] -through [get_cells *rf_r*_dat_reg*]")
        platform.add_platform_command("set_multicycle_path 2 -hold -end -from [get_clocks " + clk200 + "] -to [get_clocks " + clk100 + "] -through [get_cells *rf_r*_dat_reg*]")

        # unregistered exec units need this set of rules
        ### clk200->clk200 multi-cycle paths:
        # this is for the case when we don't register the data, and just go straight from RF out put RF input. In the worst case
        # we have three (? maybe five?) clk200 cycles to compute as we phase through the reads and writes
        platform.add_platform_command("set_multicycle_path 3 -setup -from [get_clocks " + clk200 + "] -to [get_clocks " + clk200 + "] -through [get_cells *rf_r*_dat_reg*]")
        platform.add_platform_command("set_multicycle_path 2 -hold -end -from [get_clocks " + clk200 + "] -to [get_clocks " + clk200 + "] -through [get_cells *rf_r*_dat_reg*]")

        # other paths
        ### sys->clk200 multi-cycle paths:
        # microcode fetch is stable 10ns before use by the register file, by design
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=ra_const)
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=ra_const)
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=rb_const)
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=rb_const)
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=self.ra_const_rom.adr)
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=self.ra_const_rom.adr)
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=self.rb_const_rom.adr)
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk100 + "] -through [get_nets {net}*]", net=self.rb_const_rom.adr)
        # ignore the clk200 reset path for timing purposes -- there is >1 cycle guaranteed after reset for everything to settle before anything moves on these paths
        platform.add_platform_command("set_false_path -through [get_nets " + clk200 + "_rst]")
        # ignore the clk50 reset path for timing purposes -- there is > 1 cycle guaranteed after reset for everything to settle before anything moves on these paths (applies for other crypto engines, (SHA/AES) as well)
        platform.add_platform_command("set_false_path -through [get_nets " + clk50 + "_rst]")
        ### sys->clk50 multi-cycle paths:
        # microcode fetch is guaranteed not to transition in the middle of an exec computation
        platform.add_platform_command("set_multicycle_path 2 -setup -start -from [get_clocks " + clk100 + "] -to [get_clocks " + clk50 + "] -through [get_cells microcode_reg*]")
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk50 + "] -through [get_cells microcode_reg*]")
        ### clk50->clk200 multi-cycle paths:
        # engine running will set up a full eng_clk cycle before any RF accesses need to be valid
        platform.add_platform_command("set_multicycle_path 4 -setup -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_nets {{ {net1} {net2} {net3} }}]", net1=running, net2=running_r, net3=rf.running)
        platform.add_platform_command("set_multicycle_path 3 -hold -end -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_nets {{ {net1} {net2} {net3} }}]", net1=running, net2=running_r, net3=rf.running)
        # this signal is a combo from clk50+sys
        platform.add_platform_command("set_multicycle_path 4 -setup -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins *rf_wren_pipe_reg/D]")
        platform.add_platform_command("set_multicycle_path 3 -hold -end -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins *rf_wren_pipe_reg/D]")
        # data writeback happens on phase==2, and thus is stable for at least two clk200 clocks extra
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/DI*DI*]")
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/DI*DI*]")
        platform.add_platform_command("set_multicycle_path 2 -setup -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/ADDR*ADDR*]")
        platform.add_platform_command("set_multicycle_path 1 -hold -end -from [get_clocks " + clk50 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/ADDR*ADDR*]")
        ### sys->clk200 multi-cycle paths:
        # data writeback happens on phase==2, and thus is stable for at least two clk200 clocks extra + one full eng_clk (total 25ns)
        platform.add_platform_command("set_multicycle_path 4 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/DI*DI*]")
        platform.add_platform_command("set_multicycle_path 3 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/DI*DI*]")
        platform.add_platform_command("set_multicycle_path 4 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/ADDR*ADDR*]")
        platform.add_platform_command("set_multicycle_path 3 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins RF_RAMB*/*/ADDR*ADDR*]")
        # this signal is a combo from clk50+sys
        platform.add_platform_command("set_multicycle_path 4 -setup -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins *rf_wren_pipe_reg/D]")
        platform.add_platform_command("set_multicycle_path 3 -hold -end -from [get_clocks " + clk100 + "] -to [get_clocks " + clk200 + "] -through [get_pins *rf_wren_pipe_reg/D]")
