-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 2
-- An unsigned adder circuit for adding two unsigned 4-bit numbers and outputting an 8-bit unsigned result.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is

	port 
	(
		a	   : in unsigned  (3 downto 0);
		b	   : in unsigned  (3 downto 0);
		result : out unsigned (7 downto 0)
	);

end entity;

architecture rtl of adder is
begin

	result <= ("0000" & a) + ("0000" & b);

end rtl;