module mul(input [7:0]exp_1, input [7:0]exp_2, input[22:0]man_1, input [22:0]man_2, input clk , output reg [7:0]final_exp, output [22:0]final_man);
    wire [63:0]temp_1,d_temp_1;
    wire [47:0] temp_2 , d_temp_2;
    wire [31:0] num_1, num_2;
    assign num_1 = {|exp_1, man_1};
    assign num_2 = {|exp_2, man_2};
    wallace_tree_mul wtm(num_1, num_2, clk, temp_1);
    dff_n #(64) dff_prod (temp_1, clk , 1'b1 , d_temp_1);
    integer i;
    always @(d_temp_1)
    begin
        i = 0;
        final_exp = exp_1 + exp_2 - 7'b1111110;
        while(d_temp_1[47-i] == 1'b0)
        begin
            i = i + 1;
        end
        //temp_2 = temp_1 << i;
        final_exp = final_exp - i;
    end
    barrelLeft #(48, 6) b (d_temp_1[47:0] , i[5:0],  temp_2);
    dff_n #(48) dff_temp (temp_2, clk , 1'b1 , d_temp_2);
    assign final_man = d_temp_2[46:24];
endmodule
