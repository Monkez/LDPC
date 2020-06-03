library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity permutation is
	port(
	Q0: in arr_real_q;
	H_real: in elem;
	Q_out: out arr_real_q
	);
end entity;

architecture  arch of permutation is
signal Q1 : arr_real(1 to q-1);
signal Q2 : arr_real(1 to q-1);
signal h: std_logic_vector(2 downto 0);
signal hmn : elem;

begin
	hmn <= reserve_e(H_real);
	h <= std_logic_vector(to_unsigned(hmn-1, len_elem));
	Q_out(0)<=Q0(0);
	
	G1: for i in 1 to q-1 generate
		if7: if i+4<=q-1 generate
			Q1(i)<= MUX(Q0(i), Q0(i+4), h(2));
		end generate if7;
		if32: if i+4>q-1 generate
			Q1(i)<= MUX(Q0(i), Q0(i+4-q+1), h(2));
		end generate if32;
	end generate G1;
	
	G2: for i in 1 to q-1 generate
		if21: if i+2<=q-1 generate
			Q2(i)<= MUX(Q1(i), Q1(i+2), h(1));
		end generate if21;
		if22: if i+2>q-1 generate
			Q2(i)<= MUX(Q1(i), Q1(i+2-q+1), h(1));
		end generate if22;
	end generate G2;
		
	G3: for i in 1 to q-1 generate
		if51: if i+1<=q-1 generate
			Q_out(i)<= MUX(Q2(i), Q2(i+1), h(0));
		end generate if51;
		if52: if i+1>q-1 generate
			Q_out(i)<= MUX(Q2(i), Q2(i+1-q+1), h(0));
		end generate if52;
	end generate G3;

end arch;