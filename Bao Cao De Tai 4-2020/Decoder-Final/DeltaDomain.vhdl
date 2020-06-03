library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity DeltaDomain is
	port(
	Qin: in sub_matric_real_transpose;
	Zn: in arr_elem_dc;
	output: out sub_matric_real_transpose
	);
end entity;

architecture  arch of DeltaDomain is

begin
	G:for i in 0 to q-1 generate
		G2: for j in 0 to dc-1 generate
			output(i)(j) <= Qin(add(i,Zn(j)))(j);
		end generate;
	end generate;

end arch;