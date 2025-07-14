module MIPS_single_cycle_tb();
    
import MIPS_package :: *;

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
    forever begin
        @(negedge clk)
        if (DUT.ALUResult == 32'hffffD08E) begin
            $display("ALU RESULT is : %0h\n",DUT.ALUResult);
            break;
        end
        else if (DUT.ALUResult == 32'hffffDEAD) begin
            $display("MIPS desgin failed\n");
            break;
        end
    end
    $stop();
end


endmodule