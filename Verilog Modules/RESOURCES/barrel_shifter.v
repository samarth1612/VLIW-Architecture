module mux(input A, input B, input S, output out);

    assign out = (S == 0 ) ? B : A;

endmodule

module barrelLeft #(
    parameter n = 24,
    parameter sel = 5
) (
    input [n-1:0] in, input [sel-1:0] s, output [n-1:0] out
);
    
    wire [n-1:0] temp [sel-2:0];
    genvar i;
    generate
        columnLeft #(0, n) col_01 (in, s[0], temp[0]);
        for (i = 1; i < sel - 1; i = i + 1) begin: columnLoopLeft
            columnLeft #(i, n) col (temp[i-1], s[i], temp[i]);
        end
        columnLeft #(sel-1, n) col_0n (temp[sel-2], s[sel-1], out);
    endgenerate

endmodule

module columnLeft #(
    parameter level = 4,
    parameter n = 24
) (
    input [n-1:0] in, input s, output [n-1:0] out
);

    mux mux_01 [2**level-1:0]({2**level{1'b0}}, in[2**level-1:0], s, out[2**level-1:0]);
    mux mux_02 [n-2**level-1:0](in[n-2**level-1:0], in[n-1:2**level], s, out[n-1:2**level]);

endmodule

module barrelRight #(
    parameter n = 24,
    parameter sel = 5
) (
    input [n-1:0] in, input [sel-1:0] s, output [n-1:0] out
);
    
    wire [n-1:0] temp [sel-2:0];
    genvar i;
    generate
        columnRight #(0, n) col_01 (in, s[0], temp[0]);
        for (i = 1; i < sel - 1; i = i + 1) begin: columnLoopRight
            columnRight #(i, n) col (temp[i-1], s[i], temp[i]);
        end
        columnRight #(sel-1, n) col_0n (temp[sel-2], s[sel-1], out);
    endgenerate

endmodule

module columnRight #(
    parameter level = 4,
    parameter n = 24
) (
    input [n-1:0] in, input s, output [n-1:0] out
);
    
    mux mux_01 [n-2**level-1:0](in[n-1:2**level], in[n-2**level-1:0], s, out[n-2**level-1:0]);
    mux mux_02 [2**level-1:0]({2**level{1'b0}}, in[n-1:n-2**level], s, out[n-1:n-2**level]);

endmodule

// module top;

//     reg [23:0] in;
//     reg [4:0] S;
//     wire [23:0] out;

//     barrelLeft #(24, 5) b (in, S, out);

//     initial 
//     begin
//         in = $random;
//         S = 5'd2;
//         #0 $display ("%b\n%b", in, out);
//     end

// endmodule
