-- Francis O'Hara
-- Spring 2025
-- CS 232 Lab 4

-- contains process that computes one of four operations.
-- gets incorporated in calc.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
	port
	(
		d		 : in unsigned (3 downto 0);
		e		 : in unsigned (3 downto 0);
		f		 : in std_logic_vector (1 downto 0);
		q : out unsigned (4 downto 0)
	);

end entity;

architecture rtl of alu is
	-- definitions to be added
	
	begin
		process (d, e, f) 
		begin
			case f is 
				when "00" =>
					q <= ('0' & d) + ('0' & e);
				when "01" =>
					q <= ('0' & d) - ('0' & e);
				when "10" =>
					q <= ('0' & d) AND ('0' & e);
				when others =>
					q <= ('0' & d) OR ('0' & e);
			end case;
		end process;
	end rtl;