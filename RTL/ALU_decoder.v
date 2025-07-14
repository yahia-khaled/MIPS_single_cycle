module ALU_decoder(
    input       wire                [5:0]               funct,
    input       wire                [1:0]               ALUOp,
    output      reg                 [2:0]               ALUControl
);



always @(*) begin
    casex ({ALUOp,funct})
        8'b00_xxxxxx: begin
            ALUControl = 3'b010;
        end 
        8'bx1_xxxxxx: begin
            ALUControl = 3'b011;
        end
        8'b1x_100000: begin
            ALUControl = 3'b010;
        end
        8'b1x_100010: begin
            ALUControl = 3'b011;
        end
        8'b1x_100100: begin
            ALUControl = 3'b000;
        end
        8'b1x_100101: begin
            ALUControl = 3'b001;
        end
        8'b1x_101010: begin
            ALUControl = 3'b110;
        end            
        default:
        begin
            ALUControl = 3'b000;
        end 
    endcase
end
    
endmodule