`include "rec_dub.v"

module top;

    reg [31:0] a, b;
    wire [32:0] sum;
    wire cout;
    reg clk;

    rec_dub rd(a, b, clk, sum[31:0], sum[32]);

    always #1 clk = ~clk;

    initial
    begin
        clk = 1'b1;
        a = 32'd4139379753; b = 32'd4043304975;
        #15
        
        a = 32'd885995213; b = 32'd2626620523;
        #15

        a = 32'd1200;
        b = 32'd1000;
        #15

        #5
        $finish;
    end

    initial
        $monitor ($time ," num1 = %d\tnum2 = %d\tout = %d\n", a, b, sum);
endmodule
