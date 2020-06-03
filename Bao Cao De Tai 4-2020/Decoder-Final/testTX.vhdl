library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.utils.all;
use work.GL.all;

entity testTX is

	port (
		i_Clk: in std_logic;
		start: in std_logic ;
		data_in: in arr_elem_n;
		o_TX_Serial: out std_logic
	);
end testTX;

architecture Behavioral of testTX is

component SendCodeWord is 
	port(
		clk_in: in std_logic;
		start: in std_logic;
		data_in: in arr_elem_n;
		TX_ready: in std_logic;
		data_out: out std_logic_vector(7 downto 0);
		data_out_ready: out std_logic;
		transmitting: out std_logic
	);
end component;

component UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end component;

--signal i_Clk: std_logic:='0';
signal i_TX_DV: std_logic:='0';
signal o_TX_Active: std_logic:='0';
--signal o_TX_Serial: std_logic:='0';
signal o_TX_Done: std_logic:='0';
signal i_TX_Byte: std_logic_vector(7 downto 0):="11111111";
--signal start: std_logic :='0';
signal transmitting: std_logic :='0';


begin
	TRANSMITTER1: SendCodeWord port map(
		clk_in=>i_Clk,
		start=>start,
		data_in=>data_in,
		TX_ready=>o_TX_Done,
		data_out=>i_TX_Byte,
		data_out_ready=>i_TX_DV,
		transmitting=>transmitting
	);
	
	UART_TX1: UART_TX port map(
		i_Clk=>i_Clk,
		i_TX_DV => i_TX_DV,
		i_TX_Byte =>i_TX_Byte,
		o_TX_Serial =>o_TX_Serial,
		o_TX_Done  =>o_TX_Done
	
	);
	

end Behavioral;
