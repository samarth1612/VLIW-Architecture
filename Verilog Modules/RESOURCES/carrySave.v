module carrySave #(parameter N = 32, parameter M = 22) (input [(N-1):0][63:0] a, output [(M-1):0][63:0] out);

    genvar i, j;
    integer ct = 0;
    generate
        for (i = 0; i < N / 3; i = i + 1) begin
            addArr A1(a[3*i], a[3*i+1], a[3*i+2], out[2*i], out[2*i+1]);
        end
        for (j = 1; j <= N % 3; j = j + 1) begin
            assign out[M-j] = a[N-j]; 
        end
    endgenerate

endmodule
