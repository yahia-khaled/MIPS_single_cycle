module DATA_MEM #(parameter depth = 1024, width = 8) (
    input       wire            [31:0]                          address,
    input       wire            [4*width-1:0]                   WD,
    input       wire                                            clk,
    input       wire            [1:0]                           MEM_size,
    input       wire                                            unsigned_op,
    input       wire                                            rst,
    input       wire                                            WE,
    output      reg             [4*width-1:0]                   RD
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
        case (MEM_size)
            2'b00: begin : store_byte
                MEM[address] <= WD[0 +: width];
            end
            2'b01: begin : store_half_word
                for (i=0; i<2; i = i + 1) begin
                    MEM[address+i] <= WD[i*width +: width];
                end
            end
            2'b10: begin : store_word
                for (i=0; i<4; i = i + 1) begin
                    MEM[address+i] <= WD[i*width +: width];
                end
            end 
            default: begin
                MEM[address] <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (MEM_size)
        2'b00: begin : load_byte
        if (unsigned_op) begin
            RD = {24'b0, MEM[address]};
        end
        else begin
            RD = {{24{MEM[address][7]}}, MEM[address]};
        end
        end
        2'b00: begin : load_half_word
        if (unsigned_op) begin
            RD = {16'b0, MEM[address+1], MEM[address]};
        end
        else begin
            RD = {{16{MEM[address+1][7]}}, MEM[address+1], MEM[address]};
        end
        end
        2'b00: begin : load_word
            RD = {MEM[address+3], MEM[address+2], MEM[address+1], MEM[address]};
        end 
        default:
        begin
            RD = 0;
        end 
    endcase
end

    
endmodule