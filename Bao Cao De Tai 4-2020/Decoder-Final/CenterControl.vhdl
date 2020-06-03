library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;

entity CenterControl is
	port(
	clk:in std_logic;
	enable: in std_logic;
	is_pass: in std_logic;
	Q_logic: out std_logic;
	Q_H_clk: out std_logic;
	S_clk: out std_logic;
	P1_clk: out std_logic;
	P2_clk: out std_logic;
	N_clk: out std_logic;
	CN_clk: out std_logic;
	uQ_clk: out std_logic;
	reset: out std_logic;
	is_busy: out std_logic
	);
end entity;

architecture Behavioral of CenterControl is
signal main_count: natural:=0;
signal count: natural:=0;

signal  Q_H_clk_buffer:  std_logic:='0';
signal	S_clk_buffer:  std_logic:='0';
signal	P1_clk_buffer:  std_logic:='0';
signal	P2_clk_buffer:  std_logic:='0';
signal	N_clk_buffer:  std_logic:='0';
signal	CN_clk_buffer:  std_logic:='0';
signal	uQ_clk_buffer:  std_logic:='0';
signal	Q_logic_buffer:  std_logic:='0';
signal	is_busy_buffer:  std_logic:='0';



begin
	Q_H_clk<=Q_H_clk_buffer;
	S_clk<=S_clk_buffer;
	P1_clk<=P1_clk_buffer;
	P2_clk<=P2_clk_buffer;
	N_clk<=N_clk_buffer;
	CN_clk<=CN_clk_buffer;
	uQ_clk<=uQ_clk_buffer;
	Q_logic<=Q_logic_buffer;
	is_busy<=is_busy_buffer;
	
	process (clk)
	begin
		if rising_edge(clk) then
			if enable = '0' then 
				main_count<=0;
				count<=0;
				is_busy_buffer<='0';
				Q_logic_buffer<='0';
				Q_H_clk_buffer<='0';
				S_clk_buffer<='0';
				P1_clk_buffer<='0';
				P2_clk_buffer<='0';
				N_clk_buffer<='0';
				CN_clk_buffer<='0';
				uQ_clk_buffer<='0';
				reset<='1';
			else
				if main_count>500 or (main_count>100 and is_pass = '1') then
					is_busy_buffer<='0';
					Q_logic_buffer<='0';
					Q_H_clk_buffer<='0';
					S_clk_buffer<='0';
					P1_clk_buffer<='0';
					P2_clk_buffer<='0';
					N_clk_buffer<='0';
					CN_clk_buffer<='0';
					uQ_clk_buffer<='0';
					reset<='1';
				else
					reset<='0';
					is_busy_buffer<='1';
					main_count <= main_count+1;
					if count<7 then
						count<=count+1;
					else
						count<=0;
					end if;
					
					if Q_H_clk_buffer = '1' then 
						Q_H_clk_buffer<='0';
						
					elsif count = 0  then 
						Q_H_clk_buffer<='1';
					end if;
					
					if S_clk_buffer = '1' then 
						S_clk_buffer<='0';
						
					elsif count = 1  then 
						S_clk_buffer<='1';
					end if;
					
					if P1_clk_buffer = '1' then 
						P1_clk_buffer<='0';
						
					elsif count = 2  then 
						P1_clk_buffer<='1';
					end if;
					
					if P2_clk_buffer = '1' then 
						P2_clk_buffer<='0';
						
					elsif count = 6  then 
						P2_clk_buffer<='1';
					end if;
					
					if N_clk_buffer = '1' then 
						N_clk_buffer<='0';
						
					elsif count = 3  then 
						N_clk_buffer<='1';
					end if;
					
					if CN_clk_buffer = '1' then 
						CN_clk_buffer<='0';
						
					elsif count = 4  then 
						CN_clk_buffer<='1';
					end if;
					
					if uQ_clk_buffer = '1' then 
						uQ_clk_buffer<='0';
						
					elsif count = 5  then 
						uQ_clk_buffer<='1';
					end if;
					
					if main_count = 1  then 
						Q_logic_buffer<='1';
					end if;
					
					
					
				end if;
			end if;
			
		end if;
		
	end process;
end architecture;