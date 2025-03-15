-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 3 Extension 1

-- Implementation of a reaction speed timer based on a Moore state machine with the ability to report the shortest reaction time so far.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shortest_reaction_timer is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		start	 : in	std_logic;
		react	 : in	std_logic;
		mstime : out unsigned (7 downto 0);
		shortest_time_display : buffer unsigned (7 downto 0);
		greenLED	 : out	std_logic_vector(2 downto 0)
	);

end entity;

architecture rtl of shortest_reaction_timer is

	-- Build an enumerated type for the state machine
	type state_type is (sIdle, sWait, sCount);

	-- Register to hold the current state
	signal state   : state_type;
	
	-- internal counter for tracking reaction time
	signal count : unsigned (27 downto 0); 
	

begin

	-- Logic to advance to the next state
	process (clk, reset, start, react, count)
	begin
		if reset = '0' then
			state <= sIdle;
			count <= "0000000000000000000000000000";
			shortest_time_display <= "11111111";	-- set shortest time display to FF upon reset
			
		elsif (rising_edge(clk)) then
			case state is
				when sIdle =>
					if start = '0' then
						state <= sWait;
						count <= "1000000000000000000000000000";
					end if;
				when sWait =>
					count <= count + 1;
					if count = "0000000000000000000000000000" then
						state <= sCount;
					elsif react = '0' then
						count <= "1111111111111111111111111111";
						state <= sIdle;					
					end if;
				when sCount =>
					count <= count + 1;
					if react = '0' then
						state <= sIdle;
						
						-- update shortest reaction time based on current reaction time upon react button press
						if (count(27 downto 20) < shortest_time_display) then
						shortest_time_display <= count(27 downto 20);
						end if;
						
					end if;
			end case;
		end if;
	end process;
	
	
	-- Output depends solely on the current state
	process (state, count)
	begin
		case state is
			when sIdle =>		
				mstime <= count(27 downto 20);
				greenLED <= "001";
			when sWait =>
				mstime <= "00000000";
				greenLED <= "010";
			when sCount =>
				mstime <= count(27 downto 20);
				greenLED <= "100";
				
		end case;
	end process;

end rtl;
