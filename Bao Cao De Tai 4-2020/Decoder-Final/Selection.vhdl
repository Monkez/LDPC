library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity Selection is 
	port(
		clk: in std_logic;
		Qin: in full_matrix_real;
		non_zeros_index: in arr_real_dc;
		selected_Q: out sub_matric_real
	);
end entity;

architecture Behavioral of Selection is
type sub_matric_q1 is array(0 to q-2) of arr_real_q;
type split_matrix_real is array(0 to dc -1) of sub_matric_q1;
signal split_matrix:split_matrix_real;
signal selected_Q_buffer: sub_matric_real:=(others=>(others=>0));
begin
	G1: for i in 0 to dc-1 generate
		G2: for j in 0 to q-2 generate
			split_matrix(i)(j)<=Qin(i*(q-1)+j);
		end generate;
	end generate;
	
	G3: for i in 0 to dc-1 generate
		selected_Q_buffer(i)<=split_matrix(i)(non_zeros_index(i));
	end generate;
	
	process (clk)
	begin
		if rising_edge(clk) then 
			selected_Q<=selected_Q_buffer;
		end if;
	end process;

end architecture;