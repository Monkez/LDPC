library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity min8 is
	port(
	A: in arr_real_q;
	M: out min_out 
	);
end entity;

architecture  arch of min8 is
	signal out1: min_out_arr(0 to 3);  
	signal out2: min_out_arr(0 to 1);  
	begin 
	G1: for i in 0 to 3 generate
		out1(i)<=min2(A(2*i), A(2*i+1),0, 0, 1);
	end generate;
	
	G2: for i in 0 to 1 generate
		out2(i)<=min2(out1(2*i).data, out1(2*i+1).data, out1(2*i).index, out1(2*i+1).index, 2);
	end generate;
	
	M<=min2(out2(0).data, out2(1).data, out2(0).index, out2(1).index, 4);
end arch;