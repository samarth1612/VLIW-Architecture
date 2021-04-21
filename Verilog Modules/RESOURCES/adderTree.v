module adderTree (input clk, input [31:0][63:0] a, output [1:0][63:0] out);

    wire [21:0][63:0] tmp1, buff1;
    carrySave #(32, 22) CS1 (a, tmp1);

    dff #(22*64) DFF1 (tmp1, clk, 1'b1, buff1);

    wire [14:0][63:0] tmp2, buff2;
    carrySave #(22, 15) CS2 (buff1, tmp2);

    dff #(15*64) DFF2 (tmp2, clk, 1'b1, buff2);

    wire [9:0][63:0] tmp3, buff3;
    carrySave #(15, 10) CS3 (buff2, tmp3);

    dff #(10*64) DFF3 (tmp3, clk, 1'b1, buff3);

    wire [6:0][63:0] tmp4, buff4;
    carrySave #(10, 7) CS4 (buff3, tmp4);

    dff #(7*64) DFF4 (tmp4, clk, 1'b1, buff4);

    wire [4:0][63:0] tmp5, buff5;
    carrySave #(7, 5) CS5 (buff4, tmp5);

    dff #(5*64) DFF5 (tmp5, clk, 1'b1, buff5);

    wire [3:0][63:0] tmp6, buff6;
    carrySave #(5, 4) CS6 (buff5, tmp6);

    dff #(4*64) DFF6 (tmp6, clk, 1'b1, buff6);

    wire [2:0][63:0] tmp7, buff7;
    carrySave #(4, 3) CS7 (buff6, tmp7);

    dff #(3*64) DFF7 (tmp7, clk, 1'b1, buff7);

    wire [1:0][63:0] tmp8;
    carrySave #(3, 2) CS8 (buff7, tmp8);

    dff #(2*64) DFF8 (tmp8, clk, 1'b1, out);

endmodule
