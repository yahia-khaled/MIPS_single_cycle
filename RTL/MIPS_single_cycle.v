module MIPS_single_cycle #(parameter INST_MEM_DEPTH = 256,DATA_MEM_DEPTH = 1024, width = 8)(
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
wire Branch;
wire [2:0] ALUControl;
wire ALUSrc;
wire RegDst;
wire RegWrite;
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

// output declaration of module DATA_MEM
wire [4*width-1:0] ReadData;
// output declaration of module mux for PC_Src
wire [31:0]         mux_PC_Src_out;
// output declaration of module mux for DATA MEM out
wire [31:0]         Result;



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


//-------------------------------------------PC_Src mux -------------------------------------------------//

mux #(
    .WIDTH 	(32))
u_mux_PC_Src(
    .in0 	(PC_Plus4  ),
    .in1 	(PCBranch  ),
    .sel 	(Zero & Branch),
    .out 	(mux_PC_Src_out  )
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
    .WD          	(Result          ),
    .RDA         	(RDA          ),
    .RDB         	(RDB          )
);



//-------------------------------------------MIPS control unit-------------------------------------------------//


MIPS_control_unit #(
    .Data_MEM_DEPTH 	(DATA_MEM_DEPTH  ))
u_MIPS_control_unit(
    .opcode     	(instr[31:26]      ),
    .funct      	(instr[5:0]       ),
    .MemToReg   	(MemToReg    ),
    .MemWrite   	(MemWrite    ),
    .Branch     	(Branch      ),
    .Jump       	(Jump      ),
    .ALUControl 	(ALUControl  ),
    .ALUSrc     	(ALUSrc      ),
    .RegDst     	(RegDst      ),
    .RegWrite   	(RegWrite    )
);



//-------------------------------------------sign extension-------------------------------------------------//

sign_extend u_sign_extend(
    .in           	(instr[15:0]            ),
    .out_extended 	(out_extended  )
);


//-------------------------------------------mux for REGDst-------------------------------------------------//

mux #(
    .WIDTH 	(5  ))
u_mux_REGDst(
    .in0 	(instr[20:16]  ),
    .in1 	(instr[15:11]  ),
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
    .OP_A 	(RDA  ),
    .OP_B 	(ALU_op_B  ),
    .ALUControl 	(ALUControl  ),
    .ALUResult 	(ALUResult  ),
    .Zero 	(  Zero)
);


//-------------------------------------------DATA MEMORY-------------------------------------------------//
DATA_MEM #(
    .depth 	(DATA_MEM_DEPTH  ),
    .width 	(width     ))
u_DATA_MEM(
    .address  	(ALUResult   ),
    .WD            	(RDB             ),
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



endmodule