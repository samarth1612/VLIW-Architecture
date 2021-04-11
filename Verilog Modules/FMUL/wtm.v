`include "multiplier.v"
`include "csa.v"
`include "rec_dub.v"

module wallace_tree_mul (
    input [31:0] in_1, input [31:0] in_2, input clk, output [63:0] out
);

    //Required registers and wires for the module
    wire [63:0] in [31:0], temp_1 [31:0];
    wire [31:0] temp_2 [31:0];
    wire [63:0] s [30:0], s_d [30:0];
    wire [63:0] c [30:0], c_d [30:0];
    wire cout;
    genvar i;
    
    //Generate the partial products of in_1 and in_2
    generate
        for(i = 0; i < 32; i = i + 1) 
        begin : and_loop

            //Mulitply in_1 with ith bit of in_2
            multiplier mul(in_1, in_2[i], temp_2[i]);

            //Concat 31 bits to the product and shift it i times
            assign temp_1[i] = {{32{1'b0}}, temp_2[i]};
            assign in[i] = temp_1[i] << i;
        end
    endgenerate

    // Adding the partial products and the generated sum and carry using carry save adder
    carry_save_adder csa_01(in[0], in[1], in[2], s[0], c[0]);
    carry_save_adder csa_02(in[3], in[4], in[5], s[1], c[1]);
    carry_save_adder csa_03(in[6], in[7], in[8], s[2], c[2]);
    carry_save_adder csa_04(in[9], in[10], in[11], s[3], c[3]);
    carry_save_adder csa_05(in[12], in[13], in[14], s[4], c[4]);
    carry_save_adder csa_06(in[15], in[16], in[17], s[5], c[5]);
    carry_save_adder csa_07(in[18], in[19], in[20], s[6], c[6]);
    carry_save_adder csa_08(in[21], in[22], in[23], s[7], c[7]);
    carry_save_adder csa_09(in[24], in[25], in[26], s[8], c[8]);
    carry_save_adder csa_10(in[27], in[28], in[29], s[9], c[9]);

    generate
    for(i = 0; i < 10; i = i+1)
    begin : pipeline_1
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_11(s_d[0], c_d[0], s_d[1], s[10], c[10]);
    carry_save_adder csa_12(c_d[1], s_d[2], c_d[2], s[11], c[11]);
    carry_save_adder csa_13(c_d[3], s_d[3], s_d[4], s[12], c[12]);
    carry_save_adder csa_14(c_d[4], s_d[5], c_d[5], s[13], c[13]);
    carry_save_adder csa_15(s_d[6], c_d[6], s_d[7], s[14], c[14]);
    carry_save_adder csa_16(c_d[7], c_d[8], s_d[8], s[15], c[15]);
    carry_save_adder csa_17(s_d[9], c_d[9], in[30], s[16], c[16]);

    generate
    for(i = 10; i < 17; i = i+1)
    begin : pipeline_2
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_18(s_d[10], c_d[10], s_d[11], s[17], c[17]);
    carry_save_adder csa_19(c_d[11], s_d[12], c_d[12], s[18], c[18]);
    carry_save_adder csa_20(c_d[13], s_d[13], s_d[14], s[19], c[19]);
    carry_save_adder csa_21(c_d[14], c_d[15], s_d[15], s[20], c[20]);
    carry_save_adder csa_22(s_d[16], c_d[16], in[31], s[21], c[21]);

    generate
    for(i = 17; i < 22; i = i+1)
    begin : pipeline_3
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_23(s_d[17], c_d[17], s_d[18], s[22], c[22]);
    carry_save_adder csa_24(c_d[18], s_d[19], c_d[19], s[23], c[23]);
    carry_save_adder csa_25(c_d[20], s_d[20], s_d[21], s[24], c[24]);

    generate
    for(i = 22; i < 25; i = i+1)
    begin : pipeline_4
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_26(s_d[22], c_d[22], s_d[23], s[25], c[25]);
    carry_save_adder csa_27(c_d[23], s_d[24], c_d[24], s[26], c[26]);

    generate
    for(i = 25; i < 27; i = i+1)
    begin : pipeline_5
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_28(c_d[25], s_d[25], s_d[26], s[27], c[27]);
    carry_save_adder csa_29(c_d[26], c_d[21], {64{1'b0}}, s[28], c[28]);

    generate
    for(i = 27; i < 29; i = i+1)
    begin : pipeline_6
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_30(s_d[27], c_d[27], s_d[28], s[29], c[29]);

    generate
    for(i = 29; i < 30; i = i+1)
    begin : pipeline_7
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    carry_save_adder csa_31(c_d[28], s_d[29], c_d[29], s[30], c[30]);

    generate
    for(i = 30; i < 31; i = i+1)
    begin : pipeline_8
        dff_n #(64) r_a(s[i], clk, 1'b1, s_d[i]);
        dff_n #(64) r_b(c[i], clk, 1'b1, c_d[i]);
    end
    endgenerate

    //Add the final sum and carry using recursive doubling adder
    rec_dub rd_64(s_d[30], c_d[30], clk , out, cout);

endmodule
