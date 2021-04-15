`include "main.v"

module top;

    reg [31:0] a, b;
    reg [2:0] s;
    wire [31:0] c;
    integer i;

    logicUnit #(32) lu (a, b, s, c);

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            a = $random;
            b = $random;
            s = i;
            #5;
        end
    end

    initial begin
        $monitor ("a = %b (%d)\nb = %b (%d)\nc = %b (%d)\n", a, a, b, b, c, c);
    end
    
endmodule
