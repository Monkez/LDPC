library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity Decoder is
	port(
		clk: std_logic;
		Q_full_input: in full_matrix_real;
		enable: in std_logic;
		final_code_out: out  arr_elem_n;
		is_busy: out  std_logic
		
	);
end entity;

architecture Behavioral of Decoder is

component CenterControl is
	port(
	clk:in std_logic;
	enable: in std_logic;
	is_pass: in std_logic;
	Q_logic: out std_logic;
	Q_H_clk: out std_logic;
	S_clk: out std_logic;
	P1_clk: out std_logic;
	P2_clk: out std_logic;
	N_clk: out std_logic;
	CN_clk: out std_logic;
	uQ_clk: out std_logic;
	reset: out std_logic;
	is_busy: out std_logic
	);
end component;

component H is 
	port(
		clk: in std_logic;
		reset: in std_logic;
		non_zeros_index: out arr_real_dc;
		Hmn: out arr_elem_dc
	);
end component;

component TransposeSubQ is
	port(
	Q0: in sub_matric_real;
	Q1: out sub_matric_real_transpose
	);
end component;

component UnTransposeSubQ is
	port(
	Q0: in sub_matric_real_transpose;
	Q1: out sub_matric_real
	);
end component;

component GetOutputCodeWord is
	port(
		clk: std_logic;
		enable: std_logic;
		permutated_Qmn: in sub_matric_real;
		non_zeros_index:  arr_real_dc;
		output: out arr_elem_n
	);
end component;

component ParityCheck is 
	port(
		code: in arr_elem_n;
		is_pass: out std_logic
	);
end component;

component Selection is 
	port(
		clk: in std_logic;
		Qin: in full_matrix_real;
		non_zeros_index: in arr_real_dc;
		selected_Q: out sub_matric_real
	);
end component;

component permutaion2d is 
	port(
		clk: in std_logic;
		selected_Q: in sub_matric_real;
		Hmn: in arr_elem_dc;
		permutated_Q: out sub_matric_real
	);
end component;

component unpermutaion2d is 
	port(
		clk: in std_logic;
		selected_Q: in sub_matric_real;
		Hmn: in arr_elem_dc;
		permutated_Q: out sub_matric_real
	);
end component;



component Normal is 
	port(
		clk: std_logic;
		Qmna_in: in sub_matric_real;
		Qmna_out: out sub_matric_real;
		Zn_out: out  arr_elem_dc
	);
end component;


component CN is
	port (
	clk: in std_logic;
	Qin: in sub_matric_real_transpose;
	Zn_in: in  arr_elem_dc;
	reset: in std_logic;
	R: out sub_matric_real_transpose
	);
end component ;

component update_Q is
	port(
	clk: in std_logic;
	Q0: in sub_matric_real;
	R: in sub_matric_real;
	Q1: out sub_matric_real
	);
end component;

component Q_full is 
	port(
		clk: std_logic;
		logic: std_logic;
		Q_full_in1: in full_matrix_real;
		permutated_Qmn: in sub_matric_real;
		non_zeros_index:  arr_real_dc;
		Q_full_out: out  full_matrix_real
	);
end component;



signal Q_logic: std_logic;
signal Q_H_clk: std_logic;
signal S_clk: std_logic;
signal P1_clk: std_logic;
signal P2_clk: std_logic;
signal N_clk: std_logic;
signal CN_clk: std_logic;
signal uQ_clk: std_logic;
signal reset: std_logic;
signal is_pass: std_logic:='0';
signal non_zeros_index:  arr_real_dc;
signal Hmn:  arr_elem_dc;

signal Q_full0:full_matrix_real;
signal selected_Q:  sub_matric_real;
signal permutated_Q:  sub_matric_real;
signal SRL_R_out:  sub_matric_real;
signal R: sub_matric_real := (others=>(others=>0));
signal R_t: sub_matric_real_transpose := (others=>(others=>0));
signal Qmna_out: sub_matric_real;
signal Qmna_N: sub_matric_real;
signal Qmna_N_t: sub_matric_real_transpose;
signal Zn_out: arr_elem_dc;
signal Qmna_updated: sub_matric_real;
signal permutated_Qmn:  sub_matric_real;
--signal permutated_Qmn_0:  sub_matric_real:= (others=>(others=>0));
signal final_code:   arr_elem_n;


begin

	final_code_out<=final_code;
	CC: CenterControl port map(
		clk=>clk,
		enable=>enable,
		is_pass=>is_pass,
		Q_logic=>Q_logic,
		Q_H_clk=>Q_H_clk,
		S_clk=>S_clk,
		P1_clk=>P1_clk,
		P2_clk=>P2_clk,
		N_clk=>N_clk,
		CN_clk=>CN_clk,
		uQ_clk=>uQ_clk,
		reset=>reset,
		is_busy=>is_busy

	);
	
	T1 : TransposeSubQ port map(
	
		Q0=>Qmna_N,
		Q1=>Qmna_N_t
		
	);
	
	T2 : UnTransposeSubQ port map(
	
		Q0=>R_t,
		Q1=>R
		
	);
	
	Qfull: Q_full port map(
		clk=>Q_H_clk,
		logic=>Q_logic,
		Q_full_in1=>Q_full_input,
		permutated_Qmn=>permutated_Qmn,
		non_zeros_index=>non_zeros_index,
		Q_full_out=>Q_full0
		
	);
	
	OUT1: GetOutputCodeWord port map(
		clk=> Q_H_clk,
		enable=>Q_logic,
		permutated_Qmn=>permutated_Qmn,
		non_zeros_index=>  non_zeros_index,
		output=>final_code
	);
	
	CHECk1: ParityCheck port map(
		code=>final_code,
		is_pass=>is_pass
	);
	
	H1: H port map(
		clk=>Q_H_clk,
		reset=>reset,
		non_zeros_index=>non_zeros_index,
		Hmn=>Hmn
	
	);
	
	S11 : Selection port map(
		clk=>S_clk,
		Qin=>Q_full0,
		non_zeros_index=>non_zeros_index,
		selected_Q=>selected_Q
	);
	
	P11 : permutaion2d port map(
		clk=>P1_clk,
		selected_Q=>selected_Q,
		Hmn=>Hmn,
		permutated_Q=>permutated_Q
	);
	
	
	N1: Normal port map(
		clk=>N_clk,
		Qmna_in =>permutated_Q,
		Qmna_out=>Qmna_N,
		Zn_out =>Zn_out
	);
	
	CN1: CN port map(
		clk=>CN_clk,
		Qin=>Qmna_N_t,
		Zn_in=>Zn_out,
		reset=>reset,
		R=>R_t
	
	);
	
	UQ: update_Q port map(
		clk=>uQ_clk,
		Q0=>Qmna_N,
		R=>R,
		Q1=>Qmna_updated
	);
	
	P2 : unpermutaion2d port map(
		clk=>P2_clk,
		selected_Q=>Qmna_updated,
		Hmn=>Hmn,
		permutated_Q=>permutated_Qmn
	);
	

end Behavioral;