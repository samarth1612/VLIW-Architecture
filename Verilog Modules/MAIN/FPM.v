module FPMul(input clk, input [31:0]I1, input [31:0]I2, output [31:0]out);

    wire [31:0] out_d, A, B, Exp, final_exp, final_exp_d, final_exp_d_d, final_exp_d_shifted, N1, N2;
    wire S1, S2, cout;
    wire [7:0] E1, E2;
    wire [22:0] M1, M2;
    wire [63:0] P, P_d;

    swap SW1 (I1, I2, A, B);

    split SP1 (A, S1, E1, M1);
    split SP2 (B, S2, E2, M2);

    // Summing up the Exponents
    CLA CL1 (clk, Exp, cout, {24'b0, E1}, {24'b0, E2}, 1'b0); 
    CLA CL2 (clk, final_exp, cout, Exp, ~(32'd127), 1'b1);

    delay #(8, 32) cd1 (clk, final_exp, final_exp_d);    

    assign N1 = {|E1, M1};
    assign N2 = {|E2, M2};

    WallaceMul Wm (clk, N1, N2, P);

    delay #(13, 64) cd2 (clk, P, P_d);

    // A is is inf or NAN and B is not zero
    triArr T1(A, &E1 & |B[30:0], out_d);

    // B is zero and A is Not INF or NAN
    triArr T2(B, ~(|B[30:0]) & ~&E1, out_d);

    // A is INF or NAN and B is zero
    triArr T3({32{1'b1}}, &E1 & ~(|B[30:0]), out_d);

    delay #(25, 32) cd4 (clk, out_d, out);

    //Case of overflow(no inf/NAN/zero/Denormal)
    CLA CL3 (clk, final_exp_d_shifted, cout, final_exp_d, 32'b1, 1'b0);
    triArr T4 ({S1^S2, final_exp_d_shifted[7:0], P_d[46:24]}, P_d[47] & ~(&E1 | ~(|B[30:0])), out);

    //Normal Case (no inf/NAN/zero/Denormal)
    delay #(4, 32) cd3 (clk, final_exp_d, final_exp_d_d);
    triArr T5 ({S1^S2, final_exp_d_d[7:0], P_d[45:23]}, ~P_d[47] & P_d[46] & ~(&E1 | ~(|B[30:0])), out);
endmodule

// module top2;

//     reg [31:0] I1, I2;
//     wire [31:0]out;
//     reg clk;

//     FPMul F1(clk, I1, I2, out);

//     integer j;
//     initial 
//     begin
//         #0 clk = 0;
//         for(j=0;j<50000;j++)
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
