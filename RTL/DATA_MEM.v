module DATA_MEM #(parameter depth = 1024, width = 8) (
    input       wire            [31:0]                          address,
    input       wire            [4*width-1:0]                   WD,
    input       wire                                            clk,
    input       wire                                            rst,
    input       wire                                            WE,
    output      wire            [4*width-1:0]                   RD
);



reg     [width-1:0]       MEM     [0:depth-1];

integer i;




always @(posedge clk) begin
    if (!rst) begin
        for (i=0; i < depth; i = i + 1) begin
            MEM[i] <= 0;
        end
    end
    else if(WE) begin
        for (i=0; i<4; i = i + 1) begin
            MEM[address+i] <= WD[i*width +: width];
        end
    end
end


assign RD = {MEM[address+3], MEM[address+2], MEM[address+1], MEM[address]};
    
endmodule