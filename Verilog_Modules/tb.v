`include "include.v"

module top;

    reg [31:0] a, b;
    wire [31:0]sum;
    integer i;
    reg clk;
    
    FPMul adder (clk,a,b,sum);

    initial 
    begin
        #0 clk = 0;
        for(i=0;i<=200;i++)
        begin
            #1 clk = ~clk;
        end
    end
    
    initial
    begin
        // 10000 - 8000
        #0 a=32'd50;b=32'd60;

        // 800 - 800
        #2 a=32'b01000101111110100000000000000000;b=32'b11000101111110100000000000000000;

        //1.234 + 63.201 = (supposed) 64.435 but gets 64.4349975586 because of floating point precision error
        #2 a=32'b11010111111111011011100010101111;b=32'b11010111111111011011100010110000;

        // 9.75 + 0.5625 = 10.3125
        #2 a={1'b0,{8'b10000010},23'b00111000000000000000000}; b={1'b0,{8'b01111110},23'b00100000000000000000000};
    end
    initial
    begin
        $monitor($time, " A=%b \tB=%b\tC=%b\n",a,b,sum);
    end

endmodule
