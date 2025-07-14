module Main_decoder(
    input           wire                [5:0]               opcode,
    output          reg                                     RegWrite,
    output          reg                                     RegDst,
    output          reg                                     ALUSrc,
    output          reg                                     Branch,
    output          reg                                     MemWrite,
    output          reg                                     MemToReg,
    output          reg                                     Jump,
    output          reg                 [1:0]               ALUOp
);



always @(*) begin
    case (opcode)
        6'b000000: begin
            RegWrite = 1;
            RegDst = 1;
            ALUSrc = 0;
            Branch = 0;
            MemWrite = 0;
            MemToReg = 0;
            ALUOp = 2'b10;
            Jump = 0;
        end 
        6'b100011: begin
            RegWrite = 1;
            RegDst = 0;
            ALUSrc = 1;
            Branch = 0;
            MemWrite = 0;
            MemToReg = 1;
            ALUOp = 2'b00;
            Jump = 0;
        end
        6'b101011: begin
            RegWrite = 0;
            RegDst = 0;
            ALUSrc = 1;
            Branch = 0;
            MemWrite = 1;
            MemToReg = 0;
            ALUOp = 2'b00;
            Jump = 0;
        end
        6'b000100: begin
            RegWrite = 0;
            RegDst = 0;
            ALUSrc = 0;
            Branch = 1;
            MemWrite = 0;
            MemToReg = 0;
            ALUOp = 2'b01;
            Jump = 0;
        end
        6'b001000: begin
            RegWrite = 1;
            RegDst = 0;
            ALUSrc = 1;
            Branch = 0;
            MemWrite = 0;
            MemToReg = 0;
            ALUOp = 2'b00;
            Jump = 0;
        end
        6'b000010: begin
            RegWrite = 0;
            RegDst = 0;
            ALUSrc = 0;
            Branch = 0;
            MemWrite = 0;
            MemToReg = 0;
            ALUOp = 2'b00;
            Jump = 1;
        end
        default: begin
            RegWrite = 0;
            RegDst = 0;
            ALUSrc = 0;
            Branch = 0;
            MemWrite = 0;
            MemToReg = 0;
            ALUOp = 2'b00;
            Jump = 0;
        end 
    endcase
end


    
endmodule