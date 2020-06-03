library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity GetOutputCodeWord is
	port(
		clk: std_logic;
		enable: std_logic;
		permutated_Qmn: in sub_matric_real;
		non_zeros_index:  arr_real_dc;
		output: out arr_elem_n
	);
end entity;

architecture  arch of GetOutputCodeWord is
signal output_buffer: arr_elem_n:=(others=>0);
signal sub_output: arr_elem_dc;

component Zn is
	port(
	Qin: in sub_matric_real;
	output: out arr_elem_dc
	);
end component;

begin


	Zn1: Zn port map(
		Qin=>permutated_Qmn,
		output=>sub_output
	
	);
	output<=output_buffer;


	process(clk)
	begin
		if rising_edge(clk) then 
		
			if enable = '1' then
				for i in 0 to  dc-1 loop
					for j in 0 to q-2 loop
							output_buffer(i*(q-1)+j)<=MUX3(0, sub_output(i), output_buffer(i*(q-1)+j), enable,  compare(j, non_zeros_index(i)));
						end loop;
				end loop;
			end if;
		end if;
	end process;
	
		
	
end arch;