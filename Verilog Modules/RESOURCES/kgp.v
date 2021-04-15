module kgp_block #(parameter n = 32) (
    input [n-1:0] a, input [n-1:0] b, output [2*n-1:0] kgp
);
    genvar i;
    for(i = 0; i < n; i = i + 1)
	begin
		assign kgp[2*i] = a[i];
		assign kgp[2*i + 1] = |b[i];
	end

endmodule
