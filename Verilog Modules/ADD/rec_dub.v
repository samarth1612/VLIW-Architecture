`include "compute.v"
`include "kgp.v"
`include "carry.v"

module rec_dub( 
	input [31:0] a, input [31:0] b, input clk , output [31:0] sum, output cout
);

	wire[31:0] final_cin;
	wire [63:0] kgp, d_kgp, temp_1, temp_2, temp_3, temp_4, temp_5;
	genvar i;

	// KGP block
	kgp_block kgpb (a, b, kgp);
	dff dff_1(kgp, clk, 1'b1, d_kgp);

	// Computation of carry
	compute calc (d_kgp , temp_1, temp_2, temp_3, temp_4, clk , reset , temp_5);

	// Final carry bits computation 
	carry_block ca (temp_5, final_cin , cout);
	dff dff_2(kgp, clk, 1'b1, d_kgp);

	// Final sum
	assign sum[0] = a[0] ^ b[0];
	for(i=1; i<=31; i = i+1)
	begin
		assign sum[i] = a[i] ^ b[i] ^ final_cin[i-1];
	end
	
endmodule