-- CS232 Project 7
-- Francis O'Hara
-- Spring 2025

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
   port (
    clk   : in  std_logic;                       -- main clock
    reset : in  std_logic;                       -- reset button

    PCview : out std_logic_vector( 7 downto 0);  -- debugging outputs
    IRview : out std_logic_vector(15 downto 0);
    RAview : out std_logic_vector(15 downto 0);
    RBview : out std_logic_vector(15 downto 0);
    RCview : out std_logic_vector(15 downto 0);
    RDview : out std_logic_vector(15 downto 0);
    REview : out std_logic_vector(15 downto 0);

    iport : in  std_logic_vector(7 downto 0);    -- input port
    oport : out std_logic_vector(15 downto 0));  -- output port
end entity;

architecture rtl of cpu is

	-- ROM Ports
	component ProgramRom
		port
		(
			address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;
	
	-- RAM Ports
	component DataRAM
		port
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	end component;

	-- ALU Ports
	component alu
		port
	(
			srcA: in  unsigned(15 downto 0); -- input A
			srcB: in  unsigned(15 downto 0); -- input B
			op: in  std_logic_vector(2 downto 0); -- operation
			cr: out std_logic_vector(3 downto 0); -- condition outputs
			dest: out unsigned(15 downto 0)        -- output value

	);
	end component;

	-- Build an enumerated type for the state machine
	type state_type is (sStart, sFetch, sExecuteSetup, sExecuteALU, sExecuteMemWait, sExecuteWrite, sExecuteReturnPause1, sExecuteReturnPause2, sHalt);

	-- internal signals and registers
	signal state: state_type;
	signal start_counter: unsigned(2 downto 0);
	signal RA: std_logic_vector(15 downto 0);
	signal RB: std_logic_vector(15 downto 0);
	signal RC: std_logic_vector(15 downto 0);
	signal RD: std_logic_vector(15 downto 0);
	signal RE: std_logic_vector(15 downto 0);
	signal SP: std_logic_vector(15 downto 0);
	signal IR: std_logic_vector(15 downto 0);
	signal PC: unsigned(7 downto 0);
	signal CR: std_logic_vector(3 downto 0);
	signal MAR: std_logic_vector(7 downto 0);
	signal MBR: std_logic_vector(15 downto 0);
	signal INREG: std_logic_vector(7 downto 0);
	signal OUTREG: std_logic_vector(15 downto 0);
	signal SRCA: std_logic_vector(15 downto 0);
	signal SRCB: std_logic_vector(15 downto 0);
	signal DEST: std_logic_vector(15 downto 0);
	signal OP: std_logic_vector(2 downto 0);
	signal aluCR: std_logic_vector(3 downto 0); --TODO: CHECK PROBLEMS WITH CR and aluCR
	signal ROM_OUT: std_logic_vector(15 downto 0);
	signal RAM_OUT: std_logic_vector(15 downto 0);
	signal RAM_WREN: std_logic;


begin
	-- port map the ROM
	ProgramRom1: ProgramRom
		port map(address=>std_logic_vector(PC), clock=>clk, q=>ROM_OUT);

	-- port map the RAM
	DataRAM1: DataRAM
		port map(address=>MAR, clock=>clk, data=>MBR, wren=>RAM_WREN, q=>RAM_OUT);

	-- port map the ALU
	alu1: alu
		port map(srcA=>unsigned(SRCA), srcB=>unsigned(SRCB), op=>OP, cr => aluCR, std_logic_vector(dest)=>DEST);


	-- state machine
	process(clk, reset)
	begin
		if reset = '0' then
			PC <= "00000000";
			IR <= "0000000000000000";
			OUTREG <= "0000000000000000";
			MAR <= "00000000";
			MBR <= "0000000000000000";
			RA <= "0000000000000000";
			RB <= "0000000000000000";
			RC <= "0000000000000000";
			RD <= "0000000000000000";
			RE <= "0000000000000000";
			SP <= "0000000000000000";
			CR <= "0000";
			start_counter <= "000";
			state <= sStart;

		elsif (rising_edge(clk)) then
			case state is
				when sStart =>
					start_counter <= start_counter + 1;
					if start_counter = "111" then
						state <= sFetch;
					end if;
				when sFetch =>
					IR <= ROM_OUT;
					PC <= PC + 1;
					state <= sExecuteSetup;

				when sExecuteSetup =>
					case IR(15 downto 12) is
						when "0000" =>
							if IR(11) = '1' then
								MAR <= std_logic_vector(unsigned(IR(7 downto 0)) + unsigned(RE(7 downto 0)));
							else
								MAR <= IR(7 downto 0);
							end if;
						when "0001" =>
							if IR(11) = '1' then
								MAR <= std_logic_vector(unsigned(IR(7 downto 0)) + unsigned(RE(7 downto 0)));
							else
								MAR <= IR(7 downto 0);
							end if;

							case IR(10 downto 8) is
								when "000" =>
									MBR <= RA;
								when "001" =>
									MBR <= RB;
								when "010" =>
									MBR <= RC;
								when "011" =>
									MBR <= RD;
								when "100" =>
									MBR <= RE;
								when others =>
									MBR <= SP;
							end case;
						when "0010" =>
							PC <= unsigned(IR(7 downto 0));
						when "0011" =>
							case IR(11 downto 10) is
								when "00" =>
									case IR(9 downto 8) is
										when "00" =>
											if CR(0) = '1' then
												PC <= unsigned(IR(7 downto 0));
											end if;
										when "01" =>
											if CR(1) = '1' then
												PC <= unsigned(IR(7 downto 0));
											end if;
										when "10" =>
											if CR(2) = '1' then
												PC <= unsigned(IR(7 downto 0));
											end if;
										when others =>
											if CR(3) = '1' then
												PC <= unsigned(IR(7 downto 0));
											end if;
									end case;
								when "01" =>
									PC <= unsigned(IR(7 downto 0));
									MAR <= SP(7 downto 0);
									MBR <= "0000" & CR & std_logic_vector(PC);
									SP <= std_logic_vector(unsigned(SP) + 1);
								when "10" =>
									MAR <= std_logic_vector(unsigned(SP(7 downto 0)) - 1);
									SP <= std_logic_vector(unsigned(SP) - 1);
								when others =>
									state <= sHalt;
							end case;
						when "0100" =>
							MAR <= SP(7 downto 0);
							SP <= std_logic_vector(unsigned(SP) + 1);
							case IR(11 downto 9) is
								when "000" =>
									MBR <= RA;
								when "001" =>
									MBR <= RB;
								when "010" =>
									MBR <= RC;
								when "011" =>
									MBR <= RD;
								when "100" =>
									MBR <= RE;
								when "101" =>
									MBR <= SP;
								when "110" =>
									MBR <= "00000000" & std_logic_vector(PC);
								when others =>
									MBR <= "000000000000" & CR;
							end case;
						when "0101" =>
							MAR <= std_logic_vector(unsigned(SP(7 downto 0)) - 1);
							SP <= std_logic_vector(unsigned(SP) - 1);
						when "1000" =>
							OP <= IR(14 downto 12);
							case IR(11 downto 9) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
							case IR(8 downto 6) is
								when "000" =>
									SRCB <= RA;
								when "001" =>
									SRCB <= RB;
								when "010" =>
									SRCB <= RC;
								when "011" =>
									SRCB <= RD;
								when "100" =>
									SRCB <= RE;
								when "101" =>
									SRCB <= SP;
								when "110" =>
									SRCB <= "0000000000000000";
								when others =>
									SRCB <= "1111111111111111";
							end case;
						when "1001" =>
							OP <= IR(14 downto 12);
							case IR(11 downto 9) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
							case IR(8 downto 6) is
								when "000" =>
									SRCB <= RA;
								when "001" =>
									SRCB <= RB;
								when "010" =>
									SRCB <= RC;
								when "011" =>
									SRCB <= RD;
								when "100" =>
									SRCB <= RE;
								when "101" =>
									SRCB <= SP;
								when "110" =>
									SRCB <= "0000000000000000";
								when others =>
									SRCB <= "1111111111111111";
							end case;
						when "1010" =>
							OP <= IR(14 downto 12);
							case IR(11 downto 9) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
							case IR(8 downto 6) is
								when "000" =>
									SRCB <= RA;
								when "001" =>
									SRCB <= RB;
								when "010" =>
									SRCB <= RC;
								when "011" =>
									SRCB <= RD;
								when "100" =>
									SRCB <= RE;
								when "101" =>
									SRCB <= SP;
								when "110" =>
									SRCB <= "0000000000000000";
								when others =>
									SRCB <= "1111111111111111";
							end case;
						when "1011" =>
							OP <= IR(14 downto 12);
							case IR(11 downto 9) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
							case IR(8 downto 6) is
								when "000" =>
									SRCB <= RA;
								when "001" =>
									SRCB <= RB;
								when "010" =>
									SRCB <= RC;
								when "011" =>
									SRCB <= RD;
								when "100" =>
									SRCB <= RE;
								when "101" =>
									SRCB <= SP;
								when "110" =>
									SRCB <= "0000000000000000";
								when others =>
									SRCB <= "1111111111111111";
							end case;
						when "1100" =>
							OP <= IR(14 downto 12);
							case IR(11 downto 9) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
							case IR(8 downto 6) is
								when "000" =>
									SRCB <= RA;
								when "001" =>
									SRCB <= RB;
								when "010" =>
									SRCB <= RC;
								when "011" =>
									SRCB <= RD;
								when "100" =>
									SRCB <= RE;
								when "101" =>
									SRCB <= SP;
								when "110" =>
									SRCB <= "0000000000000000";
								when others =>
									SRCB <= "1111111111111111";
							end case;
						when "1101" =>
							OP <= IR(14 downto 12);
							SRCB(0) <= IR(11);
							case IR(10 downto 8) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
						when "1110" =>
							OP <= IR(14 downto 12);
							SRCB(0) <= IR(11);
							case IR(10 downto 8) is
								when "000" =>
									SRCA <= RA;
								when "001" =>
									SRCA <= RB;
								when "010" =>
									SRCA <= RC;
								when "011" =>
									SRCA <= RD;
								when "100" =>
									SRCA <= RE;
								when "101" =>
									SRCA <= SP;
								when "110" =>
									SRCA <= "0000000000000000";
								when others =>
									SRCA <= "1111111111111111";
							end case;
						when "1111" =>
							OP <= IR(14 downto 12);
							if IR(11) = '1' then
								SRCA <= IR(10) & IR(10) & IR(10) & IR(10) & IR(10) & IR(10) &  IR(10) & IR(10) & IR(10 downto 3);
							else
								case IR(10 downto 8) is
									when "000" =>
										SRCA <= RA;
									when "001" =>
										SRCA <= RB;
									when "010" =>
										SRCA <= RC;
									when "011" =>
										SRCA <= RD;
									when "100" =>
										SRCA <= RE;
									when "101" =>
										SRCA <= SP;
									when "110" =>
										SRCA <= "00000000" & std_logic_vector(PC);
									when others =>
										SRCA <= IR;
								end case;
							end if;
						when others =>
					end case;
					state <= sExecuteALU;

				when sExecuteALU =>
					if (IR(15 downto 12) = "0001") or (IR(15 downto 12) = "0100") or (IR(15 downto 10) = "001101") then
						RAM_WREN <= '1';
					end if;
					state <= sExecuteMemWait;

				when sExecuteMemWait =>
					state <= sExecuteWrite;

				when sExecuteWrite =>
					RAM_WREN <= '0';
					if IR(15 downto 12) = "0000" then
						case IR(10 downto 8) is
							when "000" =>
								RA <= RAM_OUT;
							when "001" =>
								RB <= RAM_OUT;
							when "010" =>
								RC <= RAM_OUT;
							when "011" =>
								RD <= RAM_OUT;
							when "100" =>
								RE <= RAM_OUT;
							when "101" =>
								SP <= RAM_OUT;
							when others =>
						end case;
					elsif IR(15 downto 10) = "001110" then
						CR <= RAM_OUT(11 downto 8);
						PC <= unsigned(RAM_OUT(7 downto 0));
					elsif IR(15 downto 12) = "0101" then
						case IR(11 downto 9) is
							when "000" =>
								RA <= RAM_OUT;
							when "001" =>
								RB <= RAM_OUT;
							when "010" =>
								RC <= RAM_OUT;
							when "011" =>
								RD <= RAM_OUT;
							when "100" =>
								RE <= RAM_OUT;
							when "101" =>
								SP <= RAM_OUT;
							when "110" =>
								PC <= unsigned(RAM_OUT(7 downto 0));
							when others =>
								CR <= RAM_OUT(3 downto 0);
						end case;
					elsif IR(15 downto 12) = "0110" then
						case IR(11 downto 9) is
							when "000" =>
								OUTREG <= RA;
							when "001" =>
								OUTREG <= RB;
							when "010" =>
								OUTREG <= RC;
							when "011" =>
								OUTREG <= RD;
							when "100" =>
								OUTREG <= RE;
							when "101" =>
								OUTREG <= SP;
							when "110" =>
								OUTREG <= "00000000" & std_logic_vector(PC);
							when others =>
								OUTREG <= IR;
						end case;
					elsif IR(15 downto 12) = "0111" then
						case IR(11 downto 9) is
							when "000" =>
								RA <= "00000000" & INREG;
							when "001" =>
								RB <= "00000000" & INREG;
							when "010" =>
								RC <= "00000000" & INREG;
							when "011" =>
								RD <= "00000000" & INREG;
							when "100" =>
								RE <= "00000000" & INREG;
							when "101" =>
								SP <= "00000000" & INREG;
							when others =>
						end case;
					elsif (unsigned(IR(15 downto 12)) >= "1000") and (unsigned(IR(15 downto 12)) <= "1110") then
						case IR(2 downto 0) is
							when "000" =>
								RA <= DEST;
							when "001" =>
								RB <= DEST;
							when "010" =>
								RC <= DEST;
							when "011" =>
								RD <= DEST;
							when "100" =>
								RE <= DEST;
							when "101" =>
								SP <= DEST;
							when others =>
						end case;
						CR <= aluCR;
					elsif IR(15 downto 12) = "1111" then
						case IR(2 downto 0) is
							when "000" =>
								RA <= SRCA;
							when "001" =>
								RB <= SRCA;
							when "010" =>
								RC <= SRCA;
							when "011" =>
								RD <= SRCA;
							when "100" =>
								RE <= SRCA;
							when "101" =>
								SP <= SRCA;
							when others =>
						end case;
						CR <= aluCR;
					end if;
					if IR(15 downto 10) = "001110" then
						state <= sExecuteReturnPause1;
					else
						state <= sFetch;
					end if;
				when sExecuteReturnPause1 =>
					state <= sExecuteReturnPause2;
				when sExecuteReturnPause2 =>
					state <= sFetch;
				when others =>
			end case;
		end if;
	end process;


	-- assign internal signals to matching outputs
	PCview <= std_logic_vector(PC);
	IRview <= IR;
	RAview <= RA;
	RBview <= RB;
	RCview <= RC;
	RDview <= RD;
	REview <= RE;
	oport <= OUTREG;
	INREG <= iport;

end rtl;