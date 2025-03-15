-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 2: Flash
-- Test file for simple 7-segment display circuit.

library ieee;
use ieee.std_logic_1164.all;

entity boxtest is
end entity;

architecture test of boxtest is
  signal A: std_logic_vector(3 downto 0);
  signal Aout: std_logic_vector(3 downto 0);

  component boxdriver
  port(
  A: in std_logic_vector(3 downto 0);
  result: out std_logic_vector(3 downto 0)
  );
  end component;
    
  begin

    A(3) <= '0', '1' after 200 ns, '0' after 400 ns;
    A(2) <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns;
    A(1) <= '0', '1' after 50 ns, '0' after 100 ns, '1' after 150 ns, '0' after 200 ns, '1' after 250 ns, '0' after 300 ns, '1' after 350 ns, '0' after 400 ns;
    A(0) <= '0', '1' after 25 ns, '0' after 50 ns, '1' after 75 ns, '0' after 100 ns, '1' after 125 ns, '0' after 150 ns, '1' after 175 ns, '0' after 200 ns, '1' after 225 ns, '0' after 250 ns, '1' after 275 ns, '0' after 300 ns , '1' after 325 ns, '0' after 350 ns, '1' after 375 ns, '0' after 400 ns;

    C0: boxdriver port map( A, Aout );

  end test;
