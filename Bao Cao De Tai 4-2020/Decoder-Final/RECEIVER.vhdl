library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;
use ieee.numeric_std.all;
entity RECEIVER is 
	port(
		clk: in std_logic;
		byte_in: in std_logic_vector(7 downto 0);
		is_new: in std_logic;
		data: out full_matrix_real;
		receiving: out std_logic;
		data_ready: out std_logic
	);
end entity;

architecture Behavioral of RECEIVER is
signal count: natural:=0;
signal Current_byte: std_logic_vector(7 downto 0);
signal buffer_data : std_logic_vector(0 to q*n*real_bit-1);
signal buffer_data_ready:std_logic :='0';
signal receiving0:  std_logic :='0';
signal is_new_0:  std_logic :='0';
begin
	data_ready<=buffer_data_ready;
	receiving<=receiving0;
	G1: for i in 0 to n-1 generate
		G2: for j in 0 to q-1 generate
			data(i)(j)<=to_integer(unsigned(buffer_data((i*q+j)*real_bit to (i*q+j+1)*real_bit-1)));
		end generate;
	end generate;
	process(clk)
	begin
		if rising_edge(clk) then
			is_new_0<=is_new;
			if is_new_0='0' and is_new ='1' then
				if receiving0 = '1' then
					buffer_data(count*8 to (count+1)*8-1)<=byte_in;
					if  count < n*real_bit-1 then
						count <= count+1;
					else
						receiving0<='0';
						count<=0;
					end if;
				
				elsif receiving0  = '0' THEN
					if  byte_in="00001111" then
						buffer_data_ready<=not(buffer_data_ready);
						receiving0<='1';
						count<=0;
					else
						receiving0<='0';
						count<=0;
					end if;
				end if;
			
			end if;	
		end if;
	end process;

end architecture;