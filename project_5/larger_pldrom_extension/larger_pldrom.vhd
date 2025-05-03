-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 5
-- ROM memory component for an advanced programmable light display circuit.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldrom is

    port
    (
        addr	   : in std_logic_vector (3 downto 0);
        data : out std_logic_vector (9 downto 0)
    );

end entity;

architecture rtl of pldrom is
begin

    data <=
        "0100010101" when addr = "0000" else -- Add 1 to LR
        "1110000011" when addr = "0001" else -- Jump to line 0011 if LR is 0
        "1000000000" when addr = "0010" else -- Jump to line 0000
        "0001101111" when addr = "0011" else -- Set all LR bits to 1
        "0100110101" when addr = "0100" else -- Subtract 1 from LR
        "1110000000" when addr = "0101" else -- Jump to line 0000 if LR is 0
        "1000000100" when addr = "0110" else -- Jump to line 0100
        "0000000000";                         -- Garbage
end rtl;
