// Check whether abs(in1) > abs(in2)
module swap(input [31:0]input1, input [31:0]input2, output reg [31:0]output1, output reg [31:0]output2); 

    always @(input1 | input2)
    begin
        if(input2[30:0]>input1[30:0])
        begin
            output2 = input1;
            output1 = input2;
        end
        else
        begin
            output1 = input1;
            output2 = input2;
        end
    end

endmodule