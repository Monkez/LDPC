library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity testRX is
 port (
	i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    receiving: out std_logic;
	data: OUT full_matrix_real;
	data_ready: out std_logic
 );
end testRX;

architecture Behavioral of testRX is
signal data_in: std_logic_vector(7 downto 0);
signal is_new:  std_logic:='0';
component RECEIVER is 
	port(
		clk: in std_logic;
		byte_in: in std_logic_vector(7 downto 0);
		is_new: in std_logic;
		data: out full_matrix_real;
		receiving: out std_logic;
		data_ready: out std_logic
	);
end component;

component UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;

begin
	RXUART1: UART_RX port map( 
		i_Clk=>i_Clk,
		i_RX_Serial=>i_RX_Serial,
		o_RX_DV=>is_new,
		o_RX_Byte=>data_in
	);
	
	R1: RECEIVER port map(
		clk=>i_Clk,
		byte_in=>data_in,
		is_new=>is_new,
		data=>data,
		receiving=>receiving,
		data_ready=>data_ready
	
	);
	
	

end Behavioral;
