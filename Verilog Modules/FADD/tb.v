`include "float_add_32bit.v"

module top;
    reg [31:0] num1, num2;
    wire [31:0] out;
    reg clk;

    always #1 clk = ~clk;

    float_add fa(num1, num2, clk, out);

    initial 
    begin
        clk = 1'b0;
        // -ve Num + +ve Num
        #20 num1 = 32'b11000100110000001000000000000000;   num2 = 32'b01000100110000001000000000000000;
        // Infinity + Normal Num
        #20 num1 = 32'b01111111100000000000000000000000;   num2 = 32'b00000001111001010001000000000000;
        // Zero + Infinity
        #20 num1 = 32'b00000000000000000000000000000000;   num2 = 32'b01111111100000000000000000000000;
        // +ve Num + +ve Num
        #20 num1 = 32'b01000100011110100000000000000000;   num2 = 32'b01000100011110011100000000000000;

        //#20 num1 = 32'b11000100011110100000000000000000;   num2 = 32'b01000100011110100000000000000000;
        // Normal Num + Denormal Num
        #30 num1 = 32'b01000010100000000000000000000000;   num2 = 32'b01000000000000000000000000000010;
        // NaN + Normal Num
        #10 num1 = 32'b01111111110000000000000000000010;   num2 = 32'b00011000000000010000000011100000;

        #100
        $finish;
    end

    initial
        $monitor ($time, " num1 = %b\tnum2 = %b\tout = %b\n", num1, num2, out);

endmodule
