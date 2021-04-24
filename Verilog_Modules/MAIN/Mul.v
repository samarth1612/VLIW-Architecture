//9 Stage pipeline

module WallaceMul(input clk, input [31:0]A, input [31:0]B, output [63:0]C);

    wire [31:0][63:0] partial, tmp;
    wire [1:0][63:0] out;
    wire cout;
    
    mul M1(A, B, tmp);

    dff #(2048) DFF1 (tmp, clk, 1'b1, partial);

    adderTree At1 (clk, partial, out);

    cla_64 C64(clk, out[1], out[0], 1'b0, C, cout);

endmodule
