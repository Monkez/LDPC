library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity permutaion2d is 
	port(
		clk: in std_logic;
		selected_Q: in sub_matric_real;
		Hmn: in arr_elem_dc;
		permutated_Q: out sub_matric_real
	);
end entity;

architecture  Behavioral of permutaion2d is
signal permutated_Q_buffer: sub_matric_real:=(others=>(others=>0));

component permutation is
	port(
	Q0: in arr_real_q;
	H_real: in elem;
	Q_out: out arr_real_q
	);
end component;

begin

	G1: for i in 0 to dc-1 generate
		P: permutation port map(
		Q0=>selected_Q(i),
		H_real=>Hmn(i),
		Q_out=>permutated_Q_buffer(i)
		);
		
	end generate;
	process (clk)
	begin
		if rising_edge(clk) then 
			permutated_Q<=permutated_Q_buffer;
		end if;
	end process;


end architecture;