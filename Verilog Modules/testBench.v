`include "processor.v"

module tb;

    parameter nInst = 5;

    reg clk;
    integer i, j;

    wire [319:0] instructions [nInst-1:0];
    wire [31:0] index [nInst-1:0];

    processor proc (clk);

    always #1 clk = ~clk;

    initial begin
        clk = 1'b1;
        proc.initPC();
        proc.rf.initialize();
        proc.mem.initialize();
        proc.initInst();
        // proc.writeInst({32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10100_00010_1000000000000000000100}, 32'd1);
        // proc.writeInst({32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10100_00011_1000000000000000000101}, 32'd2);
        proc.writeInst({32'b00000_01000_00010_00011_000000000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0}, 32'd4);
        // for (j = 0; j < 5; j = j + 1) begin
        //     #4;
        //     for (i = 0; i < 32; i = i + 1)
        //         $display("%d: %b", i, proc.rf.registerFile[i]);
        //     $display("-----------------------------------------------------------------------");
        // end
        #100000 $finish;
    end

    initial begin
        $monitor($time, " %b, %b, %b", proc.rf.registerFile[8], proc.rf.registerFile[2], proc.rf.registerFile[3]);
    end
    
endmodule
