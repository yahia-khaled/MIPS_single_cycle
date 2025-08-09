module Branch_decision(
    input           wire                           Zero,
    input           wire                           ltz,
    input           wire                           lez,
    input           wire                           gtz,
    input           wire        [2:0]              Branch_type,
    output          reg                            Branch_deci
);



always @(*) begin
    case (Branch_type)
        3'b000: begin
            Branch_deci = 0;
        end
        3'b001: begin : beq
            Branch_deci = Zero;
        end
        3'b010: begin : bne
            Branch_deci = ~Zero;
        end
        3'b011: begin : bltz
            Branch_deci = ltz;
        end
        3'b100: begin : blez
            Branch_deci = lez;
        end
        3'b101: begin : bgtz
            Branch_deci = gtz;
        end
        default: begin
            Branch_deci = 0;
        end
    endcase
end


    
endmodule