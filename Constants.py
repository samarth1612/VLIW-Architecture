# A dictionary that holds the delays of the modules
moduleDelay = {
    "add0": 8,
    "add1": 8,
    "mul": 26,
    "fadd0": 8,
    "fadd1": 8,
    "fmul": 26,
    "logic": 2,
    "ldr": 4,
    "str": 4,
    "mov": 4
}

# A testbench template
testBench = """`include "processor.v"

module tb;

    parameter nInst = {nInst};

    reg clk;
    integer i, j;

    // Wires to hold the instructions and the delays
    wire [319:0] instructions [nInst-1:0];
    wire [31:0] index [nInst-1:0];

{inst}

{delay}

    processor proc (clk);

    always #1 clk = ~clk;

    initial begin
        clk = 1'b1;
        // Initialize the program counter, register files, memory blocks
        proc.initPC();
        proc.rf.initialize();
        proc.mem.initialize();
        proc.initInst();
        // Write the instructions to the processor
        for (j = 0; j < nInst; j = j + 1) begin
            proc.writeInst(instructions[j], index[j]);
        end
        #{finish} $finish; 
    end

    // Monitor the register files
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
