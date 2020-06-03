library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity MinFinderTree is
	port(
	dQ: in sub_matric_real_transpose;
	output: out min4_out_arr(0 to q-1)
	);
end entity;

architecture  arch of MinFinderTree is
	component MinFinderTreeOneRow is
		port(
		A: in arr_real_dc;
		output: out min4_out
		);
	end component;

	begin 
		G: for i in 0 to q-1 generate
			MFT1Row: MinFinderTreeOneRow port map(
				A=>dQ(i),
				output=>output(i)
			);
		end generate;
	
end arch;


