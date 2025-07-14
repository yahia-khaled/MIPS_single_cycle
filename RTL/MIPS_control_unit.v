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


// output declaration of module Main_decoder
reg RegWrite;
reg RegDst;
reg ALUSrc;
reg Branch;
reg MemWrite;
reg MemToReg;
wire [1:0] ALUOp;

Main_decoder u_Main_decoder(
    .opcode   	(opcode    ),
    .RegWrite 	(RegWrite  ),
    .RegDst   	(RegDst    ),
    .ALUSrc   	(ALUSrc    ),
    .Branch   	(Branch    ),
    .MemWrite 	(MemWrite  ),
    .MemToReg 	(MemToReg  ),
    .ALUOp    	(ALUOp     )
);


// output declaration of module ALU_decoder

ALU_decoder u_ALU_decoder(
    .funct      	(funct       ),
    .ALUOp      	(ALUOp       ),
    .ALUControl 	(ALUControl  )
);

    
endmodule