-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_adder is

	port 
	(
		a	   : in signed	(4 downto 0);
		b	   : in signed	(4 downto 0);
		result : buffer signed (4 downto 0);
		magnitude : out std_logic_vector (7 downto 0);
		sign : out unsigned (6 downto 0)
	);

end entity;

architecture rtl of signed_adder is
begin
	
		result <= a + b;

		magnitude <= ("000" & std_logic_vector(result)) when (result(4) = '0')
			else ("000" & std_logic_vector(not (result - 1)));
		
		sign <= "1111111" when (result(4) = '0')
			else "0111111";
			
end rtl;
