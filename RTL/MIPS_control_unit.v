module MIPS_control_unit #(parameter Data_MEM_DEPTH = 1024)(
    input           wire        [5:0]                               opcode,
    input           wire        [5:0]                               funct,
    input           wire                                            Zero_flag,
    output          reg                                             Jump,
    output          reg                                             MemToReg,
    output          reg         [2:0]                               ALUControl,
    output          reg                                             RegWrite,
    output          reg                                             ALUSrc,
    output          reg                                             RegDst
);



    
endmodule