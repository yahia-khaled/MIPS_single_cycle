module sign_extend(
    input       wire        [15:0]          in,
    input       wire                        zero_extended,
    output      wire        [31:0]          out_extended
);


assign out_extended = (zero_extended)? {{16{1'b0}}, in} : {{16{in[15]}}, in};


endmodule