-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- A programmable light display circuit based on a Moore State Machine.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lights is

	port(
		clk		: in	std_logic;
		reset	 	: in	std_logic;
		lightsig : out std_logic_vector(7 downto 0); 
		IRview 	: out std_logic_vector(2 downto 0);
		PCview 	: out unsigned (3 downto 0)
	);

end entity;

architecture rtl of lights is
	-- component light_program_1
	-- component light_program_2
	 component lightrom
		port
		(
			addr	   : in std_logic_vector (3 downto 0);
			data : out std_logic_vector (2 downto 0)
		);
	end component;

	-- internal signals for the light circuit
	signal IR : std_logic_vector(2 downto 0);
	signal PC : unsigned(3 downto 0);
	signal LR : unsigned(7 downto 0);
	signal ROMvalue : std_logic_vector(2 downto 0);
	
	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute);
	
	-- Register to hold the current state
		signal state   : state_type;

	-- internal signals for slowing down clock
	signal slowclock : std_logic;
	signal counter : unsigned (26 downto 0);
	
begin
	
	-- Logic to advance to the next state
	process (slowclock, reset)
	begin
		if reset = '0' then
			PC <= "0000";
			IR <= "000";
			LR <= "00000000";
			state <= sFetch;
		elsif (rising_edge(slowclock)) then
			case state is
				when sFetch =>
					IR <= ROMvalue;
					PC <= PC + 1;
					state <= sExecute;
				when sExecute =>
					case IR is 
						when "000" =>
							LR <= "00000000";
						when "001" =>
							LR <= '0' & LR(7 downto 1);
						when "010" =>
							LR <= LR(6 downto 0) & '0';
						when "011" =>
							LR <= LR + 1;
						when "100" =>
							LR <= LR - 1;
						when "101" => 
							LR <= not LR;
						when "110" =>
							LR <= LR(0) & LR(7 downto 1);
						when others =>
							LR <= LR(6 downto 0) & LR(7);
					end case;
					state <= sFetch;
			end case;
		end if;
	end process;
	
	-- process for slowing down clock
	process (clk, reset)
	begin
			if reset = '0' then
				counter <= "000000000000000000000000000";
			elsif (rising_edge(clk)) then 
				counter <= counter + 1;
			end if;
	end process;
	
	slowclock <= counter(24);
		
	IRview <= IR;
	PCview <= PC;
	lightsig <= std_logic_vector(LR);

	-- lightrom1: light_program_1
	-- lightrom1: light_program_2
	 lightrom1: lightrom
		port map( addr => std_logic_vector(PC), data => ROMvalue);
		
end rtl;