module addArr #(parameter SIZE = 64) (
    input [SIZE-1:0] a, input [SIZE-1:0] b, input [SIZE-1:0] cin, output [SIZE-1:0] sum, output [SIZE-1:0] c);
    
    genvar i;
    generate
        for (i = 0;i<SIZE-1;i=i+1) begin
            full_adder FA1(a[i],b[i],cin[i],sum[i],c[i+1]);
        end
        assign sum[SIZE-1] = a[SIZE-1]^b[SIZE-1]^cin[SIZE-1];
        assign c[0] = 1'b0;
    endgenerate

endmodule
