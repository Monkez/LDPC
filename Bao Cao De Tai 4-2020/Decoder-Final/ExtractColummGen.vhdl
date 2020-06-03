library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity ExtractColummGen is
	port(
	mftree: in min4_out_arr(0 to q-1);
	reset: in std_logic;
	output: out extra_col_ouput_arr(0 to q-1)
	);
end entity;

architecture  arch of ExtractColummGen is

component min8 is
	port(
	A: in arr_real_q;
	M: out min_out 
	);
end component;

signal config_out: real_max_q_q:=(others=>(others=>real_max-max_up_date_vale));
signal output0:  min_out_arr(0 to q-1);
signal mftree_col: arr_elem_q;
begin
	G0 : for i in 0 to q-1 generate
		mftree_col(i)<=mftree(i).index;
	end generate;
	
	G1: for i in 0 to q-1 generate
			config_out(i)(0)<=MUX(mftree(i).data1, real_max-max_up_date_vale, reset);
	end generate;
	
	G2: for i in 1 to q-2 generate
		G3: for j in i+1 to q-1 generate
			config_out(add(i, j))(i)<=MUX(MUX(real_max-max_up_date_vale, max2(mftree(i).data1,mftree(j).data1), compare(mftree(i).index, mftree(j).index)), real_max-max_up_date_vale, reset);
		end generate;
	end generate;
	
	G3: for i in 1 to q-1 generate
		MIN: min8 port  map
		(A=>config_out(i), M=>output0(i));
	end generate;
	
	output0(0).data<=config_out(0)(0);
	
	G4: for i in 0 to q-1 generate
		output(i).dQ<=output0(i).data;
		output(i).m1<=mftree(i).data1;
		output(i).m2<=mftree(i).data2;
	end generate;
	
	G5: for i in 0 to q-1 generate
		output(i).d <= get_path_info(output0(i).index, i, mftree_col);
		output(i).m1col <=mftree_col(i);
	end generate;
	

	

end arch;

