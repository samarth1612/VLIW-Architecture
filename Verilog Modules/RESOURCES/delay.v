module delay #(parameter delay = 5,parameter n = 32) (input clk, input [n-1:0]in, output [n-1:0]out);
    
    genvar i;
    for(i = 0;i < delay;i = i + 1) begin : LV
        wire [n-1:0]tmp;
        if(i == 0)
            dff #(n) ff(in, clk, 1'b1, LV[0].tmp);
        else if(i == delay-1)
            dff #(n) ff(LV[i-1].tmp, clk, 1'b1, out);
        else
            dff #(n) ff(LV[i-1].tmp, clk, 1'b1, LV[i].tmp);
    end

endmodule
