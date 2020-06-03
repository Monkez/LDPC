library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.GL.all;

package utils is 

	subtype creal is integer range 0 to real_max;
	type arr_real is array (natural  range<>) of creal;
	subtype arr_real_dc is arr_real(0 to dc-1);
	subtype arr_real_4 is arr_real(0 to 3);
	subtype arr_real_q is arr_real(0 to q-1);
	type real_max_q_q is array(0 to q-1) of arr_real_q;
	type  matrix_real_m_dc is array(0 to m-1) of arr_real_dc;
	type full_matrix_real is array(0 to n-1) of arr_real_q;
	type sub_matric_real is array(0 to dc-1) of arr_real_q;
	type sub_matric_real_transpose is array(0 to q-1) of arr_real_dc;
	type SRLmatrix is array(0 to m-2) of sub_matric_real;
	
	type arr_logic_q is array(0 to q-1) of std_logic;
	type full_matrix_logic is array(0 to n-1) of arr_logic_q;
	type mask_array is array(0 to dc) of full_matrix_logic;
	type value_array is array(0 to dc) of full_matrix_real;
	
	constant non_zeros_index_H: matrix_real_m_dc:=(
(6, 2, 4),
(3, 5, 2),
(3, 6, 1),
(2, 5, 0),
(4, 6, 3),
(0, 2, 6),
(1, 4, 6),
(4, 0, 2),
(5, 0, 4),
(5, 1, 3),
(0, 3, 5),
(1, 3, 0)
);

	constant non_zeros_value_H: matrix_elem_m_dc:=(
(7, 3, 5),
(4, 6, 3),
(4, 7, 2),
(3, 6, 1),
(5, 7, 4),
(1, 3, 7),
(2, 5, 7),
(5, 1, 3),
(6, 1, 5),
(6, 2, 4),
(1, 4, 6),
(2, 4, 1)
);
	
	
	
	type min_out is record
		data   : creal;
		index  : elem;
	end record min_out;
	type min_out_arr is  array (natural  range<>) of min_out;
	
	type min4_out is record
		data1   : creal;
		data2   : creal;
		index  : elem;
	end record min4_out;
	type min4_out_arr is  array (natural  range<>) of min4_out;
	
	
	type extra_col_ouput is record
		dQ: creal;
		m1: creal;
		m2:creal;
		d: arr_elem_2;
		m1col: elem;
	end record extra_col_ouput;
		
	type extra_col_ouput_arr is  array (natural  range<>) of extra_col_ouput;
	
	function MUX(A:creal; B:creal; C:std_logic) return creal;
	function MUX3(A1:creal; A2:creal; A3: creal; C:std_logic; D:std_logic) return creal;
	function MUX_arr_q(A:arr_real_q; B:arr_real_q; C:std_logic) return arr_real_q;
	function MUX_logic(A:std_logic; B:std_logic; C:std_logic) return std_logic;
	function MUX7(A1:creal; A2: creal; B:arr_real_dc; C:std_logic; col: creal; D:arr_real_dc) return creal;
	function MUX4(A:creal; B:creal; col: creal; D:creal) return creal;
	function MUX5(A1:creal; A2: creal; B:creal; C:std_logic; col: creal; D:creal) return creal;
	function min2(A:creal; B:creal; pos_argA:elem; pos_argB:elem; order:elem) return min_out;
	function sort2(A:creal; B:creal) return min4_out;
	function min4(A1:creal; A2:creal; B1:creal; B2:creal; pos_argA:elem; pos_argB:elem; order:elem) return min4_out;
	function max2(A:creal; B:creal) return creal;
	function compare(A:elem; B:elem) return std_logic;
	function get_path_info(argmin: elem; i: elem; M:  arr_elem_q) return  arr_elem_2;
	function dRijCompute(E: extra_col_ouput; col: elem) return creal;
	function make_masks_frome_indexs(A: arr_real_dc) return mask_array;
	function make_values_array(A:full_matrix_real; B: sub_matric_real;C: mask_array ) return value_array;
	function make_values_array2(A:full_matrix_real; B: sub_matric_real;C: arr_real_dc ) return value_array;
	function compute_new_Q(A:  value_array) return full_matrix_real;
	function add_max(A:creal; B:creal) return creal;
	
end utils;

package body utils is
	function MUX_logic(A:std_logic; B:std_logic; C:std_logic) return std_logic is
	begin
		if C='0' then 
			return A;
		else
			return B;
		end if;
	end;
	
	function MUX(A:creal; B:creal; C:std_logic) return creal is
		begin
			if c = '0' then 
				return A;
			else
				return B;
			end if;
		end;
	function MUX3(A1:creal; A2:creal; A3: creal; C:std_logic; D:std_logic) return creal is
		begin
			if c = '0' then 
				return A1;
			else
				if D = '0' then
					return A2;
				else
					return A3;
				end if;
			end if;
		end;
	
	function MUX_arr_q(A:arr_real_q; B:arr_real_q; C:std_logic) return arr_real_q is
		begin
			if c = '0' then 
				return A;
			else
				return B;
			end if;
		end;
	
	function MUX7(A1:creal; A2: creal; B:arr_real_dc; C:std_logic; col: creal; D:arr_real_dc) return creal is
		variable is_free : std_logic:='1';
		variable index : creal:=0;
		begin
			if C='0' then
				return A1;
			else
				for i in 0 to dc-1 loop
					if col = D(i) then
						is_free:='0';
						index:=i;
					end if;
				end loop;
				if is_free = '1' then
					return A2;
				else
					return B(index);
				end if;
			end if;
		end;
		
	function MUX5(A1:creal; A2: creal; B:creal; C:std_logic; col: creal; D:creal) return creal is
		begin
			if C='0' then
				return A1;
			else
				if col = D then
					return B;
				else 
					return A2;
				end if;
			
			end if;
		end;
	
	function MUX4(A:creal; B:creal; col: creal; D:creal) return creal is
		begin
			if col = D then
				return B;
			else 
				return A;
			end if;
		end;
		
	function min2(A:creal; B:creal; pos_argA:elem; pos_argB:elem; order:elem) return min_out is
		variable result: min_out;
		begin
			if A<=B then 
				result.data:=A;
				result.index:=pos_argA;
			else 
				result.data:=B;
				result.index:=pos_argB+ order;
			end if;
			return result;
		end;
		
	function sort2(A:creal; B:creal) return min4_out is
	variable result: min4_out;
		begin
			if A<=B then
				result.data1:=A;
				result.data2:=B;
				result.index:=0;
			else
				result.data1:=B;
				result.data2:=A;
				result.index:=1;
			end if;
			return result;
		end;
		
	function min4(A1:creal; A2:creal; B1:creal; B2:creal; pos_argA:elem; pos_argB:elem; order:elem) return min4_out is
		variable result: min4_out;
		begin
			if A1<=B1 then
				result.data1:=A1;
				result.index:=pos_argA;
				if A2<=B1 then
					result.data2:=A2;
				else
					result.data2:=B1;
				end if;
			else
				result.data1:=B1;
				result.index:=pos_argB+order;
				if B2<=A1 then
					result.data2:=B2;
				else
					result.data2:=A1;
				end if;
			end if;
			return result;
		end;
	
	function max2(A:creal; B:creal) return creal is
		begin
			if A>=B then
				return A;
			else 
				return B;
			end if;
				
		end;
	
	function compare(A:elem; B:elem) return std_logic is
		begin
			IF A=B then
				return '0';
			else
				return '1';
			end if;
		end;
	
	function get_path_info(argmin: elem; i: elem; M:  arr_elem_q) return  arr_elem_2 is
		variable mux1_out: arr_real_4;
		variable  argmin_is_null: std_logic;
		variable results: arr_elem_2;
		begin
			mux1_out(0):=M(i);
			mux1_out(1):=M(i);
			mux1_out(2):=M(argmin);
			mux1_out(3):=M(add(argmin, i));
			argmin_is_null:= compare(argmin, 0);
			if argmin_is_null='0' then
				results(0):= mux1_out(0);
				results(1):= mux1_out(1);
			else
				results(0):= mux1_out(2);
				results(1):= mux1_out(3);
			end if;
			
			return results;
		end;
	
	function dRijCompute(E: extra_col_ouput; col: elem) return creal is
		begin
			if E.d(0) = col or E.d(1) = col then
				if E.d(0) = E.d(1) then
					return E.m2;
				else
					if E.m1col = col then
						return E.m2;
					else
						return E.m1;
					end if;
				end if;
			else
				return E.dQ;
			end if;
		end;
		
	function make_masks_frome_indexs(A: arr_real_dc) return mask_array is
		variable rerults: mask_array:=(others=>(others=>(others=>'0')));
		variable is_free : std_logic:='0';
		begin
			for i in 0 to dc-1 loop
				rerults(i)(A(i)):=(others=>'1');
			end loop;
			
			for i in 0 to n-1 loop
				for j in 0 to q-1 loop
					is_free:='0';
					for k in 0 to dc-1 loop
						is_free:= is_free or rerults(k)(i)(j);
					end loop;
					rerults(dc)(i)(j) := not(is_free);
				end loop;
			end  loop;
			return rerults;
		end;
		
	function make_values_array2(A:full_matrix_real; B: sub_matric_real;C: arr_real_dc ) return value_array is
	
		variable rerults: value_array:=(others=>(others=>(others=>0)));
		variable is_free : std_logic:='0';
		begin
			for i in 0 to dc-1 loop
				rerults(i)(C(i)):=B(i);
			end loop;
			
			
			return rerults;
		end;
	
	function make_values_array(A:full_matrix_real; B: sub_matric_real; C: mask_array ) return value_array is
		variable rerults: value_array:=(others=>(others=>(others=>0)));
		variable bits: std_logic_vector(0 to real_bit-1);
		begin
			for i in 0 to dc-1 loop
			 for j in 0 to n-1 loop
				for k in 0 to q-1 loop
					bits:=std_logic_vector(to_unsigned(B(i)(k), real_bit));
					for m in 0 to real_bit-1 loop
						bits(m):= bits(m) and C(i)(j)(k);
					end loop;
					rerults(i)(j)(k):=to_integer(unsigned(bits));
				end loop;
			 
			 end loop;
			end loop;
			
			for j in 0 to n-1 loop
				for k in 0 to q-1 loop
					
					if C(dc)(j)(k) = '1' then
						rerults(dc)(j)(k):= A(j)(k);
					end if;
				end loop;
			 
			 end loop;
			return rerults;
			
		end;
	
	function compute_new_Q(A:  value_array) return full_matrix_real is
		variable S: creal:=0;
		variable result: full_matrix_real;
		begin
			for i in 0 to n-1 loop
				for j in 0 to q-1 loop
					S:=0;
					for k in 0 to dc loop
						S:=S+A(k)(i)(j);
					end loop;
					result(i)(j):=S;
				end loop;
			end loop;
			return result;
		
		end;
		
	function add_max(A:creal; B:creal) return creal is
		variable A_bit: std_logic_vector(real_bit downto 0):=(others=>'0');
		variable B_bit: std_logic_vector(real_bit downto 0):=(others=>'0');
		variable C_bit: std_logic_vector(real_bit downto 0):=(others=>'0');
		begin
			A_bit(real_bit-1 downto 0):=std_logic_vector(to_unsigned(A, real_bit));
			B_bit(real_bit-1 downto 0):=std_logic_vector(to_unsigned(B, real_bit));
			C_bit:=A_bit+B_bit;
			if C_bit(real_bit)='0' then 
				return to_integer(unsigned(std_logic_vector(C_bit(real_bit-1 downto 0))));
			else
				return real_max;
			end if;
		
		end;
	
	

end package body utils;