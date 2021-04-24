module  dff #(parameter size = 64)(
    input [size-1:0] D, input clk, input reset, output reg [size-1:0] Q
);

    always @(posedge clk ) 
    begin
        if (reset == 1'b0) 
        begin
            Q <= {size{1'b0}};
        end

        else 
        begin
            Q <= D;
        end
    end
    
endmodule
