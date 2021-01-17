library ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SimpleSDHC_wrapper is
  port (
    SimpleSDHC_wrapper_rst : in std_logic;
    SimpleSDHC_wrapper_clk : in std_logic;
    output_fifo_in : out std_logic_vector(160 downto 0); --1+ 32 +128
    output_fifo_full : in std_logic;
    output_fifo_wr_en : out std_logic;
    input_fifo_out : in std_logic_vector(127 downto 0);
    input_fifo_empty : in std_logic;
    input_fifo_rd_en : out std_logic;
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
end SimpleSDHC_wrapper;


architecture RTL of SimpleSDHC_wrapper is

    component sd_controller is
      generic (
	clockRate : integer := 50000000;		-- Incoming clock is 25MHz (can change this to 2000 to test Write Timeout)
	slowClockDivider : integer := 128;	-- For a 50MHz clock, slow clock for startup is 50/128 = 390kHz
	R1_TIMEOUT : integer := 64;         -- Number of bytes to wait before giving up on receiving R1 response
	WRITE_TIMEOUT : integer range 0 to 999 := 500; -- Number of ms to wait before giving up on write completing
   RESET_TICKS : integer := 64;        -- Number of half clock cycles being pulsed before lowing sd_busy in IDLE2
   ACTION_RETRIES : integer := 200;    -- Number of retries when SEND_CMD_5 fails
   READ_TOKEN_TIMEOUT : integer := 1000 -- Number of retries to receive the read start token "FE"
	);
      port (
	cs : out std_logic;				-- To SD card
	mosi : out std_logic;			-- To SD card
	miso : in std_logic;			-- From SD card
	sclk : out std_logic;			-- To SD card
	card_present : in std_logic;	-- From socket - can be fixed to '1' if no switch is present
	card_write_prot : in std_logic;	-- From socket - can be fixed to '0' if no switch is present, or '1' to make a Read-Only interface

	rd : in std_logic;				-- Trigger single block read
	rd_multiple : in std_logic;		-- Trigger multiple block read
	dout : out std_logic_vector(7 downto 0);	-- Data from SD card
	dout_avail : out std_logic;		-- Set when dout is valid
	dout_taken : in std_logic;		-- Acknowledgement for dout
	
	wr : in std_logic;				-- Trigger single block write
	wr_multiple : in std_logic;		-- Trigger multiple block write
	din : in std_logic_vector(7 downto 0);	-- Data to SD card
	din_valid : in std_logic;		-- Set when din is valid
	din_taken : out std_logic;		-- Ackowledgement for din
	
	addr : in std_logic_vector(31 downto 0);	-- Block address
	erase_count : in std_logic_vector(7 downto 0); -- For wr_multiple only

	sd_error : out std_logic;		-- '1' if an error occurs, reset on next RD or WR
	sd_busy : out std_logic;		-- '0' if a RD or WR can be accepted
	sd_error_code : out std_logic_vector(7 downto 0); -- See above, 000=No error
	
	
	reset : in std_logic;	-- System reset
	clk : in std_logic;		-- twice the SPI clk (max 50MHz)
	
	-- Optional debug outputs
	sd_type : out std_logic_vector(1 downto 0);	-- Card status (see above)
	sd_fsm : out std_logic_vector(7 downto 0) := "11111111" -- FSM state (see block at end of file)
          );
    end component;

    signal sd_reset : std_logic;
    signal sd_rd : std_logic := '0';
    signal sd_wr : std_logic := '0';
    signal sd_continue : std_logic := '0';
    signal sd_addr : std_logic_vector(31 downto 0);
    signal sd_data_i : std_logic_vector(7 downto 0);
    signal sd_data_o : std_logic_vector(7 downto 0);
    signal sd_busy : std_logic;
    signal sd_dout_avail : std_logic;
    signal sd_dout_taken : std_logic := '0';
    signal sd_din_valid : std_logic := '0';
    signal sd_din_taken : std_logic;
    signal sd_error : std_logic;
    signal sd_error_code : std_logic_vector(7 downto 0);
    signal sd_type : std_logic_vector(1 downto 0);
    
    constant BLOCK_SIZE_G : natural := 512;

  TYPE SIMPLESDHC_States IS (
    SIMPLESDHC_IDLE,
    SIMPLESDHC_INIT,
    SIMPLESDHC_READ_WAIT_BUSY,
    SIMPLESDHC_READ_WAIT_READ,
    SIMPLESDHC_READ_WAIT_READ2,
    SIMPLESDHC_WAIT_NOTBUSY,
    SIMPLESDHC_WRITE_WAIT_BUSY,
    SIMPLESDHC_WRITE_WAIT_WRITE,
    SIMPLESDHC_WRITE_WAIT_WRITE2);
  SIGNAL SIMPLESDHC_State : SIMPLESDHC_States := SIMPLESDHC_INIT;
    
begin

  label_sd_controller: sd_controller
      generic map (
	clockRate => 50000000,
	slowClockDivider => 128,
	R1_TIMEOUT => 64,
	WRITE_TIMEOUT => 500
	)
  port map (
    -- pins
	cs => cs_bo,
	mosi => mosi_o,
	miso => miso_i,
	sclk => sclk_o,
	card_present => '1',
	card_write_prot => '0',
    -- internal
	rd => sd_rd,
	rd_multiple => '0',
	dout => sd_data_o,
	dout_avail => sd_dout_avail,
	dout_taken => sd_dout_taken,
	
	wr => sd_wr,
	wr_multiple => '0',
	din => sd_data_i,
	din_valid => sd_din_valid,
	din_taken => sd_din_taken,
	
	addr => sd_addr,
	erase_count => (others => '0'),

	sd_error => sd_error,
	sd_busy => sd_busy,
	sd_error_code => sd_error_code,
	
	
	reset => sd_reset,
	clk => SimpleSDHC_wrapper_clk,
	
	-- Optional debug outputs
	sd_type => sd_type,
	sd_fsm => leds
          );
    
  SimpleSDHC_wrapper: process (SimpleSDHC_wrapper_rst, SimpleSDHC_wrapper_clk)
    variable init_done : boolean := false;
    constant TIMEOUT_MAX : integer := 5000000;
    variable timeout_counter : natural range 0 to TIMEOUT_MAX := TIMEOUT_MAX;
    variable timedout : std_logic_vector(15 downto 0) := x"0000";
    variable byte_counter : natural range 0 to BLOCK_SIZE_G := 0; -- fixme, wasteful
    variable databuf : std_logic_vector(127 downto 0);
    variable buf_counter : natural range 0 to 65535 := 0;
    variable last_addr : std_logic_vector(31 downto 0);

  begin  -- process SimpleSDHC_wrapper
    IF (SimpleSDHC_wrapper_rst = '0') THEN
--      if (RISING_EDGE(SimpleSDHC_wrapper_clk)) THEN
        sd_reset <= '1';
        SIMPLESDHC_State <= SIMPLESDHC_INIT;
        timedout := x"0000";
        byte_counter := 0;
        timeout_counter := TIMEOUT_MAX;
        init_done := false;
        buf_counter := 0;
 --     end if;
      
    ELSIF RISING_EDGE(SimpleSDHC_wrapper_clk) then
      sd_reset <= '0';
      output_fifo_wr_en <= '0';
      input_fifo_rd_en <= '0';
      if (out_sd_rd_addr_req = '0') THEN
        out_sd_rd_addr_ack <= '0';
      END IF;
      -- out_sd_rd_addr_ack <= '0';
      case SIMPLESDHC_State IS
        when SIMPLESDHC_IDLE =>
          sd_rd <= '0';
          sd_wr <= '0';
          sd_continue <= '0';
          sd_dout_taken <= '0';
          sd_din_valid <= '0';
          if ((sd_busy = '0') and (out_sd_rd_addr_req ='1')) THEN -- handshake
--output_fifo_in <= '1' & x"7000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            out_sd_rd_addr_ack <= '1';
            sd_addr <= out_sd_addr;
            last_addr := out_sd_addr;
            byte_counter := 0;
            buf_counter := 0;
            timeout_counter := TIMEOUT_MAX;
            IF (out_sd_rd = '1') THEN
--output_fifo_in <= '1' & x"6000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
              sd_rd <= '1';
              SIMPLESDHC_State <= SIMPLESDHC_READ_WAIT_BUSY;
            ELSE
              sd_wr <= '1';
              SIMPLESDHC_State <= SIMPLESDHC_WRITE_WAIT_BUSY;
            END IF;
          END IF;
--          if (timeout_counter = 0) then
--            output_fifo_in <= (NOT timedout) & sd_error;
--            output_fifo_wr_en <= '1';
--            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
--            timeout_counter := TIMEOUT_MAX;
--          else
--            timeout_counter := timeout_counter - 1;
--          end if;

        when SIMPLESDHC_INIT =>
          sd_rd <= '0';
          sd_wr <= '0';
          sd_continue <= '0';
          sd_addr <= (others => '0');
          sd_data_i <= (others => '0');
          sd_din_valid <= '0';
          sd_dout_taken <= '0';
          out_sd_rd_addr_ack <= '0';
          IF (sd_busy = '0') THEN
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
output_fifo_in <= '1' & x"8000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
          elsif (init_done = false) THEN
output_fifo_in <= '1' & x"0F0F0F0F" & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            init_done := true;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"F" & timedout(11 downto 0) & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := TIMEOUT_MAX;
          else
            timeout_counter := timeout_counter - 1;
          end IF;
          
        when SIMPLESDHC_READ_WAIT_BUSY =>
          IF (sd_busy = '1') THEN
output_fifo_in <= '1' & x"5000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            --sd_addr <= (others => '0');
            SIMPLESDHC_State <= SIMPLESDHC_READ_WAIT_READ;
            timeout_counter := TIMEOUT_MAX;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"E" & timedout(11 downto 0) & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := TIMEOUT_MAX;
          else
            timeout_counter := timeout_counter - 1;
          END IF;
        
        when SIMPLESDHC_READ_WAIT_READ =>
          IF (sd_error = '1') THEN
output_fifo_in <= '1' & x"1100" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            sd_rd <= '0';
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          --only read byte if we'll have some space to output the buffer
          ELSIF ((output_fifo_full = '0') AND (sd_dout_avail = '1')) THEN
output_fifo_in <= '1' & x"40" & sd_data_o & conv_std_logic_vector(byte_counter,16) & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            databuf(((15 - (byte_counter mod 16))*8 + 7) downto ((15 - (byte_counter mod 16))*8)) := sd_data_o;
            sd_dout_taken <= '1';
            byte_counter := byte_counter + 1;
            SIMPLESDHC_State <= SIMPLESDHC_READ_WAIT_READ2;
--          ELSIF ((output_fifo_full = '0') AND (timeout_counter = 0)) THEN
--output_fifo_in <= '1' & x"1100" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
--              SIMPLESDHC_State <= SIMPLESDHC_IDLE;
--          ELSIF (output_fifo_full = '0') THEN
--            timeout_counter := timeout_counter - 1;
          ELSIF (sd_busy = '0') THEN
output_fifo_in <= '1' & x"1000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
              SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          END IF;
          
        when SIMPLESDHC_READ_WAIT_READ2 =>
          IF (sd_error = '1') THEN
output_fifo_in <= '1' & x"3100" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            sd_rd <= '0';
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          ELSIF (sd_dout_avail = '0') THEN
output_fifo_in <= '1' & x"3000" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            sd_dout_taken <= '0';
            timeout_counter := TIMEOUT_MAX;
            IF ((byte_counter mod 16) = 0) THEN
              output_fifo_in <= '0' & last_addr(15 downto 0) & conv_std_logic_vector(buf_counter,16) & databuf;
              output_fifo_wr_en <= '1';
              buf_counter := buf_counter + 1;
            END IF;
            IF (byte_counter = BLOCK_SIZE_G) THEN
              sd_rd <= '0';
              SIMPLESDHC_State <= SIMPLESDHC_WAIT_NOTBUSY;
            ELSE
              SIMPLESDHC_State <= SIMPLESDHC_READ_WAIT_READ;
            END IF;
          END IF;
          
        when SIMPLESDHC_WAIT_NOTBUSY =>
          IF (sd_busy = '0') THEN
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"D" & timedout(11 downto 0) & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := TIMEOUT_MAX;
          else
            timeout_counter := timeout_counter - 1;
          END IF;

          
        when SIMPLESDHC_WRITE_WAIT_BUSY =>
          IF (sd_busy = '1') THEN
--output_fifo_in <= '1' & x"5001" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            --sd_addr <= (others => '0');
            SIMPLESDHC_State <= SIMPLESDHC_WRITE_WAIT_WRITE;
            timeout_counter := TIMEOUT_MAX;
          elsif (timeout_counter = 0) then
output_fifo_in <= '1' & x"C" & timedout(11 downto 0) & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            timedout := conv_std_logic_vector(conv_integer(timedout)+1,16);
            timeout_counter := TIMEOUT_MAX;
          else
            timeout_counter := timeout_counter - 1;
          END IF;
        
        when SIMPLESDHC_WRITE_WAIT_WRITE =>
          IF (sd_error = '1') THEN
output_fifo_in <= '1' & x"1101" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            sd_wr <= '0';
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          --only write byte if we have some space to output the buffer
          ELSIF ((input_fifo_empty = '0') OR ((byte_counter mod 16) /= 0)) THEN
--output_fifo_in <= '1' & x"40" & sd_data_o & conv_std_logic_vector(byte_counter,16) & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            IF ((byte_counter mod 16) = 0) THEN
              databuf := input_fifo_out;
              input_fifo_rd_en <= '1';
            END IF;
            sd_data_i <= databuf(((15 - (byte_counter mod 16))*8 + 7) downto ((15 - (byte_counter mod 16))*8));
            sd_din_valid <= '1';
            byte_counter := byte_counter + 1;
            SIMPLESDHC_State <= SIMPLESDHC_WRITE_WAIT_WRITE2;
--          ELSIF ((input_fifo_empty = '0') AND (timeout_counter = 0)) THEN
--output_fifo_in <= '1' & x"1101" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
--              SIMPLESDHC_State <= SIMPLESDHC_IDLE;
--          ELSIF (input_fifo_empty = '0') THEN
--            timeout_counter := timeout_counter - 1;
          ELSIF (sd_busy = '0') THEN
output_fifo_in <= '1' & x"1001" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
              SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          END IF;
          
        when SIMPLESDHC_WRITE_WAIT_WRITE2 =>
          IF (sd_error = '1') THEN
output_fifo_in <= '1' & x"3101" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
output_fifo_wr_en <= '1';
            sd_wr <= '0';
            SIMPLESDHC_State <= SIMPLESDHC_IDLE;
          ELSIF (sd_din_taken = '1') THEN
--output_fifo_in <= '1' & x"3001" & x"0" & sd_type & '0' & sd_error & sd_error_code & x"00000000000000000000000000000000";
--output_fifo_wr_en <= '1';
            sd_din_valid <= '0';
            timeout_counter := TIMEOUT_MAX;
            IF (byte_counter = BLOCK_SIZE_G) THEN
              sd_wr <= '0';
              SIMPLESDHC_State <= SIMPLESDHC_WAIT_NOTBUSY;
            ELSE
              SIMPLESDHC_State <= SIMPLESDHC_WRITE_WAIT_WRITE;
            END IF;
          END IF;
        
      end case;
    end IF;
    
  end process SimpleSDHC_wrapper;
  
end RTL;
