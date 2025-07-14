module MIPS_single_cycle_tb();
    

// localparamter
parameter   INST_MEM_DEPTH = 256;
parameter   DATA_MEM_DEPTH = 1024;
parameter   width          = 8;
parameter   CLK_PERIOD     = 10;


// instatitaion of module
MIPS_single_cycle #(.INST_MEM_DEPTH(INST_MEM_DEPTH),.DATA_MEM_DEPTH(DATA_MEM_DEPTH),.width(width)) DUT (.*);
logic clk;
logic rst;


initial begin
    clk = 0;
    forever begin
        #(CLK_PERIOD/2.0) clk = ~ clk;
    end
end

task reset;
    rst = 0;
    @(negedge clk);
    rst = 1;
endtask

initial begin
    reset();
    repeat(26) begin
        @(negedge clk);
    end
    $display("ALU RESULT is : %0h\n",DUT.ALUResult);
    $stop();
end


endmodule