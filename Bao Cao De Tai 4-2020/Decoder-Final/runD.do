vlib work
vcom GL.vhdl
vcom utils.vhdl
vcom H.vhdl
vcom Selection.vhdl
vcom permutation.vhdl
vcom unpermutation.vhdl
vcom permutation2d.vhdl
vcom unpermutation2d.vhdl
vcom min8.vhdl
vcom Zn.vhdl
vcom Normal.vhdl
vcom update_Q.vhdl
vcom BZn.vhdl
vcom DeltaDomain.vhdl
vcom MinFinderTreeOneRow.vhdl
vcom MinFinderTree.vhdl
vcom ExtractColummGen.vhdl
vcom OutputMessageGen.vhdl
vcom CN.vhdl
vcom TransposeSubQ.vhdl
vcom UnTransposeSubQ.vhdl
vcom GetOutputCodeWord.vhdl
vcom ParityCheck.vhdl
vcom clokDiz.vhdl
vcom CenterControl.vhdl
vcom Q_full.vhdl
vcom Decoder.vhdl
vcom TestDecoder.vhdl
vsim TestDecoder

add wave sim:/TestDecoder/i_Clk
add wave sim:/TestDecoder/clk_Decoder
add wave sim:/TestDecoder/enable
add wave sim:/testdecoder/D1/Q_logic
add wave sim:/testdecoder/D1/Q_full0
add wave sim:/testdecoder/D1/Q_H_clk
add wave sim:/testdecoder/D1/non_zeros_index
add wave sim:/testdecoder/D1/selected_Q
add wave sim:/testdecoder/D1/permutated_Q
add wave sim:/testdecoder/D1/Qmna_N
add wave sim:/testdecoder/D1/R
add wave sim:/testdecoder/D1/permutated_Qmn
add wave sim:/testdecoder/D1/OUT1/output_buffer
add wave sim:/testdecoder/D1/final_code
add wave sim:/testdecoder/final_code_out
add wave sim:/testdecoder/is_busy


run 1600000 ns
