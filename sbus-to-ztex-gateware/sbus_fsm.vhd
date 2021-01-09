-- include libraries
-- standard stuff
library IEEE;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- For Xilinx IOBUF ; UG953
Library UNISIM;
use UNISIM.vcomponents.all;

library work;
USE work.LedHandlerPkg.all;
USE work.PromPkg.all;
use work.mastrovito_V2_multiplier_parameters.all;

ENTITY SBusFSM is
  PORT (
    fxclk_in: IN std_logic; -- 48 MHz FX2 clock
    -- true SBus signals
    SBUS_3V3_CLK : 	IN STD_LOGIC; -- 16.67..25 MHz SBus Clock
    SBUS_3V3_RSTs : IN STD_LOGIC;
    SBUS_3V3_SELs : IN STD_LOGIC; -- slave only
    SBUS_3V3_ASs : 	IN STD_LOGIC;
    SBUS_3V3_PPRD : INOUT STD_LOGIC; -- IN slaves; OUT during extended transfers and on masters; input for masters only during ET
    SBUS_3V3_SIZ :  INOUT std_logic_vector(2 downto 0); -- IN slaves; OUT during extended transfers and on masters; input for masters only during ET
    SBUS_3V3_ACKs : INOUT std_logic_vector(2 downto 0); -- OUT slaves; IN on masters
    SBUS_3V3_ERRs : INOUT STD_LOGIC; -- OUT slaves; IN on masters
    SBUS_3V3_D :    INOUT std_logic_vector(31 downto 0);
    SBUS_3V3_PA :   IN std_logic_vector(27 downto 0); -- IN all; OUT during extended transfers
    -- two interupts line
    SBUS_3V3_INT1s : 	OUT STD_LOGIC := 'Z';
    SBUS_3V3_INT7s : 	OUT STD_LOGIC := 'Z';
    -- master-only signals
    SBUS_3V3_BGs : IN STD_LOGIC; -- bus granted
    SBUS_3V3_BRs : OUT STD_LOGIC := '1'; -- bus request
    -- support signals
    SBUS_OE : OUT STD_LOGIC := '1'; -- always off when powered up
    -- support leds
    SBUS_DATA_OE_LED : OUT std_logic := '0'; -- light during read cycle
    SBUS_DATA_OE_LED_2 : OUT std_logic := '0'; -- light during write cycle
    -- data leds
    LED0 : OUT std_logic := '0';
    LED1 : OUT std_logic := '0';
    LED2 : OUT std_logic := '0';
    LED3 : OUT std_logic := '0';
    LED4 : OUT std_logic := '0';
    LED5 : OUT std_logic := '0';
    LED6 : OUT std_logic := '0';
    LED7 : OUT std_logic := '0';
    -- UART
    TX : OUT std_logic := 'Z'
    );
  -- SIZ[2..0] is positive true
  CONSTANT SIZ_WORD : std_logic_vector(2 downto 0):= "000";
  CONSTANT SIZ_BYTE : std_logic_vector(2 downto 0):= "001";
  CONSTANT SIZ_HWORD : std_logic_vector(2 downto 0):= "010";
  CONSTANT SIZ_EXT : std_logic_vector(2 downto 0):= "011";
  CONSTANT SIZ_BURST4 : std_logic_vector(2 downto 0):= "100";
  CONSTANT SIZ_BURST8 : std_logic_vector(2 downto 0):= "101";
  CONSTANT SIZ_BURST16 : std_logic_vector(2 downto 0):= "110";
  CONSTANT SIZ_BURST2 : std_logic_vector(2 downto 0):= "111";
  -- ACKs[2-0] is negative true
  CONSTANT ACK_DISABLED : std_logic_vector(2 downto 0):= "ZZZ";
  CONSTANT ACK_IDLE : std_logic_vector(2 downto 0):= "111";
  CONSTANT ACK_ERR : std_logic_vector(2 downto 0):= "110";
  CONSTANT ACK_BYTE : std_logic_vector(2 downto 0):= "101";
  CONSTANT ACK_RERUN : std_logic_vector(2 downto 0):= "100";
  CONSTANT ACK_WORD : std_logic_vector(2 downto 0):= "011";
  CONSTANT ACK_DWORD : std_logic_vector(2 downto 0):= "010";
  CONSTANT ACK_HWORD : std_logic_vector(2 downto 0):= "001";
  CONSTANT ACK_RESV : std_logic_vector(2 downto 0):= "000";
  -- ADDR RANGES ; (27 downto 9) so 19 bits
  CONSTANT ROM_ADDR_PFX : std_logic_vector(18 downto 0) := "0000000000000000000";
  CONSTANT REG_ADDR_PFX : std_logic_vector(18 downto 0) := "0000000000000000001";
  CONSTANT REG_INDEX_LED        : integer := 0;
  CONSTANT REG_INDEX_AES128_CTRL: integer := 1;
  CONSTANT REG_INDEX_DMA_ADDR   : integer := 2;
  CONSTANT REG_INDEX_DMA_CTRL   : integer := 3;
  CONSTANT REG_INDEX_DMAW_ADDR   : integer := 4;
  CONSTANT REG_INDEX_DMAW_CTRL   : integer := 5;
  -- starts at 64 so we can do 64 bytes burst (see address wrapping)
  CONSTANT REG_INDEX_GCM_H1     : integer := 16;
  CONSTANT REG_INDEX_GCM_H2     : integer := 17;
  CONSTANT REG_INDEX_GCM_H3     : integer := 18;
  CONSTANT REG_INDEX_GCM_H4     : integer := 19;
  CONSTANT REG_INDEX_GCM_C1     : integer := 20;
  CONSTANT REG_INDEX_GCM_C2     : integer := 21;
  CONSTANT REG_INDEX_GCM_C3     : integer := 22;
  CONSTANT REG_INDEX_GCM_C4     : integer := 23;
  CONSTANT REG_INDEX_GCM_INPUT1 : integer := 24;
  CONSTANT REG_INDEX_GCM_INPUT2 : integer := 25;
  CONSTANT REG_INDEX_GCM_INPUT3 : integer := 26;
  CONSTANT REG_INDEX_GCM_INPUT4 : integer := 27;
  CONSTANT REG_INDEX_GCM_INPUT5 : integer := 28; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT6 : integer := 29; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT7 : integer := 30; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT8 : integer := 31; -- placeholder
  
  CONSTANT REG_INDEX_AES128_KEY1  : integer := 48;
  CONSTANT REG_INDEX_AES128_KEY2  : integer := 49;
  CONSTANT REG_INDEX_AES128_KEY3  : integer := 50;
  CONSTANT REG_INDEX_AES128_KEY4  : integer := 51;
  CONSTANT REG_INDEX_AES128_KEY5  : integer := 52;
  CONSTANT REG_INDEX_AES128_KEY6  : integer := 53;
  CONSTANT REG_INDEX_AES128_KEY7  : integer := 54;
  CONSTANT REG_INDEX_AES128_KEY8  : integer := 55;
  CONSTANT REG_INDEX_AES128_DATA1 : integer := 56;
  CONSTANT REG_INDEX_AES128_DATA2 : integer := 57;
  CONSTANT REG_INDEX_AES128_DATA3 : integer := 58;
  CONSTANT REG_INDEX_AES128_DATA4 : integer := 59;
  CONSTANT REG_INDEX_AES128_OUT1  : integer := 60;
  CONSTANT REG_INDEX_AES128_OUT2  : integer := 61;
  CONSTANT REG_INDEX_AES128_OUT3  : integer := 62;
  CONSTANT REG_INDEX_AES128_OUT4  : integer := 63;

  constant DMA_CTRL_START_IDX     : integer := 31;
  constant DMA_CTRL_BUSY_IDX      : integer := 30;
  constant DMA_CTRL_ERR_IDX       : integer := 29;
  constant DMA_CTRL_WRITE_IDX     : integer := 28; -- unused
  constant DMA_CTRL_GCM_IDX       : integer := 27;
  constant DMA_CTRL_AES_IDX       : integer := 26;
  constant DMA_CTRL_CBC_IDX       : integer := 25;

  constant AES128_CTRL_START_IDX  : integer := 31;
  constant AES128_CTRL_BUSY_IDX   : integer := 30;
  constant AES128_CTRL_ERR_IDX    : integer := 29;
  constant AES128_CTRL_NEWKEY_IDX : integer := 28;
  constant AES128_CTRL_CBCMOD_IDX : integer := 27;
  constant AES128_CTRL_AES256_IDX : integer := 26;
  constant AES128_CTRL_DEC_IDX    : integer := 25;

  -- OFFSET to REGS; (8 downto 0) so 9 bits
  CONSTANT REG_OFFSET_LED        : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_LED   *4, 9);
  CONSTANT REG_OFFSET_AES128_CTRL : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_CTRL*4, 9);
  CONSTANT REG_OFFSET_DMA_ADDR   : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_DMA_ADDR  *4, 9);
  CONSTANT REG_OFFSET_DMA_CTRL   : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_DMA_CTRL  *4, 9);
  CONSTANT REG_OFFSET_DMAW_ADDR   : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_DMAW_ADDR  *4, 9);
  CONSTANT REG_OFFSET_DMAW_CTRL   : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_DMAW_CTRL  *4, 9);
  
  CONSTANT REG_OFFSET_GCM_H1     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_H1*4, 9);
  CONSTANT REG_OFFSET_GCM_H2     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_H2*4, 9);
  CONSTANT REG_OFFSET_GCM_H3     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_H3*4, 9);
  CONSTANT REG_OFFSET_GCM_H4     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_H4*4, 9);
  CONSTANT REG_OFFSET_GCM_C1     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_C1*4, 9);
  CONSTANT REG_OFFSET_GCM_C2     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_C2*4, 9);
  CONSTANT REG_OFFSET_GCM_C3     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_C3*4, 9);
  CONSTANT REG_OFFSET_GCM_C4     : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_C4*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT1 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT1*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT2 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT2*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT3 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT3*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT4 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT4*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT5 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT5*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT6 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT6*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT7 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT7*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT8 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_GCM_INPUT8*4, 9); -- placeholder
  
  CONSTANT REG_OFFSET_AES128_KEY1 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY1*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY2 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY2*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY3 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY3*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY4 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY4*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY5 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY5*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY6 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY6*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY7 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY7*4, 9);
  CONSTANT REG_OFFSET_AES128_KEY8 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_KEY8*4, 9);
  CONSTANT REG_OFFSET_AES128_DATA1 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_DATA1*4, 9);
  CONSTANT REG_OFFSET_AES128_DATA2 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_DATA2*4, 9);
  CONSTANT REG_OFFSET_AES128_DATA3 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_DATA3*4, 9);
  CONSTANT REG_OFFSET_AES128_DATA4 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_DATA4*4, 9);
  CONSTANT REG_OFFSET_AES128_OUT1 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_OUT1*4, 9);
  CONSTANT REG_OFFSET_AES128_OUT2 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_OUT2*4, 9);
  CONSTANT REG_OFFSET_AES128_OUT3 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_OUT3*4, 9);
  CONSTANT REG_OFFSET_AES128_OUT4 : std_logic_vector(8 downto 0) := conv_std_logic_vector(REG_INDEX_AES128_OUT4*4, 9);

  constant c_CLKS_PER_BIT : integer := 417; -- 48M/115200
  -- constant c_CLKS_PER_BIT : integer := 50; -- 5.76M/115200
  END ENTITY;

ARCHITECTURE RTL OF SBusFSM IS
  TYPE SBus_States IS (
    -- after reset, move to Idle
                       SBus_Start,
    -- waiting, all outputs should be set Z
    -- includes the detection logic for the next cycle
    -- also capture PA immediately (useful for address wrapping,
    -- might become useful for extended transfer)
                       SBus_Idle,
    -- cycle during which ACK is IDLE to end SBus Cycle
    -- also check for deasserting of AS
                       SBus_Slave_Ack_Reg_Write,
    -- cycle after ACK is idle, everything goes back to Z before Idle
    -- also check for deasserting of AS
                       SBus_Slave_Ack_Reg_Write_Final,
    -- cycle(s) with data acquired from the bus & ACK of the next acquisition
    -- between 1 and 16 words (so 1 to 16 cycles in the state)
                       SBus_Slave_Ack_Reg_Write_Burst,
    -- cycle we put the data on the bus when reading from Prom
    -- also ACK goes to idle
    -- byte-wide
                       SBus_Slave_Ack_Read_Prom_Byte,
    -- cycle we put the data on the bus when reading from Prom
    -- also ACK goes to idle
    -- half-word-wide
                       SBus_Slave_Ack_Read_Prom_HWord,
    -- cycle(s) we put the data on the bus when reading from Prom
    -- also ACK the next word we will put, or goes to idle for last
    -- word-wide, burst from 1 to 16
                       SBus_Slave_Ack_Read_Prom_Burst,
    -- cycle we put the data on the bus when reading from registers
    -- also ACK goes to idle
    -- byte-wide
                       SBus_Slave_Ack_Read_Reg_Byte,
    -- cycle we put the data on the bus when reading from registers
    -- also ACK goes to idle
    -- half-word-wide
                       SBus_Slave_Ack_Read_Reg_HWord,
    -- cycle(s) we put the data on the bus when reading from registers
    -- also ACK the next word we will put, or goes to idle for last
    -- word-wide, burst from 1 to 16
                       SBus_Slave_Ack_Read_Reg_Burst,
    -- last cycle where the master read our data from the bus
    -- everything goes to Z before Idle
                       SBus_Slave_Do_Read,
    -- delay cycle to assert late error
                       SBus_Slave_Delay_Error,
    -- cycle where master detect the error (ACK or late)
    -- everything goes to Z before Idle
                       SBus_Slave_Error,
--                       SBus_Slave_Heartbeat,
                       SBus_Master_Translation,
                       SBus_Master_Read,
                       SBus_Master_Read_Ack,
                       SBus_Master_Read_Finish,
                       SBus_Master_Write,
                       SBus_Master_Write_Final
                       );
  TYPE Uart_States IS ( UART_IDLE, UART_WAITING );
  TYPE AES_States IS ( AES_IDLE, AES_INIT1, AES_CRYPT1, AES_CRYPT2 );
                       
  SIGNAL State : SBus_States := SBus_Start;
  SIGNAL Uart_State : Uart_States := UART_IDLE;
  SIGNAL AES_State : AES_States := AES_IDLE;
  SIGNAL LED_RESET: std_logic := '0';
  signal DATA_T : std_logic := '1'; -- I/O control for DATA IOBUF, default to input
  signal BUF_DATA_I, BUF_DATA_O : std_logic_vector(31 downto 0); -- buffers for data from/to
  SIGNAL p_addr : std_logic_vector(6 downto 0) := "1111111"; -- addr lines to prom
  SIGNAL p_data : std_logic_vector(31 downto 0); -- data lines to prom
  
  signal SM_T : std_logic := '1'; -- I/O control for others (Slave/Master) IOBUF, default to Slave (in)
  signal SMs_T : std_logic := '1'; -- I/O control for others (Slave/Master) IOBUF, default to Master (in)
  -- so PPRD and SIZ are IN, ACKs and ERRs are OUT (and use 'SMs_T')
  signal BUF_PPRD_I, BUF_PPRD_O : std_logic; -- buffers for PPRD from/to
  signal BUF_SIZ_I, BUF_SIZ_O : std_logic_vector(2 downto 0); -- buffers for SIZs from/to
  signal BUF_ACKs_I, BUF_ACKs_O : std_logic_vector(2 downto 0); -- buffers for ACK from/to
  signal BUF_ERRs_I, BUF_ERRs_O : std_logic; -- buffers for ERRs from/to
  
  -- signal uart_clk : std_logic; -- 5.76 MHz clock for FIFO write & UART
  signal aes_clk_out : std_logic; -- 100 MHz clock for AES
  
  signal fifo_rst : STD_LOGIC := '1'; -- start in reset mode
  signal fifo_din : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal fifo_wr_en : STD_LOGIC;
  signal fifo_rd_en : STD_LOGIC;
  signal fifo_dout : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal fifo_full : STD_LOGIC;
  signal fifo_empty : STD_LOGIC;
  signal r_TX_DV     : std_logic := '0';
  signal w_TX_DONE   : std_logic;
  signal r_TX_BYTE   : std_logic_vector(7 downto 0) := (others => '0');
  
  signal aes_wrapper_rst : std_logic := '0';
  signal fifo_toaes_din : STD_LOGIC_VECTOR ( 260 downto 0 );
  signal fifo_toaes_wr_en : STD_LOGIC;
  signal fifo_toaes_rd_en : STD_LOGIC;
  signal fifo_toaes_dout : STD_LOGIC_VECTOR ( 260 downto 0 );
  signal fifo_toaes_full : STD_LOGIC;
  signal fifo_toaes_empty : STD_LOGIC;
  signal fifo_fromaes_din : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal fifo_fromaes_wr_en : STD_LOGIC;
  signal fifo_fromaes_rd_en : STD_LOGIC;
  signal fifo_fromaes_dout : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal fifo_fromaes_full : STD_LOGIC;
  signal fifo_fromaes_empty : STD_LOGIC;
  
--  SIGNAL LIFE_COUNTER48 : natural range 0 to 48000000 := 300;
--  SIGNAL LIFE_COUNTER25 : natural range 0 to 25000000 := 300;
  SIGNAL RES_COUNTER : natural range 0 to 4 := 4;
  -- counter to wait 20s before enabling SBus signals, without this the SS20 won't POST reliably...
  -- this means a need to probe-sbus from the PROM to find the board (or warm reset)
  SIGNAL OE_COUNTER : natural range 0 to 960000000 := 960000000;
  
  SIGNAL AES_RST_COUNTER : natural range 0 to 31 := 31;
  SIGNAL AES_TIMEOUT_COUNTER : natural range 0 to 63 := 63;

  -- 16 registers for GCM (12 used), 4 for DMA (2 used ATM), 16 for AES (13 used ATM)
  type REGISTERS_TYPE is array(0 to 64) of std_logic_vector(31 downto 0);
  SIGNAL REGISTERS : REGISTERS_TYPE;
  
  pure function REG_OFFSET_IS_GCMINPUT(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_GCM_INPUT1 = value) OR
           (REG_OFFSET_GCM_INPUT2 = value) OR
           (REG_OFFSET_GCM_INPUT3 = value) OR
           (REG_OFFSET_GCM_INPUT4 = value);
  end function;
  pure function REG_OFFSET_IS_GCMH (value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_GCM_H1 = value) OR
           (REG_OFFSET_GCM_H2 = value) OR
           (REG_OFFSET_GCM_H3 = value) OR
           (REG_OFFSET_GCM_H4 = value);
  end function;
  pure function REG_OFFSET_IS_GCMC (value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_GCM_C1 = value) OR
           (REG_OFFSET_GCM_C2 = value) OR
           (REG_OFFSET_GCM_C3 = value) OR
           (REG_OFFSET_GCM_C4 = value);
  end function;
  pure function REG_OFFSET_IS_ANYDMA(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_DMA_ADDR  = value) OR
           (REG_OFFSET_DMA_CTRL  = value) OR
           (REG_OFFSET_DMAW_ADDR  = value) OR
           (REG_OFFSET_DMAW_CTRL  = value);
  end function;
  
  pure function REG_OFFSET_IS_AESKEY(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_AES128_KEY1 = value) OR
           (REG_OFFSET_AES128_KEY2 = value) OR
           (REG_OFFSET_AES128_KEY3 = value) OR
           (REG_OFFSET_AES128_KEY4 = value) OR
           (REG_OFFSET_AES128_KEY5 = value) OR
           (REG_OFFSET_AES128_KEY6 = value) OR
           (REG_OFFSET_AES128_KEY7 = value) OR
           (REG_OFFSET_AES128_KEY8 = value);
  end function;
  
  pure function REG_OFFSET_IS_AESDATA(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_AES128_DATA1 = value) OR
           (REG_OFFSET_AES128_DATA2 = value) OR
           (REG_OFFSET_AES128_DATA3 = value) OR
           (REG_OFFSET_AES128_DATA4 = value);
  end function;
  
  pure function REG_OFFSET_IS_AESOUT(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_AES128_OUT1 = value) OR
           (REG_OFFSET_AES128_OUT2 = value) OR
           (REG_OFFSET_AES128_OUT3 = value) OR
           (REG_OFFSET_AES128_OUT4 = value);
  end function;

  pure function REG_OFFSET_IS_ANYGCM(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return REG_OFFSET_IS_GCMINPUT(value) or REG_OFFSET_IS_GCMH(value) or REG_OFFSET_IS_GCMC(value);
  end function;

  pure function REG_OFFSET_IS_ANYAES(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return REG_OFFSET_IS_AESKEY(value) OR REG_OFFSET_IS_AESDATA(value) OR REG_OFFSET_IS_AESOUT(value) OR
           (REG_OFFSET_AES128_CTRL = value);
  end function;

  pure function REG_OFFSET_IS_ANYREAD(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return REG_OFFSET_IS_GCMC(value) OR
           REG_OFFSET_IS_AESOUT(value) OR
           (REG_OFFSET_DMA_CTRL = value) OR
           (REG_OFFSET_DMAW_CTRL = value) OR
           (REG_OFFSET_AES128_CTRL = value)
           ;
  end function;

  pure function REG_OFFSET_IS_ANYWRITE(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return (REG_OFFSET_LED = value) OR
           REG_OFFSET_IS_ANYGCM(value) OR
           REG_OFFSET_IS_ANYAES(value) OR
           REG_OFFSET_IS_ANYDMA(value);
  end function;

  pure function REG_OFFSET_IS_ANY(value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return true;
  end function;
  
  pure function SIZ_IS_WORD(value : in std_logic_vector(2 downto 0)) return boolean is
  begin
    return (SIZ_WORD = value) OR
           (SIZ_BURST2 = value) OR
           (SIZ_BURST4 = value) OR
           (SIZ_BURST8 = value) OR
           (SIZ_BURST16 = value);
  end function;
  
  pure function SIZ_TO_BURSTSIZE(value : in std_logic_vector(2 downto 0)) return integer is
  begin
  case value is
    WHEN SIZ_WORD => return 1;
    WHEN SIZ_BURST2 => return 2;
    WHEN SIZ_BURST4 => return 4;
    WHEN SIZ_BURST8 => return 8;
    WHEN SIZ_BURST16 => return 16;
    WHEN OTHERS => return 1; -- should not happen
  end case;
  end function;
  
  pure function INDEX_WITH_WRAP(counter: in integer;
                                 limit: in integer;
                                 value : in std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
  case limit is
    WHEN 1 => return value(3 downto 0);
    WHEN 2 => return value(3 downto 1) & conv_std_logic_vector(conv_integer(value(0))         +counter,1);
    WHEN 4 => return value(3 downto 2) & conv_std_logic_vector(conv_integer(value(1 downto 0))+counter,2);
    WHEN 8 => return value(3 downto 3) & conv_std_logic_vector(conv_integer(value(2 downto 0))+counter,3);
    WHEN 16 => return                    conv_std_logic_vector(conv_integer(value(3 downto 0))+counter,4);
    WHEN others => return value(3 downto 0); -- should not happen
  end case;
  end function;

--COMPONENT LedHandler
--PORT(    l_ifclk: IN std_logic; -- 48 MHz interface clock
--      l_LED_RESET: IN std_logic := '0';
--      l_LED_DATA: IN std_logic_vector(31 downto 0) := (others => '0');
--      l_LED0 : OUT std_logic := '0';
--      l_LED1 : OUT std_logic := '0';
--      l_LED2 : OUT std_logic := '0';
--      l_LED3 : OUT std_logic := '0');
--END COMPONENT;
  COMPONENT LedHandler
    PORT(    l_ifclk: IN std_logic; -- 48 MHz interface clock
             l_LED_RESET: IN std_logic := '0';
             l_LED_DATA: IN std_logic_vector(31 downto 0) := (others => '0');
             l_LED0 : OUT std_logic := '0';
             l_LED1 : OUT std_logic := '0';
             l_LED2 : OUT std_logic := '0';
             l_LED3 : OUT std_logic := '0';
             l_LED4 : OUT std_logic := '0';
             l_LED5 : OUT std_logic := '0';
             l_LED6 : OUT std_logic := '0';
             l_LED7 : OUT std_logic := '0');
  END COMPONENT;

  COMPONENT Prom
    GENERIC(
      addr_width : integer := 128; -- store 128 elements (512 bytes)
      addr_bits  : integer := 7; -- required bits to store 128 elements
      data_width : integer := 32 -- each element has 32-bits
      );
    PORT(
      addr : IN std_logic_vector(addr_bits-1 downto 0);
      data : OUT std_logic_vector(data_width-1 downto 0));
  END COMPONENT;

  COMPONENT mastrovito_V2_multiplication
  PORT(
    a : IN std_logic_vector(M-1 downto 0);
    b : IN std_logic_vector(M-1 downto 0);
    c : OUT std_logic_vector(M-1 downto 0)
    );
  END COMPONENT;
  --Inputs
  SIGNAL mas_a :  std_logic_vector(M-1 downto 0) := (others=>'0');
  SIGNAL mas_b :  std_logic_vector(M-1 downto 0) := (others=>'0');
  --Outputs
  SIGNAL mas_c :  std_logic_vector(M-1 downto 0);
  
  function reverse_bit_in_byte (a: in std_logic_vector(31 downto 0))
    return std_logic_vector is 
    variable t: std_logic_vector(31 downto 0);
  begin 
    t( 7 downto  0) := a( 0)&a( 1)&a( 2)&a( 3)&a( 4)&a( 5)&a( 6)&a( 7);
    t(15 downto  8) := a( 8)&a( 9)&a(10)&a(11)&a(12)&a(13)&a(14)&a(15);
    t(23 downto 16) := a(16)&a(17)&a(18)&a(19)&a(20)&a(21)&a(22)&a(23);
    t(31 downto 24) := a(24)&a(25)&a(26)&a(27)&a(28)&a(29)&a(30)&a(31);
    return t;
  end;
  
  component fifo_generator_uart is
    Port ( 
      rst : in STD_LOGIC;
      wr_clk : in STD_LOGIC;
      rd_clk : in STD_LOGIC;
      din : in STD_LOGIC_VECTOR ( 7 downto 0 );
      wr_en : in STD_LOGIC;
      rd_en : in STD_LOGIC;
      dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
      full : out STD_LOGIC;
      empty : out STD_LOGIC
    );
  end component;
  component fifo_generator_to_aes is
    Port (
      wr_clk : in STD_LOGIC;
      rd_clk : in STD_LOGIC;
      din : in STD_LOGIC_VECTOR ( 260 downto 0 );
      wr_en : in STD_LOGIC;
      rd_en : in STD_LOGIC;
      dout : out STD_LOGIC_VECTOR ( 260 downto 0 );
      full : out STD_LOGIC;
      empty : out STD_LOGIC
    );
  end component;
  component fifo_generator_from_aes is
    Port (
      wr_clk : in STD_LOGIC;
      rd_clk : in STD_LOGIC;
      din : in STD_LOGIC_VECTOR ( 127 downto 0 );
      wr_en : in STD_LOGIC;
      rd_en : in STD_LOGIC;
      dout : out STD_LOGIC_VECTOR ( 127 downto 0 );
      full : out STD_LOGIC;
      empty : out STD_LOGIC
    );
  end component;
  
  component uart_tx is
    generic (
      g_CLKS_PER_BIT : integer := 417   -- Needs to be set correctly
      );
    port (
      i_clk       : in  std_logic;
      i_tx_dv     : in  std_logic;
      i_tx_byte   : in  std_logic_vector(7 downto 0);
      o_tx_active : out std_logic;
      o_tx_serial : out std_logic;
      o_tx_done   : out std_logic
      );
  end component uart_tx;

--  component clk_wiz_0 is
--  port(clk_in1 : in std_logic;
--       clk_out1 : out std_logic);
--  end component clk_wiz_0;

  component clk_wiz_aes is
  port(clk_out1 : out std_logic;
       clk_in1 : in std_logic);
  end component clk_wiz_aes;
  
  component aes_wrapper is
  port (
    aes_wrapper_rst : in std_logic;
    aes_wrapper_clk : in std_logic;
-- iskey?, keylen, encdec, cbc, data (256 or 128 + 128)
    input_fifo_out : in std_logic_vector(260 downto 0);
    input_fifo_empty: in std_logic;
    input_fifo_rd_en : out std_logic;
-- data (128)
    output_fifo_in : out std_logic_vector(127 downto 0);
    output_fifo_full : in std_logic;
    output_fifo_wr_en : out std_logic
    );
  end component aes_wrapper;

  PROCEDURE SBus_Set_Default(
--    signal SBUS_3V3_ACKs :     OUT std_logic_vector(2 downto 0);
--    signal SBUS_3V3_ERRs : 	OUT STD_LOGIC;
    signal SBUS_3V3_INT1s : 	OUT STD_LOGIC;
    signal SBUS_3V3_INT7s : 	OUT STD_LOGIC;
    -- support leds
    signal SBUS_DATA_OE_LED : OUT std_logic; -- light during read cycle
    signal SBUS_DATA_OE_LED_2 : OUT std_logic; -- light during write cycle)
    -- ROM
    signal p_addr : OUT std_logic_vector(6 downto 0); -- TODO: how to reference the add_bits from PROM ?
    -- Data buffers
    signal DATA_T : OUT std_logic; -- I/O control for data IOBUF
    signal SM_T : OUT std_logic; -- I/O control for SM IOBUF
    signal SMs_T : OUT std_logic; -- I/O control for SM IOBUF, negated
    -- Data LEDS
    signal LED_RESET: OUT std_logic -- force LED cycling from start
    ) IS
  BEGIN
    SBUS_DATA_OE_LED <= '0'; -- off
    SBUS_DATA_OE_LED_2 <= '0'; -- off
--    SBUS_3V3_ACKs <= ACK_DISABLED; -- no drive
--    SBUS_3V3_ERRs <= 'Z'; -- idle
    SBUS_3V3_INT1s <= 'Z';
    SBUS_3V3_INT7s <= 'Z';
    p_addr <= "1111111"; -- look-up last element, all-0
    DATA_T <= '1'; -- set buffer as input
    SM_T <= '1'; -- set buffer as slave mode (in)
    SMs_T <= '1'; -- set buffer as master mode (in)
    LED_RESET <= '0'; -- let data LEDs do their thing
  END PROCEDURE;
  
BEGIN
  GENDATABUF: for i IN 0 to 31 generate
    IOBdata : IOBUF
      GENERIC MAP(
        DRIVE => 12,
        IOSTANDARD => "DEFAULT",
        SLEW => "SLOW")
      PORT MAP (
        O => BUF_DATA_I(i),           -- Buffer output (warning - data coming from SBUS so I)
        IO => SBUS_3V3_D(i),         -- Buffer INOUT PORT (connect directly to top-level PORT)
        I => BUF_DATA_O(i),         -- Buffer input (warning - data going to SBUS so O)
        T => DATA_T              -- 3-state enable input, high=input, low=output
        -- DATA_T is 1 by default, so input from the SBus (e.g. during slave *write* cycle)
        -- DATA_T should be set to 1 during slave *read* cycle, when we send data to the SBus (IOBUS is an output)
        );
  end generate GENDATABUF;

  IOBpprd : IOBUF GENERIC MAP(DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
                  PORT MAP(O => BUF_PPRD_I, IO => SBUS_3V3_PPRD, I => BUF_PPRD_O, T => SM_T);
  GENSIZBUF: for i IN 0 to 2 generate
    IOBsiz : IOBUF GENERIC MAP(DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
                   PORT MAP (O => BUF_SIZ_I(i), IO => SBUS_3V3_SIZ(i), I => BUF_SIZ_O(i), T => SM_T);
  end generate GENSIZBUF;
  GENACKBUF: for i IN 0 to 2 generate
    IOBacks : IOBUF GENERIC MAP(DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
                   PORT MAP (O => BUF_ACKs_I(i), IO => SBUS_3V3_ACKs(i), I => BUF_ACKs_O(i), T => SMs_T);
  end generate GENACKBUF;
  IOBerrs : IOBUF GENERIC MAP(DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
                  PORT MAP(O => BUF_ERRs_I, IO => SBUS_3V3_ERRs, I => BUF_ERRs_O, T => SMs_T);

  --label_led_handler: LedHandler PORT MAP( l_ifclk => SBUS_3V3_CLK, l_LED_RESET => LED_RESET, l_LED_DATA => LED_DATA, l_LED0 => LED0, l_LED1 => LED1, l_LED2 => LED2, l_LED3 => LED3 );
  label_led_handler: LedHandler PORT MAP( l_ifclk => SBUS_3V3_CLK, l_LED_RESET => LED_RESET, l_LED_DATA => REGISTERS(REG_INDEX_LED), l_LED0 => LED0, l_LED1 => LED1, l_LED2 => LED2, l_LED3 => LED3,
                                          l_LED4 => LED4, l_LED5 => LED5, l_LED6 => LED6, l_LED7 => LED7);
  
  label_prom: Prom PORT MAP (addr => p_addr, data => p_data);

  --label_mas: mastrovito_V2_multiplication PORT MAP( a => mas_a, b => mas_b, c => mas_c );
  
  label_fifo: fifo_generator_uart port map(rst => fifo_rst, wr_clk => SBUS_3V3_CLK, rd_clk => fxclk_in,
                                           din => fifo_din, wr_en => fifo_wr_en, rd_en => fifo_rd_en,
                                           dout => fifo_dout, full => fifo_full, empty => fifo_empty);
                                           
                                           
  
  label_fifo_toaes: fifo_generator_to_aes port map(wr_clk => SBUS_3V3_CLK, rd_clk => aes_clk_out,
                                           din => fifo_toaes_din, wr_en => fifo_toaes_wr_en, rd_en => fifo_toaes_rd_en,
                                           dout => fifo_toaes_dout, full => fifo_toaes_full, empty => fifo_toaes_empty);
  label_fifo_fromaes: fifo_generator_from_aes port map(wr_clk => aes_clk_out, rd_clk => SBUS_3V3_CLK,
                                           din => fifo_fromaes_din, wr_en => fifo_fromaes_wr_en, rd_en => fifo_fromaes_rd_en,
                                           dout => fifo_fromaes_dout, full => fifo_fromaes_full, empty => fifo_fromaes_empty);
  label_aes_wrapper: aes_wrapper port map(
    aes_wrapper_rst => aes_wrapper_rst,
    aes_wrapper_clk => aes_clk_out,
    input_fifo_out => fifo_toaes_dout,
    input_fifo_empty => fifo_toaes_empty,
    input_fifo_rd_en => fifo_toaes_rd_en,
    output_fifo_in => fifo_fromaes_din,
    output_fifo_full => fifo_fromaes_full,
    output_fifo_wr_en => fifo_fromaes_wr_en
    );
                                        
  -- label_clk_wiz: clk_wiz_0 port map(clk_out1 => uart_clk, clk_in1 => fxclk_in);
  label_aes_clk_wiz: clk_wiz_aes port map(clk_out1 => aes_clk_out, clk_in1 => fxclk_in);
  
  label_uart : uart_tx
    generic map (
      g_CLKS_PER_BIT => c_CLKS_PER_BIT
      )
    port map (
      i_clk       => fxclk_in,
      i_tx_dv     => r_TX_DV,
      i_tx_byte   => r_TX_BYTE,
      o_tx_active => open,
      o_tx_serial => TX,
      o_tx_done   => w_TX_DONE
      );
  
  PROCESS (SBUS_3V3_CLK, SBUS_3V3_RSTs) 
  variable do_gcm : boolean := false;
  variable finish_gcm : boolean := false;
  variable last_pa : std_logic_vector(27 downto 0) := (others => '0');
  variable BURST_COUNTER : integer range 0 to 15 := 0;
  variable BURST_LIMIT : integer range 1 to 16 := 1;
  variable BURST_INDEX : integer range 0 to 15;
  variable seen_ack : boolean := false;
  variable dma_write : boolean := false;
  variable dma_ctrl_idx : integer range 0 to 7;
  variable dma_addr_idx : integer range 0 to 7;
  BEGIN
    IF (SBUS_3V3_RSTs = '0') THEN
      State <= SBus_Start;
      fifo_rst <= '1';
      RES_COUNTER <= 4;
      
    ELSIF RISING_EDGE(SBUS_3V3_CLK) THEN
      fifo_wr_en <= '0';
      fifo_toaes_wr_en <= '0';
      fifo_fromaes_rd_en <= '0';
--      LIFE_COUNTER25 <= LIFE_COUNTER25 - 1;
      
      CASE State IS
        WHEN SBus_Idle =>
--          IF (LIFE_COUNTER25 <= 200000) THEN
--            LIFE_COUNTER25 <= 25000000;
--            fifo_wr_en <= '1';
--            fifo_din <= b"01" & SBUS_3V3_SELs & SBUS_3V3_ASs & SBUS_3V3_PPRD & BUF_SIZ_I;
--            State <= SBus_Slave_Heartbeat;
-- Anything pointing to SBus_Idle should SBus_Set_Default
-- 			    SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
--			                     SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
--			                     p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
-- READ READ READ --
--          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(BUF_SIZ_I) AND BUF_PPRD_I='1' THEN
          IF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(BUF_SIZ_I) AND BUF_PPRD_I='1' THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"41"; -- "A"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            BURST_COUNTER := 0;
            BURST_LIMIT := SIZ_TO_BURSTSIZE(BUF_SIZ_I);
            IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) AND (last_pa(1 downto 0) = "00")) then
              -- 32 bits read from aligned memory IN PROM space ------------------------------------
              BUF_ACKs_O <= ACK_WORD;
              BUF_ERRs_O <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_Burst;
            ELSIF ((last_pa(27 downto 9) = REG_ADDR_PFX) AND REG_OFFSET_IS_ANYREAD(last_pa(8 downto 0))) then
              -- 32 bits read from aligned memory IN REG space ------------------------------------
              BUF_ACKs_O <= ACK_WORD;
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Ack_Read_Reg_Burst;
            ELSE
              BUF_ACKs_O <= ACK_ERR;
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND BUF_SIZ_I = SIZ_BYTE AND BUF_PPRD_I='1' THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"42"; -- "B"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            IF (last_pa(27 downto 9) = ROM_ADDR_PFX) then
              -- 8 bits read from memory IN PROM space ------------------------------------
              BUF_ACKs_O <= ACK_BYTE;
              BUF_ERRs_O <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_Byte;
            ELSE
              BUF_ACKs_O <= ACK_ERR;
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND BUF_SIZ_I = SIZ_HWORD AND BUF_PPRD_I='1' THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"43"; -- "C"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) and (last_pa(0) = '0')) then
              -- 16 bits read from memory IN PROM space ------------------------------------
              BUF_ACKs_O <= ACK_HWORD;
              BUF_ERRs_O <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_HWord;
            ELSE
              BUF_ACKs_O <= ACK_ERR;
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
-- WRITE WRITE WRITE --
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(BUF_SIZ_I) AND BUF_PPRD_I='0' THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"44"; -- "D"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED_2 <= '1';
            BURST_COUNTER := 0;
            BURST_LIMIT := SIZ_TO_BURSTSIZE(BUF_SIZ_I);
            IF ((last_pa(27 downto 9) = REG_ADDR_PFX) and REG_OFFSET_IS_ANYWRITE(last_pa(8 downto 0))) then
              -- 32 bits write to register  ------------------------------------
              BUF_ACKs_O <=  ACK_WORD; -- acknowledge the Word
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Ack_Reg_Write_Burst;
            ELSE
              BUF_ACKs_O <= ACK_ERR; -- unsupported address, signal error
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Error; 
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND BUF_SIZ_I = SIZ_BYTE AND BUF_PPRD_I='0' THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"45"; -- "E"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED_2 <= '1';
            IF ((last_pa(27 downto 9) = REG_ADDR_PFX) and (last_pa(8 downto 2) = REG_OFFSET_LED(8 downto 2))) then
              -- 8 bits write to LED register ------------------------------------
              LED_RESET <= '1'; -- reset led cycle
              --DATA_T <= '1'; -- set buffer as input
              CASE last_pa(1 downto 0) IS
              WHEN "00" =>
                REGISTERS(REG_INDEX_LED)(31 downto 24) <= BUF_DATA_I(31 downto 24);
              WHEN "01" =>
                REGISTERS(REG_INDEX_LED)(23 downto 16) <= BUF_DATA_I(31 downto 24);
              WHEN "10" =>
                REGISTERS(REG_INDEX_LED)(15 downto 8) <= BUF_DATA_I(31 downto 24);
              WHEN "11" =>
                REGISTERS(REG_INDEX_LED)(7 downto 0) <= BUF_DATA_I(31 downto 24);
              WHEN OTHERS =>
                -- TODO: FIXME, probably should generate an error
              END CASE;
              BUF_ACKs_O <=  ACK_BYTE; -- acknowledge the Byte
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Ack_Reg_Write;
            ELSE
              BUF_ACKs_O <= ACK_ERR; -- unsupported address, signal error
              BUF_ERRs_O <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
-- _MASTER_
          ELSIF (SBUS_3V3_BGs='1' AND
                 ((REGISTERS(REG_INDEX_DMA_CTRL)(DMA_CTRL_START_IDX)='1' AND
                   REGISTERS(REG_INDEX_DMA_CTRL)(DMA_CTRL_BUSY_IDX)='0' AND
                   REGISTERS(REG_INDEX_DMA_CTRL)(DMA_CTRL_ERR_IDX)='0') OR
                  (REGISTERS(REG_INDEX_DMAW_CTRL)(DMA_CTRL_START_IDX)='1' AND
                   REGISTERS(REG_INDEX_DMAW_CTRL)(DMA_CTRL_BUSY_IDX)='0' AND
                   REGISTERS(REG_INDEX_DMAW_CTRL)(DMA_CTRL_ERR_IDX)='0')
                 )) then
-- we have a DMA request pending and not been granted the bus
            IF ((REGISTERS(REG_INDEX_DMA_CTRL)(DMA_CTRL_GCM_IDX) = '1') OR
                ((REGISTERS(REG_INDEX_DMA_CTRL)(DMA_CTRL_AES_IDX) = '1') AND
                 (REGISTERS(REG_INDEX_AES128_CTRL) = 0) AND
                 (fifo_toaes_full = '0')) OR
                ((REGISTERS(REG_INDEX_DMAW_CTRL)(DMA_CTRL_AES_IDX) = '1') AND
                 (REGISTERS(REG_INDEX_AES128_CTRL) = 0) AND
                 (fifo_fromaes_empty = '0'))
               ) THEN
              fifo_wr_en <= '1'; fifo_din <= x"61"; -- "a"
              -- GCM is always available (1 cycle)
              -- for AES don't request the bus unless the AES block is free
              -- (so for read we can use it, for write the job is done)
              -- there could be a race condition for AES if someone write the register before we get the bus...
              SBUS_3V3_BRs <= '0'; -- request the bus
            ELSE
              fifo_wr_en <= '1'; fifo_din <= x"7a"; -- "z"
            END IF;
          ELSIF (SBUS_3V3_BGs='0') THEN
              fifo_wr_en <= '1'; fifo_din <= x"62"; -- "b"
-- we were granted the bus for DMA
              SBUS_3V3_BRs <= '1'; -- relinquish the request (required)
              DATA_T <= '0'; -- set data buffer as output
              SM_T <= '0'; -- PPRD, SIZ becomes output (master mode)
              SMs_T <= '1';
              IF ((REGISTERS(REG_INDEX_DMAW_CTRL)(DMA_CTRL_START_IDX) = '1') AND
                  (fifo_fromaes_empty = '0')) THEN
                dma_write := true;
                dma_ctrl_idx := REG_INDEX_DMAW_CTRL;
                dma_addr_idx := REG_INDEX_DMAW_ADDR;
                BUF_DATA_O <= REGISTERS(REG_INDEX_DMAW_ADDR); -- virt address
                BUF_PPRD_O <= '0'; -- writing to slave
                REGISTERS(REG_INDEX_AES128_OUT1) <= fifo_fromaes_dout(127 downto 96);
                REGISTERS(REG_INDEX_AES128_OUT2) <= fifo_fromaes_dout( 95 downto 64);
                REGISTERS(REG_INDEX_AES128_OUT3) <= fifo_fromaes_dout( 63 downto 32);
                REGISTERS(REG_INDEX_AES128_OUT4) <= fifo_fromaes_dout( 31 downto 0);
                fifo_fromaes_rd_en <= '1';
              ELSE
                dma_write := false;
                dma_ctrl_idx := REG_INDEX_DMA_CTRL;
                dma_addr_idx := REG_INDEX_DMA_ADDR;
                BUF_DATA_O <= REGISTERS(REG_INDEX_DMA_ADDR); -- virt address
                BUF_PPRD_O <= '1'; -- reading from slave
              END IF;
--              IF (conv_integer(REGISTERS(REG_INDEX_DMA_CTRL)(11 downto 0)) >= 3) THEN
--                BUF_SIZ_O <= SIZ_BURST16;
--                BURST_LIMIT := 16;
--              ELS
              IF ((dma_write = false) AND
                  (REGISTERS(dma_ctrl_idx)(DMA_CTRL_GCM_IDX) = '1') AND
                  conv_integer(REGISTERS(dma_ctrl_idx)(11 downto 0)) >= 1) THEN
              -- 32 bytes burst only for GCM ATM (bit 27)
                BUF_SIZ_O <= SIZ_BURST8;
                BURST_LIMIT := 8;
              ELSE
                BUF_SIZ_O <= SIZ_BURST4;
                BURST_LIMIT := 4;
              END IF;
              -- REGISTERS(REG_INDEX_LED) <= REGISTERS(REG_INDEX_DMA_ADDR); -- show the virt on the LEDs
              BURST_COUNTER := 0;
              State <= SBus_Master_Translation;
-- ERROR ERROR ERROR 
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND BUF_SIZ_I /= SIZ_WORD THEN
            SMs_T <= '0'; -- ACKs/ERRs buffer in slave mode/output
            fifo_wr_en <= '1'; fifo_din <= x"58"; -- "X"
            BUF_ACKs_O <= ACK_ERR; -- unsupported config, signal error
            BUF_ERRs_O <= '1'; -- no late error
            State <= SBus_Slave_Error; 
          END IF;
-- -- -- -- END IDLE

        WHEN SBus_Slave_Ack_Reg_Write =>
          fifo_wr_en <= '1'; fifo_din <= x"45"; -- "E"
          BUF_ACKs_O <= ACK_IDLE; -- need one cycle of idle
          IF (SBUS_3V3_ASs='1') THEN
            seen_ack := true;
          END IF;
          State <= SBus_Slave_Ack_Reg_Write_Final;
          
        WHEN SBus_Slave_Ack_Reg_Write_Final =>
          fifo_wr_en <= '1'; fifo_din <= x"46"; -- "F"
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
          IF (finish_gcm) THEN
            finish_gcm := false;
            REGISTERS(REG_INDEX_GCM_C1) <= reverse_bit_in_byte(mas_c(31  downto  0));
            REGISTERS(REG_INDEX_GCM_C2) <= reverse_bit_in_byte(mas_c(63  downto 32));
            REGISTERS(REG_INDEX_GCM_C3) <= reverse_bit_in_byte(mas_c(95  downto 64));
            REGISTERS(REG_INDEX_GCM_C4) <= reverse_bit_in_byte(mas_c(127 downto 96));
          END IF;
          IF ((seen_ack) OR (SBUS_3V3_ASs='1')) THEN
            seen_ack := false;
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Ack_Reg_Write_Burst =>
          fifo_wr_en <= '1'; fifo_din <= x"48"; -- "H"
          BURST_INDEX := conv_integer(INDEX_WITH_WRAP(BURST_COUNTER, BURST_LIMIT, last_pa(5 downto 2)));
          REGISTERS(conv_integer(last_pa(8 downto 6))*16 + BURST_INDEX) <= BUF_DATA_I;
          IF (last_pa(8 downto 0) = REG_OFFSET_LED) THEN
            LED_RESET <= '1'; -- reset led cycle
          ELSIF (last_pa(8 downto 0) = REG_OFFSET_GCM_INPUT4) THEN
            mas_a(31  downto  0) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT1) xor REGISTERS(REG_INDEX_GCM_C1));
            mas_a(63  downto 32) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT2) xor REGISTERS(REG_INDEX_GCM_C2));
            mas_a(95  downto 64) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT3) xor REGISTERS(REG_INDEX_GCM_C3));
            mas_a(127 downto 96) <= reverse_bit_in_byte(BUF_DATA_I                      xor REGISTERS(REG_INDEX_GCM_C4));
            mas_b(31  downto  0) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H1));
            mas_b(63  downto 32) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H2));
            mas_b(95  downto 64) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H3));
            mas_b(127 downto 96) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H4));
            finish_gcm := true;
          END IF;
          if (BURST_COUNTER = (BURST_LIMIT-1)) THEN
            BUF_ACKs_O <= ACK_IDLE;
            State <= SBus_Slave_Ack_Reg_Write_Final;
          ELSE
            BUF_ACKs_O <= ACK_WORD; -- acknowledge the Word
            BURST_COUNTER := BURST_COUNTER + 1;
          END IF;
          
        WHEN SBus_Slave_Ack_Read_Prom_Burst =>
          fifo_wr_en <= '1'; fifo_din <= x"49"; -- "I"
          DATA_T <= '0'; -- set buffer as output
          -- put data from PROM on the bus
          BUF_DATA_O <= p_data; -- address set in previous cycle
          BURST_INDEX := conv_integer(INDEX_WITH_WRAP((BURST_COUNTER + 1), BURST_LIMIT, last_pa(5 downto 2)));
          p_addr <= last_pa(8 downto 6) & conv_std_logic_vector(BURST_INDEX,4); -- for next cycle
          if (BURST_COUNTER = (BURST_LIMIT-1)) then
            BUF_ACKs_O <= ACK_IDLE;
            State <= SBus_Slave_Do_Read;
          else
            BUF_ACKs_O <= ACK_WORD;
            BURST_COUNTER := BURST_COUNTER + 1;
          end if;
          
        WHEN SBus_Slave_Ack_Read_Reg_Burst =>
          fifo_wr_en <= '1'; fifo_din <= x"4A"; -- "J"
          DATA_T <= '0'; -- set buffer as output
          BURST_INDEX := conv_integer(INDEX_WITH_WRAP(BURST_COUNTER, BURST_LIMIT, last_pa(5 downto 2)));
          BUF_DATA_O <= REGISTERS(conv_integer(last_pa(8 downto 6))*16 + BURST_INDEX);
          if (BURST_COUNTER = (BURST_LIMIT-1)) then
            BUF_ACKs_O <= ACK_IDLE;
            State <= SBus_Slave_Do_Read;
          else
            BUF_ACKs_O <= ACK_WORD;
            BURST_COUNTER := BURST_COUNTER + 1;
          end if;
          
        WHEN SBus_Slave_Do_Read => -- this is the (last) cycle IN which the master read
          fifo_wr_en <= '1'; fifo_din <= x"4B"; -- "K"
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
          IF (SBUS_3V3_ASs='1') THEN
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Ack_Read_Prom_Byte =>
          fifo_wr_en <= '1'; fifo_din <= x"4C"; -- "L"
          IF (last_pa(27 downto 9) = ROM_ADDR_PFX) then -- do we need to re-test ?
            BUF_ACKs_O <= ACK_IDLE;
            -- put data from PROM on the bus
            DATA_T <= '0'; -- set buffer as output
            CASE last_pa(1 downto 0) IS
              WHEN "00" =>
                BUF_DATA_O(31 downto 24) <= p_data(31 downto 24);
                BUF_DATA_O(23 downto 0) <= (others => '0');
              WHEN "01" =>
                BUF_DATA_O(31 downto 24) <= p_data(23 downto 16);
                BUF_DATA_O(23 downto 0) <= (others => '0');
              WHEN "10" =>
                BUF_DATA_O(31 downto 24) <= p_data(15 downto 8);
                BUF_DATA_O(23 downto 0) <= (others => '0');
              WHEN "11" =>
                BUF_DATA_O(31 downto 24) <= p_data(7 downto 0);
                BUF_DATA_O(23 downto 0) <= (others => '0');
              WHEN OTHERS =>
                BUF_DATA_O(31 downto 0) <= (others => '0'); -- TODO: FIXME, probably should generate an error
            END CASE;
            State <= SBus_Slave_Do_Read;
          ELSE
            BUF_ACKs_O <= ACK_IDLE;
            State <= SBus_Slave_Delay_Error; 
          END IF;
          
        WHEN SBus_Slave_Ack_Read_Prom_HWord =>
          fifo_wr_en <= '1'; fifo_din <= x"4D"; -- "M"
          IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) and (last_pa(0) = '0'))then -- do we need to re-test ?
            BUF_ACKs_O <= ACK_IDLE;
            -- put data from PROM on the bus
            DATA_T <= '0'; -- set buffer as output
            CASE last_pa(1) IS
              WHEN '0' =>
                BUF_DATA_O(31 downto 16) <= p_data(31 downto 16);
                BUF_DATA_O(15 downto 0) <= (others => '0');
              WHEN '1' =>
                BUF_DATA_O(31 downto 16) <= p_data(15 downto 0);
                BUF_DATA_O(15 downto 0) <= (others => '0');
              WHEN OTHERS =>
                BUF_DATA_O(31 downto 0) <= (others => '0'); -- TODO: FIXME, probably should generate an error
            END CASE;
            State <= SBus_Slave_Do_Read;
          ELSE
            BUF_ACKs_O <= ACK_IDLE;
            State <= SBus_Slave_Delay_Error; 
          END IF;
          
        WHEN SBus_Slave_Error =>
          fifo_wr_en <= '1'; fifo_din <= x"59"; -- "Y"
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
          IF (SBUS_3V3_ASs='1') THEN
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Delay_Error =>
          fifo_wr_en <= '1'; fifo_din <= x"5A"; -- "Z"
          BUF_ERRs_O <= '0'; -- two cycles after ACK
          State <= SBus_Slave_Error;
          
--        WHEN SBus_Slave_Heartbeat =>
--          State <= SBus_Idle;

-- _MASTER_
        when SBus_Master_Translation =>
          fifo_wr_en <= '1'; fifo_din <= x"63"; -- "c"
          IF (dma_write = false) THEN
            DATA_T <= '1'; -- set buffer back to input
          ELSE
            DATA_T <= '0';
            BUF_DATA_O <= REGISTERS(REG_INDEX_AES128_OUT1);
          END IF;
          IF (BUF_ACKs_I = ACK_ERR) THEN
            fifo_din <= x"2F"; -- "/"
            REGISTERS(dma_ctrl_idx)(DMA_CTRL_ERR_IDX) <= '1';
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          ELSIF (BUF_ACKs_I = ACK_RERUN) THEN
            fifo_din <= x"5c"; -- "\"
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          ELSIF (BUF_ACKs_I = ACK_IDLE) THEN
            IF (dma_write = false) THEN
              State <= SBus_Master_Read;
            ELSE
              BURST_COUNTER := BURST_COUNTER + 1; -- should happen only once
              State <= SBus_Master_Write;
            END IF;
          ELSIF (SBUS_3V3_BGs='1') THEN
            -- oups, we lost our bus access without error ?!?
            fifo_din <= x"21"; -- "!"
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          END IF;

        when SBus_Master_Read =>
          fifo_wr_en <= '1'; fifo_din <= x"64"; -- "d"
          if (BUF_ACKs_I = ACK_WORD) THEN
            State <= SBus_Master_Read_Ack;
          elsif (BUF_ACKS_I = ACK_IDLE) then
            State <= SBus_Master_Read;
          elsif (BUF_ACKS_I = ACK_RERUN) THEN
            fifo_din <= x"2b"; -- "+"
            -- TODO FIXME
            -- fall back to idle without changing CTRL
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          else -- (BUF_ACKS_I = ACK_ERR) or other
            fifo_din <= x"27"; -- "'"
            -- TODO FIXME
            -- fall back to idle while setting error
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            REGISTERS(dma_ctrl_idx)(DMA_CTRL_ERR_IDX) <= '1';
            State <= SBus_Idle;
          end IF;
          
        when SBus_Master_Read_Ack =>
          fifo_wr_en <= '1'; fifo_din <= x"65"; -- "e"
          IF (REGISTERS(dma_ctrl_idx)(DMA_CTRL_GCM_IDX) = '1') THEN
            REGISTERS(REG_INDEX_GCM_INPUT1 + (BURST_COUNTER mod 4)) <= BUF_DATA_I;
            BURST_COUNTER := BURST_COUNTER + 1;
            IF (finish_gcm) THEN
              finish_gcm := false;
              REGISTERS(REG_INDEX_GCM_C1) <= reverse_bit_in_byte(mas_c(31  downto  0));
              REGISTERS(REG_INDEX_GCM_C2) <= reverse_bit_in_byte(mas_c(63  downto 32));
              REGISTERS(REG_INDEX_GCM_C3) <= reverse_bit_in_byte(mas_c(95  downto 64));
              REGISTERS(REG_INDEX_GCM_C4) <= reverse_bit_in_byte(mas_c(127 downto 96));
            ELSIF (BURST_COUNTER mod 4 = 0) THEN
              mas_a(31  downto  0) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT1) xor REGISTERS(REG_INDEX_GCM_C1));
              mas_a(63  downto 32) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT2) xor REGISTERS(REG_INDEX_GCM_C2));
              mas_a(95  downto 64) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_INPUT3) xor REGISTERS(REG_INDEX_GCM_C3));
              mas_a(127 downto 96) <= reverse_bit_in_byte(BUF_DATA_I                      xor REGISTERS(REG_INDEX_GCM_C4)); -- INPUT4 will only be valid next cycle
              mas_b(31  downto  0) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H1));
              mas_b(63  downto 32) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H2));
              mas_b(95  downto 64) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H3));
              mas_b(127 downto 96) <= reverse_bit_in_byte(REGISTERS(REG_INDEX_GCM_H4));
              finish_gcm := true;
            END IF;
          ELSIF (REGISTERS(dma_ctrl_idx)(DMA_CTRL_AES_IDX) = '1') THEN
            REGISTERS(REG_INDEX_AES128_DATA1 + (BURST_COUNTER mod 4)) <= BUF_DATA_I;
            BURST_COUNTER := BURST_COUNTER + 1;
            IF (BURST_COUNTER mod 4 = 0) THEN
--              REGISTERS(REG_INDEX_AES128_CTRL) <= x"88000000"; -- request to start a CBC block
              -- enqueue the block in the AES FIFO
              IF (REGISTERS(dma_ctrl_idx)(DMA_CTRL_CBC_IDX) = '0') THEN
              fifo_toaes_din <=
                '0' & -- !iskey
                '0' & -- keylen, ignored
                '1' & -- encdec, enc for now
                '0' & -- cbc
                '1' & -- internal cbc
                x"00000000000000000000000000000000" &
                REGISTERS(REG_INDEX_AES128_DATA1) & REGISTERS(REG_INDEX_AES128_DATA2) &
                REGISTERS(REG_INDEX_AES128_DATA3) & BUF_DATA_I;
              fifo_toaes_wr_en <= '1';
              ELSE
              fifo_toaes_din <=
                '0' & -- !iskey
                '0' & -- keylen, ignored
                '1' & -- encdec, enc for now
                '0' & -- cbc
                '0' & -- internal cbc
                x"00000000000000000000000000000000" &
                (REGISTERS(REG_INDEX_AES128_DATA1) XOR REGISTERS(REG_INDEX_AES128_OUT1)) & 
                (REGISTERS(REG_INDEX_AES128_DATA2) XOR REGISTERS(REG_INDEX_AES128_OUT2)) &
                (REGISTERS(REG_INDEX_AES128_DATA3) XOR REGISTERS(REG_INDEX_AES128_OUT3)) & 
                (BUF_DATA_I                        XOR REGISTERS(REG_INDEX_AES128_OUT4));
              fifo_toaes_wr_en <= '1';
              REGISTERS(dma_ctrl_idx)(DMA_CTRL_CBC_IDX) <= '0';
              END IF;
            END IF;
          END IF; -- GCM | AES
          if (BURST_COUNTER = BURST_LIMIT) THEN
            State <= SBus_Master_Read_Finish;
          ELSIF (BUF_ACKs_I = ACK_WORD) THEN
            State <= SBus_Master_Read_Ack;
          elsif (BUF_ACKS_I = ACK_IDLE) then
            State <= SBus_Master_Read;
          elsif (BUF_ACKS_I = ACK_RERUN) THEN
            fifo_din <= x"2b"; -- "+"
            -- TODO FIXME
            -- fall back to idle without changing CTRL
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          else -- (BUF_ACKS_I = ACK_ERR) or other
            fifo_din <= x"27"; -- "'"
            -- TODO FIXME
            -- fall back to idle while setting error
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            REGISTERS(dma_ctrl_idx)(DMA_CTRL_ERR_IDX) <= '1';
            State <= SBus_Idle;
          end IF;

        when SBus_Master_Read_Finish =>
          -- missing the handling of late error
          fifo_wr_en <= '1'; fifo_din <= x"66"; -- "f"
          IF (finish_gcm) THEN
            finish_gcm := false;
            REGISTERS(REG_INDEX_GCM_C1) <= reverse_bit_in_byte(mas_c(31  downto  0));
            REGISTERS(REG_INDEX_GCM_C2) <= reverse_bit_in_byte(mas_c(63  downto 32));
            REGISTERS(REG_INDEX_GCM_C3) <= reverse_bit_in_byte(mas_c(95  downto 64));
            REGISTERS(REG_INDEX_GCM_C4) <= reverse_bit_in_byte(mas_c(127 downto 96));
          END IF;
          IF (REGISTERS(dma_ctrl_idx)(11 downto 0) = ((BURST_LIMIT/4)-1)) THEN
            -- finished, stop the DMA engine
            REGISTERS(dma_ctrl_idx) <= (others => '0');
          ELSE
            -- move to next block
            REGISTERS(dma_ctrl_idx)(11 downto 0) <= REGISTERS(dma_ctrl_idx)(11 downto 0) - (BURST_LIMIT/4);
            REGISTERS(dma_addr_idx) <= REGISTERS(dma_addr_idx) + (BURST_LIMIT*4);
          END IF;
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
          State <= SBus_Idle;

        when SBus_Master_Write =>
          fifo_wr_en <= '1'; fifo_din <= x"67"; -- "g"
          IF (BUF_ACKs_I = ACK_IDLE) THEN
            -- wait some more
          ELSIF (BUF_ACKs_I = ACK_WORD) THEN
            IF (BURST_COUNTER = BURST_LIMIT) THEN
              State <= SBus_Master_Write_Final;
            ELSE
              BUF_DATA_O <= REGISTERS(REG_INDEX_AES128_OUT1 + (BURST_COUNTER mod 4));
              BURST_COUNTER := BURST_COUNTER + 1;
            END IF;
          elsif (BUF_ACKS_I = ACK_RERUN) THEN
            fifo_din <= x"2b"; -- "+"
            -- TODO FIXME
            -- fall back to idle without changing CTRL
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            State <= SBus_Idle;
          else -- (BUF_ACKS_I = ACK_ERR) or other
            fifo_din <= x"27"; -- "'"
            -- TODO FIXME
            -- fall back to idle while setting error
            SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                             SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                             p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            REGISTERS(dma_ctrl_idx)(DMA_CTRL_ERR_IDX) <= '1';
            State <= SBus_Idle;
          END IF;
          
        when SBus_Master_Write_Final =>
          -- missing the handling of late error
          fifo_wr_en <= '1'; fifo_din <= x"68"; -- "h"
          IF (REGISTERS(dma_ctrl_idx)(DMA_CTRL_AES_IDX) = '1') THEN -- should always be true ATM
            IF (REGISTERS(dma_ctrl_idx)(11 downto 0) = ((BURST_LIMIT/4)-1)) THEN
              -- finished, stop the DMA engine
              REGISTERS(dma_ctrl_idx) <= (others => '0');
            ELSE
              -- move to next block
              REGISTERS(dma_ctrl_idx)(11 downto 0) <= REGISTERS(dma_ctrl_idx)(11 downto 0) - (BURST_LIMIT/4);
              REGISTERS(dma_addr_idx) <= REGISTERS(dma_addr_idx) + (BURST_LIMIT*4);
            END IF;
          END IF;
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
          State <= SBus_Idle;
-- FALLBACK
        WHEN OTHERS => -- include SBus_Start
          -- SBUS_OE <= '0'; -- enable all signals -- moved to COUNTER48 timer
          if SBUS_3V3_RSTs = '1' then
          SBus_Set_Default(SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, SM_T, SMs_T, LED_RESET);
            REGISTERS(REG_INDEX_DMA_CTRL) <= (others => '0');
            REGISTERS(REG_INDEX_DMAW_CTRL) <= (others => '0');
            IF (RES_COUNTER = 0) THEN
              -- fifo_wr_en <= '1'; fifo_din <= x"2A"; -- "*"
              State <= SBus_Idle;
            ELSE
              fifo_rst <= '0';
              RES_COUNTER <= RES_COUNTER - 1;
            END IF;
          else -- shouldn't happen ?
            fifo_rst <= '1';
            RES_COUNTER <= 4;
          END IF;

      END CASE;
      
      CASE AES_State IS
      WHEN AES_IDLE =>
        IF ((REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_START_IDX) = '1') AND
            (fifo_toaes_full = '0')
            ) THEN
            fifo_wr_en <= '1'; fifo_din <= x"30"; -- "0"
            REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_BUSY_IDX) <= '1';
          -- start & !busy & !aesbusy -> start processing
          if (REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_NEWKEY_IDX) = '1') THEN --newkey 
            fifo_toaes_din <=
              '1' & -- iskey
              REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_AES256_IDX) & -- keylen
              (NOT REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_DEC_IDX)) & -- encdec
              REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_CBCMOD_IDX) & -- cbc
              '0' & -- internal cbc
              REGISTERS(REG_INDEX_AES128_KEY1) & REGISTERS(REG_INDEX_AES128_KEY2) &
              REGISTERS(REG_INDEX_AES128_KEY3) & REGISTERS(REG_INDEX_AES128_KEY4) &
              REGISTERS(REG_INDEX_AES128_KEY5) & REGISTERS(REG_INDEX_AES128_KEY6) &
              REGISTERS(REG_INDEX_AES128_KEY7) & REGISTERS(REG_INDEX_AES128_KEY8);
            fifo_toaes_wr_en <= '1';
            AES_State <= AES_INIT1;
          ELSE
            fifo_toaes_din <=
              '0' & -- !iskey
              REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_AES256_IDX) & -- keylen
              (NOT REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_DEC_IDX)) & -- encdec
              REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_CBCMOD_IDX) & -- cbc
              '0' & -- internal cbc
              REGISTERS(REG_INDEX_AES128_OUT1) & REGISTERS(REG_INDEX_AES128_OUT2) &
              REGISTERS(REG_INDEX_AES128_OUT3) & REGISTERS(REG_INDEX_AES128_OUT4) &
              REGISTERS(REG_INDEX_AES128_DATA1) & REGISTERS(REG_INDEX_AES128_DATA2) &
              REGISTERS(REG_INDEX_AES128_DATA3) & REGISTERS(REG_INDEX_AES128_DATA4);
            fifo_toaes_wr_en <= '1';
            AES_State <= AES_CRYPT1;
          END IF;
        END IF;
        
        when AES_INIT1 =>
          fifo_wr_en <= '1'; fifo_din <= x"31"; -- "1"
          fifo_toaes_wr_en <= '0';
          REGISTERS(REG_INDEX_AES128_CTRL)(AES128_CTRL_NEWKEY_IDX) <= '0';
          AES_State <= AES_IDLE;
          
        when AES_CRYPT1 =>
          AES_TIMEOUT_COUNTER <= 63;
          fifo_wr_en <= '1'; fifo_din <= x"33"; -- "3"
          fifo_toaes_wr_en <= '0';
          AES_State <= AES_CRYPT2;
        WHEN AES_CRYPT2 =>
          AES_TIMEOUT_COUNTER <= AES_TIMEOUT_COUNTER - 1;
          fifo_wr_en <= '1'; fifo_din <= x"34"; -- "4"
          IF (fifo_fromaes_empty = '0') THEN
            fifo_wr_en <= '1'; fifo_din <= x"35"; -- "5"
            fifo_fromaes_rd_en <= '1';
            -- start & busy & !aesbusy -> done processing
            REGISTERS(REG_INDEX_AES128_OUT1) <= fifo_fromaes_dout(127 downto 96);
            REGISTERS(REG_INDEX_AES128_OUT2) <= fifo_fromaes_dout( 95 downto 64);
            REGISTERS(REG_INDEX_AES128_OUT3) <= fifo_fromaes_dout( 63 downto 32);
            REGISTERS(REG_INDEX_AES128_OUT4) <= fifo_fromaes_dout( 31 downto 0);
            REGISTERS(REG_INDEX_AES128_CTRL) <= (others => '0');
            AES_State <= AES_IDLE;
          ELSIF (AES_TIMEOUT_COUNTER = 0) THEN
            fifo_wr_en <= '1'; fifo_din <= x"36"; -- "6"
            -- oups
            REGISTERS(REG_INDEX_AES128_CTRL) <= (others => '0');
            AES_State <= AES_IDLE;
          END IF;
      END CASE;
    END IF;
  END PROCESS;
  
  process(fxclk_in, fifo_rst)
  BEGIN
  if (fifo_rst = '1') THEN
    Uart_State <= UART_IDLE;
  ELSIF RISING_EDGE(fxclk_in) THEN
    r_TX_DV <= '0';
    fifo_rd_en <= '0';
--    LIFE_COUNTER48 <= LIFE_COUNTER48 - 1;
    CASE Uart_State IS
    WHEN UART_IDLE =>
        IF (fifo_empty = '0') THEN
            r_TX_DV <= '1';
            fifo_rd_en <= '1';
            r_TX_BYTE <= fifo_dout;
            Uart_State <= UART_WAITING;
--        ELSIF (LIFE_COUNTER48 <= 500000) THEN
--            LIFE_COUNTER48 <= 48000000;
--            r_TX_DV <= '1';
--            CASE State IS
--                       When SBus_Start => r_TX_BYTE <= x"61"; -- "a"
--                       When SBus_Idle => r_TX_BYTE <= x"62"; -- "b"
--                       When SBus_Slave_Ack_Reg_Write => r_TX_BYTE <= x"63"; -- "c"
--                       When SBus_Slave_Ack_Reg_Write_Final => r_TX_BYTE <= x"64"; -- "d"                
--                       When SBus_Slave_Ack_Reg_Write_Final_Idle => r_TX_BYTE <= x"65"; -- "d"
--                       When SBus_Slave_Ack_Reg_Write_Burst => r_TX_BYTE <= x"66"; -- "f"
--                       When SBus_Slave_Ack_Read_Prom_Byte => r_TX_BYTE <= x"67"; -- "g"
--                       When SBus_Slave_Ack_Read_Prom_HWord => r_TX_BYTE <= x"68"; -- "h"
--                       When SBus_Slave_Ack_Read_Prom_Burst => r_TX_BYTE <= x"69"; -- "i"
--                       When SBus_Slave_Ack_Read_Reg_Byte => r_TX_BYTE <= x"6a"; -- "j"
--                       When SBus_Slave_Ack_Read_Reg_HWord => r_TX_BYTE <= x"6b"; -- "k"
--                       When SBus_Slave_Ack_Read_Reg_Burst => r_TX_BYTE <= x"6c"; -- "l"
--                       When SBus_Slave_Do_Read => r_TX_BYTE <= x"6d"; -- "m"
--                       When SBus_Slave_Delay_Error => r_TX_BYTE <= x"6e"; -- "n"
--                       When SBus_Slave_Error => r_TX_BYTE <= x"6f"; -- "o"
--                       When others => r_TX_BYTE <= x"7a"; -- "z"
--             END CASE;
        END IF;
    WHEN UART_WAITING =>
        if (w_TX_DONE = '1') then
            Uart_State <= UART_IDLE;
        END IF;
    END CASE;
  END IF;
  END PROCESS;
  
  -- process to enable signal after a while
  process(fxclk_in)
  BEGIN
  IF RISING_EDGE(fxclk_in) THEN
    IF (OE_COUNTER = 0) THEN
        SBUS_OE <= '0';
    ELSE
        OE_COUNTER <= OE_COUNTER - 1;
    END IF;
  END IF;
  END PROCESS;
  
  process (aes_clk_out)
  BEGIN
  IF RISING_EDGE(aes_clk_out) THEN
    if (AES_RST_COUNTER = 0) THEN
        aes_wrapper_rst <= '1';
    else
        AES_RST_COUNTER <= (AES_RST_COUNTER - 1);
        aes_wrapper_rst <= '0';
    end if;
  END IF;
  END PROCESS;
  
END rtl;
