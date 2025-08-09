module PC_reg (
    input       wire                     clk,
    input       wire                     rst,
    input       wire        [31:0]       PC_next,
    output      wire        [31:0]       PC_out
);


reg        [31:0]   PC;


assign PC_out = PC;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        PC <= 0;
    end
    else begin
        PC <= PC_next;
    end
end
    
endmodule