library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;
use ieee.numeric_std.all;

entity SendQ is 
	port(
		clk_in: in std_logic;
		start: in std_logic;
		data_in: in full_matrix_real;
		TX_ready: in std_logic;
		data_out: out std_logic_vector(7 downto 0);
		data_out_ready: out std_logic;
		transmitting: out std_logic
	);
end entity;

architecture Behavioral of SendQ is
signal count: natural:=0;
signal transmitting0: std_logic:='0';
signal buffer_data : std_logic_vector(0 to n*q*real_bit-1):=(others=>'0');
signal last_start :std_logic:='0';
signal last_TX_ready :std_logic:='0';
signal data_out_ready0:  std_logic:='0';
begin
	transmitting<=transmitting0;
	data_out_ready<=data_out_ready0;
	G1: for i in 0 to n-1 generate
		G2: for j in 0 to q-1 generate
			buffer_data((i*q+j)*real_bit to (i*q+j+1)*real_bit-1)<=std_logic_vector(to_unsigned(data_in(i)(j), real_bit));
		end generate;
	end generate;
	

	process (clk_in)
	begin
		if rising_edge(clk_in) then
			last_start<=start;
			last_TX_ready<=TX_ready;
			
			if last_start='1' and start='0' then
				transmitting0 <='1';
				
			end if;
			
			if data_out_ready0='1' then
				data_out_ready0<='0';
			else
				if transmitting0='1'  then
					if count = 0 then
						data_out_ready0<='1';
						count<=1;
						data_out<=buffer_data(count*8 to (count+1)*8-1);
					else
						if last_TX_ready='0' and TX_ready='1' then
							if count< n*real_bit then
								data_out_ready0<='1';
								count<=count+1;
								data_out<=buffer_data(count*8 to (count+1)*8-1);
							else
								count <=0;
								transmitting0<='0';
							end if;
						end if;
					end if;
				end if;
			end if;
			
			
		end if;
		
		
		
		
	
	end process;

end architecture;