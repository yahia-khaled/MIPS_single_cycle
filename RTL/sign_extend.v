module sign_extend(
    input       wire        [15:0]          in,
    output      wire        [31:0]          out_extended
);


assign out_extended = {{16{in[15]}}, in};


endmodule