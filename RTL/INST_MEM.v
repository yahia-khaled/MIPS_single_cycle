module INST_MEM #(parameter depth = 1024, width = 8) (
    input       wire            [4*width-1:0]             Read_address,
    output      wire            [4*width-1:0]              RD
);


(* rom_style = "block" *)  // Force Vivado to infer Block RAM (BRAM)
reg     [width-1:0]       MEM     [0:depth-1];

integer i;

initial begin
    $readmemh("../sim_files/Test1.mem",MEM);
end

assign RD = {MEM[Read_address+3], MEM[Read_address+2], MEM[Read_address+1], MEM[Read_address]};
    
endmodule