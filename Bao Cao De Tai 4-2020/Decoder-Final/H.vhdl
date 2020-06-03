library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;
entity H is 
	port(
		clk: in std_logic;
		reset: in std_logic;
		non_zeros_index: out arr_real_dc;
		Hmn: out arr_elem_dc
	);
end entity;


architecture Behavioral of H is
signal count: integer range 0 to m-1;
signal count_buffer: integer range 0 to m-1;
begin
	non_zeros_index <=non_zeros_index_H(count);
	Hmn <= non_zeros_value_H(count);
	process(clk, reset)
	begin
		if reset='1' then
			count_buffer <= 0;
			count <= 0;
		else
			if rising_edge(clk) then
				count<=count_buffer;
				if count_buffer<m-1 then
					count_buffer <= count_buffer+1;
				else 
					count_buffer <=0;
				end if;
			end if;
			
		
		end if;
	
	end process;
end architecture;