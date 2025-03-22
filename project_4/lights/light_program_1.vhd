-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- ROM memory component for a programmable light display circuit.

-- The program stored on this ROM turns on the rightmost light, shifts it until it reaches the far left,
-- shifts it back to the far right, turns all lights off, and turns all lights on. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity light_program_1 is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (2 downto 0)
	);

end entity;

architecture rtl of light_program_1 is
begin

	data <= 
		"000" when addr = "0000" else
		"011" when addr = "0001" else
		"010" when addr = "0010" else
		"010" when addr = "0011" else
		"010" when addr = "0100" else
		"010" when addr = "0101" else
		"010" when addr = "0110" else
		"010" when addr = "0111" else
		"010" when addr = "1000" else
		"001" when addr = "1001" else
		"001" when addr = "1010" else
		"001" when addr = "1011" else
		"001" when addr = "1100" else
		"001" when addr = "1101" else
		"001" when addr = "1101" else
		"001";
end rtl;