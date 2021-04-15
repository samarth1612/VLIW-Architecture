module rec_dub( 
	input [63:0] a, input [63:0] b, input clk , output [63:0] sum, output cout
);

	wire[63:0] final_cin;
	wire [127:0] kgp, d_kgp, temp_1, temp_2, temp_3, temp_4, temp_5, temp_6;
	genvar i;

	// KGP block
	kgp_block #(64) kgpb (a, b, kgp);
	dff_n #(128) dff_1(kgp, clk, 1'b1, d_kgp);

	// Computation of carry
	add_64_compute calc (d_kgp , temp_1, temp_2, temp_3, temp_4, temp_5, clk , reset , temp_6);

	// Final carry bits computation 
	carry_block #(64) ca (temp_6, final_cin , cout);
	dff_n #(128) dff_2(kgp, clk, 1'b1, d_kgp);

	// Final sum
	assign sum[0] = a[0] ^ b[0]; 
	for(i = 1; i <= 63; i = i + 1)
	begin
		assign sum[i] = a[i] ^ b[i] ^ final_cin[i-1];
	end
	
endmodule
