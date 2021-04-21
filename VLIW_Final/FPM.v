`include "FPA.v"
`include "triArr.v"

module FPMul(input clk, input [31:0]I1, input [31:0]I2, output [31:0]out);
    wire [31:0]outbuff2;
    wire [31:0]A, B;
    Swap SW1(I1, I2, A, B);

    wire S1, S2;
    wire [7:0] E1, E2;
    wire [22:0] M1, M2;

    Split SP1(A, S1, E1, M1);
    Split SP2(B, S2, E2, M2);

    // Summing up the Exponents
    wire [31:0]Ednm, Eout, Eoutbuff, Eoutbuff1;
    wire  Carr;
    CLA CL1(clk, Ednm, Carr, {24'b0, E1}, {24'b0, E2}, 1'b0); 
    CLA CL2(clk, Eout, Carr, Ednm, ~(32'd127), 1'b1);

    delay #(13, 32) cd1 (clk, Eout, Eoutbuff);    

    wire [31:0]N1, N2;
    wire [63:0]P, Pbuff;
    assign N1 = {|E1, M1};
    assign N2 = {|E2, M2};

    WallaceMul Wm (clk, N1, N2, P);

    delay #(12, 64) cd2 (clk, P, Pbuff);

    // A is is inf or NAN and B is not zero
    TriArr T1 (A, &E1 & |B[30:0], outbuff2);

    // B is zero and A is Not INF or NAN
    TriArr T2 (B, ~(|B[30:0]) & ~&E1, outbuff2);

    // A is INF or NAN and B is zero
    TriArr T3 ({32{1'b1}}, &E1 & ~(|B[30:0]), outbuff2);

    delay #(25, 32) cd4 (clk, outbuff2, out);

    //Case of overflow(no inf/NAN/zero/Denormal)
    wire [31:0] EoutShift;
    CLA CL3 (clk, EoutShift, Carr, Eoutbuff, 32'b1, 1'b0);
    TriArr T4 ({S1^S2, EoutShift[7:0], Pbuff[46:24]}, Pbuff[47] & ~(&E1 | ~(|B[30:0])), out);

    //Normal Case (no inf/NAN/zero/Denormal)
    delay #(4, 32) cd3 (clk, Eoutbuff, Eoutbuff1);
    TriArr T5 ({S1^S2, Eoutbuff1[7:0], Pbuff[45:23]}, ~Pbuff[47] & Pbuff[46] & ~(&E1 | ~(|B[30:0])), out);
endmodule

// module top;

//     reg [31:0] I1, I2;
//     wire [31:0]out;
//     reg clk;

//     FPMul F1(clk, I1, I2, out);

//     integer j;
//     initial 
//     begin
//         #0 clk = 0;
//         for(j=0;j<500;j++)
//             #5 clk = ~clk;
//     end

//     initial
//     begin
//         // case infinity and zero (out = NAN)
//         #0 I2={1'b0, {8{1'b1}}, 23'b0}; I1=32'b0;     

//         // 2 ,  9
//         #10 I1 = 32'b01000000000000000000000000000000; I2 = 32'b01000001000100000000000000000000;

//         //1.234 ,  63.201 = 77.990034 
//         #10 I1=32'b00111111100111011111001110110110;I2=32'b01000010011111001100110111010011;
//     end
//     initial
//     begin
//         $monitor($time,  " A=%b B=%b\tC=%b\n", I1, I2, out);
//    end

// endmodule
