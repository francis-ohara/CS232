-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 2: Flash
-- Circuit for lighting up the bottom 4 segments of the Altera DE0 board's 7-segment display based on the value of a 2-bit counter.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity boxdriver is

	port 
	(
		a	   : in std_logic_vector (3 downto 0);
		result : out std_logic_vector (3 downto 0)
	);

end entity;

architecture rtl of boxdriver is
begin

	result(0) <= '1' when a = "0000" or a = "0001" or a = "0010" or a = "0011" else '0';
	result(1) <= '1' when a = "0100" or a = "0101" or a = "0110" or a = "0111" else '0';
	result(2) <= '1' when a = "1000" or a = "1001" or a = "1010" or a = "1011" else '0';
	result(3) <= '1' when a = "1100" or a = "1101" or a = "1110" or a = "1111" else '0';

end rtl;
