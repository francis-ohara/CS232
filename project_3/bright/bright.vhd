-- Francis O'Hara
-- Spring 2025
-- CS 232 Lab 3

-- A circuit that implements a Moore state machine for controlling LEDs with specific patterns of button presses.

library ieee;
use ieee.std_logic_1164.all;

entity bright is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		buttonOne: in std_logic;
		buttonTwo: in std_logic;
		buttonThree: in std_logic;
		greenLED	 : out	std_logic_vector(3 downto 0)
	);

end entity;

architecture rtl of bright is

	-- Build an enumerated type for the state machine
	type state_type is (sIdle, sOne, sTwo, sThree);

	-- Register to hold the current state
	signal state   : state_type;

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			state <= sIdle;
		elsif (rising_edge(clk)) then
			case state is
				when sIdle =>
					if buttonOne = '0' then
						state <= sOne;
					else
						state <= sIdle;
					end if;
				when sOne =>
					if buttonTwo = '0' then
						state <= sTwo;
					elsif buttonThree = '0' then
						state <= sIdle;
					else
						state <= sOne;
					end if;
				when sTwo=>
					if buttonThree = '0' then
						state <= sThree;
					elsif buttonOne = '0' then
						state <= sIdle;
					else
						state <= sTwo;
					end if;
				when sThree =>
					if buttonOne = '0' or buttonTwo = '0' then
						state <= sIdle;
					else
						state <= sThree;
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when sIdle =>
				greenLED <= "1000";
			when sOne =>
				greenLED <= "0100";
			when sTwo =>
				greenLED <= "0010";
			when sThree =>
				greenLED <= "0001";
		end case;
	end process;

end rtl;
