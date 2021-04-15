module multiplier (
    input [31:0] a, input b, output reg [31:0] c
);
    
    always@(a, b)
    begin

        if(b != 0)
            c = a;

        else
            c = 32'd0;   
    end
    
endmodule
