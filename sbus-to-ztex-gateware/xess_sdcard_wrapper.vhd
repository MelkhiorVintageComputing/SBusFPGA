library ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library XESS;
use XESS.CommonPckg.all;
use XESS.SdCardPckg.all;

entity xess_sdcard_wrapper is
  port (
    xess_sdcard_wrapper_rst : in std_logic;
    xess_sdcard_wrapper_clk : in std_logic;
    output_fifo_in : out std_logic_vector(160 downto 0); --1+ 32 +128
    output_fifo_full : in std_logic;
    output_fifo_wr_en : out std_logic;
    out_sd_rd : in std_logic;
    out_sd_addr : in std_logic_vector(31 downto 0);
    out_sd_rd_addr_req : in std_logic;
    out_sd_rd_addr_ack : out std_logic;
    -- pins
    cs_bo : out std_logic;
    sclk_o : out std_logic;
    mosi_o : out std_logic;
    miso_i : in std_logic;
    -- LEDs
    leds : out std_logic_vector(7 downto 0)
    );
end xess_sdcard_wrapper;


architecture RTL of xess_sdcard_wrapper is 

    component SdCardCtrl is
    generic (
      FREQ_G          : real       := 100.0;  -- Master clock frequency (MHz).
      INIT_SPI_FREQ_G : real       := 0.4;  -- Slow SPI clock freq. during initialization (MHz).
      SPI_FREQ_G      : real       := 25.0;  -- Operational SPI freq. to the SD card (MHz).
      BLOCK_SIZE_G    : natural    := 512;  -- Number of bytes in an SD card block or sector.
      CARD_TYPE_G     : CardType_t := SD_CARD_E  -- Type of SD card connected to this controller.
      );
    port (
      -- Host-side interface signals.
      clk_i      : in  std_logic;       -- Master clock.
      reset_i    : in  std_logic                     := NO;  -- active-high, synchronous  reset.
      rd_i       : in  std_logic                     := NO;  -- active-high read block request.
      wr_i       : in  std_logic                     := NO;  -- active-high write block request.
      continue_i : in  std_logic                     := NO;  -- If true, inc address and continue R/W.
      addr_i     : in  std_logic_vector(31 downto 0) := x"00000000";  -- Block address.
      data_i     : in  std_logic_vector(7 downto 0)  := x"00";  -- Data to write to block.
      data_o     : out std_logic_vector(7 downto 0)  := x"00";  -- Data read from block.
      busy_o     : out std_logic;  -- High when controller is busy performing some operation.
      hndShk_i   : in  std_logic;  -- High when host has data to give or has taken data.
      hndShk_o   : out std_logic;  -- High when controller has taken data or has data to give.
      error_o    : out std_logic_vector(15 downto 0) := (others => NO);
      -- I/O signals to the external SD card.
      cs_bo      : out std_logic                     := HI;  -- Active-low chip-select.
      sclk_o     : out std_logic                     := LO;  -- Serial clock to SD card.
      mosi_o     : out std_logic                     := HI;  -- Serial data output to SD card.
      miso_i     : in  std_logic                     := ZERO  -- Serial data input from SD card.
      );
  end component;

    signal sd_reset : std_logic;
    signal sd_rd : std_logic;
    signal sd_wr : std_logic;
    signal sd_continue : std_logic;
    signal sd_addr : std_logic_vector(31 downto 0);
    signal sd_data_i : std_logic_vector(7 downto 0);
    signal sd_data_o : std_logic_vector(7 downto 0);
    signal sd_busy : std_logic;
    signal sd_hndshk_i : std_logic;
    signal sd_hndshk_o : std_logic;
    signal sd_error : std_logic_vector(15 downto 0);
    
    constant BLOCK_SIZE_G : natural := 512;

  TYPE XESS_SDCARD_States IS (
    XESS_SDCARD_IDLE,
    XESS_SDCARD_INIT,
    XESS_SDCARD_READ_WAIT_BUSY,
    XESS_SDCARD_READ_WAIT_READ,
    XESS_SDCARD_READ_WAIT_READ2,
    XESS_SDCARD_READ_WAIT_NOTBUSY);
  SIGNAL XESS_SDCARD_State : XESS_SDCARD_States := XESS_SDCARD_INIT;
    
begin

  label_xess_sdcard_core: SdCardCtrl
    generic map (
      BLOCK_SIZE_G => BLOCK_SIZE_G,
      CARD_TYPE_G => SDHC_CARD_E
    )
    port map (
      clk_i => xess_sdcard_wrapper_clk,
      reset_i => sd_reset,
      rd_i => sd_rd,
      wr_i => sd_wr,
      continue_i => sd_continue,
      addr_i => sd_addr,
      data_i => sd_data_i,
      data_o => sd_data_o,
      busy_o => sd_busy,
      hndShk_i => sd_hndshk_i,
      hndShk_o => sd_hndshk_o,
      error_o => sd_error,
      -- pins
      cs_bo => cs_bo,
      sclk_o => sclk_o,
      mosi_o => mosi_o,
      miso_i => miso_i
    );
    
  xess_sdcard_wrapper: process (xess_sdcard_wrapper_rst, xess_sdcard_wrapper_clk)
    variable init_done : boolean := false;
    variable timeout_counter : natural range 0 to 100000 := 0;
    variable timedout : std_logic_vector(15 downto 0) := x"0000";
    variable byte_counter : natural range 0 to BLOCK_SIZE_G := 0; -- fixme, wasteful
    variable databuf : std_logic_vector(127 downto 0);
    variable buf_counter : natural range 0 to 65535 := 0;
    variable last_addr : std_logic_vector(31 downto 0);

  begin  -- process xess_sdcard_wrapper
    IF (xess_sdcard_wrapper_rst = '0') THEN
--      if (RISING_EDGE(xess_sdcard_wrapper_clk)) THEN
        sd_reset <= '1';
        XESS_SDCARD_State <= XESS_SDCARD_INIT;
        timedout := x"0000";
        byte_counter := 0;
        timeout_counter := 100000;
        init_done := false;
        buf_counter := 0;
 --     end if;
      
    ELSIF RISING_EDGE(xess_sdcard_wrapper_clk) then
      sd_reset <= '0';
      output_fifo_wr_en <= '0';
      if (out_sd_rd_addr_req = '0') THEN
        out_sd_rd_addr_ack <= '0';
      END IF;
      -- out_sd_rd_addr_ack <= '0';
      case XESS_SDCARD_State IS
        when XESS_SDCARD_IDLE =>
          leds <= x"01";
          if (out_sd_rd_addr_req ='1') THEN -- handshake
--output_fifo_in <= '1' & x"7000" & sd_error & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            out_sd_rd_addr_ack <= '1';
            IF (out_sd_rd = '1') THEN
--output_fifo_in <= '1' & x"6000" & sd_error & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
              sd_rd <= '1';
              sd_addr <= out_sd_addr;
last_addr := out_sd_addr;
              byte_counter := 0;
              buf_counter := 0;
              timeout_counter := 100000;
              XESS_SDCARD_State <= XESS_SDCARD_READ_WAIT_BUSY;
            END IF;
          END IF;
--          if (timeout_counter = 0) then
--            output_fifo_in <= (NOT timedout) & sd_error;
--            output_fifo_wr_en <= '1';
--            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
--            timeout_counter := 100000;
--          else
--            timeout_counter := timeout_counter - 1;
--          end if;

        when XESS_SDCARD_INIT =>
          leds <= x"FF";
          sd_rd <= '0';
          sd_wr <= '0';
          sd_continue <= '0';
          sd_addr <= (others => '0');
          sd_data_i <= (others => '0');
          sd_hndshk_i <= '0';
          out_sd_rd_addr_ack <= '0';
          IF (sd_busy = '0') THEN
            XESS_SDCARD_State <= XESS_SDCARD_IDLE;
output_fifo_in <= '1' & x"8000" & sd_error & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
          elsif (init_done = false) THEN
output_fifo_in <= '1' & x"0F0F0F0F" & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            init_done := true;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"F" & timedout(11 downto 0) & sd_error & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := 100000;
          else
            timeout_counter := timeout_counter - 1;
          end IF;
          
        when XESS_SDCARD_READ_WAIT_BUSY =>
          leds <= x"02";
          IF (sd_busy = '1') THEN
--output_fifo_in <= '1' & x"5000" & sd_error & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
                sd_rd <= '0';
                sd_addr <= (others => '0');
                XESS_SDCARD_State <= XESS_SDCARD_READ_WAIT_READ;
            elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"E" & timedout(11 downto 0) & sd_error & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := 100000;
          else
            timeout_counter := timeout_counter - 1;
          END IF;
        
        when XESS_SDCARD_READ_WAIT_READ =>
          leds <= x"1F";
          --only read byte if we'll have some space to output the buffer
          IF ((output_fifo_full = '0') AND (sd_hndshk_o = '1')) THEN
--output_fifo_in <= '1' & x"40" & sd_data_o & conv_std_logic_vector(byte_counter,16) & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            databuf(((15 - (byte_counter mod 16))*8 + 7) downto ((15 - (byte_counter mod 16))*8)) := sd_data_o;
            sd_hndshk_i <= '1';
            byte_counter := byte_counter + 1;
            XESS_SDCARD_State <= XESS_SDCARD_READ_WAIT_READ2;
          ELSIF (sd_busy = '0') THEN
output_fifo_in <= '1' & x"1000" & sd_error & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
              XESS_SDCARD_State <= XESS_SDCARD_IDLE;
          END IF;
          
        when XESS_SDCARD_READ_WAIT_READ2 =>
          leds <= x"2F";
          IF (sd_hndshk_o = '0') THEN
--output_fifo_in <= '1' & x"3000" & sd_error & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            sd_hndshk_i <= '0';
            IF ((byte_counter mod 16) = 0) THEN
              output_fifo_in <= '0' & last_addr(15 downto 0) & conv_std_logic_vector(buf_counter,16) & databuf;
              output_fifo_wr_en <= '1';
              buf_counter := buf_counter + 1;
            END IF;
            IF (byte_counter = BLOCK_SIZE_G) THEN
              timeout_counter := 100000;
              XESS_SDCARD_State <= XESS_SDCARD_READ_WAIT_NOTBUSY;
            ELSE
              XESS_SDCARD_State <= XESS_SDCARD_READ_WAIT_READ;
            END IF;
          END IF;
          
        when XESS_SDCARD_READ_WAIT_NOTBUSY =>
          leds <= x"04";
          IF (sd_busy = '0') THEN
            XESS_SDCARD_State <= XESS_SDCARD_IDLE;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"D" & timedout(11 downto 0) & sd_error & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := 100000;
          else
            timeout_counter := timeout_counter - 1;
          END IF;
        
      end case;
    end IF;
    
  end process xess_sdcard_wrapper;
  
end RTL;
