`include "processor.v"

module tb;

    reg clk;
    wire [255:0] ans;

    processor proc (clk, ans);

    always #1 clk = ~clk;
    
endmodule
