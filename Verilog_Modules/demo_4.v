`include "processor.v"

module tb;

    parameter nInst = 3;

    reg clk;
    integer i, j;

    wire [319:0] instructions [nInst-1:0];
    wire [31:0] index [nInst-1:0];

	assign instructions[0] = {32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10010_00101_0000000000000111000011, 32'b0, 32'b0};
	assign instructions[1] = {32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b10010_00011_0000000000001000011111, 32'b0, 32'b0};
	assign instructions[2] = {32'b0, 32'b0, 32'b0, 32'b00101_00111_00101_00011_000000000000, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0};


	assign index[0] = 0;
	assign index[1] = 4;
	assign index[2] = 8;


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
        $display("{\n \"time\": ", $time, ",");
        for (i = 0; i < 32; i = i + 1)
            if (i == 31)
                $display("\"%d\": \"%d\"", i, proc.rf.registerFile[i]);
            else
                $display("\"%d\": \"%d\",", i, proc.rf.registerFile[i]);
        $display("}");
    end
    
endmodule

