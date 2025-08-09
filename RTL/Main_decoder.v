module Main_decoder(
    input           wire                [5:0]               opcode,
    output          reg                                     RegWrite,
    output          reg                 [1:0]               RegDst,
    output          reg                 [1:0]               MEM_size,
    output          reg                                     ALUSrc,
    output          reg                 [2:0]               Branch, 
    output          reg                                     MemWrite,
    output          reg                                     MemToReg,
    output          reg                                     zero_extended,
    output          reg                                     Jump,
    output          reg                                     unsigned_ALU_op,
    output          reg                                     immediate_to_upper_reg,
    output          reg                                     PC_to_ra_reg,
    output          reg                 [3:0]               ALUOp
);



always @(*) begin
    //default values
    RegDst = 2'b00;
    RegWrite = 0;
    Branch = 3'b000;
    PC_to_ra_reg = 0;
    Jump = 0;
    MemToReg = 0;
    MemWrite = 0;
    unsigned_ALU_op = 0;
    MEM_size = 0;
    immediate_to_upper_reg = 0;
    zero_extended = 0;
    case (opcode)
        6'b000000: begin : R_TYPE
            RegWrite = 1;
            ALUSrc = 0;
            ALUOp = 4'b1111;
            RegDst = 2'b10;
        end
        6'b000001: begin : bltz
            ALUSrc = 0;
            Branch = 3'b011;
            ALUOp = 4'b0000;
        end
        6'b000010: begin : jump
            ALUSrc = 0;
            ALUOp = 4'b0000;
            Jump = 1;
        end
        6'b000011: begin : jal
            RegDst = 2'b10;
            ALUSrc = 0;
            ALUOp = 4'b10;
            Jump = 1;
            RegWrite = 1;
            PC_to_ra_reg = 1;
        end
        6'b000100: begin  : beq
            ALUSrc = 0;
            Branch = 3'b001;
            ALUOp = 4'b0001;
        end
        6'b000101: begin  : bne
            ALUSrc = 0;
            Branch = 3'b010;
            ALUOp = 4'b0001;
        end
        6'b000110: begin  : blez
            ALUSrc = 0;
            Branch = 3'b100;
            ALUOp = 4'b0010;
        end
        6'b000111: begin  : bgtz
            ALUSrc = 0;
            Branch = 3'b101;
            ALUOp = 4'b0011;
        end
        6'b001000: begin : addi
            RegWrite = 1;
            ALUSrc = 1;
            ALUOp = 4'b0100;
        end
        6'b001001: begin : addiu
            RegWrite = 1;
            ALUSrc = 1;
            ALUOp = 4'b0100;
            unsigned_ALU_op = 1;
        end
        6'b001010: begin : slti
            RegWrite = 1;
            ALUSrc = 1;
            ALUOp = 4'b0101;
        end
        6'b001011: begin : sltiu
            RegWrite = 1;
            ALUSrc = 1;
            ALUOp = 4'b0101;
            unsigned_ALU_op = 1;
        end
        6'b001100: begin : andi
            RegWrite = 1;
            ALUSrc = 1;
            zero_extended = 1;
            ALUOp = 4'b0110;
        end
        6'b001101: begin : ori
            RegWrite = 1;
            ALUSrc = 1;
            zero_extended = 1;
            ALUOp = 4'b0111;
        end
        6'b001110: begin : xori
            RegWrite = 1;
            ALUSrc = 1;
            zero_extended = 1;
            ALUOp = 4'b1000;
        end
        6'b001111: begin : lui
            RegWrite = 1;
            ALUSrc = 1;
            ALUOp = 4'b1000;
            immediate_to_upper_reg = 1;
        end       
        6'b100000: begin : lb
            RegWrite = 1;
            ALUSrc = 1;
            MemToReg = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b00;
        end
        6'b100001: begin : lh
            RegWrite = 1;
            ALUSrc = 1;
            MemToReg = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b01;
        end
        6'b100011: begin : lw
            RegWrite = 1;
            ALUSrc = 1;
            MemToReg = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b10;
        end
        6'b100100: begin : lbu
            RegWrite = 1;
            ALUSrc = 1;
            MemToReg = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b00;
            unsigned_ALU_op = 1;
        end
        6'b100101: begin : lhu
            RegWrite = 1;
            ALUSrc = 1;
            MemToReg = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b01;
            unsigned_ALU_op = 1;
        end
        6'b101000: begin  : sb
            ALUSrc = 1;
            MemWrite = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b00;
        end
        6'b101001: begin  : sh
            ALUSrc = 1;
            MemWrite = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b01;
        end
        6'b101011: begin  : sw
            ALUSrc = 1;
            MemWrite = 1;
            ALUOp = 4'b0000;
            MEM_size = 2'b10;
        end
        default: begin
            ALUSrc = 0;
            ALUOp = 4'b0000;
        end 
    endcase
end


    
endmodule