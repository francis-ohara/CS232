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
-- CREATED		"Sat Mar 15 08:10:35 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY task2 IS 
	PORT
	(
		a :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		b :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
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
END task2;

ARCHITECTURE bdf_type OF task2 IS 

COMPONENT adder
	PORT(a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hexdisplay
	PORT(a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	r0 :  STD_LOGIC;
SIGNAL	r00 :  STD_LOGIC;
SIGNAL	r01 :  STD_LOGIC;
SIGNAL	r02 :  STD_LOGIC;
SIGNAL	r03 :  STD_LOGIC;
SIGNAL	r04 :  STD_LOGIC;
SIGNAL	r05 :  STD_LOGIC;
SIGNAL	r06 :  STD_LOGIC;
SIGNAL	r1 :  STD_LOGIC;
SIGNAL	r10 :  STD_LOGIC;
SIGNAL	r11 :  STD_LOGIC;
SIGNAL	r12 :  STD_LOGIC;
SIGNAL	r13 :  STD_LOGIC;
SIGNAL	r14 :  STD_LOGIC;
SIGNAL	r15 :  STD_LOGIC;
SIGNAL	r16 :  STD_LOGIC;
SIGNAL	r2 :  STD_LOGIC;
SIGNAL	r3 :  STD_LOGIC;
SIGNAL	r4 :  STD_LOGIC;
SIGNAL	r5 :  STD_LOGIC;
SIGNAL	r6 :  STD_LOGIC;
SIGNAL	r7 :  STD_LOGIC;

SIGNAL	GDFX_TEMP_SIGNAL_4 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_2 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN 

r06 <= GDFX_TEMP_SIGNAL_4(6);
r05 <= GDFX_TEMP_SIGNAL_4(5);
r04 <= GDFX_TEMP_SIGNAL_4(4);
r03 <= GDFX_TEMP_SIGNAL_4(3);
r02 <= GDFX_TEMP_SIGNAL_4(2);
r01 <= GDFX_TEMP_SIGNAL_4(1);
r00 <= GDFX_TEMP_SIGNAL_4(0);

r16 <= GDFX_TEMP_SIGNAL_2(6);
r15 <= GDFX_TEMP_SIGNAL_2(5);
r14 <= GDFX_TEMP_SIGNAL_2(4);
r13 <= GDFX_TEMP_SIGNAL_2(3);
r12 <= GDFX_TEMP_SIGNAL_2(2);
r11 <= GDFX_TEMP_SIGNAL_2(1);
r10 <= GDFX_TEMP_SIGNAL_2(0);

r7 <= GDFX_TEMP_SIGNAL_0(7);
r6 <= GDFX_TEMP_SIGNAL_0(6);
r5 <= GDFX_TEMP_SIGNAL_0(5);
r4 <= GDFX_TEMP_SIGNAL_0(4);
r3 <= GDFX_TEMP_SIGNAL_0(3);
r2 <= GDFX_TEMP_SIGNAL_0(2);
r1 <= GDFX_TEMP_SIGNAL_0(1);
r0 <= GDFX_TEMP_SIGNAL_0(0);

GDFX_TEMP_SIGNAL_1 <= (r7 & r6 & r5 & r4);
GDFX_TEMP_SIGNAL_3 <= (r3 & r2 & r1 & r0);


b2v_inst : adder
PORT MAP(a => a,
		 b => b,
		 result => GDFX_TEMP_SIGNAL_0);


b2v_inst3 : hexdisplay
PORT MAP(a => GDFX_TEMP_SIGNAL_1,
		 result => GDFX_TEMP_SIGNAL_2);


b2v_inst4 : hexdisplay
PORT MAP(a => GDFX_TEMP_SIGNAL_3,
		 result => GDFX_TEMP_SIGNAL_4);

HEX0_D0 <= r00;
HEX0_D1 <= r01;
HEX0_D2 <= r02;
HEX0_D3 <= r03;
HEX0_D4 <= r04;
HEX0_D5 <= r05;
HEX0_D6 <= r06;
HEX1_D0 <= r10;
HEX1_D1 <= r11;
HEX1_D2 <= r12;
HEX1_D3 <= r13;
HEX1_D4 <= r14;
HEX1_D5 <= r15;
HEX1_D6 <= r16;

r0 <= GDFX_TEMP_SIGNAL_0(0);
r00 <= GDFX_TEMP_SIGNAL_4(0);
r01 <= GDFX_TEMP_SIGNAL_4(1);
r02 <= GDFX_TEMP_SIGNAL_4(2);
r03 <= GDFX_TEMP_SIGNAL_4(3);
r04 <= GDFX_TEMP_SIGNAL_4(4);
r05 <= GDFX_TEMP_SIGNAL_4(5);
r06 <= GDFX_TEMP_SIGNAL_4(6);
r1 <= GDFX_TEMP_SIGNAL_0(1);
r10 <= GDFX_TEMP_SIGNAL_2(0);
r11 <= GDFX_TEMP_SIGNAL_2(1);
r12 <= GDFX_TEMP_SIGNAL_2(2);
r13 <= GDFX_TEMP_SIGNAL_2(3);
r14 <= GDFX_TEMP_SIGNAL_2(4);
r15 <= GDFX_TEMP_SIGNAL_2(5);
r16 <= GDFX_TEMP_SIGNAL_2(6);
r2 <= GDFX_TEMP_SIGNAL_0(2);
r3 <= GDFX_TEMP_SIGNAL_0(3);
r4 <= GDFX_TEMP_SIGNAL_0(4);
r5 <= GDFX_TEMP_SIGNAL_0(5);
r6 <= GDFX_TEMP_SIGNAL_0(6);
r7 <= GDFX_TEMP_SIGNAL_0(7);
END bdf_type;