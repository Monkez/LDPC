library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;
entity ParityCheck is 
	port(
		code: in arr_elem_n;
		is_pass: out std_logic
	);
end entity;

architecture Behavioral of ParityCheck is

signal parity_results: arr_elem_m;
signal Code_Selection: matrix_elem_m_dc;
begin
	G1: for i in 0 to m-1 generate
		G2: for j in 0 to dc-1 generate
			Code_Selection(i)(j)<=code(non_zeros_index_H(i)(j)+j*(q-1));
		end generate;
	end generate;
	
	G3: for i in 0 to m-1 generate
		parity_results(i)<=muldcxdc(Code_Selection(i), non_zeros_value_H(i));
	end generate;
	is_pass<=Syndrome(parity_results);
end architecture;