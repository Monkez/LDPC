library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.utils.all;
use work.GL.all;

entity TestDecoder is
	port(
		i_Clk: in std_logic;
		i_RX_Serial: in std_logic;
		o_TX_Serial: out std_logic
	);
end entity;

architecture Behavioral of TestDecoder is


component Decoder is
	port(
		clk: std_logic;
		Q_full_input: in full_matrix_real;
		enable: in std_logic;
		final_code_out: out  arr_elem_n;
		is_busy: out  std_logic
	);
end component;

component clokDiz is
	generic (
		num : integer := 10
    );
	port(
	clk_in:in std_logic;
	clk_out: out std_logic
	);
end component;

component testTX is

	port (
		i_Clk: in std_logic;
		start: in std_logic ;
		data_in: in arr_elem_n;
		o_TX_Serial: out std_logic
	);
end component;

component testRX is
 port (
	i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    receiving: out std_logic;
	data: out full_matrix_real
 );
end component;

component testControl is
 port (
	i_Clk       : in  std_logic;
    receiving_status : in  std_logic;
    enable_decoder: out std_logic
 );
end component;

signal enable: std_logic:='0';
signal is_busy: std_logic:='1';
signal clk_Decoder: std_logic:='1';
signal receiving: std_logic:='1';
signal data: full_matrix_real;
signal final_code_out: arr_elem_n;


begin

	cD: clokDiz port map(
		clk_in=>i_Clk,
		clk_out=>clk_Decoder
	);
	
	D1: Decoder port map(
		clk=>clk_Decoder,
		Q_full_input=>data,
		enable=>enable,
		final_code_out=>final_code_out,
		is_busy=>is_busy
	);
	
	
	Tx1: testTX port map(
		i_Clk=>i_Clk,
		start=>is_busy,
		data_in=>final_code_out,
		o_TX_Serial=>o_TX_Serial
	);
	
	Rx1: testRX port map(
		i_Clk=>    i_Clk,   
		i_RX_Serial =>i_RX_Serial,
		receiving=>receiving,
		data=>data
	);
	
	TC: testControl port map(
		i_Clk=>i_Clk,
		receiving_status=>receiving,
		enable_decoder=>enable
	);
	

	
	

end;