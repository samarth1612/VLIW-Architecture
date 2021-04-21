module CLA (input clk, output [32:1] sum, output cout, input [32:1] a, input [32:1] b, input cin);

    wire [32:1][1:0] pkg, pkg_d, temp_1, temp_2, temp_3, temp_4, temp_5, temp_2_d, temp_4_d;
    wire [32:1] gk, buffGk;
    genvar i;

    // pkg  00-kill  11-generate  10-propagate
    //pkg generation

    assign pkg[1][0] = (a[1] & b[1]) | (b[1] & cin) | (cin & a[1]);
    assign pkg[1][1] = (a[1] & b[1]) | (b[1] & cin) | (cin & a[1]);

    generate
        for (i = 2; i < 33; i = i + 1) begin: generate_pgk
            assign pkg[i][0] = a[i] & b[i];
            assign pkg[i][1] = a[i] | b[i];
        end
    endgenerate

    dff #(64) DFF1 (pkg, clk, 1'b1, pkg_d);

    //pkg Reducing

    //  1 - 32.31 
    //  2   32.30
    //  4   32.28
    //  8   32.24
    //  16  32.16

    // 1 jump
    assign temp_1[1][0] = pkg_d[1][0];
    assign temp_1[1][1] = pkg_d[1][1];

    generate
        for (i = 2; i < 33; i = i + 1) begin: level_1
            assign temp_1[i][0] = (pkg_d[i][0]) | (pkg_d[i][1] & pkg_d[i-1][0]);
            assign temp_1[i][1] = (pkg_d[i][0]) | (pkg_d[i][1] & pkg_d[i-1][1]);
        end
    endgenerate

    // 2 jump

    generate
        for (i = 1; i < 3; i = i + 1) begin: level_2a
            assign temp_2[i][0] = temp_1[i][0];
            assign temp_2[i][1] = temp_1[i][1];
        end
    endgenerate

    generate
        for (i = 3; i < 33; i = i + 1) begin: level_2b
            assign temp_2[i][0] = (temp_1[i][0]) | (temp_1[i][1] & temp_1[i-2][0]);
            assign temp_2[i][1] = (temp_1[i][0]) | (temp_1[i][1] & temp_1[i-2][1]);
        end
    endgenerate

    dff #(64) DFF2 (temp_2, clk, 1'b1, temp_2_d);


    // 4 jumps
    generate
        for (i = 1; i < 5; i = i + 1) begin: level_3a
            assign temp_3[i][0] = temp_2_d[i][0];
            assign temp_3[i][1] = temp_2_d[i][1];
        end
    endgenerate

    generate
        for (i = 5; i < 33; i = i + 1) begin: level_3b
            assign temp_3[i][0] = (temp_2_d[i][0]) | (temp_2_d[i][1] & temp_2_d[i-4][0]);
            assign temp_3[i][1] = (temp_2_d[i][0]) | (temp_2_d[i][1] & temp_2_d[i-4][1]);
        end
    endgenerate

    // 8 jumps
    generate
        for (i = 1; i < 9; i = i + 1) begin: level_4a
            assign temp_4[i][0] = temp_3[i][0];
            assign temp_4[i][1] = temp_3[i][1];
        end
    endgenerate

    generate
        for (i = 9; i < 33; i = i + 1) begin: level_4b
            assign temp_4[i][0] = (temp_3[i][0]) | (temp_3[i][1] & temp_3[i-8][0]);
            assign temp_4[i][1] = (temp_3[i][0]) | (temp_3[i][1] & temp_3[i-8][1]);
        end
    endgenerate

    dff #(64) DFF3 (temp_4, clk, 1'b1, temp_4_d);

    // 16 jumps 
    generate
        for (i = 1; i < 17; i = i + 1) begin: level_5a
            assign temp_5[i][0] = temp_4_d[i][0];
            assign temp_5[i][1] = temp_4_d[i][1];
        end
    endgenerate

    generate
        for (i = 17; i < 33; i = i + 1) begin: level_5b
            assign temp_5[i][0] = (temp_4_d[i][0]) | (temp_4_d[i][1] & temp_4_d[i-16][0]);
            assign temp_5[i][1] = (temp_4_d[i][0]) | (temp_4_d[i][1] & temp_4_d[i-16][1]);
        end
    endgenerate

    //GK Calculating
    generate
        for (i = 1; i < 33; i = i + 1) begin: generate_cin
            assign gk[i] = temp_5[i][1];
        end
    endgenerate

    dff #(32) DFF4 (gk, clk, 1'b1, buffGk);

    wire [32:1]buffa,buffb,buffc;
    delay #(4) del1(clk, a, buffa);
    delay #(4) del2(clk, b, buffb);
    delay #(4) del3(clk, {31'b0,cin}, buffc);

    //calculating sum
    assign sum[1] = buffa[1] ^ buffb[1] ^ buffc[1];
    generate
        for (i = 2; i < 33; i = i + 1) begin: generate_sum
            assign sum[i] = buffGk[i-1] ^ buffa[i] ^ buffb[i];
        end
    endgenerate

    assign cout = buffGk[32];

endmodule
