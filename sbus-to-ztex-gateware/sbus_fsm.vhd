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
    SBUS_3V3_RSTs : 	IN STD_LOGIC;
    SBUS_3V3_SELs : 	IN STD_LOGIC;
    SBUS_3V3_ASs : 	IN STD_LOGIC;
    SBUS_3V3_PPRD : 	IN STD_LOGIC; -- OUT during extended transfers and on masters; input for masters only during ET
    SBUS_3V3_SIZ :     IN std_logic_vector(2 downto 0); -- OUT during extended transfers and on masters; input for masters only during ET
    SBUS_3V3_ACKs :     OUT std_logic_vector(2 downto 0) := (others => 'Z'); -- IN on masters
    SBUS_3V3_PA :      IN std_logic_vector(27 downto 0); -- OUT during extended transfers and on masters
    SBUS_3V3_ERRs : 	OUT STD_LOGIC := 'Z'; -- IN on masters
    SBUS_3V3_D :      INOUT std_logic_vector(31 downto 0);
    SBUS_3V3_INT1s : 	OUT STD_LOGIC := 'Z';
    SBUS_3V3_INT7s : 	OUT STD_LOGIC := 'Z';
    -- master-only signals
    SBUS_3V3_BGs : IN STD_LOGIC; -- bus granted
    SBUS_3V3_BRs : OUT STD_LOGIC := 'Z'; -- bus request
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
  -- OFFSET to REGS; (8 downto 0) so 9 bits
  CONSTANT REG_OFFSET_LED        : std_logic_vector(8 downto 0) := conv_std_logic_vector( 0, 9);
  -- starts at 64 so we can do 64 bytes burst (see address wrapping)
  CONSTANT REG_INDEX_GCM_H1     : integer := 0;
  CONSTANT REG_INDEX_GCM_H2     : integer := 1;
  CONSTANT REG_INDEX_GCM_H3     : integer := 2;
  CONSTANT REG_INDEX_GCM_H4     : integer := 3;
  CONSTANT REG_INDEX_GCM_C1     : integer := 4;
  CONSTANT REG_INDEX_GCM_C2     : integer := 5;
  CONSTANT REG_INDEX_GCM_C3     : integer := 6;
  CONSTANT REG_INDEX_GCM_C4     : integer := 7;
  CONSTANT REG_INDEX_GCM_INPUT1 : integer := 8;
  CONSTANT REG_INDEX_GCM_INPUT2 : integer := 9;
  CONSTANT REG_INDEX_GCM_INPUT3 : integer := 10;
  CONSTANT REG_INDEX_GCM_INPUT4 : integer := 11;
  CONSTANT REG_INDEX_GCM_INPUT5 : integer := 12; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT6 : integer := 13; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT7 : integer := 14; -- placeholder
  CONSTANT REG_INDEX_GCM_INPUT8 : integer := 15; -- placeholder
  
  CONSTANT REG_OFFSET_GCM_H1     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_H1*4, 9);
  CONSTANT REG_OFFSET_GCM_H2     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_H2*4, 9);
  CONSTANT REG_OFFSET_GCM_H3     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_H3*4, 9);
  CONSTANT REG_OFFSET_GCM_H4     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_H4*4, 9);
  CONSTANT REG_OFFSET_GCM_C1     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_C1*4, 9);
  CONSTANT REG_OFFSET_GCM_C2     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_C2*4, 9);
  CONSTANT REG_OFFSET_GCM_C3     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_C3*4, 9);
  CONSTANT REG_OFFSET_GCM_C4     : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_C4*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT1 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT1*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT2 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT2*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT3 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT3*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT4 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT4*4, 9);
  CONSTANT REG_OFFSET_GCM_INPUT5 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT5*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT6 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT6*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT7 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT7*4, 9); -- placeholder
  CONSTANT REG_OFFSET_GCM_INPUT8 : std_logic_vector(8 downto 0) := conv_std_logic_vector(64 + REG_INDEX_GCM_INPUT8*4, 9); -- placeholder
  
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
                       SBus_Slave_Error
--                       ,SBus_Slave_Heartbeat
                       );
  TYPE Uart_States IS ( UART_IDLE, UART_WAITING );
                       
  SIGNAL State : SBus_States := SBus_Start;
  SIGNAL Uart_State : Uart_States := UART_IDLE;
  SIGNAL LED_RESET: std_logic := '0';
  SIGNAL LED_DATA: std_logic_vector(31 downto 0) := (others => '0');
  signal DATA_T : std_logic := '1'; -- I/O control for IOBUF, default to input
  signal BUF_DATA_I, BUF_DATA_O : std_logic_vector(31 downto 0); --buffers for data from/to
  SIGNAL p_addr : std_logic_vector(6 downto 0) := "1111111"; -- addr lines to prom
  SIGNAL p_data : std_logic_vector(31 downto 0); -- data lines to prom
  
  -- signal uart_clk : std_logic; -- 5.76 MHz clock for FIFO write & UART
  
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
  
  
  
--  SIGNAL LIFE_COUNTER48 : natural range 0 to 48000000 := 300;
--  SIGNAL LIFE_COUNTER25 : natural range 0 to 25000000 := 300;
  SIGNAL RES_COUNTER : natural range 0 to 5 := 5;
  -- counter to wait 20s before enabling SBus signals, without this the SS20 won't POST reliably...
  -- this means a need to probe-sbus from the PROM to find the board (or warm reset)
  SIGNAL OE_COUNTER : natural range 0 to 960000000 := 960000000;

  type GCM_REGISTERS_TYPE is array(0 to 15) of std_logic_vector(31 downto 0);
  SIGNAL GCM_REGISTERS : GCM_REGISTERS_TYPE;
  
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

  pure function REG_OFFSET_IS_ANYGCM (value : in std_logic_vector(8 downto 0)) return boolean is
  begin
    return REG_OFFSET_IS_GCMINPUT(value) or REG_OFFSET_IS_GCMH(value) or REG_OFFSET_IS_GCMC(value);
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
  
  component fifo_generator_0 is
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

  component clk_wiz_0 is
  port(clk_in1 : in std_logic;
       clk_out1 : out std_logic);
  end component clk_wiz_0;

  PROCEDURE SBus_Set_Default(
    signal SBUS_3V3_ACKs :     OUT std_logic_vector(2 downto 0);
    signal SBUS_3V3_ERRs : 	OUT STD_LOGIC;
    signal SBUS_3V3_INT1s : 	OUT STD_LOGIC;
    signal SBUS_3V3_INT7s : 	OUT STD_LOGIC;
    -- support leds
    signal SBUS_DATA_OE_LED : OUT std_logic; -- light during read cycle
    signal SBUS_DATA_OE_LED_2 : OUT std_logic; -- light during write cycle)
    -- ROM
    signal p_addr : OUT std_logic_vector(6 downto 0); -- TODO: how to reference the add_bits from PROM ?
    -- Data buffers
    signal DATA_T : OUT std_logic; -- I/O control for IOBUF
    -- Data LEDS
    signal LED_RESET: OUT std_logic -- force LED cycling from start
    ) IS
  BEGIN
    SBUS_DATA_OE_LED <= '0'; -- off
    SBUS_DATA_OE_LED_2 <= '0'; -- off
    SBUS_3V3_ACKs <= ACK_DISABLED; -- no drive
    SBUS_3V3_ERRs <= 'Z'; -- idle
    SBUS_3V3_INT1s <= 'Z';
    SBUS_3V3_INT7s <= 'Z';
    p_addr <= "1111111"; -- look-up last element, all-0
    DATA_T <= '1'; -- set buffer as input
    LED_RESET <= '0'; -- let data LEDs do their thing
  END PROCEDURE;
  
BEGIN
  GENDATABUF: for i IN 0 to 31 generate     
    IOBx : IOBUF
      GENERIC MAP(
        DRIVE => 12,
        IOSTANDARD => "DEFAULT",
        SLEW => "SLOW")
      PORT MAP (
        O => BUF_DATA_I(i),           -- Buffer output (warning - data coming from SBUS so I)
        IO => SBUS_3V3_D(i),         -- Buffer INOUT PORT (connect directly to top-level PORT)
        I => BUF_DATA_O(i),         -- Buffer input (warning - data going to SBUS so O)
        T => DATA_T              -- 3-state enable input, high=input, low=output
        );
  end generate GENDATABUF;

  --label_led_handler: LedHandler PORT MAP( l_ifclk => SBUS_3V3_CLK, l_LED_RESET => LED_RESET, l_LED_DATA => LED_DATA, l_LED0 => LED0, l_LED1 => LED1, l_LED2 => LED2, l_LED3 => LED3 );
  label_led_handler: LedHandler PORT MAP( l_ifclk => SBUS_3V3_CLK, l_LED_RESET => LED_RESET, l_LED_DATA => LED_DATA, l_LED0 => LED0, l_LED1 => LED1, l_LED2 => LED2, l_LED3 => LED3,
                                          l_LED4 => LED4, l_LED5 => LED5, l_LED6 => LED6, l_LED7 => LED7);
  
  label_prom: Prom PORT MAP (addr => p_addr, data => p_data);

  label_mas: mastrovito_V2_multiplication PORT MAP( a => mas_a, b => mas_b, c => mas_c );
  
  label_fifo: fifo_generator_0 port map(rst => fifo_rst, wr_clk => SBUS_3V3_CLK, rd_clk => fxclk_in,
                                        din => fifo_din, wr_en => fifo_wr_en, rd_en => fifo_rd_en,
                                        dout => fifo_dout, full => fifo_full, empty => fifo_empty);
                                        
  -- label_clk_wiz: clk_wiz_0 port map(clk_out1 => uart_clk, clk_in1 => fxclk_in);
  
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
  variable last_pa : std_logic_vector(27 downto 0) := (others => '0');
  variable BURST_COUNTER : integer range 0 to 15 := 0;
  variable BURST_LIMIT : integer range 1 to 16 := 1;
  variable BURST_INDEX : integer range 0 to 15;
  variable seen_ack : boolean := false;
  BEGIN
    IF (SBUS_3V3_RSTs = '0') THEN
      State <= SBus_Start;
      fifo_rst <= '1';
      
    ELSIF RISING_EDGE(SBUS_3V3_CLK) THEN
      fifo_rst <= '0';
      fifo_wr_en <= '0';
--      LIFE_COUNTER25 <= LIFE_COUNTER25 - 1;
      
      CASE State IS
        WHEN SBus_Idle =>
--          IF (LIFE_COUNTER25 <= 200000) THEN
--            LIFE_COUNTER25 <= 25000000;
--            fifo_wr_en <= '1';
--            fifo_din <= b"01" & SBUS_3V3_SELs & SBUS_3V3_ASs & SBUS_3V3_PPRD & SBUS_3V3_SIZ;
--            State <= SBus_Slave_Heartbeat;
-- Anything pointing to SBus_Idle should SBus_Set_Default
-- 			    SBus_Set_Default(SBUS_3V3_ACKs, SBUS_3V3_ERRs, SBUS_3V3_INT1s, SBUS_3V3_INT7s,
--			                     SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
--			                     p_addr, DATA_T, LED_RESET);
-- READ READ READ --
--          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(SBUS_3V3_SIZ) AND SBUS_3V3_PPRD='1' THEN
          IF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(SBUS_3V3_SIZ) AND SBUS_3V3_PPRD='1' THEN
            fifo_wr_en <= '1'; fifo_din <= x"41"; -- "A"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            BURST_COUNTER := 0;
            BURST_LIMIT := SIZ_TO_BURSTSIZE(SBUS_3V3_SIZ);
            IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) AND (last_pa(1 downto 0) = "00")) then
              -- 32 bits read from aligned memory IN PROM space ------------------------------------
              SBUS_3V3_ACKs <= ACK_WORD;
              SBUS_3V3_ERRs <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_Burst;
            ELSIF ((last_pa(27 downto 9) = REG_ADDR_PFX) AND REG_OFFSET_IS_ANYGCM(last_pa(8 downto 0))) then
              -- 32 bits read from aligned memory IN REG space ------------------------------------
              SBUS_3V3_ACKs <= ACK_WORD;
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Ack_Read_Reg_Burst;
            ELSE
              SBUS_3V3_ACKs <= ACK_ERR;
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SBUS_3V3_SIZ = SIZ_BYTE AND SBUS_3V3_PPRD='1' THEN
            fifo_wr_en <= '1'; fifo_din <= x"42"; -- "B"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            IF (last_pa(27 downto 9) = ROM_ADDR_PFX) then
              -- 8 bits read from memory IN PROM space ------------------------------------
              SBUS_3V3_ACKs <= ACK_BYTE;
              SBUS_3V3_ERRs <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_Byte;
            ELSE
              SBUS_3V3_ACKs <= ACK_ERR;
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SBUS_3V3_SIZ = SIZ_HWORD AND SBUS_3V3_PPRD='1' THEN
            fifo_wr_en <= '1'; fifo_din <= x"43"; -- "C"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED <= '1';
            IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) and (last_pa(0) = '0')) then
              -- 16 bits read from memory IN PROM space ------------------------------------
              SBUS_3V3_ACKs <= ACK_HWORD;
              SBUS_3V3_ERRs <= '1'; -- no late error
              -- word address goes to the p_addr lines
              p_addr <= last_pa(8 downto 2);
              State <= SBus_Slave_Ack_Read_Prom_HWord;
            ELSE
              SBUS_3V3_ACKs <= ACK_ERR;
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Error;
            END IF;
-- WRITE WRITE WRITE --
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SIZ_IS_WORD(SBUS_3V3_SIZ) AND SBUS_3V3_PPRD='0' THEN
            fifo_wr_en <= '1'; fifo_din <= x"44"; -- "D"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED_2 <= '1';
            BURST_COUNTER := 0;
            BURST_LIMIT := SIZ_TO_BURSTSIZE(SBUS_3V3_SIZ);
            IF ((last_pa(27 downto 9) = REG_ADDR_PFX) and (last_pa(8 downto 0) = REG_OFFSET_LED)) then
              -- 32 bits write to LED register  ------------------------------------
              if (SBUS_3V3_SIZ = SIZ_WORD) THEN
                LED_RESET <= '1'; -- reset led cycle
                --DATA_T <= '1'; -- set buffer as input
                LED_DATA <= BUF_DATA_I; -- display data
                SBUS_3V3_ACKs <=  ACK_WORD; -- acknowledge the Word
                SBUS_3V3_ERRs <= '1'; -- no late error
                State <= SBus_Slave_Ack_Reg_Write;
              ELSE
                SBUS_3V3_ACKs <=  ACK_ERR;
                SBUS_3V3_ERRs <= '1'; -- no late error
                State <= SBus_Slave_Error;
              END IF;
            ELSIF ((last_pa(27 downto 9) = REG_ADDR_PFX) and REG_OFFSET_IS_ANYGCM(last_pa(8 downto 0))) then
              -- 32 bits write to GCM register  ------------------------------------
              SBUS_3V3_ACKs <=  ACK_WORD; -- acknowledge the Word
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Ack_Reg_Write_Burst;
            ELSE
              SBUS_3V3_ACKs <= ACK_ERR; -- unsupported address, signal error
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Error; 
            END IF;
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SBUS_3V3_SIZ = SIZ_BYTE AND SBUS_3V3_PPRD='0' THEN
            fifo_wr_en <= '1'; fifo_din <= x"45"; -- "E"
            last_pa := SBUS_3V3_PA;
            SBUS_DATA_OE_LED_2 <= '1';
            IF ((last_pa(27 downto 9) = REG_ADDR_PFX) and (last_pa(8 downto 2) = REG_OFFSET_LED(8 downto 2))) then
              -- 8 bits write to LED register ------------------------------------
              LED_RESET <= '1'; -- reset led cycle
              --DATA_T <= '1'; -- set buffer as input
              CASE last_pa(1 downto 0) IS
              WHEN "00" =>
                LED_DATA(31 downto 24) <= BUF_DATA_I(31 downto 24);
              WHEN "01" =>
                LED_DATA(23 downto 16) <= BUF_DATA_I(31 downto 24);
              WHEN "10" =>
                LED_DATA(15 downto 8) <= BUF_DATA_I(31 downto 24);
              WHEN "11" =>
                LED_DATA(7 downto 0) <= BUF_DATA_I(31 downto 24);
              WHEN OTHERS =>
                -- TODO: FIXME, probably should generate an error
              END CASE;
              SBUS_3V3_ACKs <=  ACK_BYTE; -- acknowledge the Byte
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Ack_Reg_Write;
            ELSE
              SBUS_3V3_ACKs <= ACK_ERR; -- unsupported address, signal error
              SBUS_3V3_ERRs <= '1'; -- no late error
              State <= SBus_Slave_Error; 
            END IF;
-- ERROR ERROR ERROR 
          ELSIF SBUS_3V3_SELs='0' AND SBUS_3V3_ASs='0' AND SBUS_3V3_SIZ /= SIZ_WORD THEN
            fifo_wr_en <= '1'; fifo_din <= x"58"; -- "X"
            SBUS_3V3_ACKs <= ACK_ERR; -- unsupported config, signal error
            SBUS_3V3_ERRs <= '1'; -- no late error
            State <= SBus_Slave_Error; 
          END IF;
-- -- -- --
        WHEN SBus_Slave_Ack_Reg_Write =>
          fifo_wr_en <= '1'; fifo_din <= x"45"; -- "E"
          SBUS_3V3_ACKs <= ACK_IDLE; -- need one cycle of idle
          IF (do_gcm) THEN
            mas_a(31  downto  0) <= reverse_bit_in_byte(GCM_REGISTERS(8) xor GCM_REGISTERS(4));
            mas_a(63  downto 32) <= reverse_bit_in_byte(GCM_REGISTERS(9) xor GCM_REGISTERS(5));
            mas_a(95  downto 64) <= reverse_bit_in_byte(GCM_REGISTERS(10) xor GCM_REGISTERS(6));
            mas_a(127 downto 96) <= reverse_bit_in_byte(GCM_REGISTERS(11) xor GCM_REGISTERS(7));
            mas_b(31  downto  0) <= reverse_bit_in_byte(GCM_REGISTERS(0));
            mas_b(63  downto 32) <= reverse_bit_in_byte(GCM_REGISTERS(1));
            mas_b(95  downto 64) <= reverse_bit_in_byte(GCM_REGISTERS(2));
            mas_b(127 downto 96) <= reverse_bit_in_byte(GCM_REGISTERS(3));
          END IF;
          IF (SBUS_3V3_ASs='1') THEN
            seen_ack := true;
          END IF;
          State <= SBus_Slave_Ack_Reg_Write_Final;
          
        WHEN SBus_Slave_Ack_Reg_Write_Final =>
          fifo_wr_en <= '1'; fifo_din <= x"46"; -- "F"
          SBus_Set_Default(SBUS_3V3_ACKs, SBUS_3V3_ERRs, SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, LED_RESET);
          IF (do_gcm) THEN
            do_gcm := false;
            GCM_REGISTERS(4) <= reverse_bit_in_byte(mas_c(31  downto  0));
            GCM_REGISTERS(5) <= reverse_bit_in_byte(mas_c(63  downto 32));
            GCM_REGISTERS(6) <= reverse_bit_in_byte(mas_c(95  downto 64));
            GCM_REGISTERS(7) <= reverse_bit_in_byte(mas_c(127 downto 96));
          END IF;
          IF ((seen_ack) OR (SBUS_3V3_ASs='1')) THEN
            seen_ack := false;
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Ack_Reg_Write_Burst =>
          fifo_wr_en <= '1'; fifo_din <= x"48"; -- "H"
          BURST_INDEX := conv_integer(INDEX_WITH_WRAP(BURST_COUNTER, BURST_LIMIT, last_pa(5 downto 2)));
          GCM_REGISTERS(BURST_INDEX) <= BUF_DATA_I;
          SBUS_3V3_ACKs <= ACK_WORD; -- acknowledge the Word
          IF (BURST_INDEX = REG_INDEX_GCM_INPUT4) THEN
            do_gcm := true;
          END IF;
          if (BURST_COUNTER = (BURST_LIMIT-1)) THEN
            State <= SBus_Slave_Ack_Reg_Write;
          ELSE
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
            SBUS_3V3_ACKs <= ACK_IDLE;
            State <= SBus_Slave_Do_Read;
          else
            SBUS_3V3_ACKs <= ACK_WORD;
            BURST_COUNTER := BURST_COUNTER + 1;
          end if;
          
        WHEN SBus_Slave_Ack_Read_Reg_Burst =>
          fifo_wr_en <= '1'; fifo_din <= x"4A"; -- "J"
          DATA_T <= '0'; -- set buffer as output
          BURST_INDEX := conv_integer(INDEX_WITH_WRAP(BURST_COUNTER, BURST_LIMIT, last_pa(5 downto 2)));
          BUF_DATA_O <= GCM_REGISTERS(BURST_INDEX);
          if (BURST_COUNTER = (BURST_LIMIT-1)) then
            SBUS_3V3_ACKs <= ACK_IDLE;
            State <= SBus_Slave_Do_Read;
          else
            SBUS_3V3_ACKs <= ACK_WORD;
            BURST_COUNTER := BURST_COUNTER + 1;
          end if;
          
        WHEN SBus_Slave_Do_Read => -- this is the (last) cycle IN which the master read
          fifo_wr_en <= '1'; fifo_din <= x"4B"; -- "K"
          SBus_Set_Default(SBUS_3V3_ACKs, SBUS_3V3_ERRs, SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, LED_RESET);
          IF (SBUS_3V3_ASs='1') THEN
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Ack_Read_Prom_Byte =>
          fifo_wr_en <= '1'; fifo_din <= x"4C"; -- "L"
          IF (last_pa(27 downto 9) = ROM_ADDR_PFX) then -- do we need to re-test ?
            SBUS_3V3_ACKs <= ACK_IDLE;
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
            SBUS_3V3_ACKs <= ACK_IDLE;
            State <= SBus_Slave_Delay_Error; 
          END IF;
          
        WHEN SBus_Slave_Ack_Read_Prom_HWord =>
          fifo_wr_en <= '1'; fifo_din <= x"4D"; -- "M"
          IF ((last_pa(27 downto 9) = ROM_ADDR_PFX) and (last_pa(0) = '0'))then -- do we need to re-test ?
            SBUS_3V3_ACKs <= ACK_IDLE;
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
            SBUS_3V3_ACKs <= ACK_IDLE;
            State <= SBus_Slave_Delay_Error; 
          END IF;
          
        WHEN SBus_Slave_Error =>
          fifo_wr_en <= '1'; fifo_din <= x"59"; -- "Y"
          SBus_Set_Default(SBUS_3V3_ACKs, SBUS_3V3_ERRs, SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, LED_RESET);
          IF (SBUS_3V3_ASs='1') THEN
            State <= SBus_Idle;
          END IF;
          
        WHEN SBus_Slave_Delay_Error =>
          fifo_wr_en <= '1'; fifo_din <= x"5A"; -- "Z"
          SBUS_3V3_ERRs <= '0'; -- two cycles after ACK
          State <= SBus_Slave_Error;
          
--        WHEN SBus_Slave_Heartbeat =>
--          State <= SBus_Idle;
          
        WHEN OTHERS => -- include SBus_Start
          SBus_Set_Default(SBUS_3V3_ACKs, SBUS_3V3_ERRs, SBUS_3V3_INT1s, SBUS_3V3_INT7s,
                           SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2,
                           p_addr, DATA_T, LED_RESET);
          -- SBUS_OE <= '0'; -- enable all signals -- moved to COUNTER48 timer
          if SBUS_3V3_RSTs = '1' then
            IF (RES_COUNTER = 0) THEN
              fifo_wr_en <= '1'; fifo_din <= x"2A"; -- "*"
              State <= SBus_Idle;
            ELSE
              RES_COUNTER <= RES_COUNTER - 1;
            END IF;
          else
            RES_COUNTER <= 5;
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
  
END rtl;
