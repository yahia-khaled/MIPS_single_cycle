module ALU(
    input       wire                                    clk,
    input       wire                                    rst,
    input       wire        signed      [31:0]          OP_A,
    input       wire        signed      [31:0]          OP_B,
    input       wire                    [4:0]           ALUControl,
    input       wire                    [4:0]           shamt,
    output      reg         signed      [31:0]          ALUResult,
    output                  wire                        Zero
);


reg         [31:0]          hi;
reg         [31:0]          lo;
wire        [63:0]          mult_result;


assign Zero = (ALUResult == 0)? 1 : 0;

assign mult_result = (ALUControl == 5'b10000)? OP_A * OP_B : 0;

always @(*) begin
    case (ALUControl)
        5'b00000: begin : shift_logical_left
            ALUResult = OP_B << shamt;
        end
        5'b00001: begin : shift_logical_right
            ALUResult = OP_B >> shamt;
        end
        5'b00010: begin : shift_right_arithmetic
            ALUResult = OP_B >>> shamt;
        end
        5'b00011: begin : shift_left_logical_variable
            ALUResult = OP_B << OP_A[4:0];
        end
        5'b00100: begin : shift_right_logical_variable
            ALUResult = OP_B >> OP_A[4:0];
        end 
        5'b00101: begin : shift_right_arithmetic_variable
            ALUResult = OP_B >>> OP_A[4:0];
        end
        5'b00110: begin : Addition
            ALUResult = OP_A + OP_B;
        end
        5'b00111: begin : subtraction
            ALUResult = OP_A - OP_B;
        end 
        5'b01000: begin : AND_operation
            ALUResult = OP_A & OP_B;
        end 
        5'b01001: begin : OR_operation
            ALUResult = OP_A | OP_B;
        end
        5'b01010: begin : XOR_operation
            ALUResult = OP_A ^ OP_B;
        end
        5'b01011: begin : NOR_operation
            ALUResult = ~(OP_A | OP_B);
        end
        5'b01100: begin : Set_Less_than
            ALUResult = (OP_A < OP_B);
        end
        5'b01101: begin : move_from_hi
            ALUResult = hi;
        end
        5'b01110: begin : move_from_lo
            ALUResult = lo;
        end
        default: begin 
            ALUResult = 0;
        end
    endcase

end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        hi <= 0;
    end
    else begin
        case (ALUControl)
            5'b01111: begin : move_to_hi
                hi <= OP_A;
            end
            5'b10001: begin : mult_for_hi
                hi <= mult_result[63:32];
            end
            default: begin
                hi <= hi;
            end 
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        lo <= 0;
    end
    else begin
        case (ALUControl)
            5'b10000: begin : move_to_lo
                lo <= OP_A;
            end
            5'b10001: begin : mult_for_lo
                lo <= mult_result[31:0];
            end
            default: begin
                lo <= lo;
            end 
        endcase
    end
end
    
endmodule