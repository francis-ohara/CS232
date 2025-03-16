-- Bruce A. Maxwell, edited by Stephanie Taylor (Computer Science Department, Colby College)
-- Spring 2013
-- CS 232
--
-- Test bench program for calc.vhd and alu.vhd.  Creates a
-- series of signals for the two inputs and the function to
-- apply to them

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calcbench is
end entity;

architecture test of calcbench is

  -- internal signals to drive the circuit
  signal bench_a : unsigned (3 downto 0);
  signal bench_b : unsigned (3 downto 0);
  signal bench_c : std_logic_vector( 1 downto 0 );
  signal bench_f : unsigned(4 downto 0);

  -- component we want to test
  component calc
  port 
  (
    a      : in unsigned  (3 downto 0);
    b      : in unsigned  (3 downto 0);
    c      : in std_logic_vector (1 downto 0);
    result : out unsigned (4 downto 0)
  );
  end component;
  

begin
  -- set the inputs a, b, c to test various combinations
  bench_a <= "0000", "0001" after 20 ns, "0010" after 40 ns, "0111" after 60 ns;
  bench_b <= "0000", "0001" after 10 ns, "0010" after 30 ns, "0100" after 50 ns;
  bench_c <= "00", "01" after 15 ns, "00"after 25 ns, "01" after 45 ns,
     "10" after 50 ns, "11" after 65 ns, "00" after 70 ns;

  -- port map the calc circuit and connect the drivers and output signal
  c1: calc port map ( bench_a, bench_b, bench_c, result => bench_f );

end test;