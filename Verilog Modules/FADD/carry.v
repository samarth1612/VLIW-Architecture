module carry_block (
    input [63:0] in, output [31:0] final_cin, output cout
);

	genvar i;
	for(i=0; i<=31; i = i+1)
	begin
		assign final_cin[i] = in[2*i + 1];
	end
    assign cout = final_cin[31];

endmodule