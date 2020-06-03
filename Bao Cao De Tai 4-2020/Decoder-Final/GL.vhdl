library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

package GL is 

	-- Decoder configurations
	constant n : natural := 21 ;
	constant m: natural := 12 ;
	constant dc: natural := 3 ;
	constant q: natural := 8 ;
	constant len_elem: natural := 3;
	constant real_bit: natural :=10;
	constant real_max: natural :=1023;
	constant max_up_date_vale: natural :=400;
	
	-- Custom subtypes and types
	subtype elem is natural range 0 to q-1;
	subtype bin is std_logic_vector(0 to len_elem-1);
	type arr_elem is array (natural  range<>) of elem;
	type arr_bin is array (natural  range<>) of bin;
	subtype arr_elem_dc is arr_elem(0 to dc -1);
	subtype arr_elem_q is arr_elem(0 to q -1);
	subtype arr_elem_2 is arr_elem(0 to 1);
	subtype arr_elem_n is arr_elem(0 to n-1);
	subtype arr_elem_m is arr_elem(0 to m-1);
	type  matrix_elem_m_dc is array(0 to m-1) of arr_elem_dc;
	
	function elem_to_bin(A:elem) return bin;
	function bin_to_elem(A:bin) return elem;
 	function add (A:elem ;B:elem) return elem;
	function mul (A:elem ;B:elem) return elem;
	function reserve_e(A: elem) return elem;
	function muldcxdc (A:arr_elem_dc ;B:arr_elem_dc) return elem;
	function Syndrome (A:arr_elem_m) return std_logic;
	
	constant table : arr_bin (0 to 7) := (
		"000",
		"001",
		"010",
		"100",
		"011",
		"110",
		"111",
		"101"
	);
	constant resever_table: arr_elem(0 to 7):=(0, 1, 7, 6, 5, 4, 3, 2);
	
	
	
	
end GL;

package body GL is
	-- bin_to_elem8 Finction
	function bin_to_elem(A:bin) return elem is
	variable result:elem:=0;
		begin
			case A is
				when "000" => result := 0 ;
				when "001" => result := 1 ;
				when "010" => result := 2 ;
				when "100" => result := 3 ;
				when "011" => result := 4 ;
				when "110" => result := 5 ;
				when "111" => result := 6 ;
				when "101" => result := 7 ;
				when others => result := 0;
			end case;
			return result;
		end;
	
	-- elem8_to_bin Finction
	function elem_to_bin(A:elem) return bin is
		begin
			return table(A);
		end;
		
	-- Revese elemen gl8
	function reserve_e(A: elem) return elem is
		begin
			return resever_table(A);
		end;
	
	-- ADD Function
	function add (A:elem ;B:elem) return elem is
		begin
			return bin_to_elem(table(A) xor table(B));
		end;
		
	-- MUL Function	
	function mul (A:elem ;B:elem) return elem is
		begin
			if (A=0) or (B=0) then
				return 0;
			else return (A+B-2) mod 7+1;
			end if;
		end;
		
	function muldcxdc (A:arr_elem_dc ;B:arr_elem_dc) return elem is
		variable result:elem:=0;
		begin
			for i in 0 to dc-1 loop
				result:=add(result, mul(A(i), B(i)));
			end loop;
			return result;
		end;
		
	function Syndrome (A:arr_elem_m) return std_logic is
		variable result:natural:=0;
		begin
			for i in 0 to m-1 loop
				result:=result+A(i);
			end loop;
			if result=0 then
				return '1';
			else
				return '0';
			end if;
		end;
		
end package body GL;
