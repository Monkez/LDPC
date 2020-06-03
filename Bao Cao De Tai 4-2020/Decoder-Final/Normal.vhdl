library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.utils.all;
use work.GL.all;

entity Normal is 
	port(
		clk: std_logic;
		Qmna_in: in sub_matric_real;
		Qmna_out: out sub_matric_real;
		Zn_out: out  arr_elem_dc
	);
end entity;

architecture  Behavioral of Normal is

component Zn is
	port(
	Qin: in sub_matric_real;
	output: out arr_elem_dc
	);
end component;

signal ZnO : arr_elem_dc;

begin
	

	Zn1: Zn port map(
		Qin=>Qmna_in,
		output=>ZnO
	);
	process(clk)
	begin
		if rising_edge(clk) then 
			Zn_out<=ZnO;
			for i in 0 to dc-1 loop
				for j in 0 to q-1 loop
					Qmna_out(i)(j) <= to_integer(unsigned(std_logic_vector(to_unsigned(Qmna_in(i)(j), real_bit))	- std_logic_vector(to_unsigned(Qmna_in(i)(ZnO(i)), real_bit))	));	
				end loop;
			end loop;
		end if;
	end process;
	

end architecture;