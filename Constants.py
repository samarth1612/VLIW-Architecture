moduleDelay = {
    "add0": 4,
    "add1": 4,
    "mul": 13,
    "fadd0": 4,
    "fadd1": 4,
    "fmul": 26,
    "logic": 1,
    "ldr": 1,
    "str": 1,
    "mov": 1
}

testBench = """`include "processor.v"

module tb;

    parameter nInst = {nInst};

    reg clk;
    integer i, j;

    wire [319:0] instructions [nInst-1:0];
    wire [31:0] index [nInst-1:0];

{inst}

{delay}

    processor proc (clk);

    always #1 clk = ~clk;

    initial begin
        clk = 1'b1;
        proc.initPC();
        proc.rf.initialize();
        proc.mem.initialize();
        proc.initInst();
        for (j = 0; j < nInst; j = j + 1) begin
            proc.writeInst(instructions[j], index[j]);
        end
        #200 $finish; 
    end

    always @(clk) begin
        $display("{{\\n \\\"time\\\": ", $time, ",");
        for (i = 0; i < 32; i = i + 1)
            if (i == 31)
                $display("\\\"%d\\\": \\\"%d\\\"", i, proc.rf.registerFile[i]);
            else
                $display("\\\"%d\\\": \\\"%d\\\",", i, proc.rf.registerFile[i]);
        $display("}}");
    end
    
endmodule

"""
