vlib work
vlog -f sourcefile.list
vsim -voptargs=+acc work.MIPS_single_cycle_tb
add wave *
add wave -position insertpoint sim:/MIPS_single_cycle_tb/DUT/*
add wave -position insertpoint  \
sim:/MIPS_single_cycle_tb/DUT/u_Reg_file/REG_FILE
run -all 
#quit