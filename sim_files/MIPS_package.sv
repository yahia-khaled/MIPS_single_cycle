package MIPS_package;


// paramters
parameter   INST_MEM_DEPTH = 256;
parameter   DATA_MEM_DEPTH = 1024;
parameter   width          = 8;
parameter   CLK_PERIOD     = 10;


typedef enum {R_TYPE, J_TYPE, I_TYPE} Inst_type;

typedef enum bit [5:0] {
    ADD = 6'b100000,
    SUB = 6'b100010,
    AND = 6'b100100,
    OR = 6'b100101,
    SLT = 6'b101010
} funct_t;

typedef enum bit [5:0] {
    ADDI = 6'b001000,
    ANDI = 6'b001100,
    SLTI = 6'b001010,
    ORI = 6'b001101
} OPCODE_I_TYPE;

typedef enum bit [5:0] {
    J = 6'b000010,
    JAL = 6'b000011
} OPCODE_J_TYPE;

typedef struct packed {
    bit       [5:0]       opcode;
    bit       [4:0]       rs;
    bit       [4:0]       rt;
    bit       [4:0]       rd;
    bit       [4:0]       shamt;
    funct_t               funct;
} R_TYPE_INST;

typedef struct packed {
    OPCODE_I_TYPE              opcode;
    bit             [4:0]       rs;
    bit             [4:0]       rt;
    bit             [15:0]      immediate;
} I_type_inst;

typedef struct packed {
    OPCODE_J_TYPE              opcode;
    bit             [25:0]     address;
} J_type_inst;

class Instruction_gen;
    rand    Inst_type            TYPE;
    rand    R_TYPE_INST          R_INST;
    rand    I_type_inst          I_INST;
    rand    J_type_inst          J_INST;
    bit     [31:0]               instruction;

    
    function void post_randomize ();
        case (TYPE)
            R_TYPE: instruction = R_INST;
            J_TYPE: instruction = I_INST;
            default: instruction = R_INST;
        endcase
    endfunction

    constraint J_TYPE_address {
        J_INST.address <= DATA_MEM_DEPTH-1;
    }

endclass

endpackage