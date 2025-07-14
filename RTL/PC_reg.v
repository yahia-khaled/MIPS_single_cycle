module PC_reg #(parameter instr_MEM_width = 256) (
    input       wire                                            clk,
    input       wire                                            rst,
    input       wire        [$clog2(instr_MEM_width)-1:0]       PC_next,
    output      wire        [$clog2(instr_MEM_width)-1:0]       PC_out
);


reg        [$clog2(instr_MEM_width)-1:0]   PC;


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