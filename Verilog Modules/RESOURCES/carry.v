module carry_block #(parameter n = 32) (
    input [2*n-1:0] in, output [n-1:0] final_cin, output cout
);

	genvar i;
	for(i = 0; i < n; i = i + 1)
	begin
		assign final_cin[i] = in[2*i + 1];
	end
    assign cout = final_cin[n-1];

endmodule
