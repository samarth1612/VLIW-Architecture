module float_mul (input [31:0]num_1 , input [31:0]num_2 , input clk, output [31:0]out);

    wire sign_1, sign_2;
    wire [7:0] exp_1, exp_2, exp_3;
    wire [22:0] man_1, man_2, man_3;
    split s1(num_1, sign_1, exp_1, man_1 );
    split s2(num_2, sign_2, exp_2, man_2 );
    mul m(exp_1, exp_2, man_1, man_2, clk , exp_3, man_3);
    cases exceptions(sign_1^sign_2, exp_1, exp_2,  exp_3, man_1, man_2, man_3, out);
    
endmodule
