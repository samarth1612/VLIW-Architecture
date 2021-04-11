`include "levels.v"
`include "d_flip_flop.v"
`include "parallel_prefix.v"

module compute(
    input [127:0] kgp, inout [127:0] temp_1, inout [127:0] temp_2, 
    inout [127:0] temp_3, inout [127:0] temp_4, inout [127:0] temp_5, input clk , input reset, 
    output [127:0] temp_6
);
    wire [127:0] d_temp_1, d_temp_2, d_temp_3, d_temp_4, d_temp_5, d_temp_6;
    // Level - 1
    level_1 L1 (kgp , temp_1);
    dff_n #(128) DFF1 (temp_1, clk , 1'b1 , d_temp_1);
    
    // Level - 2
    level_2 L2 (d_temp_1, temp_2);
    dff_n #(128) DFF2 (temp_2, clk , 1'b1 , d_temp_2);

    // Level - 3
    level_3 L3 (d_temp_2, temp_3);
    dff_n #(128) DFF3 (temp_3, clk , 1'b1 , d_temp_3);

    // Level - 4
    level_4 L4 (d_temp_3, temp_4);
    dff_n #(128) DFF4 (temp_4, clk , 1'b1 , d_temp_4);

    // Level - 5
    level_5 L5 (d_temp_4, temp_5);
    dff_n #(128) DFF5 (temp_5, clk , 1'b1 , d_temp_5);

    // Level - 6
    level_6 L6 (d_temp_5, temp_6);

endmodule
