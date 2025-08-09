module Reg_file (
    input       wire        [4:0]       Read_addr_A,
    input       wire        [4:0]       Read_addr_B,
    input       wire        [4:0]       write_addr,
    input       wire                    clk,
    input       wire                    rst,
    input       wire                    WE,
    input       wire        [31:0]      WD,
    output      wire        [31:0]      RDA,
    output      wire        [31:0]      RDB
);


integer i;
reg [31:0]  REG_FILE [0:31];


assign RDA = REG_FILE[Read_addr_A];
assign RDB = REG_FILE[Read_addr_B];

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            REG_FILE[i] <= 0;
        end
    end
    else if (WE) begin
        REG_FILE[write_addr] <= WD;
    end
end

    
endmodule