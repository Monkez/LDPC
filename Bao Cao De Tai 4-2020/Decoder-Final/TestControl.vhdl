library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity testControl is
 port (
	i_Clk       : in  std_logic;
    receiving_status : in  std_logic;
    enable_decoder: out std_logic
 );
end entity;

architecture Behavioral of testControl is
signal last_receiving_status :std_logic:='0';
signal enable_decoder0 :std_logic:='1';
signal count: natural :=0;
begin
	enable_decoder<=enable_decoder0;
	process(i_Clk)
	begin
		if rising_edge(i_Clk) then
		last_receiving_status<=receiving_status;
		
			if enable_decoder0='0' then
				if count <400 then
					count<= count+1;
				else
					count<=0;
					enable_decoder0 <='1';
				end if;
			else
				if last_receiving_status='1' and receiving_status='0'  then
					enable_decoder0<='0';
				end if;
			end if;
		
		
		end if;
	end process;
end;