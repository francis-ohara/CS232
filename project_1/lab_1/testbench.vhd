-- Stephanie Taylor
-- Fall 2020
-- CS 232 Lab 1
-- Test file for the simple circuit in lab 1

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture one of testbench is

  signal A, B, F: std_logic;

  component circuit1
  port( 
    A :  IN  STD_LOGIC;
    B :  IN  STD_LOGIC;
    F :  OUT  STD_LOGIC
    );
  end component;

begin

A <= '0', '1' after 75 ns, '0' after 100 ns, '1' after 150 ns, '0' after 175 ns;
B <= '0', '1' after 25 ns, '0' after 50 ns, '1' after 125 ns;

T0: circuit1 port map(A, B, F);

end one;

