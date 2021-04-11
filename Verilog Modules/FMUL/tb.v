`include "float_mul_32bit.v"

module top;
    reg [31:0] num1, num2;
    wire [31:0] out;
    float_mul fm(num1, num2, clk , out);
    reg clk;

    always #1 clk = ~clk;

    initial 
    begin
        clk = 1'b0;
        // Infinity * Normal Num
        #30     num1 = 32'b01111111100000000000000000000000;   num2 = 32'b00000001111001010001000000000000;
        // Zero * Infinity
        #30    num1 = 32'b00000000000000000000000000000000;   num2 = 32'b01111111100000000000000000000000;
        // +ve Num * +ve Num
        #30    num1 = 32'b01000000000000000000000000000000;   num2 = 32'b01000100011110100000000000000000;
        // -ve Num * +ve Num
        #30    num1 = 32'b01000001001000000000000000000000;   num2 = 32'b11000010110001100000000000000000;
        // Normal Num * Denormal Num
        #30    num1 = 32'b01000010100000000000000000000000;   num2 = 32'b01000000000000000000000000000010;
        // NaN * Normal Num
        #30    num1 = 32'b01111111110000000000000000000010;   num2 = 32'b00011000000000010000000011100000;
    
        #100
        $finish;
    end

    initial
        $monitor ($time ," num1 = %b\tnum2 = %b\tout = %b\n", num1, num2, out);

endmodule
