-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 4
-- An extension of the programmable light display circuit that displays the current address in the program counter as a hexadecimal number using one 7-segment display
-- and the current instruction in the instruction register as a 3-bit binary number using three 7-segment displays.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcview_irview_extension is

    port(
        clk		: in	std_logic;
        reset	 	: in	std_logic;
        lightsig : out std_logic_vector(7 downto 0);

        hex_0 : out std_logic_vector(6 downto 0);   -- displays rightmost bit of IR
        hex_1 : out std_logic_vector(6 downto 0);   -- displays middle bit of IR
        hex_2 : out std_logic_vector(6 downto 0);   -- displays leftmost bit of IR
        hex_3 : out std_logic_vector(6 downto 0)   -- displays address in PC as hex number
    );

end entity;

architecture rtl of pcview_irview_extension is
    component lightrom
        port
        (
            addr	   : in std_logic_vector (3 downto 0);
            data : out std_logic_vector (2 downto 0)
        );
    end component;

    component hexdisplay
        port
        (
            a	   : in std_logic_vector(3 downto 0);
            result : out std_logic_vector(6 downto 0)
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

    -- internal signals for displaying IR and PC
    signal IRview_0 	: std_logic_vector(3 downto 0);
    signal IRview_1 	: std_logic_vector(3 downto 0);
    signal IRview_2 	: std_logic_vector(3 downto 0);
    signal PCview 	: std_logic_vector(3 downto 0);

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

    PCview <= std_logic_vector(PC - 1) when PC /= 0 else std_logic_vector(PC);  -- decrement to ensure current IR matches current PC
    IRview_0 <= "000" & IR(0);
    IRview_1 <= "000" & IR(1);
    IRview_2 <= "000" & IR(2);
    lightsig <= std_logic_vector(LR);

    lightrom1: lightrom
        port map( addr => std_logic_vector(PC), data => ROMvalue);

    hex_pc: hexdisplay
        port map(a => PCview, result => hex_3);
    hex_ir_2: hexdisplay
        port map(a => IRview_2, result => hex_2);
    hex_ir_1: hexdisplay
        port map(a => IRview_1, result => hex_1);
    hex_ir_0: hexdisplay
        port map(a => IRview_0, result => hex_0);
end rtl;