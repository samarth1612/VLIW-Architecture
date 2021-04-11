`include "wtm.v"

module top;

    reg [31:0] in1, in2;
    wire [63:0] out;
    reg clk;

    wallace_tree_mul wtm(in1, in2, clk, out);

    always #1 clk = ~clk;

    initial
    begin
        clk = 1'b1;
        in1 = 32'd10000000;
        in2 = 32'd1021;
        #20

        in1 = 32'd3423;
        in2 = 32'd3413;
        #20
        
        in1 = 32'd65354733;
        in2 = 32'd67445575;
        #20

        #500
        $finish;
    end

    initial
        $monitor ($time ," num1 = %d\tnum2 = %d\tout = %d\n", in1, in2, out);

endmodule
