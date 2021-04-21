// Splitting the 32 bits into exponent, sign and mantissa
module split(input [31:0]num, output sign, output [7:0]exp, output [22:0]man);  

    assign sign = num[31];
    assign exp =  num[30:23];
    assign man = num[22:0];
    
endmodule
