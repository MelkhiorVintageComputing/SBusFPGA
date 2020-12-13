-- include libraries
-- standard stuff
library IEEE;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE LedHandlerPkg IS
END LedHandlerPkg;

PACKAGE BODY LedHandlerPkg IS
END LedHandlerPkg;

-- include libraries
-- standard stuff
library IEEE;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY LedHandler IS
  PORT(
    l_ifclk: IN std_logic; -- 48 MHz FX clock or SBus clock to avoid cross-domain clocking
    l_LED_RESET: IN std_logic := '0';
    l_LED_DATA: IN std_logic_vector(31 downto 0) := (others => '0');
    l_LED0 : OUT std_logic := '0';
    l_LED1 : OUT std_logic := '0';
    l_LED2 : OUT std_logic := '0';
    l_LED3 : OUT std_logic := '0';
    l_LED4 : OUT std_logic := '0';
    l_LED5 : OUT std_logic := '0';
    l_LED6 : OUT std_logic := '0';
    l_LED7 : OUT std_logic := '0'
    );
END ENTITY;

ARCHITECTURE RTL OF LedHandler IS
  TYPE Led_States IS (Led_Off,
                      Led_On,
                      Led_b0,
                      Led_b1,
                      Led_b2,
                      Led_b3);
  SIGNAL State : Led_States := Led_Off;
-- FOURTH/FORTIETH was too fast, double
-- 48 MHz Clock
--	CONSTANT ONE_FOURTH   : natural := 24000000;
--	CONSTANT ONE_FORTIETH : natural :=  2400000;
-- SBus Clock @ 25 MHz
    CONSTANT ONE_FOURTH   : natural := 12500000;
    CONSTANT ONE_FORTIETH : natural :=  1250000;
-- Simulation time frame
--  CONSTANT ONE_FOURTH   : natural :=  3;
--  CONSTANT ONE_FORTIETH : natural :=   1;
  SIGNAL TIME_COUNTER : natural range 0 to ONE_FOURTH := 0;
  SIGNAL BLINK_COUNTER : natural range 0 to 5 := 0;
BEGIN
  PROCESS (l_ifclk, l_LED_RESET)
  BEGIN
    IF (l_LED_RESET = '1') THEN
      State <= Led_Off;
      TIME_COUNTER <= 0;
      BLINK_COUNTER <= 0;
    END IF;
    IF rising_edge(l_ifclk) THEN
      CASE State IS
        WHEN Led_Off =>
          l_LED0 <= '0';
          l_LED1 <= '0';
          l_LED2 <= '0';
          l_LED3 <= '0';
          l_LED4 <= '0';
          l_LED5 <= '0';
          l_LED6 <= '0';
          l_LED7 <= '0';
          if (TIME_COUNTER = ONE_FORTIETH-1) then
            TIME_COUNTER <= 0;
            State <= Led_On;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
        WHEN Led_On =>
          l_LED0 <= '1';
          l_LED1 <= '1';
          l_LED2 <= '1';
          l_LED3 <= '1';
          l_LED4 <= '1';
          l_LED5 <= '1';
          l_LED6 <= '1';
          l_LED7 <= '1';
          if (TIME_COUNTER = ONE_FORTIETH-1) then
            TIME_COUNTER <= 0;
            if (BLINK_COUNTER = 4) then
              BLINK_COUNTER <= 0;
              State <= Led_b0;
            else
              BLINK_COUNTER <= BLINK_COUNTER +1;
              State <= Led_Off;
            end if;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
        when Led_b0 =>
          l_LED0 <= l_LED_DATA(0);
          l_LED1 <= l_LED_DATA(1);
          l_LED2 <= l_LED_DATA(2);
          l_LED3 <= l_LED_DATA(3);
          l_LED4 <= l_LED_DATA(4);
          l_LED5 <= l_LED_DATA(5);
          l_LED6 <= l_LED_DATA(6);
          l_LED7 <= l_LED_DATA(7);
          if (TIME_COUNTER = ONE_FOURTH-1) then
            TIME_COUNTER <= 0;
            State <= Led_b1;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
        when Led_b1 =>
          l_LED0 <= l_LED_DATA(8);
          l_LED1 <= l_LED_DATA(9);
          l_LED2 <= l_LED_DATA(10);
          l_LED3 <= l_LED_DATA(11);
          l_LED4 <= l_LED_DATA(12);
          l_LED5 <= l_LED_DATA(13);
          l_LED6 <= l_LED_DATA(14);
          l_LED7 <= l_LED_DATA(15);
          if (TIME_COUNTER = ONE_FOURTH-1) then
            TIME_COUNTER <= 0;
            State <= Led_b2;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
        when Led_b2 =>
          l_LED0 <= l_LED_DATA(16);
          l_LED1 <= l_LED_DATA(17);
          l_LED2 <= l_LED_DATA(18);
          l_LED3 <= l_LED_DATA(19);
          l_LED4 <= l_LED_DATA(20);
          l_LED5 <= l_LED_DATA(21);
          l_LED6 <= l_LED_DATA(22);
          l_LED7 <= l_LED_DATA(23);
          if (TIME_COUNTER = ONE_FOURTH-1) then
            TIME_COUNTER <= 0;
            State <= Led_b3;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
        when Led_b3 =>
          l_LED0 <= l_LED_DATA(24);
          l_LED1 <= l_LED_DATA(25);
          l_LED2 <= l_LED_DATA(26);
          l_LED3 <= l_LED_DATA(27);
          l_LED4 <= l_LED_DATA(28);
          l_LED5 <= l_LED_DATA(29);
          l_LED6 <= l_LED_DATA(30);
          l_LED7 <= l_LED_DATA(31);
          if (TIME_COUNTER = ONE_FOURTH-1) then
            TIME_COUNTER <= 0;
            State <= Led_Off;
          else
            TIME_COUNTER <= TIME_COUNTER+1;
          end if;
      END case;
    END if;

  end process;
end RTL;
