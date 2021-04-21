module LogicUnit(input clk,input [2:0]operation,input [31:0]A, input [31:0]B, output [31:0]C);

    wire [31:0]cmp;
    twocmp tc (A,cmp);

    assign C = ~(|operation[2:0])?A & B:32'bz;                                  //000
    assign C = (operation[0] & ~(|operation[2:1]))?A ^ B:32'bz;                 //001
    assign C = (operation[1] & ~operation[0] & ~operation[2])?~(A & B):32'bz;   //010
    assign C = (~operation[2] & (&operation[1:0]))?A|B:32'bz;                   //011
    assign C = (operation[2] & ~(|operation[1:0]))?~A:32'bz;                    //100
    assign C = (operation[2] & ~operation[1] & operation[0])?~(A|B):32'bz;      //101
    assign C = &operation[2:1] & ~operation[0]?cmp:32'bz;                       //110
    assign C = (&operation[2:0])? ~(A ^ B):32'bz;                               //111
    
endmodule

module twocmp(input [31:0]A,output [31:0]B);

    genvar i;
    generate
        for(i=0;i<32;i=i+1)
        begin
            if(i == 0)
                assign B[0] = A[0];
            else
                assign B[i] = |A[i-1:0] ? ~A[i] : A[i];
        end
    endgenerate

endmodule

// module top;
//     reg [31:0] A,B;
//     reg [2:0]op;
//     wire [31:0]C;

//     LogicUnit LU(op,A,B,C);

//     initial 
//     begin
//         #0 A= 32'b11011011; B = 32'b10111100;op=3'b0; 
//         #10 op=3'b001;
//         #10 op=3'b010;
//         #10 op=3'b011;
//         #10 op=3'b100;
//         #10 op=3'b101;
//         #10 op=3'b110;
//         #10 op=3'b111;
//     end

//     initial 
//     begin
//         $monitor($time," A=%b B=%b output=%b",A,B,C);    
//     end

// endmodule