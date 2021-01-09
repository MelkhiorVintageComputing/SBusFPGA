library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aes_wrapper is
  port (
    aes_wrapper_rst : in std_logic;
    aes_wrapper_clk : in std_logic;
-- iskey?, keylen, encdec, cbc, internal cbc, data (256 or 128 + 128)
    input_fifo_out : in std_logic_vector(260 downto 0);
    input_fifo_empty: in std_logic;
    input_fifo_rd_en : out std_logic;
-- data (128)
    output_fifo_in : out std_logic_vector(127 downto 0);
    output_fifo_full : in std_logic;
    output_fifo_wr_en : out std_logic
    );
  TYPE AES_States IS ( AES_IDLE, AES_INIT1, AES_INIT2, AES_CRYPT1, AES_CRYPT2 );
  SIGNAL AES_State : AES_States := AES_IDLE;

  signal aes_reset_n : std_logic;
  signal aes_encdec : std_logic;
  signal aes_init : std_logic;
  signal aes_next : std_logic;
  signal aes_ready : std_logic;
  signal aes_key : std_logic_vector(255 downto 0);
  signal aes_keylen : std_logic;
  signal aes_block : std_logic_vector(127 downto 0);
  signal aes_result : std_logic_vector(127 downto 0);
  signal aes_result_valid : std_logic;
  
  signal aes_last : std_logic_vector(127 downto 0);

  constant iskey_idx : integer := 260;
  constant keylen_idx : integer := 259;
  constant encdec_idx : integer := 258;
  constant cbc_idx : integer := 257;
  constant intcbc_idx : integer := 256;
end aes_wrapper;


architecture RTL of aes_wrapper is 

  component aes_core is
    port (
      clk : in std_logic;
      reset_n: in std_logic;
      encdec: in std_logic;
      init: in std_logic;
      xnext: in std_logic;
      ready: out std_logic;
      key: in  std_logic_vector(255 downto 0);
      keylen: in std_logic;
      xblock: in std_logic_vector(127 downto 0);
      result: out std_logic_vector(127 downto 0);
      result_valid: out std_logic
      );
  end component aes_core;
  
  
begin

  label_aes_core: aes_core port map(
    clk => aes_wrapper_clk,
    reset_n => aes_reset_n,
    encdec => aes_encdec,
    init => aes_init,
    xnext => aes_next,
    ready => aes_ready,
    key => aes_key,
    keylen => aes_keylen,
    xblock => aes_block,
    result => aes_result,
    result_valid => aes_result_valid
    );
    
  aes_wrapper: process (aes_wrapper_rst, aes_wrapper_clk)
  begin  -- process aes_wrapper
    IF (aes_wrapper_rst = '0') THEN
      aes_reset_n <= '0';
      AES_State <= AES_IDLE;
      
    ELSIF RISING_EDGE(aes_wrapper_clk) then
      aes_reset_n <= '1';
      input_fifo_rd_en <= '0';
      output_fifo_wr_en <= '0';
      CASE AES_State IS
        WHEN AES_IDLE =>
          IF ((input_fifo_empty = '0') AND
              (output_fifo_full = '0') AND
              (aes_ready = '1')
              ) then
            input_fifo_rd_en <= '1';
            IF (input_fifo_out(iskey_idx) = '1') THEN
              aes_key <= input_fifo_out(255 downto 0);
              aes_keylen <= input_fifo_out(keylen_idx);
              aes_init <= '1';
              aes_encdec <= input_fifo_out(encdec_idx);
              AES_State <= AES_INIT1;
            ELSE
              aes_next <= '1';
              aes_encdec <= input_fifo_out(encdec_idx);
              IF (input_fifo_out(cbc_idx) = '1') THEN
                -- cbc mode
                aes_block <= input_fifo_out(127 downto 0) XOR input_fifo_out(255 downto 128);
              ELSIF (input_fifo_out(intcbc_idx) = '1') THEN
                -- internal cbc mode
                aes_block <= input_fifo_out(127 downto 0) XOR aes_last;
              ELSE
                -- normal mode
                aes_block <= input_fifo_out(127 downto 0);
              END IF;
              AES_State <= AES_CRYPT1;
            END IF;
          END IF;
          
        WHEN AES_INIT1 =>
          AES_State <= AES_INIT2;
          
        WHEN AES_INIT2 =>
          aes_init <= '0';
          IF (aes_ready = '1') THEN
            AES_State <= AES_IDLE;
          END IF;
          
        WHEN AES_CRYPT1 =>
          AES_State <= AES_CRYPT2;
          
        WHEN AES_CRYPT2 =>
          aes_next <= '0';
          IF (aes_result_valid = '1') then 
            output_fifo_wr_en <= '1';
            output_fifo_in <= aes_result;
            aes_last <= aes_result;
            AES_State <= AES_IDLE;
          END IF;
        
      END CASE;
    end IF;
    
  end process aes_wrapper;
  
end RTL;
