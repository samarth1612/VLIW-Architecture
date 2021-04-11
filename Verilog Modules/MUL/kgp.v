module kgp_block (
    input [63:0] a, input [63:0] b, output [127:0] kgp
);
    genvar i;
    for(i=0; i<=63; i = i+1)
	begin
		assign kgp[2*i] = a[i];
		assign kgp[2*i + 1] = |b[i];
	end

endmodule