module cla_64(input clk, input [63:0]a, input [63:0]b, input cin, output [63:0]out, output cout);

    wire ctmp;
    wire [31:0]out1,out2;
	CLA l91 (clk, out[31:0], ctmp, a[31:0], b[31:0], cin);
	CLA l92 (clk, out1, cout, a[63:32], b[63:32], 1'b0);
    CLA l93 (clk, out2, cout, a[63:32], b[63:32], 1'b1);

    assign out[63:32] = ctmp?out2:out1;
  
endmodule
