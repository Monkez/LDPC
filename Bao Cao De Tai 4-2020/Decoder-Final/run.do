vlib work
vcom GL.vhdl
vcom utils.vhdl
vcom min8.vhdl
vcom clokDiz.vhdl
vcom BZn.vhdl
vcom DeltaDomain.vhdl
vcom MinFinderTreeOneRow.vhdl
vcom MinFinderTree.vhdl
vcom ExtractColummGen.vhdl
vcom OutputMessageGen.vhdl
vcom CN.vhdl

vcom testCn.vhdl
vsim test

add wave sim:/test/clk
add wave sim:/test/clk_CN
add wave sim:/test/R
add wave sim:/test/LED_out

run 500 ns