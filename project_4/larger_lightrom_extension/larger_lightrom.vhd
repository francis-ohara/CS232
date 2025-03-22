-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- An improvement on the ROM memory component for the programmable light display circuit that can store 32 instructions instead of 16.

-- The first 16 instructions turn on the rightmost LED, shifts it until it reaches the leftmost LED,
-- 		shifts it back until it reaches the rightmost position, and then turns off all LEDs.
-- The next 16 instructions turn on all LEDs, turn off the rightmost LED, shifts the offed LED
-- 		until it reaches the leftmost LED position, shifts it back until it reaches the second to rightmost LED position,
--		and then turns off all LEDs.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity larger_lightrom is

	port 
	(
		addr	   : in std_logic_vector (4 downto 0);
		data : out std_logic_vector (2 downto 0)
	);

end entity;

architecture rtl of larger_lightrom is
begin

	data <=
		"011" when addr = "00000" else
		"010" when addr = "00001" else
		"010" when addr = "00010" else
		"010" when addr = "00011" else
		"010" when addr = "00100" else
		"010" when addr = "00101" else
		"010" when addr = "00110" else
		"010" when addr = "00111" else
		"001" when addr = "01000" else
		"001" when addr = "01001" else
		"001" when addr = "01010" else
		"001" when addr = "01011" else
		"001" when addr = "01100" else
		"001" when addr = "01101" else
		"001" when addr = "01110" else
		"000" when addr = "01111" else
		"101" when addr = "10000" else
		"100" when addr = "10001" else
		"111" when addr = "10010" else
		"111" when addr = "10011" else
		"111" when addr = "10100" else
		"111" when addr = "10101" else
		"111" when addr = "10110" else
		"111" when addr = "10111" else
		"111" when addr = "11000" else
		"110" when addr = "11001" else
		"110" when addr = "11010" else
		"110" when addr = "11011" else
		"110" when addr = "11100" else
		"110" when addr = "11101" else
		"110" when addr = "11110" else
		"000";

end rtl;
