module full_adder (
    input a, input b, input cin, output sum, output carry
);

    wire w1, w2, w3, w4, w5;

    xor xor_0 (w1, a, b);
    xor xor_1 (sum, w1, cin);

    and and_0 (w2, a, b);
    and and_1 (w3, a, cin);
    and and_2 (w4, b, cin);
    or  or_0 (w5, w2, w3);
    or  or_1 (carry, w4, w5);

endmodule

module carry_save_adder (
    input [63:0] a, input [63:0] b, input [63:0] c, output [63:0] sum, output [63:0] carry
);
    assign carry[0] = 1'b0;
    genvar i;
    generate
        for(i = 0; i < 63; i = i + 1) 
        begin: full_adder
            full_adder fa(a[i], b[i], c[i], sum[i], carry[i + 1]);
        end
    endgenerate
    assign sum[63] = 1'b0;

endmodule
