library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity SBusFSM_TB is
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
end entity;

architecture sim of SBusFSM_TB is

COMPONENT SBusFSM is
PORT (
      fxclk_in: IN std_logic; -- 48 MHz interface clock
-- true SBus signals
      SBUS_3V3_CLK : 	IN STD_LOGIC; -- 16.67..25 MHz SBus Clock
      SBUS_3V3_RSTs : 	IN STD_LOGIC;
      SBUS_3V3_SELs : 	IN STD_LOGIC;
      SBUS_3V3_ASs : 	IN STD_LOGIC;
      SBUS_3V3_PPRD : 	INOUT STD_LOGIC;
      SBUS_3V3_SIZ :     INOUT std_logic_vector(2 downto 0);
      SBUS_3V3_ACKs :     INOUT std_logic_vector(2 downto 0);
      SBUS_3V3_PA :      IN std_logic_vector(27 downto 0);
      SBUS_3V3_ERRs : 	INOUT STD_LOGIC;
      SBUS_3V3_D :      INOUT std_logic_vector(31 downto 0);
      SBUS_3V3_INT1s : 	OUT STD_LOGIC;
      SBUS_3V3_INT7s : 	OUT STD_LOGIC;
 -- master-only signals
      SBUS_3V3_BGs : IN STD_LOGIC; -- bus granted
      SBUS_3V3_BRs : OUT STD_LOGIC := 'Z'; -- bus request
 -- support signals
      SBUS_OE : OUT STD_LOGIC := '0';
 -- support leds
      SBUS_DATA_OE_LED : OUT std_logic; -- light during read cycle
      SBUS_DATA_OE_LED_2 : OUT std_logic; -- light during write cycle
  -- data leds
      LED0 : OUT std_logic := '0';
      LED1 : OUT std_logic := '0';
      LED2 : OUT std_logic := '0';
      LED3 : OUT std_logic := '0';
      LED4 : OUT std_logic := '0';
      LED5 : OUT std_logic := '0';
      LED6 : OUT std_logic := '0';
      LED7 : OUT std_logic := '0'
      );
END COMPONENT;

signal fxclk_in: std_logic;
signal SBUS_3V3_CLK : std_logic;
signal SBUS_3V3_RSTs : std_logic;
signal      SBUS_3V3_SELs : 	 STD_LOGIC;
signal      SBUS_3V3_ASs : 	 STD_LOGIC;
signal      SBUS_3V3_PPRD : 	 STD_LOGIC;
signal      SBUS_3V3_SIZ :      std_logic_vector(2 downto 0);
signal      SBUS_3V3_ACKs :      std_logic_vector(2 downto 0);
signal      SBUS_3V3_PA :       std_logic_vector(27 downto 0);
signal      SBUS_3V3_ERRs : 	 STD_LOGIC;
signal      SBUS_3V3_D :       std_logic_vector(31 downto 0);
signal      SBUS_3V3_INT1s : 	 STD_LOGIC;
signal      SBUS_3V3_INT7s : 	 STD_LOGIC;
signal      SBUS_3V3_BGs : STD_LOGIC; -- bus granted
signal      SBUS_3V3_BRs : STD_LOGIC; -- bus request
 -- support signals
signal      SBUS_OE :  STD_LOGIC;
 -- support leds
signal      SBUS_DATA_OE_LED :  std_logic; -- light during read cycle
signal      SBUS_DATA_OE_LED_2 :  std_logic; -- light during write cycle
  -- data leds
signal      LED0 :  std_logic;
signal      LED1 :  std_logic;
signal      LED2 :  std_logic;
signal      LED3 :  std_logic;
signal      LED4 :  std_logic;
signal      LED5 :  std_logic;
signal      LED6 :  std_logic;
signal      LED7 :  std_logic;


	CONSTANT PROM_SIZE   : natural :=  25;
	SIGNAL PROM_COUNTER : natural range 0 to PROM_SIZE*4 := 0;
	SIGNAL LED_COUNTER : natural range 0 to 4 := 0;

  -- Procedure for clock generation
  procedure clk_gen(signal clk : OUT std_logic; constant FREQ : real) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

PROCEDURE MasterRequestRead (
  signal SBUS_3V3_CLK : in std_logic;
  SIGNAL SBUS_3V3_SELs : out std_logic;
  SIGNAL SBUS_3V3_ASs : out std_logic;
  SIGNAL SBUS_3V3_PPRD : out std_logic;
  SIGNAL SBUS_3V3_PA : out std_logic_vector(27 downto 0);
  SIGNAL SBUS_3V3_SIZ : out std_logic_vector(2 downto 0);
  constant phys_addr : in std_logic_vector(27 downto 0);
  constant size : in std_logic_vector(2 downto 0)
  ) is
begin 
  -- should be called on a rising edge of clock +0.1 ns
  wait for 24 ns;
    SBUS_3V3_SELs <= '0';
    SBUS_3V3_ASs <= '0';
    SBUS_3V3_PPRD <= '1';
    SBUS_3V3_PA <= phys_addr;
    SBUS_3V3_SIZ <= size;
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
END PROCEDURE;

PROCEDURE MasterRequestWrite (
  signal SBUS_3V3_CLK : in std_logic;
  SIGNAL SBUS_3V3_SELs : out std_logic;
  SIGNAL SBUS_3V3_ASs : out std_logic;
  SIGNAL SBUS_3V3_PPRD : out std_logic;
  SIGNAL SBUS_3V3_PA : out std_logic_vector(27 downto 0);
  SIGNAL SBUS_3V3_SIZ : out std_logic_vector(2 downto 0);
  SIGNAL SBUS_3V3_D : out std_logic_vector(31 downto 0);
  constant phys_addr : in std_logic_vector(27 downto 0);
  constant size : in std_logic_vector(2 downto 0);
  constant data : in std_logic_vector(31 downto 0)
  ) is
begin 
  -- should be called on a rising edge of clock +0.1 ns
  wait for 24 ns;
    SBUS_3V3_SELs <= '0';
    SBUS_3V3_ASs <= '0';
    SBUS_3V3_PPRD <= '0';
    SBUS_3V3_PA <= phys_addr;
    SBUS_3V3_SIZ <= size;
    SBUS_3V3_D <= data;
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
END PROCEDURE;


PROCEDURE MasterRequestWriteBurst4 (
  signal SBUS_3V3_CLK : in std_logic;
  SIGNAL SBUS_3V3_SELs : out std_logic;
  SIGNAL SBUS_3V3_ASs : out std_logic;
  SIGNAL SBUS_3V3_PPRD : out std_logic;
  SIGNAL SBUS_3V3_PA : out std_logic_vector(27 downto 0);
  SIGNAL SBUS_3V3_SIZ : out std_logic_vector(2 downto 0);
  SIGNAL SBUS_3V3_D : out std_logic_vector(31 downto 0);
  constant phys_addr : in std_logic_vector(27 downto 0);
  constant data1 : in std_logic_vector(31 downto 0);
  constant data2 : in std_logic_vector(31 downto 0);
  constant data3 : in std_logic_vector(31 downto 0);
  constant data4 : in std_logic_vector(31 downto 0)
  ) is
begin 
  -- should be called on a rising edge of clock +0.1 ns
  wait for 24 ns;
    SBUS_3V3_SELs <= '0';
    SBUS_3V3_ASs <= '0';
    SBUS_3V3_PPRD <= '0';
    SBUS_3V3_PA <= phys_addr;
    SBUS_3V3_SIZ <= SIZ_BURST4;
    SBUS_3V3_D <= data1;
  wait until rising_edge(SBUS_3V3_CLK) and (SBUS_3V3_ACKs = ACK_WORD);
--  wait for 2.5 ns;
--    SBUS_3V3_D <= (others => '0');
  wait for 20 ns;
    SBUS_3V3_D <= data2;
  wait until rising_edge(SBUS_3V3_CLK) and (SBUS_3V3_ACKs = ACK_WORD);
--  wait for 2.5 ns;
--    SBUS_3V3_D <= (others => '0');
  wait for 20 ns;
    SBUS_3V3_D <= data3;
  wait until rising_edge(SBUS_3V3_CLK) and (SBUS_3V3_ACKs = ACK_WORD);
--  wait for 2.5 ns;
--    SBUS_3V3_D <= (others => '0');
  wait for 20 ns;
    SBUS_3V3_D <= data4;
END PROCEDURE;

procedure MasterWaitAck (
  signal SBUS_3V3_CLK : in std_logic;
  signal SBUS_3V3_ACKs : in std_logic_vector(2 downto 0);
  constant ack : in std_logic_vector(2 downto 0)
  ) is
begin 
  -- should be called on a rising edge of clock +0.1 ns
  wait until (rising_edge(SBUS_3V3_CLK) and (SBUS_3V3_ACKs = ack or SBUS_3V3_ACKs = "110" ));
  wait for 0.1 ns;
-- "110" is an error ack
end PROCEDURE;

PROCEDURE MasterEndRequest (
  signal SBUS_3V3_CLK : in std_logic;
  SIGNAL SBUS_3V3_SELs : out std_logic;
  SIGNAL SBUS_3V3_ASs : out std_logic;
  SIGNAL SBUS_3V3_PPRD : out std_logic;
  SIGNAL SBUS_3V3_PA : out std_logic_vector(27 downto 0);
  SIGNAL SBUS_3V3_SIZ : out std_logic_vector(2 downto 0);
  SIGNAL SBUS_3V3_D : out std_logic_vector(31 downto 0)
  ) is
begin 
  -- should be called on a rising edge of clock +0.1 ns
  wait for 24 ns;
  SBUS_3V3_SELs <= '1';
  SBUS_3V3_ASs <= '1';
  SBUS_3V3_PPRD <= 'Z';
  SBUS_3V3_PA <= (others => 'Z');
  SBUS_3V3_D <= (others => 'Z');
  SBUS_3V3_SIZ <= (others => 'Z');
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
end PROCEDURE;

begin
uut: SBusFSM PORT MAP (fxclk_in => fxclk_in, SBUS_3V3_CLK => SBUS_3V3_CLK, SBUS_3V3_RSTs => SBUS_3V3_RSTs, SBUS_3V3_SELs => SBUS_3V3_SELs, SBUS_3V3_ASs => SBUS_3V3_ASs, SBUS_3V3_PPRD => SBUS_3V3_PPRD, SBUS_3V3_SIZ => SBUS_3V3_SIZ, SBUS_3V3_ACKs => SBUS_3V3_ACKs, SBUS_3V3_PA => SBUS_3V3_PA, SBUS_3V3_ERRs => SBUS_3V3_ERRs, SBUS_3V3_D => SBUS_3V3_D, SBUS_3V3_INT1s => SBUS_3V3_INT1s, SBUS_3V3_INT7s => SBUS_3V3_INT7s, SBUS_3V3_BGs => SBUS_3V3_BGs, SBUS_3V3_BRs => SBUS_3V3_BRs, SBUS_OE => SBUS_OE, SBUS_DATA_OE_LED => SBUS_DATA_OE_LED, SBUS_DATA_OE_LED_2 => SBUS_DATA_OE_LED_2,
         LED0 => LED0, LED1 => LED1, LED2 => LED2, LED3 => LED3, LED4 => LED4, LED5 => LED5, LED6 => LED6, LED7 => LED7
);

process begin
  -- Clock generation with concurrent procedure call
  clk_gen(SBUS_3V3_CLK, 25.0E6);  -- 25 MHz clock
end process;
process begin
  clk_gen(fxclk_in, 48.0E6);  -- 48 MHz clock
end process;
process begin
  SBUS_3V3_RSTs <= '0';
  wait for 115 ns; -- 3 clocks minus 5ns
  SBUS_3V3_RSTs <= '1';
  wait;
end process;
process 
variable s : line;
begin
SBUS_3V3_SELs <= '1'; -- unselect slave
SBUS_3V3_ASs <= '1';
SBUS_3V3_D <= (others => 'Z');
SBUS_3V3_PA <= (others => 'Z');
SBUS_3V3_SIZ <= (others => 'Z');
SBUS_3V3_BGs <= 'Z';
wait for 420 ns;                        -- wait for reset to be done

#ifdef WRITE_LEDS_WORD
-- test 32 bits write to leds
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_LED, -- 0x200
                     SIZ_WORD,           -- word
                     "11111000110001001010001000110001");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  wait;
#endif // WRITE_LEDS_WORD

#ifdef WRITE_LEDS_BYTE
-- test 8 bits write to leds
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  case LED_COUNTER is
    WHEN 0 =>
      MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                         REG_ADDR_PFX & REG_OFFSET_LED, -- 0x200
                         SIZ_BYTE,           -- byte
                         "11111000" & "ZZZZZZZZZZZZZZZZZZZZZZZZ");
    WHEN 1 =>
      MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                         REG_ADDR_PFX & (REG_OFFSET_LED+1), -- 0x201
                         SIZ_BYTE,           -- byte
                         "11000100" & "ZZZZZZZZZZZZZZZZZZZZZZZZ");
    WHEN 2 =>
      MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                         REG_ADDR_PFX & (REG_OFFSET_LED+2), -- 0x202
                         SIZ_BYTE,           -- byte
                         "10100010" & "ZZZZZZZZZZZZZZZZZZZZZZZZ");
    WHEN 3 =>
      MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                         REG_ADDR_PFX & (REG_OFFSET_LED+3), -- 0x203
                         SIZ_BYTE,           -- byte
                         "00110001" & "ZZZZZZZZZZZZZZZZZZZZZZZZ");
    WHEN others =>
  end case;
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_BYTE);               -- byte
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  LED_COUNTER <= LED_COUNTER + 1;
  if (LED_COUNTER = 4) then
    wait;
  else
  end if;
#endif // WRITE_LEDS_BYTE

#ifdef READ_PROM_WORD
-- test read from PROM as Word
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    conv_std_logic_vector(PROM_COUNTER, 28),
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  PROM_COUNTER <= PROM_COUNTER + 4;
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  if (PROM_COUNTER = PROM_SIZE*4) then
    wait;
  else    
  end if;
#endif // READ_PROM_WORD


#ifdef READ_PROM_BURST4
-- test read from PROM as Burst4 Word
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    conv_std_logic_vector(PROM_COUNTER, 28),
                    SIZ_BURST4);           -- burst4
  -- this next sequence only works for 1 word/cycle burst
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);    
  PROM_COUNTER <= PROM_COUNTER + 16;
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  if (PROM_COUNTER >= PROM_SIZE*4) then
    wait;
  else    
  end if;
#endif // READ_PROM_BURST4

#ifdef READ_PROM_BYTE
-- test read from PROM as Byte
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    conv_std_logic_vector(PROM_COUNTER, 28),
                    SIZ_BYTE);           -- byte
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_BYTE);               -- byte
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D(31 downto 24));
  wait for 0.1 ns;
  writeline(output, s);
  PROM_COUNTER <= PROM_COUNTER + 1;
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  if (PROM_COUNTER = PROM_SIZE*4) then
    wait;
  else    
  end if;
#endif // READ_PROM_BYTE

#ifdef READ_PROM_HWORD
-- test read from PROM as HWord
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    conv_std_logic_vector(PROM_COUNTER, 28),
                    SIZ_HWORD);           -- byte
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_HWORD);               -- byte
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D(31 downto 16));
  wait for 0.1 ns;
  writeline(output, s);
  PROM_COUNTER <= PROM_COUNTER + 2;
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  if (PROM_COUNTER = PROM_SIZE*4) then
    wait;
  else    
  end if;
#endif // READ_PROM_HWORD

#ifdef DO_GCM
-- test 32 bits GCM
  wait for 115 ns; -- 3 clocks minus 5ns
  wait until rising_edge(SBUS_3V3_CLK);
  wait for 0.1 ns;
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_H1,
                     SIZ_WORD,           -- word
                     x"6b8b4567");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s);  
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_H2,
                     SIZ_WORD,           -- word
                     x"66334873");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_H3,
                     SIZ_WORD,           -- word
                     x"2ae8944a");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_H4,
                     SIZ_WORD,           -- word
                     x"46e87ccd");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_H4,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  
  
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_C1,
                     SIZ_WORD,           -- word
                     x"327b23c6");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_C2,
                     SIZ_WORD,           -- word
                     x"74b0dc51");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_C3,
                     SIZ_WORD,           -- word
                     x"625558ec");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_C4,
                     SIZ_WORD,           -- word
                     x"3d1b58ba");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C4,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  
  
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_INPUT1,
                     SIZ_WORD,           -- word
                     x"643c9869");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_INPUT2,
                     SIZ_WORD,           -- word
                     x"19495cff");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_INPUT3,
                     SIZ_WORD,           -- word
                     x"238e1f29");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                     REG_ADDR_PFX & REG_OFFSET_GCM_INPUT4,
                     SIZ_WORD,           -- word
                     x"507ed7ab");
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
 
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C1,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C2,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C3,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C4,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  -- expect 0x1f1554d6 0x82e930b8 0xdbd891cc 0x91f3f7c9 from the write above
  
--        MasterRequestWrite(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
--                       REG_ADDR_PFX & REG_OFFSET_GCM_INPUT4,
--                       SIZ_WORD,           -- word
--                       x"507ed7ab");
--    MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
--                  ACK_WORD);               -- word
--hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
--    MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  -- 0x11265233 0x1b6d90f3 0x53b8d61b 0x40e13340
--  MasterRequestWriteBurst4(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
--                           REG_ADDR_PFX & REG_OFFSET_GCM_INPUT1,
--                           x"11265233",
--                           x"1b6d90f3",
--                           x"53b8d61b",
--                           x"40e13340");
                           -- next with address wrap
  MasterRequestWriteBurst4(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D,
                           REG_ADDR_PFX & REG_OFFSET_GCM_INPUT2,
                           x"1b6d90f3",
                           x"53b8d61b",
                           x"40e13340",
                           x"11265233");
MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_INPUT1,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_INPUT2,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_INPUT3,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_INPUT4,
                    SIZ_WORD);           -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_ACKs); writeline(output, s); 
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D); 
  
  -- try reading again, burst
  wait for 40 ns; -- 1 cycle
  wait for 40 ns; -- 1 cycle
  wait for 40 ns; -- 1 cycle
  
  MasterRequestRead(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ,
                    REG_ADDR_PFX & REG_OFFSET_GCM_C1,
                    SIZ_BURST4);           -- word
  -- this next sequence only works for 1 word/cycle burst
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);               -- word
  MasterWaitAck(SBUS_3V3_CLK, SBUS_3V3_ACKs,
                ACK_WORD);               -- word
  hwrite(s, SBUS_3V3_D);
  writeline(output, s);
  wait until rising_edge(SBUS_3V3_CLK);
  hwrite(s, SBUS_3V3_D);
  wait for 0.1 ns;
  writeline(output, s);
  MasterEndRequest(SBUS_3V3_CLK, SBUS_3V3_SELs, SBUS_3V3_ASs, SBUS_3V3_PPRD, SBUS_3V3_PA, SBUS_3V3_SIZ, SBUS_3V3_D);
  
  -- expect 0x420f015c 0x7dc538f1 0xa6badb5f 0x0676df7b from the additional burst on input

  wait;
#endif // DO_GCM

END PROCESS;

end architecture;
