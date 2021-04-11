module  dff(
    input [63:0]D, input clk, input reset, output reg [63:0] Q
);
    always @(posedge clk ) 
    begin
        if (reset == 1'b0) 
        begin
            Q = 64'b0;
        end

        else 
        begin
            Q = D;
        end
    end
endmodule
