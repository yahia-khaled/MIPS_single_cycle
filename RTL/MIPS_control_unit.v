module MIPS_control_unit (
    input           wire        [5:0]                     opcode,
    input           wire        [5:0]                     funct,
    output          wire                                  MemToReg,
    output          wire                                  MemWrite,
    output          wire                                  PC_to_ra_reg,
    output          wire        [2:0]                     Branch,
    output          wire                                  Jump,
    output          wire        [4:0]                     ALUControl,
    output          wire                                  ALUSrc,
    output          wire                                  jump_to_reg,
    output          wire                                  unsigned_op,
    output          wire                                  zero_extended,
    output          wire                                  immediate_to_upper_reg,
    output          wire        [1:0]                     RegDst,
    output          wire        [1:0]                     MEM_size,
    output          wire                                  RegWrite
);


// output declaration of module Main_decoder
wire [3:0] ALUOp;
wire        unsigned_flag_main_dec;
wire        unsigned_flag_ALU_dec;
wire        PC_to_ra_main_decoder;
wire        PC_to_ra_ALU;
wire [1:0]  RegDst_ALU;
wire [1:0]  RegDst_Main;

assign RegDst = (opcode != 0)? RegDst_Main : RegDst_ALU;

assign PC_to_ra_reg = PC_to_ra_ALU | PC_to_ra_main_decoder;


assign unsigned_op = unsigned_flag_main_dec | unsigned_flag_ALU_dec;

Main_decoder u_Main_decoder(
    .opcode   	(opcode    ),
    .RegWrite 	(RegWrite  ),
    .RegDst   	(RegDst_Main    ),
    .ALUSrc   	(ALUSrc    ),
    .Branch   	(Branch    ),
    .MemWrite 	(MemWrite  ),
    .MemToReg 	(MemToReg  ),
    .Jump 	(Jump  ),
    .unsigned_ALU_op 	(unsigned_flag_main_dec  ),
    .MEM_size 	(MEM_size  ),
    .zero_extended 	(zero_extended  ),
    .PC_to_ra_reg 	(PC_to_ra_main_decoder  ),
    .immediate_to_upper_reg 	(immediate_to_upper_reg  ),
    .ALUOp    	(ALUOp     )
);


// output declaration of module ALU_decoder

ALU_decoder u_ALU_decoder(
    .funct      	(funct       ),
    .ALUOp      	(ALUOp       ),
    .jump_to_reg      	(jump_to_reg       ),
    .pc_to_reg_ALU      	(PC_to_ra_ALU       ),
    .RegDst      	(RegDst_ALU       ),
    .unsigned_op      	(unsigned_flag_ALU_dec       ),
    .ALUControl 	(ALUControl  )
);

    
endmodule