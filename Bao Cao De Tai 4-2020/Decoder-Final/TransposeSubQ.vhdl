library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity TransposeSubQ is
	port(
	Q0: in sub_matric_real;
	Q1: out sub_matric_real_transpose
	);
end entity;

architecture  arch of TransposeSubQ is
begin
	G1: for i in 0 to q-1 generate
		G2: for j in 0 to dc-1 generate
			Q1(i)(j)<=Q0(j)(i);
		end generate;
	end generate;
end arch;