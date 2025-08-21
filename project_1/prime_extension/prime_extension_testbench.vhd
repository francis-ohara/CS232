-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 1: Extension
-- Test file for the prime number detector extension circuit in project 1

library ieee;
  use ieee.std_logic_1164.all;

entity prime_extension_testbench is
end entity;

architecture one of prime_extension_testbench is

  signal a, b, c, d, e, f, o : std_logic;

  component prime
    port (
      A : in  STD_LOGIC;
      B : in  STD_LOGIC;
      C : in  STD_LOGIC;
      D : in  STD_LOGIC;
      E : in  STD_LOGIC;
      F : in  STD_LOGIC;
      O : out STD_LOGIC
    );
  end component;

begin

  A <= '0', '1' after 80 ns;
  B <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 120 ns;
  C <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, '1' after 100 ns, '0' after 120 ns, '1' after 140 ns;
  D <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns, '0' after 80 ns, '1' after 90 ns, '0' after 100 ns, '1' after 110 ns, '0' after 120 ns, '1' after 130 ns, '0' after 140 ns, '1' after 150 ns;
  E <= '0';
  F <= '0';
  T0: prime port map (A, B, C, D, F);

end architecture;

