library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.utils.all;
use work.GL.all;

entity test is
	port (
		clk: in std_logic;
		reset: in std_logic;
		row_selection: in std_logic_vector(2 downto 0);
		LED_out: out std_logic_vector(0 to 9);
		LED_count: out std_logic_vector(1 downto 0)
		
	);
end test;

architecture Behavioral of test is
type subQ_arr is array(0 to 2) of sub_matric_real_transpose;
type Zn_arr is array(0 to 2) of arr_elem_dc;
constant subQ_array : subQ_arr:=(
((23, 60, 44),
(73, 0, 0),
(100, 100, 96),
(0, 100, 100),
(100, 86, 52),
(86, 100, 100),
(100, 100, 100),
(49, 86, 86)),
((100, 100, 100),
(100, 100, 100),
(100, 100, 0),
(100, 100, 100),
(100, 100, 94),
(99, 100, 100),
(0, 0, 100),
(100, 100, 100)),
((100, 100, 100),
(100, 100, 0),
(70, 100, 100),
(100, 100, 100),
(100, 100, 100),
(0, 0, 100),
(100, 100, 100),
(100, 100, 100))
);
constant Zn_array: Zn_arr:=(
(3, 1, 1),
(6, 6, 2),
(5, 5, 1)
);
						
component CN is
	port (
	clk: in std_logic;
	Qin: in sub_matric_real_transpose;
	Zn_in: in  arr_elem_dc;
	reset: in std_logic;
	R: out sub_matric_real_transpose
	);
end component;
	
component clokDiz is
	generic (
		num : integer := 1000  
    );
	port(
	clk_in:in std_logic;
	clk_out: out std_logic
	);
end component;
	
	
-- signal row_selection:  std_logic_vector(2 downto 0):="001";
-- signal LED_out:  std_logic_vector(9 downto 0);
-- signal reset : std_logic:='0';
-- signal clk:  std_logic:='0';
signal clk_CN : std_logic:='0';

signal Zn_in: arr_elem_dc;
signal R : sub_matric_real_transpose;
signal subQ : sub_matric_real_transpose;
signal count: natural range 0 to 2:=0;
signal last_reset: std_logic:='0';
begin
	--clk<= not(clk) after 10 ns;
	
	LED_out<=std_logic_vector(to_unsigned(R(to_integer(unsigned(row_selection)))(0), 10));
	subQ<=subQ_array(count);
	Zn_in<=Zn_array(count);
	LED_count<=std_logic_vector(to_unsigned(count,2));
	
	cD: clokDiz port map(
	clk_in=>clk,
	clk_out=>clk_CN
	);
	
	CN1: CN port map(
		clk=>clk_CN,
		Qin=>subQ,
		Zn_in=>Zn_in,
		reset=>reset,
		R=>R
	);
	
	process(clk_CN)
	begin
		if rising_edge(clk_CN) then
			last_reset<=reset;
			if last_reset='0' and reset = '1' then
				if count<2 then
					count<=count+1;
				else
					count <=0;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;