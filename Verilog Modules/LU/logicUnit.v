module logicUnit #(
    parameter n = 32
) (
    input [n-1:0] a, input [n-1:0] b, input [4:0] s, output reg [n-1:0] c
);
    always @(a, b, s) begin
        case (s)
            5'b01010: c = a & b;
            5'b01011: c = a | b;
            5'b01100: c = a ^ b;
            5'b01101: c = ~(a & b);
            5'b01110: c = ~(a | b);
            5'b01111: c = ~(a ^ b);
            5'b10000: c = ~a;
            5'b10001: c = ~a + 1'b1;
            default: c = {n{1'bx}};
        endcase
    end
endmodule
