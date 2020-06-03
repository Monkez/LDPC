library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;

entity clokDiz is
	generic (
		num : integer := 2  
    );
	port(
	clk_in:in std_logic;
	clk_out: out std_logic
	);
end entity;

architecture Behavioral of clokDiz is
signal count: natural:=0;
signal clk_buffer: std_logic:='0';

begin
	clk_out<=clk_buffer;
	process(clk_in)
	begin
		if rising_edge(clk_in) then
			if count = num-1 then 
				count<=0;
				clk_buffer<= not(clk_buffer);
			else
				count <= count+1;
			end if;
		end if;
		
	end process;
end architecture;