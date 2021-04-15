module add_32_compute(
    input [63:0] kgp, inout [63:0] temp_1, inout [63:0] temp_2, 
    inout [63:0] temp_3, inout [63:0] temp_4, input clk , input reset, 
    output [63:0] temp_5
);
    wire [63:0] d_temp_1, d_temp_2, d_temp_3, d_temp_4, d_temp_5;
    // Level - 1
    add_32_level_1 L1 (kgp , temp_1);
    dff_n #(64) DFF1 (temp_1, clk , 1'b1 , d_temp_1);
    
    // Level - 2
    add_32_level_2 L2 (d_temp_1, temp_2);
    dff_n #(64) DFF2 (temp_2, clk , 1'b1 , d_temp_2);

    // Level - 3
    add_32_level_3 L3 (d_temp_2, temp_3);
    dff_n #(64) DFF3 (temp_3, clk , 1'b1 , d_temp_3);

    // Level - 4
    add_32_level_4 L4 (d_temp_3, temp_4);
    dff_n #(64) DFF4 (temp_4, clk , 1'b1 , d_temp_4);

    // Level - 5
    add_32_level_5 L5 (d_temp_4, temp_5);

endmodule
