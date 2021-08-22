from migen import *
from migen.genlib.cdc import MultiReg

from litex.soc.interconnect.csr import *
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect import wishbone
from litex.soc.interconnect.csr_eventmanager import *

prime_string = "$2^{{255}}-19$"  # 2\ :sup:`255`-19
field_latex = "$\mathbf{{F}}_{{{{2^{{255}}}}-19}}$"

opcode_bits = 6  # number of bits used to encode the opcode field
opcodes = {  # mnemonic : [bit coding, docstring]
    "UDF" : [-1, "Placeholder for undefined opcodes"],
    "PSA" : [0, "Wd $\gets$ Ra  // pass A"],
    "PSB" : [1, "Wd $\gets$ Rb  // pass B"],
    "MSK" : [2, "Wd $\gets$ Replicate(Ra[0], 256) & Rb  // for doing cswap()"],
    "XOR" : [3, "Wd $\gets$ Ra ^ Rb  // bitwise XOR"],
    "NOT" : [4, "Wd $\gets$ ~Ra   // binary invert"],
    "ADD" : [5, "Wd $\gets$ Ra + Rb  // 256-bit binary add, must be followed by TRD,SUB"],
    "SUB" : [6, "Wd $\gets$ Ra - Rb  // 256-bit binary subtraction, this is not the same as a subtraction in the finite field"],
    "MUL" : [7, f"Wd $\gets$ Ra * Rb  // multiplication in {field_latex} - result is reduced"],
    "TRD" : [8, "If Ra $\geqq 2^{{255}}-19$ then Wd $\gets$ $2^{{255}}-19$, else Wd $\gets$ 0  // Test reduce"],
    "BRZ" : [9, "If Ra == 0 then mpc[9:0] $\gets$ mpc[9:0] + immediate[9:0] + 1, else mpc $\gets$ mpc + 1  // Branch if zero"],
    "FIN" : [10, "halt execution and assert interrupt to host CPU that microcode execution is done"],
    "SHL" : [11, "Wd $\gets$ Ra << 1  // shift Ra left by one and store in Wd"],
    "XBT" : [12, "Wd[0] $\gets$ Ra[254]  // extract the 255th bit of Ra and put it into the 0th bit of Wd"],
    "MAX" : [13, "Maximum opcode number (for bounds checking)"],
}

num_registers = 32
instruction_layout = [
    ("opcode", opcode_bits, "opcode to be executed"),
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
This implements the register file for the Curve25519 engine. It's implemented using
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
        self.window = Signal(log2_int(depth) - log2_int(num_registers))

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

class Curve25519Const(Module, AutoDoc):
    def __init__(self, insert_docs=False):
        global did_const_doc
        constant_defs = {
            0: [0, "zero", "The number zero"],
            1: [1, "one", "The number one"],
            2: [121665, "am24", "The value $\\frac{{A-2}}{{4}}$"],
            3: [0x7FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFED, "field", f"Binary coding of {prime_string}"],
            4: [121666, "ap24", "The value $\\frac{{A+2}}{{4}}$"],
            5: [5, "five", "The number 5 (for pow22501)"],
            6: [10, "ten", "The number 10 (for pow22501)"],
            7: [20, "twenty", "The number 20 (for pow22501)"],
            8: [50, "fifty", "The number 50 (for pow22501)"],
            9: [100, "one hundred", "The number 100 (for pow22501)"],
            10: [254, "two hundred fifty four", "The number 254 (iteration count)"],
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
            self.constants = ModuleDoc(title="Curve25519 Constants", body=constant_str)

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

        self.a = Signal(width)
        self.b = Signal(width)
        self.q = Signal(width)
        self.start = Signal()
        self.q_valid = Signal()
        # pipeline the instruction
        self.instruction_in = Signal(len(self.instruction))
        self.instruction_out = Signal(len(self.instruction))

        self.opcode_list = opcode_list
        self.comb += [
            self.instruction.raw_bits().eq(self.instruction_in)
        ]

class ExecMask(ExecUnit):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["MSK"], insert_docs=True)  # we insert_docs to be true for exactly once module exactly once
        self.intro = ModuleDoc(title="Masking ExecUnit Subclass", body=f"""
This execution unit implements the bit-mask and operation. It takes Ra[0] (the
zeroth bit of Ra) and replicates it to {str(width)} bits wide, and then ANDs it with
the full contents of Rb. This operation is introduced as one of the elements of
the `cswap()` routine, which is a constant-time swap of two variables based on a `swap` flag.

Here is an example of how to swap the contents of `ra` and `rb` based on the value of the 0th bit of `swap`::

  XOR  dummy, ra, rb       // dummy $\gets$ ra ^ rb
  MSK  dummy, swap, dummy  // If swap[0] then dummy $\gets$ dummy, else dummy $\gets$ 0
  XOR  ra, dummy, ra       // ra $\gets$ ra ^ dummy
  XOR  rb, dummy, rb       // rb $\gets$ rb ^ dummy
""")
        self.sync.eng_clk += [
            self.q_valid.eq(self.start),
            self.instruction_out.eq(self.instruction_in),
        ]
        self.comb += [
            self.q.eq(self.b & Replicate(self.a[0], width)),
        ]

class ExecLogic(ExecUnit):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["XOR", "NOT", "PSA", "PSB", "XBT", "SHL"])
        self.intro = ModuleDoc(title="Logic ExecUnit Subclass", body=f"""
This execution unit implements bit-wise logic operations: XOR, NOT, and
passthrough.

* XOR returns the result of A^B
* NOT returns the result of !A
* PSA returns the value of A
* PSB returns the value of B
* SHL returns A << 1
* XBT returns the 255th bit of A, reported in the 0th bit of the result

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
            ).Elif(self.instruction.opcode == opcodes["XBT"][0],
                self.q.eq(Cat(self.a[254], zeros))
            ).Elif(self.instruction.opcode == opcodes["SHL"][0],
                self.q.eq(Cat(0, self.a[:255])),
            ),
        ]

class ExecAddSub(ExecUnit, AutoDoc):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["ADD", "SUB"])
        self.notes = ModuleDoc(title="Add/Sub ExecUnit Subclass", body=f"""
This execution module implements 256-bit binary addition and subtraction.

Note that to implement operations in $\mathbf{{F}}_p$, where *p* is $2^{{255}}-19$, this must be compounded
with other operators as follows:

Addition of Ra + Rb into Rc in {field_latex}:

.. code-block:: c

  ADD Rc, Ra, Rb    // Rc <- Ra + Rb
  TRD Rd, Rc        // Rd <- ReductionValue(Rc)
  SUB Rc, Rc, Rd    // Rc <- Rc - Rd

Negation of Ra into Rc in {field_latex}:

.. code-block:: c

  SUB Rc, #FIELDPRIME, Ra   //  Rc <- 2^255-19 - Ra

Note that **#FIELDPRIME** is one of the 32 available hard-coded constants
that can be substituted for any register in any arithmetic operation, please
see the section on "Constants" for more details.

Subtraction of Ra - Rb into Rc in {field_latex}:

.. code-block:: c

  SUB Rb, #FIELDPRIME, Rb   //  Rb <- 2^255-19 - Rb
  ADD Rc, Ra, Rb    // Rc <- Ra + Rb
  TRD Rd, Rc        // Rd <- ReductionValue(Rc)
  SUB Rc, Rc, Rd    // Rc <- Rc - Rd

In all the examples above, Ra and Rb must be members of {field_latex}.
        """)

        self.sync.eng_clk += [
            self.q_valid.eq(self.start),
            self.instruction_out.eq(self.instruction_in),
        ]
        self.comb += [
            If(self.instruction.opcode == opcodes["ADD"][0],
               self.q.eq(self.a + self.b),
            ).Elif(self.instruction.opcode == opcodes["SUB"][0],
               self.q.eq(self.a - self.b),
            ),
        ]

class ExecTestReduce(ExecUnit, AutoDoc):
    def __init__(self, width=256):
        ExecUnit.__init__(self, width, ["TRD"])

        self.notes = ModuleDoc(title="Modular Reduction Test ExecUnit Subclass", body=f"""
First, observe that $2^n-19$ is 0x07FF....FFED.
Next, observe that arithmetic in the field of {prime_string} will never set
the 256th bit.

Modular reduction must happen when an arithmetic operation
overflows the bounds of the modulus. When this happens, one must
subtract the modulus (in this case {prime_string}).

The reduce operation is done in two halves. The first half is
to check if a reduction must happen. The second is to do the subtraction.
In order to allow for constant-time operation, we always do the subtraction,
even if it is not strictly necessary.

We use this to our advantage, and compute a reduction using
a test operator that produces a residue, and a subtraction operation.

It's up to the programmer to ensure that the two instruction sequence
is never broken up.

Thus the reduction algorithm is as follows:

1. TestReduce
  - If the 256th bit is set (e.g, ra[255]), then return {prime_string}
  - If bits ra[255:5] are all 1, and bits ra[4:0] are greater than or equal to 0x1D, then return {prime_string}
  - Otherwise return 0
2. Subtract
  - Subtract the return value of TestReduce from the tested value

        """)
        self.sync.eng_clk += [
            self.q_valid.eq(self.start),
            self.instruction_out.eq(self.instruction_in),
        ]
        self.comb += [
            If( (self.a >= 0x7FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFED),
                self.q.eq(0x7FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFED)
            ).Else(
                self.q.eq(0x0)
            ),
        ]

class ExecMul(ExecUnit, AutoDoc):
    def __init__(self, width=256, sim=False):
        ExecUnit.__init__(self, width, ["MUL"])

        self.sync.eng_clk += [ # pipeline the instruction
            self.instruction_out.eq(self.instruction_in),
        ]
        self.notes = ModuleDoc(title=f"Multiplication in {field_latex} ExecUnit Subclass", body=f"""
Unlike the ADD/SUB module, this operator explicitly works in {field_latex}. It takes in two inputs,
Ra and Rb, and both must be members of {field_latex}. The result is also reduced to a member of {field_latex}.

The multiplier is designed with a separate clock, `mul_clk` so that it can be remapped to a faster
domain than `engine_clk` for better performance. The nominal target for `mul_clk` is 100MHz.

The base algorithm for this implementation is lifted from the paper "Compact and Flexible FPGA Implementation
of Ed25519 and X25519" by Furkan Turan and Ingrid Verbauwhede (https://doi.org/10.1145/3312742).  The algorithm
specified in this paper is optimized for the DSP48E blocks found inside a 7-Series Xilinx FPGA. In particular,
we can compute 17-bit multiplies using this hardware block, and 255 divides evenly into 17 to produce
a requirement of 15x DSP48E blocks.

At a high level, the steps to compute the multiplication are:

1. Schoolbook multiplication
2. Collapse partial sums
3. Propagate carries
4. Is the sum $\geq$ $2^{{255}}-19$?
5. If yes, add 19; else add 0
6. Propagate carries again, in case the addition by 19 causes overflows

The multiplier would run about 30% faster if step (6) were skipped. This step happens
in a fairly small minority of cases, maybe a fraction of 1%, and the worst-case
carry propagate through every limb (mathspeak for "digits") is diminishingly rare. The test for
whether or not to propagate carries is fairly straightforward. However, short-circuiting
the carry propagate step based upon the properties of the data creates
a timing side-channel. Therefore, we prefer a slower but safer implementation, even if
we are spending a bunch of cycles propagating zeros most of the time.

A constant-time optimization would be for the multiplier to simply produce a 256-bit
result, and then use a subsequent TRD/SUB instruction pair. However, the non-pipelined
version of the engine25519 executes at a rate of 60ns per instruction, or 120ns total to
compute the TRD/SUB combination, whereas iterating through the carry propagates
would take 140ns total (as the mul core runs 2x clock speed of the rest of the engine).
This is basically a wash.

However, if pipelining (and bypassing) were implemented, this might become a viable
optimization, but bypassing such a wide core would also have resource and speed
implications of its own.

The above steps are coordinated by the `mseq` state machine. Control lines for
the DSP48E blocks are grouped into two sets, one controls the global state of
things such as the operation mode and input modes, and the other controls the
routing of individual 17-bit limbs (e.g. "digits" of our 17-bit representation of
numbers) to various sources and destinations.

The following sections walk through the algorithm in detail.

Schoolbook Multiplication
-------------------------

The first step in the algorithm is called "schoolbook multiplication". It's
almost that, but with a twist. Below is what actual schoolbook multiplication
would be like, if you had a pair of numbers that were broken into three "limbs" (digits)
A[2:0] and B[2:0].

::

                   |    A2        A1       A0
    x              |    B2        B1       B0
   ------------------------------------------
                   | A2*B0     A1*B0    A0*B0
            A2*B1  | A1*B1     A0*B1
   A2*B2    A1*B2  | A0*B2
     (overflow)         (not overflowing)

The result of schoolbook multiplication is a result that potentially has
2x the number of limbs than the either multiplicand.

Mapping the overflow back into the prime field (e.g. wrapping the overflow around)
is a process called reduction. It turns out that for
a prime field like {field_latex}, reduction works out to taking the limbs that
extend beyond the base number of limbs in the field, shifting them right by the
number of limbs, multiplying it by 19, and adding it back in; and if the result
isn't a member of the field, add 19 one last time, and take the result as just
the bottom 255 bits (ignore any carry overflow).

This trick works because the form of the field is $2^{{n}}-p$: it is a power
of 2, reduced by some small amount $p$. By starting from a power of 2,
most of the binary numbers representable in an n-bit word are valid members of
the field. The only ones that are not valid field members are the numbers that are equal
to $2^{{n}}-p$ but less than $2^{{n}}-1$ (the biggest number that fits in n bits).
To turn these invalid binary numbers into members of the field, you just need
to add $p$, and the reduction is complete.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/reduction_diagram.png
   :alt: A diagram illustrating modular reduction

The diagram above draws out the number lines for both a simple binary number line,
and for some field $\mathbf{{F}}_{{{{2^{{n}}}}-p}}$. Both lines start at 0 on the left,
and increment until they roll over. The point at which $\mathbf{{F}}_{{{{2^{{n}}}}-p}}$
rolls over is a distance $p$ from the end of the binary number line: thus, we can
observe that $2^{{n}}-1$ reduces to $p-1$. Adding 1 results in $2^{{n}}$, which reduces
to $p$: that is, the top bit, wrapped around, and multiplied
it by $p$.

As we continue toward the right, the numbers continue to go up and wrap around, and
for each wrap the distance between the binary wrap point and the $\mathbf{{F}}_{{{{2^{{n}}}}-p}}$
wrap point increases by a factor of $p$, such that $2^{{n+1}}$ reduces to $2*p$. Thus modular
reduction of natural binary numbers that are larger than our field $2^{{n}}-p$
consists of taking the bits that overflow an $n$-bit representation, shifting them to
the right by $n$, and multiplying by $p$.

A more tractable example to compute than {field_latex} is the field $\mathbf{{F}}_{{{{2^{{6}}}}-5}} = 59$.
The members of the field are from 0-58, and reduction is done by taking any number modulo 59. Thus,
the number 59 reduces to 0; 60 reduces to 1; 61 reduces to 2, and so forth, until we get to 64, which
reduces to 5 -- the value of the overflowed bits (1) times $p$.

Let's look at some more examples. First, recall that the biggest member of the
field, 58, in binary is 0b00_11_1010.

Let's consider a simple case where we are presented a partial sum that overflows
the field by one bit, say, the number 0b01_11_0000, which is decimal 112. In this case, we take
the overflowed bit, shift it to the right, multiply by 5:

  0b01_11_0000
     ^ move this bit to the right multiply by 0b101 (5)
  0b00_11_0000 + 0b101 = 0b00_11_0101 = 53

And we can confirm using a calculator that 112 % 59 = 53. Now let's overflow
by yet another bit, say, the number 0b11_11_0000. Let's try the math again:

  0b11_11_0000
     ^ move to the right and multiply by 0b101: 0b101 * 0b11 = 0b1111
  0b00_11_0000 + 0b1111 = 0b00_11_1111

This result is still not a member of the field, as the maximum value is 0b0011_1010.
In this case, we need to add the number 5 once again to resolve this "special-case"
overflow where we have a binary number that fits in $n$ bits but is in that sliver
between $2^{{n}}-p$ and $2^{{n}}-1$:

  0b00_11_1111 + 0b101 = 0b01_00_0100

At this step, we can discard the MSB overflow, and the result is 0b0100 = 4;
and we can check with a calculator that 240 % 59 = 4.

Therefore, when doing schoolbook multiplication, the partial products that start to
overflow to the left can be brought back around to the right hand side, after
multiplying by $p$, in this case, the number 19. This magical property is one
of the reasons why {field_latex} is quite amenable to math on binary machines.

Let's use this finding to rewrite the straight schoolbook
multiplication form from above, but now with the modular reduction applied to
the partial sums, so it all wraps around into this compact form:
::

                   |    A2        A1       A0
    x              |    B2        B1       B0
   ------------------------------------------
                   | A2*B0     A1*B0    A0*B0
                   | A1*B1     A0*B1 19*A2*B1
                 + | A0*B2  19*A2*B2 19*A1*B2
                 ----------------------------
                        S2        S1       S0

As discussed above, each overflowed limb is wrapped around and multiplied by 19,
creating a number of partial sums S[2:0] that now has as many terms as
there are limbs, but with each partial sum still potentially
overflowing the native width of the limb. Thus, the inputs to a limb are 17 bits wide,
but we retain precision up to 48 bits during the partial sum stage, and then do a
subsequent condensation of partial sums to reduce things back down to 17 bits again.
The condensation is done in the next three steps, "collapse partial sums", "propagate carries",
and finally "normalize".

However, before moving on to those sections, there is an additional trick we need
to apply for an efficient implementation of this multiplication step in hardware.

In order to minimize the amount of data movement, we observe that for each row,
the "B" values are shared between all the multipliers, and the "A" values are
constant along the diagonals. Thus we can avoid re-loading the "A" values every
cycle by shifting the partial sums diagonally through the computation, allowing
the "A" values to be loaded as "A" and "A*19" into holding register once before
the computations starts, and selecting between the two options based on the step
number during the computation.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/mapping.png
   :alt: Mapping schoolbook multiply onto the hardware array to minimize data movement

The diagram above illustrates how the schoolbook multiply is mapped onto the hardware
array. The top diagram is an exact redrawing of the previous text box, where the
partial sums that would extend to the left have been multiplied by 19 and wrapped around.
Each colored block corresponds to a given DSP48E1 block. The red arrow
illustrates the path of a partial sum in both the schoolbook form and the unwrapped
form for hardware implementation. In the bottom diagram, one can clearly see that
the Ax coefficients are constant for each column, and that for each row, the Bx
values are identical across all blocks in each step. Thus each column corresponds to
a single DSP48E1 block. We take advantage of the ability of the DSP48E1 block to
hold two selectable A values to pre-load Ax and Ax*19 before the computation starts, and
we bus together the Bx values and change them in sequence with each round. The
partial sums are then routed to the "down and right" to complete the mapping. The final
result is one cycle shifted from the canonical mapping.

We have a one-cycle structural pipeline delay going from this step to the next one, so
we use this pipeline delay to do a shift with no add by setting the `opmode` from `C+M` to
`C+0` (in other words, instead of adding to the current multiplication output for the last
step, we squash that input and set it to 0).

The fact that we pipeline the data also gives us an opportunity to pick up the upper limb
of the partial sum collapse "for free" by copying it into the "D" register of the DSP48E1
during the shift step.

In C, the code basically looks like this:

.. code-block:: c

   // initialize the a_bar set of data
   for( int i = 0; i < DSP17_ARRAY_LEN; i++ ) {{
      a_bar_dsp[i] = a_dsp[i] * 19;
   }}
   operand p;
   for( int i = 0; i < DSP17_ARRAY_LEN; i++ ) {{
      p[i] = 0;
   }}

   // core multiply
   for( int col = 0; col < 15; col++ ) {{
     for( int row = 0; row < 15; row++ ) {{
       if( row >= col ) {{
         p[row] += a_dsp[row-col] * b_dsp[col];
       }} else {{
         p[row] += a_bar_dsp[15+row-col] * b_dsp[col];
       }}
     }}
   }}

This completes in 15 cycles.

Collapse Partial Sums
---------------------

The potential width of the partial sum is up to 43 bits wide (according to
the paper cited above; the native partial sum precision of the DSP48E1 is 48 bits).
This step divides the partial sums up into 17-bit words, and then shifts the higher
to the next limbs over, allowing them to collapse into a smaller sum that
overflows less.

::

   ... P2[16:0]   P1[16:0]      P0[16:0]
   ... P1[33:17]  P0[33:17]     P14[33:17]*19
   ... P0[50:34]  P14[50:34]*19 P13[50:34]*19

Again, the magic number 19 shows up to allow sums which "wrapped around"
to add back in. Note that in the timing diagram below, we refer to the
mid- and upper- words of the shifted partial sums as "Q" and "R" respectively,
because the timing diagram lacks the width within a data bubble to
write out the full notation: so `Q0,1` is P14[33:17] and `R0,2` is P13[50:34] for P0[16:0].

This is what the C code equivalent looks like for this operation.

.. code-block:: c

     // the lowest limb has to handle two upper limbs wrapping around (Q/R)
     prop[0] = (p[0] & 0x1ffff) +
       (((p[14] * 1) >> 17) & 0x1ffff) * 19 +
       (((p[13] * 1) >> 34) & 0x1ffff) * 19;
     // the second lowest limb has to handle just one limb wrapping around (Q)
     prop[1] = (p[1] & 0x1ffff) +
       ((p[0] >> 17) & 0x1ffff) +
       (((p[14] * 1) >> 34) & 0x1ffff) * 19;
     // the rest are just shift-and-add without the modular wrap-around
     for(int bitslice = 2; bitslice < 15; bitslice += 1) {{
         prop[bitslice] = (p[bitslice] & 0x1ffff) + ((p[bitslice - 1] >> 17) & 0x1ffff) + ((p[bitslice - 2] >> 34));
     }}

This completes in 2 cycles after a one-cycle pipeline stall delay penalty to retrieve
the partial sum result from the previous step.

Propagate Carries
-----------------

The partial sums will generate carries, which need to be propagated down the
chain. The C-code equivalent of this looks as follows:

.. code-block:: c

   for(int i = 0; i < 15; i++) {{
     if ( i+1 < 15 ) {{
        prop[i+1] = (prop[i] >> 17) + prop[i+1];
        prop[i] = prop[i] & 0x1ffff;
     }}
   }}

This completes in 14 cycles.

Normalize
---------

We're almost here, except that $0 \leq result \leq 2^{{256}}-1$, which is slightly
larger than the range of {field_latex}.

Thus we need to check if number is somewhere in between 0x7ff....ffed and
0x7ff....ffff, or if the 256th bit will be set. In these cases, we need to add 19 to
the result, so that the result is a member of the field $2^{{255}}-19$ (the 256th bit
is dropped automatically when concatenating the fifteen 17-bit limbs together).

We use the DSP48E1 block to help accelerate the test for this case, so that it
can complete in a single cycle without slowing down the machine. We use the "pattern
detect" (PD) feature of the DSP48E1 to check for all "1's" in bit positions 255-5, and a
single LUT to compare the final 5 bits to check for numbers between {prime_string} and
$2^{{255}}-1$. We then OR this result with the 256th bit.

If the result falls within this special "overflow" case, we add the number 19, otherwise,
we add 0. Note that this add-by-19-or-0 step is implemented by pre-loading the number 19 into the A:B
pipeline registers of the DSP4E1 block during the "propagate" stage. Selection of
whether to add 19 or 0 relies on the fact that the DSP48E1 block has an input multiplexer
to its internal adder that can pick data from multiple sources, including the ability to
pick no source by loading the number 0. Thus the operation mode of the DSP48E1 is adjusted
to either pull an input from A:B (that is, the number 19) or the number 0, based on the
result of the overflow computation. Thus the PD feature is important in preventing this
step from being rate-limiting. With the PD feature we only have to check an effective 16
intermediate results, instead of 256 raw bits, and then drive set the operation mode of
the ALU.

Thus, this operation completes in a single cycle.

After adding the number 19, we have to once again propagate carries. Even if we add the number
0, we also have to "propagate carries" for constant-time operation. This is done by
running the carry propagate operation described above a second time.

Once the second carry propagate is finished, we have the final result.

Potential corner case
---------------------

There is a potential corner case where if the carry-propagated result going into
"normalize" is between

  0xFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFDA and
  0xFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFEC

In this case, the top bit would be wrapped around, multiplied by 19, and added to
the LSB, but the result would not be a member of $2^{{255}}-19$ (it would be one
of the 19 numbers just short of $2^{{255}}-1$), and the multiplier would pass it
on as if it were a valid result.

In some cases, this isn't even a problem, because if the subsequent result goes through
any operation that includes a "TRD" instruction, it should reduce the number
correctly.

However, I do not think this corner case is possible, because the overflow path to set the
high bit is from the top limb going from 0x1_FFFF -> 0x2_0000 (that is, 0x7FFFC -> 0x80000
when written MSB-aligned) due to a carry coming in from the lower limb, and
it would require the carry to be very large, not just +1 as shown in the simple
rollover case, but a value from 0x1_FFED-0x1_FFDB.

I don't have a formal mathematical proof of this, but I strongly suspect that
carry values going into the top limb cannot approach these large numbers, and therefore
it is not possible to hit this corner case.

In the case that it _could_ be hit, the fix would be to add an additional
detection stage to handle the case that the result is not normalized, and
to add 19 to the final sum. This can be accelerated to a single cycle by also
adding 1 into the partial products, short-circuiting the carry propagate because
this should be the only special case we're trying to check for (we should definitely
not be able to re-overflow because we are only adding at most 19 to the final result
in the previous step).

It'd be great to have a real mathematician comment if this is a real corner case.

Maybe this is a more solid reasoning why this corner case can't happen:

The biggest value of a partial sum is 0x53_FFAC_0015 (0x1_FFFF * 0x1_FFFF * 15).
This means the biggest value of the third overflowed 17-bit limb is 0x14. Therefore
the biggest value resulting from the "collapse partial sums" stage is
0x1_FFFF + 0x1_FFFF + 0x14 = 0x4_0012. Thus the largest carry term that has
to propagate is 0x4_0012 >> 17 = 2. 2 is much smaller than the amount required
to trigger this condition, that is, a value in the range of 0x1_FFED-0x1_FFDB.
Thus, perhaps this condition simply can't happen?

""")
        # array of 15, 17-bit wide signals = 255 bits
        a_17 = [Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),
                Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),
                Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),]
        b_17 = [Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),
                Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),
                Signal(17),Signal(17),Signal(17),Signal(17),Signal(17),]
        # split incoming data into 17-bit wide chunks
        for i in range(15):
            self.comb += [
                a_17[i].eq(self.a[i*17:i*17+17]),
                b_17[i].eq(self.b[i*17:i*17+17]),
            ]

        # signals common to all DSP blocks
        dsp_alumode = Signal(4)
        dsp_opmode = Signal(7)
        dsp_reset = Signal()
        dsp_a1_ce = Signal()
        dsp_a2_ce = Signal()
        dsp_b1_ce = Signal()
        dsp_b2_ce = Signal()
        dsp_d_ce = Signal()
        dsp_p_ce = Signal()
        self.comb += [
            dsp_reset.eq(ResetSignal()),
            dsp_b1_ce.eq(0), # not used
        ]
        zeros = Signal(48, reset=0)  # dummy zeros signals to tie off unused bits of the DSP48E
        self.comb += zeros.eq(0)

        step = Signal(max=15+1)  # controls the multiplication step
        prop = Signal() # count the propagations

        for i in range(15):
            # create all the per-block DSP signals before we loop through and connect them
            setattr(self, "dsp_a" + str(i), Signal(48, name="dsp_a" + str(i)))
            setattr(self, "dsp_b" + str(i), Signal(17, name="dsp_b" + str(i)))
            setattr(self, "dsp_c" + str(i), Signal(48, name="dsp_c" + str(i)))
            setattr(self, "dsp_d" + str(i), Signal(17, name="dsp_d" + str(i)))
            setattr(self, "dsp_match" + str(i), Signal(name="dsp_match"+str(i)))
            setattr(self, "dsp_p" + str(i), Signal(48, name="dsp_p"+str(i)))
            setattr(self, "dsp_p_ce" + str(i), Signal(48, name="dsp_p_ce"+str(i)))
            setattr(self, "dsp_inmode" + str(i), Signal(5, name="dsp_inmode"+str(i)))

        self.timing = ModuleDoc(title="Detailed timing operation", body="""

Below is a detailed timing diagram that illustrates the expected sequence of events
by the implementation of this code.

Signal descriptions:

* `clk` is `mul_clk`, nominally 100MHz (2x engine clock)
* `go` is the signal from the microcode sequencer to latch inputs and start computation
* `self.a` is the `a` operand
* `self.b` is the `b` operand
* `state` is the current `mseq` state machine's state
* `step` is a counter used by `mseq` to control how many iterations to run in a given state
* `prop` is a counter used to count which iteration of the carry propagate we're on
* `dsp.a`-`dsp.d` is the `a-d` inputs to the DSP48E1 blocks
* `A1_CE` is the enable to the A1 pipe register. Note that we configure 2x pipeline registers on the A input.
* `A1` is a pipe register internal to the DSP48E1 block
* `A2_CE` is the enable to the A2 pipe register
* `A2` is a pipe register internal to the DSP48E1 block
* `B2_CE` is the enable to the B2 pipe register. Note that we configure 1x pipeline registers on the B input, and when 1x register is selected, the second pipe register (B2) is used. Thus there is no B1 register.
* `B2` is a pipe register internal to the DSP48E1 block
* `C` is the C input value. Note that this one input is *not* pipelined, and thus there is no register enable for it. Because it is not pipelined it's also likely to be critical-path. We use this mainly to loop P results back into the ALU with masking operations applied within a single cycle.
* `D_CE` is the enable to the D pipe register. There is only one possible D register in the DSP48E1
* `D` is a pipe register internal to the DSP48E1 block that feeds the pre-adder
* `inmode` configures the input mode to the DSP48E1 ALU blocks. It is not pipelined and allows us to re-route data from A, B, C, and D to various ALU internals.
* `opmode` configures what computation to perform by the DSP48E1 ALU on the current cycle. It is not pipelined.
* `P_CE` is the enable for the output product register.
* `P` is the output product register presented by the DSP48E1 ALU.
* `overflow` is the overflow detection output from the DSP48E1 ALU. Its result timing is synchronous with the `P` register.
* `done` is the signal from the multiplier back to the microcode sequencer to latch the result and finish computation

.. wavedrom::
  :caption: Detailed timing of the multiply operation

  { "config": {skin : "default"},
  "signal" : [
  { "name": "clk",         "wave": "p......|.........|.......|....." },
  { "name": "go",          "wave": "010..........................10" },
  { "name": "self.a",      "wave": "x2...........................2.", "data": ["A0[255:0]","A1[255:0]"] },
  { "name": "self.b",      "wave": "x2...........................2.", "data": ["B0[255:0]","B1[255:0]"] },
  { "name": "state",       "wave": "2.34......5555...|..86...|..923", "data":["IDLE","SETA","MPY","DLY","PLSB","PMSB","PROP","NORM","PROP","DONE","IDLE","SETA"]},
  { "name": "step",        "wave": "x..2===|==5...55|5556.666|66xxx", "data":["0","1", "2", "3","13","14","0","1","2","11","12","13","0","1","2","11","12","13"]},
  { "name": "prop",        "wave": "x.........5.....|...6....|..xxx", "data":["0","1"]},
  { "name": "dsp.a",       "wave": "x2x2x.....8x.................2x", "data": ["A0xx","A19","0", "A1xx"] },
  { "name": "dsp.b",       "wave": "x2====|==x55xxxxxxx8xx.......2=", "data": ["19","B00","B01","B02","B03","B13","B14","1or19","1or19","19","19","B1_00"] },
  { "name": "dsp.c",        "wave": "x...2===|=x5x5...|..x6...|..xxx", "data":["Q0","Q1","Q2","Q3","Q13","P0,0","C* >> 17    ","C* >> 17    "]},
  { "name": "dsp.d",        "wave": "x.........55x.xxxxxx...xxxxxxx.", "data":["*Q0,1","R0,2"]},
  {},
  { "name": "A1_CE",       "wave": "1.010.....10..................." },
  { "name": "A1",          "wave": "x.2.2......8.........x.........", "data": ["A0xx","A0xx*19","0"] },
  { "name": "A2_CE",       "wave": "0..10......10.................." },
  { "name": "A2",          "wave": "x...2.......8........x.........", "data":["A0xx","0"] },
  { "name": "B2_CE",       "wave": "01.......01.0......10.........." },
  { "name": "B2",          "wave": "x.22===|==x55xxxx.xx8x.........", "data": ["19","B00","B01","B02","B03","B13","B14","1or19","1or19","19"] },
  { "name": "C",           "wave": "x...2===|==555...|..86...|..x..", "data": ["Q0","Q1","Q2","Q3","Q13","Q14","P0,0","*P","C* >> 17    ","C&","C* >> 17    "] },
  { "name": "D_CE",        "wave": "0.........1.0.................." },
  { "name": "D",           "wave": "x..........55xx................", "data": ["Q0,1","R0,2","QS14,1","RS14,2","QS14,1","RS14,2"] },
  { "name": "inmode",      "wave": "x.2.2.....x5.x.xx.xx8x.........", "data":["A1B2","AnB2","DB2","0B2"]},
  { "name": "opmode",      "wave": "x.2.=.....2555...|..86...|..xxx", "data":["M","C+M","C+0","C+M","P+M","C+P","AB/0+C","C+P"]},
  {},
  { "name": "P_CE",        "wave": "0.1.....|....5555|5516666|660.1", "data": ["P1", "P2", "P3","P4","P13","P14","P1", "P2", "P3","P4","P13","P14"] },
  { "name": "P",           "wave": "x..2====|===55555|5552666|666x.", "data": ["A19","P0","P1","P2","P3","P13","P14","P0","PLSB","PMSB","C1","C2","C3","C12", "C13","C14","S+","C1","C2","C3","C12", "C13","C14","final"] },
  { "name": "overflow",    "wave": "x...................2x.........", "data":["Y/N"]},
  { "name": "done",        "wave": "0...........................10." },
  ]}

Notes:

1. the final product sum on the first DLY cycle is just a shift to get the
  product results into the right unit. Thus, for the load of `dsp.d` `*Q0,1`, it needs
  to pick the result off of the neighboring DSP unit, because it needs to acquire the value
  before the final shift.
2. The `S+` on the P line is the non-normalized sum. This is basically the final result, but
   sometimes with the 19 added to the least significant limb, in the case that the result is greater than
   or equal to $2^{{255}}-19$. This addition must be propagated through the whole result.
3. The "done" state is slightly more complicated than illustrated here. Because the multiplier runs at
   twice the speed of the sequencing engine (two `mul_clk` per `eng_clk`), "done" actually spans between
   2 and 3 states. In the case that the computation finishes in-phase with the slower engine clock, we assert
   "done" for two cycles. In the case that we finish out of phase, have to wait a half `eng_clk` cycle
   (one state in `mul_clk`) before asserting the done pulse for two `mul_clk` cycles (thus 3 total cycles).
   The computation is fixed-time, so the determination of how many wait states is done at the design stage and
   hard-coded. However, anytime the algorithm is adjusted, the designer needs to re-check the number of
   cycles it took and pick the correct "done" sequencing.

          """)

        self.diagrams = ModuleDoc(title="Dataflow Diagrams", body="""

Here's a collection of data flow diagrams that help illustrate how to configure the DSP48E1 block.
The DSP48E1 block has a lot of configuration options, so instead of overlaying on the messy overall
diagram of the DSP48E1, we simplify its construction and draw only the pieces relevant to each phase
of the algorithm.

There's no substitute for consulting Xilinx UG479 (https://www.xilinx.com/support/documentation/user_guides/ug479_7Series_DSP48E1.pdf),
but if you're just getting started here's a few breadcrumbs to help you steer around the block.

1. The block contains a pre-adder, multiplier, and "ALU".
2. It has four major inputs, A, B, C, and D. A/B are typically multiplier inputs, C is mostly intended for carry propagation and shuttling partial sums, and D is a pre-adder input. Thus a common form of computation is P = (A+D)*B + C.
3. Almost any input can be zero'd out, and so if you wanted to compute just A*B, what is actually computed is (A+D)*B + C but with the C and D values zero'd out. This is controlled by combinations of `inmode` and `opmode`.
4. Inputs A-D and output P can all be registered, and for this implementation we put two registers on A, one register on B, zero registers on C, one register on D, and one register on P.
5. Inputs A and B can have two pipeline registers. While the datasheet makes it look like you could be able to selectively write from the DSP48E1 input to either A1/A2 or B1/B2, in fact, you can't.
  A2 can only get a value from A1 (thus setting A2 necessitates overwriting the value in A1). However, you can gate the A2's enable, so it can hold a value indefinitely, and the multiplier can route an input from either A1 or A2. We use this to our advantage and load `dsp.a` into the A2 register, and `dsp.a*19` into the A1 register, and then use the `inmode` configuration to switch between these two inputs based on which partial sum we're computing at the moment.
  I think normally this feature is used to implement pipelining and pipeline bypassing in other applications, and we are slightly abusing it here to our advantage.
6. Because we configured C to have no input register, it can be used for cycle-to-cycle feedback of partial sums.
  Introducing an input register here (per DRC recco spit out by Vivado) could speed up the clock rate but it also introduces a single-cycle stall every time we have to do a partial sum feedback, which is a greater performance impact for our implementation.
7. The "ALU" part of the DSP48E1 is used as the partial sum adder in our implementation (but it can also do logic operations and other fun things that we don't need). It actually adds four numbers: P <- X + Y + Z + Carry bit.
  We don't use the carry "bit" as it is only one-bit wide and we are propagating several bits of carry at once, so it is hard-wired to 0. X/Y/Z are up to 48 bits wide, and allows us to add combinations of the multiplier output, a concatenation of A:B (A as MSB, B as LSB), C, P, the number 0, and a couple other source options we don't use in this implementation. This is controlled by `opmode`.
8. In parallel to the "ALU" is a pattern detector. The pattern being detected is hard-coded into the bitstream, and in this case we are looking for a run of `1`'s to help accelerate the overflow detection problem. The output of the pattern detector is always being computed, and dataflow-synchronous to the P output.
9. Unused bits of verilog instances in Migen need to be tied to 0; Migen does not automatically extend/pad shorter `Signal` values to match verilog input widths. This is important because the DSP48E1 input widths don't always exactly match the Migen widths. We create a "zeros" signal and `Cat()` it onto the MSBs as necessary to ensure all inputs to the DSP48E1 are properly specified.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/mpy_pipe3.png
   :alt: data flow block diagram of the multiplier core

Above is the relevant elements of the DSP48E1 block as configured for the systolic dataflow for the "schoolbook"
multiply operation. Items shaded in gray are external to the DSP48E1 block.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/psum3.png
   :alt: data flow block diagram of the partial sum step

Above is the configuration of the DSP48E1 block for the partial sum steps. Partial sum takes two cycles to
sum together the three 17-bit segments of the partial sums.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/carry_prop3.png
   :alt: data flow block diagram of the carry propagate

Above is the configuration of the DSP48E1 block for the carry propagate step. This step must be repeated
14 times to handle the worst-case carry propagate path. During the carry propagate step, the pattern
detector is active, and on the final step we check it to see if the result overflows $2^{{255}}-19$.

.. image:: https://raw.githubusercontent.com/betrusted-io/gateware/master/gateware/curve25519/normalize4.png
   :alt: data flow block diagram of the normalization step

Above is the configuration of the DSP48E1 block for the normalization step. If the result overflows $2^{{255}}-19$,
we must add 19 to make it a member of the prime field once again. We can do this in a single cycle by
short-circuiting the carry propagate: we already know we will have to propagate a carry to handle the overflow
case (there are only 19 possible numbers that will overflow this, and all of them have 1's set up the entire
chain), so we pre-add the carry simultaneous with adding the number 19 to the least significant limb. We also
use this step to mask out the upper level bits on the partial sums, because the top bits are now the old
carries that have already been propagated. If we fail to do this, then we re-propagate the carries from the last step.

        """)

        start_pipe = Signal()
        self.sync.mul_clk += start_pipe.eq(self.start) # break critical path of instruction decode -> SETUP_A state muxes
        self.submodules.mseq = mseq = ClockDomainsRenamer("mul_clk")(FSM(reset_state="IDLE"))
        mseq.act("IDLE",
            NextValue(step, 0),
            NextValue(prop, 0),
            If(start_pipe,
                NextState("SETUP_A")
            )
        )
        mseq.act("SETUP_A", # SETA, load the a, a19 values values
            NextState("MULTIPLY"),
        )
        mseq.act("MULTIPLY", # MPY
            If(step < 14,
                NextValue(step, step + 1)
            ).Else(
                NextState("P_DELAY"),
                NextValue(step, 0),
            )
        )
        mseq.act("P_DELAY", # DLY - due to pipelining of P register, we have a structural hazard that delays feedback by one cycle
            # we take advantage of this time to (1) shift the results into canonical position and (2) nab a copy of the data for the PSUM_MSB state
            NextState("PSUM_LSB")
        )
        mseq.act("PSUM_LSB", # PLSB
            NextState("PSUM_MSB")
        )
        mseq.act("PSUM_MSB", # PMSB
            NextState("CARRYPROP")
        )
        mseq.act("CARRYPROP", # PROP
            If( step == 13,
               If( prop == 0,
                   NextState("NORMALIZE"),
                   NextValue(step, 0),
               ).Else(
                   NextState("DONE"),  # if modifying to the "DONE" state, change q-latch statement at the end
               )
            ).Else(
                NextValue(step, step + 1),
            )
        )
        mseq.act("NORMALIZE", # NORM
            NextState("CARRYPROP"),
            NextValue(prop, 1),
            NextValue(step, 0),
        )
        ### note that the post-amble "manually" aligns the mul_clk to eng_clk phases
        ### this can have one of two outcomes if the previous number of states is even or odd
        ### in this case, we end up phase mis-aligned, so we have to burn a dummy cycle to sync clocks
        ### see q_valid logic at end of this module
        mseq.act("DONE", # DONE -- we are actually finished on an odd phase of the eng_clk, can't assert RF here
            NextState("DONE2"),
        )
        mseq.act("DONE2",  # assert valid to the RF here
            NextState("DONE3"),
        )
        mseq.act("DONE3", # second done state, because we are latching into a half-rate clock domain, so valid is good for one full eng_clk
            NextState("IDLE"),
            # Note: we could, in theory, pipeline the next multiply by detecting if go goes high here,
            # and bypassing IDLE and going straight to SETA, but...
        )

        # DSP48E opcode encodings
        # general DSP48E computation is P <- X + Y + Z + C
        OP_PASS_M        = 0b000_01_01  # X:Y <- M; Z <-0;    P <- 0 + M + 0
        OP_M_PLUS_PCIN   = 0b001_01_01  # X:Y <- M; Z <-PCIN; P <- PCIN + M + 0
        OP_M_PLUS_C      = 0b011_01_01  # X:Y <- M; Z <-C;    P <- C + M + 0
        OP_M_PLUS_P      = 0b010_01_01  # X:Y <- M; Z <-P   ; P <- P + M + 0
        OP_P_PLUS_PCIN17 = 0b101_10_00  # X <- P; Y <- 0; Z <- PCIN >> 17; P <- PCIN>>17 + P + 0
        OP_C_PLUS_P      = 0b010_11_00  # X <- 0; Y <- C; Z <- P; P <- 0 + C + P
        OP_AB_PLUS_P     = 0b010_00_11  # X <- A:B; Y <- 0; Z <- P; P <- A:B + 0 + P + 0
        OP_AB_PLUS_C     = 0b011_00_11  # X <- A:B; Y <- 0; Z <- C; P <- A:B + 0 + C + 0
        OP_0_PLUS_P      = 0b010_00_00  # X <- 0; Y <- 0; Z <- P; P <- 0 + 0 + P + 0
        OP_C_PLUS_0      = 0b011_00_00  # X <- 0; Y <- 0; Z <- C; P <- C + 0 + 0 + 0
        INMODE_A1 = 0b0001
        INMODE_A2 = 0b0000
        INMODE_D  = 0b0110
        INMODE_0  = 0b0010
        INMODE_B2 = 0b0
        # INMODE_B1 = 0b1  # should not be used in this configuration, only 1 BREG configured

        overflow_25519 = Signal() # set during normalize if we're overflowing 2^255-19

        # see the self.timing documentation (above, best viewed after post-processing with sphinx) for how this all works.
        self.comb += [
            dsp_alumode.eq(0),
            If(mseq.before_entering("SETUP_A"),
                dsp_b2_ce.eq(1),
                dsp_a1_ce.eq(1),
            ).Elif(mseq.ongoing("SETUP_A"),
                # at this point, these are already loaded: A1 <- Axx, B2 <- 19
                # P <- A1 * B2
                dsp_opmode.eq(OP_PASS_M),
                # pipeline in the b1 value for the first round of the multiply
                dsp_b2_ce.eq(1),
                dsp_p_ce.eq(1),
            ).Elif(mseq.ongoing("MULTIPLY"),
                dsp_p_ce.eq(1),
                If(step == 0,
                    dsp_a1_ce.eq(1),
                    dsp_a2_ce.eq(1),  # latch the pipelined Axx * 19 signal on the first round of multiply
                    dsp_opmode.eq(OP_PASS_M), # don't add PCIN on the first partial product, as it's bogus on step 0
                ).Else(
                    dsp_a1_ce.eq(0),
                    dsp_a2_ce.eq(0),
                    dsp_opmode.eq(OP_M_PLUS_C),
                ),
                If(step != 14,
                    dsp_b2_ce.eq(1),
                ).Else(
                    dsp_b2_ce.eq(0),
                )
            ).Elif(mseq.ongoing("P_DELAY"),
                dsp_opmode.eq(OP_C_PLUS_0),
                dsp_p_ce.eq(1),
                dsp_b2_ce.eq(1),
                dsp_d_ce.eq(1),
                dsp_a1_ce.eq(1),
            ).Elif(mseq.ongoing("PSUM_LSB"),
                dsp_p_ce.eq(1),
                dsp_b2_ce.eq(1),
                dsp_d_ce.eq(1),
                dsp_opmode.eq(OP_M_PLUS_C),
                dsp_a2_ce.eq(1),
            ).Elif(mseq.ongoing("PSUM_MSB"),
                dsp_p_ce.eq(1),
                dsp_opmode.eq(OP_M_PLUS_P),
            ).Elif(mseq.ongoing("CARRYPROP"),
                dsp_p_ce.eq(0), # move to individual unit P_CEs for this stage
                dsp_opmode.eq(OP_C_PLUS_P),
                If(step==13,
                    dsp_b2_ce.eq(1),
                )
            ).Elif(mseq.ongoing("NORMALIZE"),
                dsp_p_ce.eq(1),
                If(overflow_25519 | (self.dsp_p14[17] == 1),
                    dsp_opmode.eq(OP_AB_PLUS_C),
                ).Else(
                    dsp_opmode.eq(OP_C_PLUS_0),
                )
            )
        ]
        b_step = Signal(17)
        self.comb += [
            # the code below doesn't synthesize well, so let's write out the barrel shifter explicitly
            # getattr(self, "dsp_b" + str(i)).eq((self.b >> (17 * (step + 1))) & 0x1_ffff),  # b_17[step+1]
            # written out explicitly because the fancy for-loop format also leads to a weird synthesis result...
            If(step == 0, b_step.eq(b_17[1])
            ).Elif(step == 1, b_step.eq(b_17[2])
            ).Elif(step == 2, b_step.eq(b_17[3])
            ).Elif(step == 3, b_step.eq(b_17[4])
            ).Elif(step == 4, b_step.eq(b_17[5])
            ).Elif(step == 5, b_step.eq(b_17[6])
            ).Elif(step == 6, b_step.eq(b_17[7])
            ).Elif(step == 7, b_step.eq(b_17[8])
            ).Elif(step == 8, b_step.eq(b_17[9])
            ).Elif(step == 9, b_step.eq(b_17[10])
            ).Elif(step == 10, b_step.eq(b_17[11])
            ).Elif(step == 11, b_step.eq(b_17[12])
            ).Elif(step == 12, b_step.eq(b_17[13])
            ).Elif(step == 13, b_step.eq(b_17[14])
            )
        ]

        # reduce width of DSP's INMODE combinational path using a sub machine that reduces
        # the complexity of the `mseq` machine and allows for a pipeline stage to be inserted...
        INMODE_IDLE = 0
        INMODE_MPY = 1
        INMODE_PROP1 = 2
        INMODE_PROP2 = 3
        inmode_sel = Signal(2)
        self.sync.mul_clk += [
            If(mseq.ongoing("IDLE") | mseq.ongoing("SETUP_A"),
                inmode_sel.eq(INMODE_IDLE)
            ).Elif(mseq.ongoing("MULTIPLY"),
                inmode_sel.eq(INMODE_MPY),
            ).Elif(mseq.ongoing("P_DELAY") | mseq.ongoing("PSUM_LSB"),
                inmode_sel.eq(INMODE_PROP1)
            ).Else(
                inmode_sel.eq(INMODE_PROP2)
            )
        ]

        for i in range(15):
            # INMODE is a critical path, so rewrite code not in computation order but in signal use order to better
            # understand how to optimize it.
            self.comb += [
                If(inmode_sel == INMODE_IDLE,
                    getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_A1, INMODE_B2)),
                ),
                If(inmode_sel == INMODE_MPY,
                    If(step == 0,
                        getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_A1, INMODE_B2)),
                        # A1 has Axx on the first step only
                    ).Elif(i > (14 - step),  # lay out the diagonal wrap-around of partial sums
                        getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_A1, INMODE_B2)),  # A1 has Axx*19
                    ).Else(
                        getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_A2, INMODE_B2)),
                        # A2 has Axx for rest of steps
                    )
                ),
                If(inmode_sel == INMODE_PROP1,
                    getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_D, INMODE_B2)),
                ),
                If(inmode_sel == INMODE_PROP2,
                    getattr(self, "dsp_inmode" + str(i)).eq(Cat(INMODE_0, INMODE_B2)),
                )
            ]

            # rest of signals are in computation order below
            self.comb += [
                If(mseq.before_entering("SETUP_A"),
                    getattr( self, "dsp_a" + str(i) ).eq(Cat(a_17[i], zeros[:(30-17)])),
                    getattr( self, "dsp_b" + str(i) ).eq(19),
                ).Elif(mseq.ongoing("SETUP_A"),
                    getattr(self, "dsp_b" + str(i)).eq(b_17[0]), # preload B00
                ).Elif(mseq.ongoing("MULTIPLY"),
                    getattr(self, "dsp_c" + str(i)).eq(getattr(self, "dsp_p" + str( (i+1) % 15 ))),
                    If(step == 0,
                        getattr(self, "dsp_a" + str(i)).eq(getattr(self, "dsp_p" + str(i))),
                    ),
                    If(step < 14,
                        getattr(self, "dsp_b" + str(i)).eq(Cat(b_step, zeros[:1])),  # b_17[step+1]; note that b input is 18 bits wide, so pad with one 0 to prevent a dangling X on the high bit
                    ),
                )
            ]

            if i > 0: # sum is different from bottom limb, as the top MSB wraps around
                self.comb += [
                    If(mseq.ongoing("P_DELAY"),
                        getattr(self, "dsp_c" + str(i)).eq(getattr(self, "dsp_p" + str((i + 1) % 15))),
                        getattr(self, "dsp_d" + str(i)).eq((getattr(self, "dsp_p" + str(i)) >> 17) & 0x1_ffff), # (i-1)+1, the +1 is because the result has not been shifted yet
                        getattr(self, "dsp_b" + str(i)).eq(1),
                    )]
            else:
                self.comb += [
                    If(mseq.ongoing("P_DELAY"),
                        getattr(self, "dsp_a" + str(i)).eq(zeros),
                        getattr(self, "dsp_c" + str(i)).eq(getattr(self, "dsp_p" + str((i + 1) % 15))),
                        getattr(self, "dsp_d" + str(i)).eq((getattr(self, "dsp_p" + str(0)) >> 17) & 0x1_ffff),
                        getattr(self, "dsp_b" + str(i)).eq(19),
                    )]

            self.comb += [
                    If(mseq.ongoing("PSUM_LSB"),
                        getattr(self, "dsp_c" + str(i)).eq(getattr(self, "dsp_p" + str(i)) & 0x1_ffff),
                    )]
            if i > 1:  # sum-ordering is different for the bottom two limbs, as the top wraps around into two limbs
                self.comb += [
                    If(mseq.ongoing("PSUM_LSB"),
                        getattr(self, "dsp_d" + str(i)).eq((getattr(self, "dsp_p" + str(i - 2)) >> 34) & 0x1_ffff),
                        getattr(self, "dsp_b" + str(i)).eq(1),
                    )]
            elif i == 1:
                self.comb += [
                    If(mseq.ongoing("PSUM_LSB"),
                        getattr(self, "dsp_d" + str(i)).eq((getattr(self, "dsp_p" + str(14)) >> 34) & 0x1_ffff),
                        getattr(self, "dsp_b" + str(i)).eq(19),
                    )]
            else:
                self.comb += [
                    If(mseq.ongoing("PSUM_LSB"),
                        getattr(self, "dsp_d" + str(i)).eq((getattr(self, "dsp_p" + str(13)) >> 34) & 0x1_ffff),
                        getattr(self, "dsp_b" + str(i)).eq(19),
                    )]

            self.comb += [
                If(mseq.ongoing("PSUM_MSB"),
                    getattr(self, "dsp_c0").eq(zeros), # dsp_c is actually don't care due to the opmode
                ).Elif(mseq.ongoing("NORMALIZE"),
                    getattr(self, "dsp_c" + str(i)).eq(getattr(self, "dsp_p" + str(i)) & 0x1_ffff),
                )
            ]

            if i == 0:
                self.comb += [
                    If(mseq.ongoing("CARRYPROP"),
                        getattr(self, "dsp_c" + str(i)).eq( zeros ),
                    ),
                    If(mseq.ongoing("CARRYPROP") & (step == 13),
                        getattr(self, "dsp_b" + str(i)).eq( 19 ), # special-case constant to handle normalization in overflow of prime field; a is loded with 0 on previous cycle
                    ),
                ]
            else:
                self.comb += [
                    If(mseq.ongoing("CARRYPROP"),
                        getattr(self, "dsp_c" + str(i)).eq( Cat(getattr(self, "dsp_p" + str(i - 1)) >> 17, zeros[:17]) ),
                        getattr(self, "dsp_p_ce" + str(i)).eq(step == (i-1)),
                    ),
                    If(mseq.ongoing("CARRYPROP") & (step == 13),
                        getattr(self, "dsp_b" + str(i)).eq(0),
                    )
                ]
            if sim:
                instance = "DSP48E1_sim"
            else:
                instance = "DSP48E1"
            self.specials += [
                Instance(instance, name="DSP_ENG25519_" + str(i),
                    # configure number of input registers
                    p_ACASCREG=1,
                    p_AREG=2,
                    p_ADREG=0,
                    p_ALUMODEREG=0,
                    p_BCASCREG=1,
                    p_BREG=1,

                    # only pipeline at the output
                    p_CARRYINREG=0,
                    p_CARRYINSELREG=0,
                    p_CREG=0,
                    p_DREG=1, # i think we can use this to save some fabric registers
                    p_INMODEREG=0,
                    p_MREG=0,
                    p_OPMODEREG=0,
                    p_PREG=1,

                    p_A_INPUT="DIRECT",
                    p_B_INPUT="DIRECT",
                    p_USE_DPORT="TRUE",
                    p_USE_MULT="DYNAMIC",
                    p_USE_SIMD="ONE48",

                    # setup pattern detector to catch the case of mostly 1's
                    p_AUTORESET_PATDET="NO_RESET",
                    p_MASK   =0xffff_fffe_0000, #'1'*(48-17)+'0'*17,  # 1 bits are ignored, 0 compared
                    p_PATTERN=0x1_ffff, # '0'*(48-17)+'1'*17,  # compare against 0x1_FFFF
                    p_SEL_MASK="MASK",
                    p_SEL_PATTERN="PATTERN",
                    p_USE_PATTERN_DETECT="PATDET",

                    # signals
                    i_A=getattr(self, "dsp_a" + str(i)),
                    i_ALUMODE=dsp_alumode,
                    i_B=Cat(getattr(self, "dsp_b" + str(i)), zeros[:(18-17)]), # extra bits must be set to zero
                    i_C=getattr(self, "dsp_c" + str(i)),
                    i_CARRYIN=0,
                    i_CARRYINSEL=zeros[:3],
                    i_CEA1=dsp_a1_ce,
                    i_CEA2=dsp_a2_ce,
                    i_CEAD=0, # no pipe
                    i_CEALUMODE=0, # no pipe
                    i_CEB1=dsp_b1_ce,
                    i_CEB2=dsp_b2_ce,
                    i_CEC=0, # no pipe
                    i_CECARRYIN=0,
                    i_CECTRL=0, # no pipe on opmode
                    i_CED=dsp_d_ce,
                    i_CEP=dsp_p_ce | getattr(self, "dsp_p_ce" + str(i)),
                    i_CLK=ClockSignal("mul_clk"),  # run at 2x speed of engine clock
                    i_D=Cat(getattr(self, "dsp_d" + str(i)), zeros[:(25-17)]),
                    i_INMODE=getattr(self, "dsp_inmode" + str(i)),
                    i_OPMODE=dsp_opmode,
                    o_P=getattr(self, "dsp_p" + str(i)),
                    o_PATTERNDETECT=getattr(self, "dsp_match" + str(i)),

                    # tie unused CE
                    i_CEM=0,
                    i_CEINMODE=1,

                    # resets
                    i_RSTA=dsp_reset,
                    i_RSTALLCARRYIN=dsp_reset,
                    i_RSTALUMODE=dsp_reset,
                    i_RSTB=dsp_reset,
                    i_RSTC=dsp_reset,
                    i_RSTCTRL=dsp_reset,
                    i_RSTD=dsp_reset,
                    i_RSTINMODE=dsp_reset,
                    i_RSTM=dsp_reset,
                    i_RSTP=dsp_reset,
                )
            ]
            self.sync.mul_clk += [ # this syncs into the eng_clk domain
                If(mseq.ongoing("DONE"), ## mod this to sync with the phase that the state machine ends on
                   self.q[i * 17:i * 17 + 17].eq(getattr(self, "dsp_p" + str(i))[:17]),
                ).Else(
                    self.q[i * 17:i * 17 + 17].eq(self.q[i * 17:i * 17 + 17]),
                ),
            ]
        # whether we are asserting on DONE/DONE2 or DONE2/DONE3 depends on even/odd # of states previously spent to compute the mul
        self.sync.mul_clk += [
            If(mseq.ongoing("DONE2") | mseq.ongoing("DONE3"),
                self.q_valid.eq(1),
               ).Else(
                self.q_valid.eq(0),
            )
        ]
        # compute special-case detection if the partial sum output is >= 2^255-19
        self.comb += [
            overflow_25519.eq(
                self.dsp_match14 &
                self.dsp_match13 &
                self.dsp_match12 &
                self.dsp_match11 &
                self.dsp_match10 &
                self.dsp_match9 &
                self.dsp_match8 &
                self.dsp_match7 &
                self.dsp_match6 &
                self.dsp_match5 &
                self.dsp_match4 &
                self.dsp_match3 &
                self.dsp_match2 &
                self.dsp_match1 &
                (self.dsp_p0 >= 0x1_ffed)
            )
        ]


class Engine(Module, AutoCSR, AutoDoc):
    def __init__(self, platform, prefix, sim=False, build_prefix=""):
        opdoc = "\n"
        for mnemonic, description in opcodes.items():
            opdoc += f" * **{mnemonic}** ({str(description[0])}) -- {description[1]} \n"

        self.intro = ModuleDoc(title="Curve25519 Engine", body="""
The Curve25519 engine is a microcoded hardware accelerator for Curve25519 operations.
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

        ### register file
        rf_depth_raw = 512
        rf_width_raw = 256
        self.submodules.rf = rf = RegisterFile(depth=rf_depth_raw, width=rf_width_raw)
        self.window = CSRStorage(fields=[
            CSRField("window", size=log2_int(rf_depth_raw) - log2_int(num_registers), description="Selects the current register window to use"),
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
        rb_dat = Signal(rf_width_raw)
        rb_adr = Signal(log2_int(num_registers))
        rb_const = Signal()
        wd_dat = Signal(rf_width_raw)
        wd_adr = Signal(log2_int(num_registers))
        rf_write = Signal()

        self.submodules.ra_const_rom = Curve25519Const(insert_docs=True)
        self.submodules.rb_const_rom = Curve25519Const()

        ### merge execution path signals with host access paths
        self.comb += [
            ra_const.eq(instruction.ca),
            rb_const.eq(instruction.cb),
            ra_adr.eq(instruction.ra),
            rb_adr.eq(instruction.rb),
            self.ra_const_rom.adr.eq(ra_adr),
            self.rb_const_rom.adr.eq(rb_adr),
            rf.window.eq(self.window.fields.window),

            If(running & ~pause_gnt,
                rf.ra_adr.eq(Cat(ra_adr, self.window.fields.window)),
                rf.rb_adr.eq(Cat(rb_adr, self.window.fields.window)),
                rf.instruction_pipe_in.eq(instruction.raw_bits()),
                rf.wd_adr.eq(Cat(wd_adr, self.window.fields.window)),
                rf.wd_dat.eq(wd_dat),
                rf.wd_bwe.eq(0xFFFF_FFFF), # enable all bytes
                rf.we.eq(rf_write),
            ).Else(
                rf.ra_adr.eq(radr >> 3),
                rf.wd_adr.eq(wadr >> 3),
                rf.wd_dat.eq(Cat(wdata,wdata,wdata,wdata,wdata,wdata,wdata,wdata)), # replicate; use byte-enable to multiplex
                rf.wd_bwe.eq(0xF << ((wadr & 0x7) * 4)), # select the byte
                rf.we.eq(wdata_we),
            ),
            If(~ra_const,
                ra_dat.eq(rf.ra_dat),
            ).Else(
                ra_dat.eq(self.ra_const_rom.const)
            ),
            If(~rb_const,
                rb_dat.eq(rf.rb_dat),
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
                If(mpc < mpc_stop,
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

        exec_units = {
            "exec_mask"      : ExecMask(width=rf_width_raw),
            "exec_logic"     : ExecLogic(width=rf_width_raw),
            "exec_addsub"    : ExecAddSub(width=rf_width_raw),
            "exec_testreduce": ExecTestReduce(width=rf_width_raw),
            "exec_mul"       : ExecMul(width=rf_width_raw, sim=sim),
        }
        index = 0
        for name, unit in exec_units.items():
            setattr(self.submodules, name, unit);
            setattr(self, "done" + str(index), Signal(name="done"+str(index)))
            setattr(self, "unit_q" + str(index), Signal(wd_dat.nbits, name="unit_q"+str(index)))
            setattr(self, "unit_sel" + str(index), Signal(name="unit_sel"+str(index)))
            setattr(self, "unit_wd" + str(index), Signal(log2_int(num_registers), name="unit_wd"+str(index)))
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
            index += 1

        for i in range(index):
            self.comb += [
                If(getattr(self, "done" + str(i)),
                   done.eq(1),  # TODO: for proper pipelining, handle case of two units done simultaneously!
                   wd_dat.eq(getattr(self, "unit_q" + str(i))),
                   wd_adr.eq(getattr(self, "unit_wd" + str(i))),
                ).Elif(seq.ongoing("IDLE"),
                    done.eq(0),
                )
            ]

        self.comb += [
            rf_write.eq(done),
        ]

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
