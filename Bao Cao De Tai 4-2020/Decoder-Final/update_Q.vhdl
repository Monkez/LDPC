library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity update_Q is
	port(
	clk: in  std_logic;
	Q0: in sub_matric_real;
	R: in sub_matric_real;
	Q1: out sub_matric_real
	);
end entity;

architecture  arch of update_Q is
signal Q1_buffer: sub_matric_real:=(others=>(others=>0));
begin
	G1: for i in 0 to dc-1 generate
		G2: for j in 0 to q-1 generate
			Q1_buffer(i)(j)<=add_max(Q0(i)(j), R(i)(j));
		end generate;
	end generate;
	
	process (clk)
	begin
		if rising_edge(clk) then 
			Q1<=Q1_buffer;
		end if;
	end process;
end arch;