module mux4_to_1 #(parameter WIDTH = 32) (
    input           wire            [WIDTH-1:0]         in0,
    input           wire            [WIDTH-1:0]         in1,
    input           wire            [WIDTH-1:0]         in2,
    input           wire            [WIDTH-1:0]         in3,
    input           wire            [1:0]               sel,
    output          reg             [WIDTH-1:0]         out
);


always @(*) begin
    case (sel)
        2'b00: begin
            out = in0;
        end
        2'b01: begin
            out = in1;
        end
        2'b10: begin
            out = in2;
        end
        2'b11: begin
            out = in3;
        end
    endcase
end
    
endmodule