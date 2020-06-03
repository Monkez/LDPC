library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity Zn is
	port(
	Qin: in sub_matric_real;
	output: out arr_elem_dc
	);
end entity;

architecture  arch of Zn is
	signal output0: min_out_arr(0 to 5);

	component min8 is
		port(
		A: in arr_real_q;
		M: out min_out 
		);
	end component;

begin
	
	G1: for i in 0 to dc-1 generate
		Min: min8 port map(
			A=>Qin(i),
			M=>output0(i)
		);
	end generate;
	
	G3: for i in 0 to dc-1 generate
		output(i)<=output0(i).index;
	end generate;
end arch;