module MEMORY #(parameter depth = 1024, width = 8) (
    input       wire            [$clog2(depth)-1:0]             Read_address,
    input       wire            [4*width-1:0]                   WD,
    input       wire            [$clog2(depth)-1:0]             write_address,
    input       wire                                            WE,
    output      wire            [4*width-1:0]                   RD
);



reg     [width-1:0]       MEM     [0:depth];

integer i;

always @(*) begin
    if (WE) begin
        for (i=0; i<4; i = i + 1) begin
            MEM[write_address+i] = WD[i*width +: widthd];
        end
    end
end


assign RD = {MEM[Read_address+3], MEM[Read_address+2], MEM[Read_address+1], MEM[Read_address]};
    
endmodule