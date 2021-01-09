library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trivium_wrapper is
  port (
    trivium_wrapper_rst : in std_logic;
    trivium_wrapper_clk : in std_logic;
    output_fifo_in : out std_logic_vector(31 downto 0);
    output_fifo_full : in std_logic;
    output_fifo_wr_en : out std_logic
    );
end trivium_wrapper;

architecture RTL of trivium_wrapper is 

  component rng_trivium is

    generic (
      num_bits:   integer range 1 to 64;
      init_key:   std_logic_vector(79 downto 0);
      init_iv:    std_logic_vector(79 downto 0) );

    port (
      clk:        in  std_logic;
      rst:        in  std_logic;
      reseed:     in  std_logic;
      newkey:     in  std_logic_vector(79 downto 0);
      newiv:      in  std_logic_vector(79 downto 0);
      out_ready:  in  std_logic;
      out_valid:  out std_logic;
      out_data:   out std_logic_vector(num_bits-1 downto 0) );

  end component;
  
  TYPE TRIVIUM_States IS ( TRIVIUM_IDLE, TRIVIUM_BYTE, TRIVIUM_OUT );
  SIGNAL TRIVIUM_State : TRIVIUM_States := TRIVIUM_IDLE;

  signal trivium_data : std_logic_vector(7 downto 0);

  signal trivium_rst : std_logic;
  signal trivium_out_ready : std_logic;
  signal trivium_out_valid : std_logic;
  
begin
  label_trivium_core: rng_trivium
    generic map(
      num_bits => 8,
      init_key => x"01234657890123465789", -- ouch
      init_iv => x"98765432109876543210" -- ouch
      )
    port map(
      clk => trivium_wrapper_clk,
      rst => trivium_rst,
      reseed => '0', -- ouch
      newkey => (others => '0'), -- ouch
      newiv => (others => '0'), -- ouch
      out_ready => trivium_out_ready,
      out_valid => trivium_out_valid,
      out_data => trivium_data
      );
  
  trivium_wrapper: process (trivium_wrapper_rst, trivium_wrapper_clk)
    variable byte_index : integer range 0 to 3;
    variable buf : std_logic_vector(31 downto 0);
  begin  -- process trivium_wrapper
    IF (trivium_wrapper_rst = '0') THEN
      trivium_rst <= '1';
      TRIVIUM_State <= TRIVIUM_IDLE;
      byte_index := 0;
      
    ELSIF RISING_EDGE(trivium_wrapper_clk) then
      trivium_rst <= '0';
      output_fifo_wr_en <= '0';
      CASE TRIVIUM_State IS
        WHEN TRIVIUM_IDLE =>
          IF (trivium_out_valid = '1') THEN
            TRIVIUM_State <= TRIVIUM_BYTE;
            trivium_out_ready <= '1';
          END IF;
        -- one byte every cycle, plus 1 cycle for out and 1 idle
        -- 6 cycles for 32 bits in the FIFO at most
        WHEN TRIVIUM_BYTE =>
          case byte_index IS
            WHEN 0 =>
              trivium_out_ready <= '1';
              buf(7 downto 0) := trivium_data;
              byte_index := 1;
            WHEN 1 =>
              trivium_out_ready <= '1';
              buf(15 downto 8) := trivium_data;
              byte_index := 2;
            WHEN 2 =>
              trivium_out_ready <= '1';
              buf(23 downto 16) := trivium_data;
              byte_index := 3;
            WHEN 3 =>
              trivium_out_ready <= '0';
              buf(31 downto 24) := trivium_data;
              TRIVIUM_State <= TRIVIUM_OUT;
              byte_index := 0;
          END CASE;

        when TRIVIUM_OUT =>
          trivium_out_ready <= '0';
          IF (output_fifo_full = '0') THEN
            output_fifo_in <= buf;
            output_fifo_wr_en <= '1';
            TRIVIUM_State <= TRIVIUM_IDLE;
          END IF;
      END CASE;
    end IF;
    
  end process trivium_wrapper;
  
end RTL;
