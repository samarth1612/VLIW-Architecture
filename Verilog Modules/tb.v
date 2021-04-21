`include "include.v"

module top;

    reg [31:0] a, b;
    wire [31:0] c;
    integer i;
    reg clk;
    reg [2:0][31:0] x;
    
    FPMul adder (clk,a,b,c);

    initial 
    begin
        #0 clk = 0;
        for(i=0;i<=500;i++)
        begin
            #1 clk = ~clk;
        end
    end
    
    initial
    begin
        // +ve Num + +ve Num
        #0 a = 32'b01000100011110100000000000000000;   b = 32'b01000100011110011100000000000000;
        // out = 01000100111110011110000000000000
        // -ve Num + +ve Num
        #2 a = 32'b11000100110000001000000000000000;   b = 32'b01000100110000001000000000000000;
        // out = 10000000000000000000000000000000
        // Normal Num + Denormal Num
        #2 a = 32'b01000010100000000000000000000000;   b = 32'b01000000000000000000000000000010;
        // out = 01000010100001000000000000000000
        #100
        $finish;

    end
    initial
    begin
        $monitor($time, " A=%b\tB=%b\tC=%b\n",a,b,c);
    end

endmodule
