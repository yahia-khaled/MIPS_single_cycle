module ALU_decoder(
    input       wire                [5:0]               funct,
    input       wire                [1:0]               ALUOp,
    output      reg                 [4:0]               ALUControl
);



always @(*) begin
    casex ({ALUOp,funct})
        8'b00_xxxxxx: begin : ADD_operation
            ALUControl = 5'b00110;
        end 
        8'bx1_xxxxxx: begin : SUB_operation
            ALUControl = 5'b00111;
        end
        8'b1x_000000: begin : shift_logical_left
            ALUControl = 5'b00000;
        end
        8'b1x_000010: begin : shift_logical_right
            ALUControl = 5'b00001;
        end
        8'b1x_000011: begin : shift_right_arithmetic
            ALUControl = 5'b00010;
        end
        8'b1x_000100: begin : shift_left_logical_variable
            ALUControl = 5'b00011;
        end
        8'b1x_000110: begin : shift_right_logical_variable
            ALUControl = 5'b00100;
        end
        8'b1x_000111: begin : shift_right_arithmetic_variable
            ALUControl = 5'b00101;
        end
        8'b1x_100000: begin : Addition
            ALUControl = 5'b00110;
        end
        8'b1x_100010: begin : subtraction
            ALUControl = 5'b00111;
        end
        8'b1x_100100: begin : AND_operation
            ALUControl = 5'b01000;
        end
        8'b1x_100101: begin : OR_operations
            ALUControl = 5'b01001;
        end
        8'b1x_100110: begin : XOR_operation
            ALUControl = 5'b01010;
        end
        8'b1x_100111: begin : NOR_operation
            ALUControl = 5'b01011;
        end
        8'b1x_101010: begin : Set_Less_than
            ALUControl = 5'b01100;
        end          
        default:
        begin
            ALUControl = 5'b00110;
        end 
    endcase
end
    
endmodule