-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- ROM memory component for a programmable light display circuit.

-- The program stored on this ROM turns on all lights, turns off the rightmost light,
-- shifts the turned off light until it reaches the far left, and shifts the turned off light back
-- until it reaches the second light from the far left.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity light_program_2 is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (2 downto 0)
	);

end entity;

architecture rtl of light_program_2 is
begin

	data <= 
		"000" when addr = "0000" else
		"101" when addr = "0001" else
		"100" when addr = "0010" else
		"111" when addr = "0011" else
		"111" when addr = "0100" else
		"111" when addr = "0101" else
		"111" when addr = "0110" else
		"111" when addr = "0111" else
		"111" when addr = "1000" else
		"111" when addr = "1001" else
		"110" when addr = "1010" else
		"110" when addr = "1011" else
		"110" when addr = "1100" else
		"110" when addr = "1101" else
		"110" when addr = "1110" else
		"110";
end rtl;