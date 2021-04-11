`include "rec_dub.v"
`include "split.v"
`include "swap.v"
`include "barrel_shifter.v"
// // Shifting the mantissa
// module barrel_shift(input [31:0]in, input [7:0]shift, output [31:0]out);

//     assign out = in>>shift;

// endmodule

module float_add (input[31:0]in1, input [31:0]in2, input clk, output [31:0]out);

    wire [31:0] a, b;
    swap swap_check(in1, in2, a, b);
    wire sign1,sign2;
    wire [7:0] exp1,exp2;
    wire [22:0] man1,man2;
    
    split s1(a, sign1, exp1, man1);
    split s2(b, sign2, exp2, man2);

    // Difference of exponents
    wire [7:0] D;
    assign D = exp1 - exp2;

    wire [31:0] num1, num2, num3;
    assign num1 = {|exp1, man1};
    assign num2 = {|exp2, man2};

    // To make exponents same
    barrelRight #(32, 5) br (num2, D[4:0], num3);

    wire [31:0] num4;
    wire ex_or;
    // 1s complement of 2nd num
    assign ex_or = sign1^sign2;
    assign num4 = {32{ex_or}}^num3;

    wire [31:0] sum, final_sum;
    wire carry, final_carry;

    rec_dub rc_add1(num1, num4, clk, sum, carry);
    rec_dub rc_add2(sum, {31'b0 , ex_or}, clk, final_sum, final_carry);

    wire [22:0] final_man;
    reg [22:0] temp;
    reg [7:0] exp3;

    // always block
    integer i = 0;
    always @(final_sum)
    begin
        if(final_sum[24] == 1)
        begin
            i = 0;
            temp = final_sum[23:1];
            exp3 = exp1 + 1'b1;
        end
        
        else if(final_sum[23] == 0)
        begin
            i = 1;
            while(final_sum[23-i] == 1'b0)
            begin
                i = i + 1;
            end
            exp3 = exp3-i;
            temp = final_sum[22:0];
        end

        else
        begin
            i = 0;
            temp = final_sum[22:0];
            exp3 = exp1;
        end
    end

    barrelLeft #(23, 5) bl (temp , i[4:0] ,  final_man);
    // Final output
    reg [31:0] out;
    always @(exp3 or final_man)
    begin
        // Infinity case
        if(&exp1 == 1'b1 && |man1 == 1'b0)
            out = {sign1,{8{1'b1}},23'b0};
        // Normal
        else
            out = {sign1,{8{|final_sum}} &exp3, final_man};
    end

endmodule