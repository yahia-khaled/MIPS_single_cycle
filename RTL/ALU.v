module ALU(
    input       signed      wire        [31:0]          OP_A,
    input       signed      wire        [31:0]          OP_B,
    input                   wire        [2:0]           ALUControl,
    output      signed      reg         [31:0]          ALUResult,
    output                  reg                         Zero
);


assign Zero = (ALUResult == 0)? 1 : 0;


always @(*) begin
    case (ALUControl)
        3'b000: begin : AND operation
            ALUResult = OP_A & OP_B;
        end 
        3'b001: begin : OR operation
            ALUResult = OP_A | OP_B;
        end
        3'b010: begin : Addition
            ALUResult = OP_A + OP_B;
        end
        3'b011: begin : subtraction
            ALUResult = OP_A - OP_B;
        end
        3'b100: begin : AND NOT B
            ALUResult = OP_A & ~(OP_B);
        end
        3'b101: begin : OR NOT B
            ALUResult = OP_A | ~(OP_B);
        end
        3'b110: begin : Set Less than
            ALUResult = (OP_A < OP_B);
        end
        3'b111: begin : XOR
            ALUResult = OP_A ^ OP_B;
        end
    endcase

end
    
endmodule