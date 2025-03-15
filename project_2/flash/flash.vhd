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
-- CREATED		"Sat Mar 15 08:05:54 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY flash IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		HEX0_2 :  OUT  STD_LOGIC;
		HEX0_3 :  OUT  STD_LOGIC;
		HEX0_4 :  OUT  STD_LOGIC;
		HEX0_6 :  OUT  STD_LOGIC
	);
END flash;

ARCHITECTURE bdf_type OF flash IS 

COMPONENT lpm_counter0
	PORT(clock : IN STD_LOGIC;
		 aclr : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT boxdriver
	PORT(a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	C :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	R :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 



b2v_inst : lpm_counter0
PORT MAP(clock => clk,
		 aclr => SYNTHESIZED_WIRE_0,
		 q => C);


b2v_inst2 : boxdriver
PORT MAP(a => C,
		 result => R);


SYNTHESIZED_WIRE_0 <= NOT(reset);


HEX0_2 <= R(0);
HEX0_3 <= R(1);
HEX0_4 <= R(2);
HEX0_6 <= R(3);

END bdf_type;