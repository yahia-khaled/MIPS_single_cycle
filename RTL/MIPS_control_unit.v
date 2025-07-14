module MIPS_control_unit #(parameter Data_MEM_DEPTH = 1024)(
    input           wire        [5:0]                     opcode,
    input           wire        [5:0]                     funct,
    output          wire                                  MemToReg,
    output          wire                                  MemWrite,
    output          wire                                  Branch,
    output          wire                                  Jump,
    output          wire        [2:0]                     ALUControl,
    output          wire                                  ALUSrc,
    output          wire                                  RegDst,
    output          wire                                  RegWrite
);


// output declaration of module Main_decoder
wire [1:0] ALUOp;

Main_decoder u_Main_decoder(
    .opcode   	(opcode    ),
    .RegWrite 	(RegWrite  ),
    .RegDst   	(RegDst    ),
    .ALUSrc   	(ALUSrc    ),
    .Branch   	(Branch    ),
    .MemWrite 	(MemWrite  ),
    .MemToReg 	(MemToReg  ),
    .Jump 	(Jump  ),
    .ALUOp    	(ALUOp     )
);


// output declaration of module ALU_decoder

ALU_decoder u_ALU_decoder(
    .funct      	(funct       ),
    .ALUOp      	(ALUOp       ),
    .ALUControl 	(ALUControl  )
);

    
endmodule