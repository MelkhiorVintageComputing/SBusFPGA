-- from http://www.arithmetic-circuits.org/finite-field/vhdl_codes.htm
-- only change is to hardwire the proper M and F for GHASH (GCM)
----------------------------------------------------------------------------
-- Mastrovito Multiplier, second version (mastrovito_V2_multiplier.vhd)
--
-- Computes the polynomial multiplication mod f in GF(2**m)
-- The hardware is genenerate for a specific f.
--
-- 
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
package mastrovito_V2_multiplier_parameters is
  constant M: integer := 128;
  constant F: std_logic_vector(M-1 downto 0):= (0 => '1', 1 => '1', 2 => '1', 7 => '1', others => '0'); --for GHASH
  --constant F: std_logic_vector(M-1 downto 0):= "00011011";
  --constant F: std_logic_vector(M-1 downto 0):= x"001B"; --for M=16 bits
  --constant F: std_logic_vector(M-1 downto 0):= x"0101001B"; --for M=32 bits
  --constant F: std_logic_vector(M-1 downto 0):= x"010100000101001B"; --for M=64 bits
  --constant F: std_logic_vector(M-1 downto 0):= x"0000000000000000010100000101001B"; --for M=128 bits
  --constant F: std_logic_vector(M-1 downto 0):= "000"&x"00000000000000000000000000000000000000C9"; --for M=163
  --constant F: std_logic_vector(M-1 downto 0):= (0=> '1', 74 => '1', others => '0'); --for M=233
  type matrix_reductionR is array (0 to M-1) of STD_LOGIC_VECTOR(M-2 downto 0);
  function reduction_matrix_R return matrix_reductionR;

end mastrovito_V2_multiplier_parameters;

package body mastrovito_V2_multiplier_parameters is
  function reduction_matrix_R return matrix_reductionR is
  variable R: matrix_reductionR;
  begin
  for j in 0 to M-1 loop
     for i in 0 to M-2 loop
        R(j)(i) := '0'; 
     end loop;
  end loop;
  for j in 0 to M-1 loop
     R(j)(0) := f(j);
  end loop;
  for i in 1 to M-2 loop
     for j in 0 to M-1 loop
        if j = 0 then 
           R(j)(i) := R(M-1)(i-1) and R(j)(0);
        else
           R(j)(i) := R(j-1)(i-1) xor (R(M-1)(i-1) and R(j)(0)); 
        end if;
     end loop;
  end loop;
  return R;
  end reduction_matrix_R;

end mastrovito_V2_multiplier_parameters;


------------------------------------------------------------
-- Classic Multiplication
------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mastrovito_V2_multiplier_parameters.all;

entity mastrovito_V2_multiplication is
port (
  a, b: in std_logic_vector(M-1 downto 0);
  c: out std_logic_vector(M-1 downto 0)
);
end mastrovito_V2_multiplication;

architecture simple of mastrovito_V2_multiplication is
  constant R: matrix_reductionR := reduction_matrix_R;
  signal D: std_logic_vector (M-1 downto 0);
  signal E: std_logic_vector (M-2 downto 0);

begin

  genD: process(a,b)
    variable di: std_logic_vector(M-1 downto 0);
  begin
  for i in 0 to M-1 loop
    di(i) := '0';
    for k in 0 to i loop
      di(i) := (di(i) xor (a(k) and b(i-k)));
    end loop;
  end loop;
  D <= di;
  end process genD;

  genE: process(a,b)
    variable ei: std_logic_vector(M-2 downto 0);
  begin
  for i in 0 to M-2 loop
    ei(i) := '0';
    for k in i to M-2 loop
      ei(i) := (ei(i) xor (a(M-1-(k-i)) and b(k+1)));
    end loop;
  end loop;
  E <= ei;
  end process genE;


 --Mastrovito multiplication, second version
  mastrovitoV2: process(e,d)
    variable ci, re: std_logic_vector(M-1 downto 0);
  begin
  for i in 0 to M-1 loop
    re(i) := (R(i)(0) and E(0));
    --re(i) := '0';
    for j in 1 to M-2 loop
      re(i) := (re(i) xor (R(i)(j) and E(j)));
    end loop;
    ci(i) := (D(i) xor re(i));
  end loop;
  C <= ci;
  end process;
end simple;
