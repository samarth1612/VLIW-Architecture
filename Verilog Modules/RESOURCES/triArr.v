module triArr(input [31:0]A, input en, output [31:0]B);

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1)
            bufif1 T(B[i], A[i], en);
    endgenerate
    
endmodule
