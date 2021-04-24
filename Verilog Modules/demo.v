`include "processor.v"

module tb;

    parameter nInst = 4;

    reg clk;
    integer i, j, k;

    wire [319:0] instructions [nInst-1:0];
    wire [31:0] index [nInst-1:0];

    assign instructions[0] = {32'b00000_00010_00001_00011_000000000000, 32'b0, 32'b00100_01000_10011_01111_01010_0000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10011_0000000000110111000100_10110, 32'b0};
    assign instructions[1] = {32'b00010_00100_00010_00110_000000000000, 32'b00000_10111_00010_11000_000000000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0};
    assign instructions[2] = {32'b00000_00010_00010_01000_000000000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10010_00100_0000000000111110100000, 32'b0, 32'b0};
    assign instructions[3] = {32'b00000_00101_00001_00100_000000000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10100_01000_0000000000001000001100};

  	assign index[0] = 0;
  	assign index[1] = 4;
  	assign index[2] = 13;
  	assign index[3] = 17;


    processor proc (clk);

    always #1 clk = ~clk;

    initial begin
        clk = 1'b1;
        proc.initPC();
        proc.rf.initialize();
        proc.mem.initialize();
        proc.initInst();
        for (k = 0; k < nInst; k = k + 1) begin
            proc.writeInst(instructions[k], index[k]);
        end
        #100 $finish;
    end

    always @(proc.rf.registerFile[31]) begin
        if (proc.rf.registerFile[31] < index[nInst-1]) begin
            for (i = 0; i < 32; i = i + 1)
                $display("%d: %b", i, proc.rf.registerFile[i]);
            $display("-----------------------------------------------------------------------");
        end
    end

endmodule
