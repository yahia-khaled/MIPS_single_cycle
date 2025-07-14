vlib work
vlog -f sourcefile.list
vsim -voptargs=+acc work.MIPS_single_cycle_tb
add wave *
add wave -position insertpoint sim:/MIPS_single_cycle_tb/DUT/*
run -all 
#quit