module add_32_level_1(
    input [63:0] kgp, output [63:0] temp_1
);

    genvar i;
    generate
        for (i = 0; i < 2; i = i + 2) 
        begin: lvl1_01
            parallel_prefix L1_01 (kgp[i+1:i], 2'b00, temp_1[i+1:i]);
        end
    endgenerate

    generate
        for (i = 2; i < 64; i = i + 2) 
        begin: lvl1_02
            parallel_prefix L1_02 (kgp[i+1:i], temp_1[i-1:i-2], temp_1[i+1:i]);
        end
    endgenerate

endmodule


module add_32_level_2(
    input [63:0] temp_1, output [63:0] temp_2
);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 2) 
        begin: lvl2_01
            parallel_prefix L2_01 (temp_1[i+1:i], 2'b00, temp_2[i+1:i]);
        end
    endgenerate

    generate
        for (i = 4; i < 64; i = i + 2) 
        begin: lvl2_02
            parallel_prefix L2_02 (temp_1[i+1:i], temp_2[i-1:i-2], temp_2[i+1:i]);
        end
    endgenerate

endmodule


module add_32_level_3(
    input [63:0] temp_2, output [63:0] temp_3
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 2) 
        begin: lvl3_01
            parallel_prefix L3_01 (temp_2[i+1:i], 2'b00, temp_3[i+1:i]);
        end
    endgenerate

    generate
        for (i = 8; i < 64; i = i + 2) 
        begin: lvl3_02
            parallel_prefix L3_02 (temp_2[i+1:i], temp_3[i-1:i-2], temp_3[i+1:i]);
        end
    endgenerate

endmodule


module add_32_level_4(
    input [63:0] temp_3, output [63:0] temp_4
);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 2) 
        begin: lvl4_01
            parallel_prefix L4_01 (temp_3[i+1:i], 2'b00, temp_4[i+1:i]);
        end
    endgenerate

    generate
        for (i = 16; i < 64; i = i + 2) 
        begin: lvl4_02
            parallel_prefix L4_02 (temp_3[i+1:i], temp_4[i-1:i-2], temp_4[i+1:i]);
        end
    endgenerate

endmodule


module add_32_level_5 (
    input [63:0] temp_4, output [63:0] temp_5
);

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 2) 
        begin: lvl5_01
            parallel_prefix L5_01 (temp_4[i+1:i], 2'b00, temp_5[i+1:i]);
        end
    endgenerate

    generate
        for (i = 32; i < 64; i = i + 2) 
        begin: lvl5_02
            parallel_prefix L5_02 (temp_4[i+1:i], temp_5[i-1:i-2], temp_5[i+1:i]);
        end
    endgenerate

endmodule
