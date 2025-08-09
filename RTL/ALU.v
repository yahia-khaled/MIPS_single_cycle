module ALU(
    input       wire                                    clk,
    input       wire                                    rst,
    input       wire                                    unsigned_ALU_op,
    input       wire                    [31:0]          OP_A,
    input       wire                    [31:0]          OP_B,
    input       wire                    [4:0]           ALUControl,
    input       wire                    [4:0]           shamt,
    output      reg         signed      [31:0]          ALUResult,
    output      wire                                    Zero,
    output      wire                                    ltz,
    output      wire                                    lez,
    output      wire                                    gtz
);


// handle unsigned cases
wire                [31:0]       OP_A_unsigned;
wire                [31:0]       OP_B_unsigned;
wire    signed      [31:0]       OP_A_signed;
wire    signed      [31:0]       OP_B_signed;

assign OP_A_signed = (unsigned_ALU_op)? 0 : OP_A;
assign OP_B_signed = (unsigned_ALU_op)? 0 : OP_B;

assign OP_A_unsigned = (unsigned_ALU_op)? OP_A : 0;
assign OP_B_unsigned = (unsigned_ALU_op)? OP_B : 0;


reg                         [31:0]          hi;
reg                         [31:0]          lo;
reg         signed          [31:0]          remainder;
reg         signed          [31:0]          count;
reg         signed          [31:0]          W;
wire        signed          [63:0]          mult_result;


assign Zero = (ALUResult == 0)? 1 : 0;

assign ltz = (OP_A < 0 && ALUControl == 5'b10010)? 1 : 0;
assign lez = (OP_A <= 0 && ALUControl == 5'b10011)? 1 : 0;
assign gtz = (OP_A > 0 && ALUControl == 5'b10100)? 1 : 0;

assign mult_result = (ALUControl == 5'b10000)? ((unsigned_ALU_op)? (OP_A_unsigned * OP_A_unsigned) : (OP_A_signed * OP_B_signed)) : 0;


always @(*) begin
    case (ALUControl)
        5'b00000: begin : shift_logical_left
            ALUResult = OP_B << shamt;
        end
        5'b00001: begin : shift_logical_right
            ALUResult = OP_B >> shamt;
        end
        5'b00010: begin : shift_right_arithmetic
            ALUResult = OP_B_signed >>> shamt;
        end
        5'b00011: begin : shift_left_logical_variable
            ALUResult = OP_B << OP_A[4:0];
        end
        5'b00100: begin : shift_right_logical_variable
            ALUResult = OP_B >> OP_A[4:0];
        end 
        5'b00101: begin : shift_right_arithmetic_variable
            ALUResult = OP_B_signed >>> OP_A[4:0];
        end
        5'b00110: begin : Addition
            if (unsigned_ALU_op) begin
                ALUResult = OP_A_unsigned + OP_B_unsigned;
            end
            else begin
                ALUResult = OP_A_signed + OP_B_signed;
            end
        end
        5'b00111: begin : subtraction
            if (unsigned_ALU_op) begin
                ALUResult = OP_A_unsigned - OP_B_unsigned;
            end
            else begin
                ALUResult = OP_A_signed - OP_B_signed;
            end
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
            if (unsigned_ALU_op) begin
                ALUResult = OP_A_unsigned < OP_B_unsigned;
            end
            else begin
                case ({OP_A_signed[31], OP_B_signed[31]})
                    2'b10: begin
                        ALUResult = 1;
                    end
                    2'b01: begin
                        ALUResult = 0;
                    end
                    2'b00: begin
                        ALUResult = OP_A_signed < OP_B_signed; 
                    end
                    2'b11: begin
                        ALUResult = (~OP_A_signed + 1) < (~OP_B_signed + 1); 
                    end 
                endcase
            end
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