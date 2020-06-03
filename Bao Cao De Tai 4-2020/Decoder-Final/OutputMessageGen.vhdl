library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity OutputMessageGen is
	port(
	ExtraCol: in extra_col_ouput_arr(0 to 7);
	dR: out sub_matric_real_transpose
	);
end entity;

architecture  arch of OutputMessageGen is
begin
	G1: for i in 0 to q-1 generate
		G2: for j in 0 to dc-1 generate
			dR(i)(j)<=dRijCompute(ExtraCol(i), j);
		end generate;
	end generate;
end arch;