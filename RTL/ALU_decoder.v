module ALU_decoder(
    input       wire                [5:0]               funct,
    input       wire                [3:0]               ALUOp,
    output      reg                                     jump_to_reg,
    output      reg                                     pc_to_reg_ALU,
    output      reg                                     unsigned_op,
    output      reg                 [1:0]               RegDst,
    output      reg                 [4:0]               ALUControl
);



always @(*) begin
    jump_to_reg = 0;
    unsigned_op = 0;
    pc_to_reg_ALU = 0;
    RegDst = 2'b01;

    casex ({ALUOp,funct})
        //---------------------------------- I-type ALU operation--------------------------//
        10'b0000_xxxxxx: begin : Less_than_zero
            ALUControl = 5'b10010;
        end
        10'b0001_xxxxxx: begin : SUB_operation
            ALUControl = 5'b00111;
        end
        10'b0010_xxxxxx: begin : Less_than_equal_zero
            ALUControl = 5'b10011;
        end
        10'b0011_xxxxxx: begin : Greater_than_zero
            ALUControl = 5'b10100;
        end
        10'b0100_xxxxxx: begin : Add_for_immediate
            ALUControl = 5'b00110;
        end
        10'b0101_xxxxxx: begin : Set_less_than
            ALUControl = 5'b01100;
        end
        10'b0110_xxxxxx: begin : And_immediate
            ALUControl = 5'b01000;
        end
        10'b0111_xxxxxx: begin : OR_immediate
            ALUControl = 5'b01001;
        end
        10'b1000_xxxxxx: begin : XOR_immediate
            ALUControl = 5'b01010;
        end


        //---------------------------------- R-type ALU operation--------------------------//
        10'b1111_000000: begin : shift_logical_left
            ALUControl = 5'b00000;
        end
        10'b1111_000010: begin : shift_logical_right
            ALUControl = 5'b00001;
        end
        10'b1111_000011: begin : shift_right_arithmetic
            ALUControl = 5'b00010;
        end
        10'b1111_000100: begin : shift_left_logical_variable
            ALUControl = 5'b00011;
        end
        10'b1111_000110: begin : shift_right_logical_variable
            ALUControl = 5'b00100;
        end
        10'b1111_000111: begin : shift_right_arithmetic_variable
            ALUControl = 5'b00101;
        end
        10'b1111_001001: begin : jalr
            ALUControl = 5'b00000;
            jump_to_reg = 1;
            pc_to_reg_ALU = 1;
            RegDst = 2'b10;
        end
        10'b1111_010000: begin : move_from_hi
            ALUControl = 5'b01101;
        end
        10'b1111_010001: begin : move_to_hi
            ALUControl = 5'b01111;
        end
        10'b1111_010010: begin : move_from_lo
            ALUControl = 5'b01110;
        end
        10'b1111_010011: begin : move_to_lo
            ALUControl = 5'b10000;
        end
        10'b1111_011000: begin : mult
            ALUControl = 5'b10001;
        end
        10'b1111_011001: begin : mult_unsigned
            ALUControl = 5'b10001;
            unsigned_op = 1;
        end
        10'b1111_100000: begin : Addition
            ALUControl = 5'b00110;
        end
        10'b1111_100001: begin : Addition_unsigned
            ALUControl = 5'b00110;
            unsigned_op = 1;
        end
        10'b1111_001000: begin : jr
            ALUControl = 5'b10101;
            jump_to_reg = 1;
        end
        10'b1111_100010: begin : subtraction
            ALUControl = 5'b00111;
        end
        10'b1111_100011: begin : subtraction_unsigned
            ALUControl = 5'b00111;
            unsigned_op = 1;
        end
        10'b1111_100100: begin : AND_operation
            ALUControl = 5'b01000;
        end
        10'b1111_100101: begin : OR_operations
            ALUControl = 5'b01001;
        end
        10'b1111_100110: begin : XOR_operation
            ALUControl = 5'b01010;
        end
        10'b1111_100111: begin : NOR_operation
            ALUControl = 5'b01011;
        end
        10'b1111_101010: begin : Set_Less_than
            ALUControl = 5'b01100;
        end
        10'b1111_101011: begin : Set_Less_than_unsigned
            ALUControl = 5'b01100;
            unsigned_op = 1;
        end
        default:
        begin
            ALUControl = 5'b00110;
        end 
    endcase
end
    
endmodule