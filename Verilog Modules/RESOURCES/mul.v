module mul(input [31:0]a, input [31:0]b, output [31:0][63:0]out);

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin
           assign out[i] = (a & {64{b[i]}})<<i;
        end
    endgenerate 

endmodule
