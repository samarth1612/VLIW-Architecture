module carry_block (
    input [127:0] in, output [63:0] final_cin, output cout
);

	genvar i;
	for(i=0; i<=63; i = i+1)
	begin
		assign final_cin[i] = in[2*i + 1];
	end
    assign cout = final_cin[63];

endmodule