library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity CN is
	port (
	clk: in std_logic;
	Qin: in sub_matric_real_transpose;
	Zn_in: in  arr_elem_dc;
	reset: in std_logic;
	R: out sub_matric_real_transpose
	);
end CN;

architecture Behavioral of CN is

	SIGNAL R_buffer	: sub_matric_real_transpose:=(others=>(others=>0));
	component Zn is
		port(
			Qin: in sub_matric_real;
			output: out arr_elem_dc
			);
	end component;

	component BZn is
		port(
		Z: in  arr_elem_dc;
		output: out arr_elem_dc
		);
	end component;
	
	component DeltaDomain is
		port(
		Qin: in sub_matric_real_transpose;
		Zn: in arr_elem_dc;
		output: out sub_matric_real_transpose
		);
	end component;
	
	component MinFinderTree is
		port(
		dQ: in sub_matric_real_transpose;
		output: out min4_out_arr(0 to q-1)
		);
	end component;
	
	component ExtractColummGen is
		port(
			mftree: in min4_out_arr(0 to q-1);
			reset: in std_logic;
			output: out extra_col_ouput_arr(0 to q-1)
			);
	end component;
	
	component OutputMessageGen is
		port(
		ExtraCol: in extra_col_ouput_arr(0 to 7);
		dR: out sub_matric_real_transpose
		);
	end component;
	
	
	
	signal Zn_arr: arr_elem_dc;
	signal BZn_arr: arr_elem_dc;
	signal dQ: sub_matric_real_transpose;
	signal mftree: min4_out_arr(0 to 7);
	signal extracol: extra_col_ouput_arr(0 to 7);
	signal dR:  sub_matric_real_transpose;

begin
	Zn_arr<=Zn_in;
	
	BZn0: BZn port map(
		Z=>Zn_arr,
		output=>BZn_arr
	);
	
	DQ0: DeltaDomain port map(
		Qin=>Qin,
		Zn=>Zn_arr,
		output=>dQ
	);
	
	MFT: MinFinderTree port map(
		dQ=>dQ,
		output=>mftree
	);
	
	Extract: ExtractColummGen port map(
		mftree=>mftree,
		reset=>reset,
		output=>extracol
	);
	
	dR0: OutputMessageGen port map(
		ExtraCol=>extracol,
		dR=>dR
	);
	
	DQ1: DeltaDomain port map(
		Qin=>dR,
		Zn=>BZn_arr,
		output=>R_buffer
	);
	
	process (clK)
	begin
		if rising_edge(clk) and reset ='0' then
			R<=R_buffer;
		end if;
	end process;
	
	
end Behavioral;