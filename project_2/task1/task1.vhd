-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
-- CREATED		"Sat Mar 15 08:08:17 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY task1 IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		HEX0_D0 :  OUT  STD_LOGIC;
		HEX0_D1 :  OUT  STD_LOGIC;
		HEX0_D2 :  OUT  STD_LOGIC;
		HEX0_D3 :  OUT  STD_LOGIC;
		HEX0_D4 :  OUT  STD_LOGIC;
		HEX0_D5 :  OUT  STD_LOGIC;
		HEX0_D6 :  OUT  STD_LOGIC;
		HEX1_D0 :  OUT  STD_LOGIC;
		HEX1_D1 :  OUT  STD_LOGIC;
		HEX1_D2 :  OUT  STD_LOGIC;
		HEX1_D3 :  OUT  STD_LOGIC;
		HEX1_D4 :  OUT  STD_LOGIC;
		HEX1_D5 :  OUT  STD_LOGIC;
		HEX1_D6 :  OUT  STD_LOGIC
	);
END task1;

ARCHITECTURE bdf_type OF task1 IS 

COMPONENT lpm_counter0
	PORT(clock : IN STD_LOGIC;
		 aclr : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hexdisplay
	PORT(a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	a :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	r0 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	r1 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 



b2v_inst : lpm_counter0
PORT MAP(clock => clk,
		 aclr => SYNTHESIZED_WIRE_0,
		 q => a);


b2v_inst2 : hexdisplay
PORT MAP(a => a(3 DOWNTO 0),
		 result => r0);


b2v_inst3 : hexdisplay
PORT MAP(a => a(7 DOWNTO 4),
		 result => r1);


SYNTHESIZED_WIRE_0 <= NOT(reset);


HEX0_D0 <= r0(0);
HEX0_D1 <= r0(1);
HEX0_D2 <= r0(2);
HEX0_D3 <= r0(3);
HEX0_D4 <= r0(4);
HEX0_D5 <= r0(5);
HEX0_D6 <= r0(6);
HEX1_D0 <= r1(0);
HEX1_D1 <= r1(1);
HEX1_D2 <= r1(2);
HEX1_D3 <= r1(3);
HEX1_D4 <= r1(4);
HEX1_D5 <= r1(5);
HEX1_D6 <= r1(6);

END bdf_type;