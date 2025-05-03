-- Francis O'Hara
-- Spring 2025
-- CS 232 Project 5
-- An advanced programmable light display circuit based on a Moore State Machine.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pld2 is

    port(
        clk: in    std_logic;
        reset: in    std_logic;
        lightsig: out std_logic_vector(7 downto 0)
    );

end entity;

architecture rtl of pld2 is
    component pldrom
        port
        (
            addr: in std_logic_vector (3 downto 0);
            data: out std_logic_vector (9 downto 0)
        );
    end component;

    -- internal signals for the light circuit
    signal IR: std_logic_vector(9 downto 0);
    signal PC: unsigned(3 downto 0);
    signal LR: unsigned(7 downto 0);
    signal ROMvalue: std_logic_vector(9 downto 0);
    signal ACC: unsigned(7 downto 0);
    signal SRC: unsigned(7 downto 0);

    -- Build an enumerated type for the state machine
    type state_type is (sFetch, sExecute1, sExecute2);

    -- Register to hold the current state
    signal state: state_type;

    -- internal signals for slowing down clock
    signal slowclock: std_logic;
    signal counter: unsigned (26 downto 0);

begin

    -- Logic to advance to the next state
    process (slowclock, reset)
    begin
        if reset = '0' then
            -- initialize registers to when reset button pressed
            PC <= "0000";
            IR <= "0000000000";
            LR <= "00000000";
            state <= sFetch;    -- move to fetch state
        elsif (rising_edge(slowclock)) then
            case state is
                when sFetch =>
                -- fetch the next instruction into the program counter
                    PC <= PC + 1;
                    IR <= ROMvalue;
                    state <= sExecute1;     -- move to execute1 state
                when sExecute1 =>
                    case IR(9 downto 8) is
                        when "00" =>    -- when move instruction
                        -- check source bits from instruction and update SRC accordingly
                            if IR(5 downto 4) = "00" then
                                SRC <= ACC;
                            elsif IR(5 downto 4) = "01" then
                                SRC <= LR;
                            elsif IR(5 downto 4) = "10" then
                                SRC <= unsigned(IR(3) & IR(3) & IR(3) & IR(3) & IR(3 downto 0));
                            else
                                SRC <= "11111111";
                            end if;
                        when "01" =>    -- when binary operation instruction
                        -- check source bits from instruction and update SRC accordingly
                            if IR(4 downto 3) = "00" then
                                SRC <= ACC;
                            elsif IR(4 downto 3) = "01" then
                                SRC <= LR;
                            elsif IR(4 downto 3) = "10" then
                                SRC <= unsigned(
                                    IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1 downto 0));
                            else
                                SRC <= "11111111";
                            end if;
                        when "10" =>    -- when unconditional jump instruction
                        -- jump to address specified by address bits of instruction
                            PC <= unsigned(IR(3 downto 0));
                        when others =>      -- when conditional jump instruction
                        -- jump to address specified by address bits if ACC or LR is 0
                            if IR(7) = '0' then     -- jump if ACC is 0
                                if ACC = "00000000" then
                                    PC <= unsigned(IR(3 downto 0));
                                end if;
                            else    -- jump if LR is 0
                                if LR = "00000000" then
                                    PC <= unsigned(IR(3 downto 0));
                                end if;
                            end if;
                    end case;
                    state <= sExecute2;     -- move to execute2 state
                when sExecute2 =>
                    case IR(9 downto 8) is
                        when "00" =>
                        -- check destination bits and move appropriate value from SRC to destination
                            if IR(7 downto 6) = "00" then
                                ACC <= SRC;
                            elsif IR(7 downto 6) = "01" then
                                LR <= SRC;
                            elsif IR(7 downto 6) = "10" then
                                ACC(3 downto 0) <= SRC(3 downto 0);
                            else
                                ACC(7 downto 4) <= SRC(3 downto 0);
                            end if;
                        when "01" =>
                        -- check binary operation bits and perform appropriate operation on source and destination
                            if IR(2) = '0' then     -- if destination is ACC
                                case IR(7 downto 5) is
                                    when "000" =>
                                        ACC <= ACC + SRC;
                                    when "001" =>
                                        ACC <= ACC - SRC;
                                    when "010" =>
                                        ACC <= SRC(6 downto 0) & '0';
                                    when "011" =>
                                        ACC <= SRC(7) & SRC(7 downto 1);
                                    when "100" =>
                                        ACC <= ACC xor SRC;
                                    when "101" =>
                                        ACC <= ACC and SRC;
                                    when "110" =>
                                        ACC <= SRC(6 downto 0) & SRC(7);
                                    when others =>
                                        ACC <= SRC(0) & SRC(7 downto 1);
                                end case;
                            else    -- if destination is LR
                                case IR(7 downto 5) is
                                    when "000" =>
                                        LR <= LR + SRC;
                                    when "001" =>
                                        LR <= LR - SRC;
                                    when "010" =>
                                        LR <= LR(6 downto 0) & '0';
                                    when "011" =>
                                        LR <= SRC(7) & SRC(7 downto 1);
                                    when "100" =>
                                        LR <= LR xor SRC;
                                    when "101" =>
                                        LR <= LR and SRC;
                                    when "110" =>
                                        LR <= SRC(6 downto 0) & SRC(7);
                                    when others =>
                                        LR <= SRC(0) & SRC(7 downto 1);
                                end case;
                            end if;
                        when others =>
                    end case;
					state <= sFetch;    -- move to fetch state
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


    slowclock <= counter(21);

    lightsig <= std_logic_vector(LR);

    pldrom1: pldrom
        port map(addr => std_logic_vector(PC), data => ROMvalue);

end rtl;