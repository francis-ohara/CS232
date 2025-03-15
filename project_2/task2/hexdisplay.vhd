-- Francis O'Hara
-- Spring 2025
-- CS232 Project 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexdisplay is

	port 
	(
		a	   : in unsigned (3 downto 0);
		result : out unsigned (6 downto 0)
	);

end entity;

architecture rtl of hexdisplay is
begin

	result(0) <= '1' when a = "0001" or a = "0100" or a = "1011" or a = "1100" or a = "1101" else '0';
	result(1) <= '1' when a = "0101" or a = "0110" or a = "1011" or a = "1100" or a = "1111" else '0';
	result(2) <= '1' when a = "0010" or a = "1100" or a = "1110" or a = "1111" else '0';
	result(3) <= '1' when a = "0001" or a = "0100" or a = "0111" or a = "1111" else '0';
	result(4) <= '1' when a = "0001" or a = "0011" or a = "0100" or a = "0101" or a = "0111" or a = "1001" else '0';
	result(5) <= '1' when a = "0001" or a = "0010" or a = "0011" or a = "0111" or a = "1010" or a = "1100" or a = "1101" else '0';
	result(6) <= '1' when a = "0000" or a = "0001" or a = "0111" else '0';

end rtl;
