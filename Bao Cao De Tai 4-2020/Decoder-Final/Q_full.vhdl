library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity Q_full is 
	port(
		clk: std_logic;
		logic: std_logic;
		Q_full_in1: in full_matrix_real;
		permutated_Qmn: in sub_matric_real;
		non_zeros_index:  arr_real_dc;
		Q_full_out: out  full_matrix_real
	);
end entity;

architecture  Behavioral of Q_full is

signal Q_buffer: full_matrix_real;


begin
	Q_full_out<=Q_buffer;
	process(clk)
	begin
		if rising_edge(clk) then
			for i in 0 to dc-1 loop
				for j in 0 to q-2 loop
					for k in 0 to q-1 loop
						Q_buffer(i*(q-1)+j)(k)<=MUX5(Q_full_in1(i*(q-1)+j)(k), Q_buffer(i*(q-1)+j)(k),  permutated_Qmn(i)(k), logic, j, non_zeros_index(i));
					end loop;
				end loop;		
			end loop; 
		end if;
	end process;

end architecture;