module MIPS_single_cycle #(parameter INST_MEM_DEPTH = 1100,DATA_MEM_DEPTH = 1024, width = 8)(
    input           wire                                   clk,
    input           wire                                   rst
);


wire    [31:0]        PC_jump;
wire    [31:0]        PC_Plus4;
wire    [31:0]        PCBranch;
wire    [27:0]        inst_shift;
// output declaration of module PC_reg
wire [31:0] PC_out;
wire [31:0] PC_next;
// output declaration of module MIPS_control_unit
wire MemToReg;
wire MemWrite;
wire [2:0] Branch;
wire [4:0] ALUControl;
wire ALUSrc;
wire [1:0] RegDst;
wire [1:0] MEM_size;
wire RegWrite;
wire PC_to_ra_reg;
wire jump_to_reg;
wire unsigned_op_top;
wire immediate_to_upper_reg;
wire [31:0] upper_immediate;
wire [31:0] mux_imm_to_reg;
wire zero_extended;
wire Jump;

// output declaration of module INST_MEM
wire [4*width-1:0] instr;
// output declaration of module Reg_file
wire [31:0] RDA;
wire [31:0] RDB;
// output declaration of module sign_extend
wire [31:0] out_extended;
// output declaration of module mux for wireDst
wire [4:0] WriteReg;
// output declaration of module mux for ALUSrc
wire [31:0] ALU_op_B;
// output declaration of module ALU
wire        [31:0]      ALUResult;
wire                    Zero;
wire                    ltz;
wire                    lez;
wire                    gtz;

// output declaration of module DATA_MEM
wire [4*width-1:0] ReadData;
// output declaration of module mux for PC_Src
wire [31:0]         mux_PC_Src_out;
// output declaration of module mux for DATA MEM out
wire [31:0]         Result;
// output declaration of Write data in REG file mux
wire [31:0] WriteRegData;

// PC soruce
wire             PCSrc;
// Reg to PC mux output
wire      [31:0]        mux_reg_to_PC;


//-------------------------------------------PC counter-------------------------------------------------//

PC_reg u_PC_reg(
    .clk     	(clk      ),
    .rst     	(rst      ),
    .PC_next 	(PC_next  ),
    .PC_out  	(PC_out   )
);


//-------------------------------------------PC next mux-------------------------------------------------//

mux #(
    .WIDTH 	(32))
u_mux_PC_next(
    .in0 	(mux_PC_Src_out ),
    .in1 	(PC_jump  ),
    .sel 	(Jump),
    .out 	(PC_next  )
);


//-------------------------------------------PC Branch mux -------------------------------------------------//

mux #(
    .WIDTH 	(32))
u_mux_PC_Branch(
    .in0 	(mux_reg_to_PC  ),
    .in1 	(PCBranch  ),
    .sel 	(PCSrc),
    .out 	(mux_PC_Src_out  )
);

//-------------------------------------------  Reg to PC mux -------------------------------------------------//

mux #(
    .WIDTH 	(32))
u_mux_Reg_to_PC(
    .in0 	(PC_Plus4  ),
    .in1 	(RDA  ),
    .sel 	(jump_to_reg),
    .out 	(mux_reg_to_PC  )
);
//------------------------------------------- Branch decision -------------------------------------------------//

Branch_decision u_Branch_decision(
    .Zero        	(Zero         ),
    .ltz         	(ltz          ),
    .lez         	(lez          ),
    .gtz         	(gtz          ),
    .rt         	(instr[16]          ),
    .Branch_type 	(Branch  ),
    .Branch_deci 	(PCSrc  )
);


//-------------------------------------------INST MEMORY-------------------------------------------------//

INST_MEM #(
    .depth 	(INST_MEM_DEPTH  ),
    .width 	(width     ))
u_INST_MEM(
    .Read_address 	(PC_out  ),
    .RD           	(instr            )
);

//-------------------------------------------REG FILE -------------------------------------------------//

Reg_file u_Reg_file(
    .Read_addr_A 	(instr[25:21]  ),
    .Read_addr_B 	(instr[20:16]  ),
    .write_addr  	(WriteReg ),
    .WE          	(RegWrite ),
    .clk          	(clk ),
    .rst          	(rst ),
    .WD          	(WriteRegData          ),
    .RDA         	(RDA          ),
    .RDB         	(RDB          )
);


//------------------------------------------- Write data immediate to reg REG file Mux -------------------------------------------------//


mux #(
    .WIDTH 	(32  ))
REG_file_imm_to_reg_mux(
    .in0 	(Result  ),
    .in1 	( upper_immediate),
    .sel 	(immediate_to_upper_reg  ),
    .out 	(mux_imm_to_reg)
);

//------------------------------------------- Write data PC to reg Mux -------------------------------------------------//


mux #(
    .WIDTH 	(32  ))
REG_file_PC_to_reg_mux(
    .in0 	(mux_imm_to_reg  ),
    .in1 	(PC_Plus4  ),
    .sel 	(PC_to_ra_reg  ),
    .out 	(WriteRegData)
);


//-------------------------------------------MIPS control unit-------------------------------------------------//


MIPS_control_unit u_MIPS_control_unit(
    .opcode     	(instr[31:26]      ),
    .funct      	(instr[5:0]       ),
    .MemToReg   	(MemToReg    ),
    .MemWrite   	(MemWrite    ),
    .Branch     	(Branch      ),
    .Jump       	(Jump      ),
    .zero_extended       	(zero_extended      ),
    .ALUControl 	(ALUControl  ),
    .RegDst     	(RegDst      ),
    .ALUSrc     	(ALUSrc      ),
    .unsigned_op     	(unsigned_op_top      ),
    .jump_to_reg     	(jump_to_reg      ),
    .PC_to_ra_reg     	(PC_to_ra_reg      ),
    .immediate_to_upper_reg     	(immediate_to_upper_reg      ),
    .MEM_size     	(MEM_size      ),
    .RegWrite   	(RegWrite    )
);



//-------------------------------------------sign extension-------------------------------------------------//

sign_extend u_sign_extend(
    .in           	(instr[15:0]            ),
    .zero_extended           	(zero_extended            ),
    .out_extended 	(out_extended  )
);


//-------------------------------------------mux for REGDst-------------------------------------------------//


mux4_to_1 #(
    .WIDTH 	(5  ))
u_mux4_to_1_REGDst(
    .in0 	(instr[20:16]  ),
    .in1 	(instr[15:11]  ),
    .in2 	(5'b11111  ),
    .in3 	(5'b00000  ),
    .sel 	(RegDst  ),
    .out 	(WriteReg  )
);



//-------------------------------------------mux FOR ALUSrc-------------------------------------------------//
mux #(
    .WIDTH 	(32  ))
u_mux_ALU_Src(
    .in0 	(RDB  ),
    .in1 	(out_extended  ),
    .sel 	(ALUSrc  ),
    .out 	(ALU_op_B  )
);



//-------------------------------------------ALU-------------------------------------------------//
ALU ALU_inst(
    .clk 	(clk  ),
    .rst 	(rst  ),
    .unsigned_ALU_op     	(unsigned_op_top      ),
    .OP_A 	(RDA  ),
    .OP_B 	(ALU_op_B  ),
    .ALUControl 	(ALUControl  ),
    .shamt 	(instr[6 +: 5]  ),
    .ALUResult 	(ALUResult  ),
    .Zero 	(  Zero),
    .ltz 	(  ltz),
    .lez 	(  lez),
    .gtz 	(  gtz)
);


//-------------------------------------------DATA MEMORY-------------------------------------------------//
DATA_MEM #(
    .depth 	(DATA_MEM_DEPTH  ),
    .width 	(width     ))
u_DATA_MEM(
    .address  	(ALUResult   ),
    .WD            	(RDB             ),
    .MEM_size(MEM_size),
    .unsigned_op(unsigned_op_top),
    .clk(clk),
    .rst(rst),
    .WE            	(MemWrite             ),
    .RD            	(ReadData             )
);

//-------------------------------------------mux FOR DATA MEMORY out-------------------------------------------------//
mux #(
    .WIDTH 	(4*width  ))
u_mux_DATA_MEM_Result(
    .in0 	(ALUResult  ),
    .in1 	(ReadData  ),
    .sel 	(MemToReg  ),
    .out 	(Result  )
);



// assign for PC jump signal
assign PC_Plus4 = PC_out + 4;

assign PCBranch = (out_extended<<2) + PC_Plus4;

assign inst_shift = (instr[25:0]<<2);

assign PC_jump = {PC_Plus4[31:28], inst_shift};

assign upper_immediate = {instr[15:0], 16'b0};


endmodule