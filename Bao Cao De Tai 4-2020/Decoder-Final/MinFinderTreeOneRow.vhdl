library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity MinFinderTreeOneRow is
	port(
	A: in arr_real_dc;
	output: out min4_out
	);
end entity;

architecture  arch of MinFinderTreeOneRow is
	
	signal A_padding:arr_real_4:=(others=>real_max);
	signal sorted: min4_out_arr(0 to 1) ;
	
	begin
		A_padding(0 to 2)<=A;
		G1: for i in 0 to 1 generate
			sorted(i)<=sort2(A_padding(2*i), A_padding(2*i+1));
		end generate;
		output <= min4(sorted(0).data1,sorted(0).data2, sorted(1).data1,sorted(1).data2, sorted(0).index, sorted(1).index, 2);
	
end arch;


