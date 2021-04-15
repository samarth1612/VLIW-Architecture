module logicUnit #(
    parameter n = 32
) (
    input [n-1:0] a, input [n-1:0] b, input [2:0] s, output reg [n-1:0] c
);
    always @(a, b, s) begin
        case (s)
            3'b000: c = a & b;
            3'b001: c = a ^ b;
            3'b010: c = ~(a & b);
            3'b011: c = a | b;
            3'b100: c = ~a;
            3'b101: c = ~(a | b);
            3'b110: c = ~a + 1'b1;
            3'b111: c = ~(a ^ b);
            default: c = a & b;
        endcase
    end
endmodule
