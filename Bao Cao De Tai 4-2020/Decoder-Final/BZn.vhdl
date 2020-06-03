library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity BZn is
	port(
	Z: in  arr_elem_dc;
	output: out arr_elem_dc
	);
end entity;

architecture  arch of BZn is
signal B: arr_elem(0 to dc);
begin
	B(0)<=0;
	G1: for i in 0 to dc-1 generate
		B(i+1)<=add(B(i), Z(i));
	end generate;
	
	G2: for i in 0 to dc-1 generate
		output(i)<= add(Z(i), B(dc));
	end generate;
end arch;