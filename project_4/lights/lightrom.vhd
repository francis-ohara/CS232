-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- ROM memory component for a programmable light display circuit.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lightrom is

	port 
	(
		addr	   : in std_logic_vector (3 downto 0);
		data : out std_logic_vector (2 downto 0)
	);

end entity;

architecture rtl of lightrom is
begin

	data <= 
		"000" when addr = "0000" else
		"101" when addr = "0001" else
		"101" when addr = "0010" else
		"101" when addr = "0011" else
		"001" when addr = "0100" else
		"001" when addr = "0101" else
		"111" when addr = "0110" else
		"111" when addr = "0111" else
		"111" when addr = "1000" else
		"111" when addr = "1001" else
		"010" when addr = "1010" else
		"010" when addr = "1011" else
		"011" when addr = "1100" else
		"100" when addr = "1101" else
		"101" when addr = "1110" else
		"011";
		
end rtl;
