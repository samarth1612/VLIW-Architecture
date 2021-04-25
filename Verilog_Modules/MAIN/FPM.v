module FPMul(input clk, input [31:0]I1, input [31:0]I2, output [31:0]out);

    wire [31:0] out_d, A, B, Exp, final_exp, final_exp_d, final_exp_d_d, final_exp_d_shifted, N1, N2;
    wire S1, S2, cout, x;
    wire [7:0] E1, E2;
    wire [22:0] M1, M2;
    wire [63:0] P, P_d;

    swap SW1 (I1, I2, A, B);

    split SP1 (A, S1, E1, M1);
    split SP2 (B, S2, E2, M2);

    // Summing up the Exponents
    CLA CL1 (clk, Exp, cout, {24'b0, E1}, {24'b0, E2}, 1'b0); 
    CLA CL2 (clk, final_exp, cout, Exp, ~(32'd127), 1'b1);
    dff #(32) dffexp (final_exp, clk, 1'b1, final_exp_d);
    // delay #(1, 32) cd1 (clk, final_exp, final_exp_d);    

    assign N1 = {|E1, M1};
    assign N2 = {|E2, M2};

    WallaceMul Wm (clk, N1, N2, P);
    assign P_d = P;

    // A is is inf or NAN and B is not zero
    triArr T1(A, &E1 & |B[30:0], out_d);

    // B is zero and A is Not INF or NAN
    triArr T2(B, ~(|B[30:0]) & ~&E1, out_d);

    // A is INF or NAN and B is zero
    triArr T3({32{1'b1}}, &E1 & ~(|B[30:0]), out_d);

    delay #(13, 32) cd4 (clk, out_d, out);

    //Case of overflow(no inf/NAN/zero/Denormal)
    CLA CL3 (clk, final_exp_d_shifted, cout, final_exp_d, 32'b1, 1'b0);
    assign x = P_d[47] & ~(&E1 | ~(|B[30:0]));
    triArr T4 ({S1^S2, final_exp_d_shifted[7:0], P_d[46:24]}, 1'b1, out);

    //Normal Case (no inf/NAN/zero/Denormal)
    delay #(4, 32) cd3 (clk, final_exp_d, final_exp_d_d);
    triArr T5 ({S1^S2, final_exp_d_d[7:0], P_d[45:23]}, ~P_d[47] & P_d[46] & ~(&E1 | ~(|B[30:0])), out);
endmodule


// /*
//     Including the required modules
// */
// `include "zeroInf.v"
// `include "wallaceTreeMultiplier.v"
// `include "barrelShifter.v"
// /*
//     A module that mutiplies two numbers represented in IEEE 754 format
// */
// module IEEEmultiply (input [31:0] a, input [31:0] b, input clk, output [31:0] c);

//     /*
//         Required registers and wires for the module
//     */
//     wire s1, s2, s3;
//     wire [7:0] e1, e2, e3, e3F, e3D;
//     wire [22:0] m1, m2, m3, m3F, m3D;
//     wire [63:0] prod, prodD, prodB;
//     wire [31:0] mm1, mm2;
//     wire [47:0] mprod, mprodD;
//     reg [7:0] ex;
//     integer i;
//     /*
//         Split the given 32-bit number into sign bit, exponent bits and mantissa bits
//     */
//     assign s1 = a[31];
//     assign e1 = a[30:23];
//     assign m1 = a[22:0];
//     assign s2 = b[31];
//     assign e2 = b[30:23];
//     assign m2 = b[22:0];
//     /*
//         If any one of the operand is inf or zero,
//         assign the same to the output
//     */
//     assign s3 = s1 ^ s2;
//     /*
//         Concatenating the assumed bit to the mantissa
//         For denormal number (all exponent bits are 0), we concatenate the bitwise OR of the exponent, i.e. zero
//         For normal numbers, we concatenate the bitwise OR of the exponent, i.e. one
//     */
//     assign mm1 = {|e1, m1};
//     assign mm2 = {|e2, m2};
//     /*
//         Multiply the numbers using the Wallace Tree Multiplier module
//     */
//     wallaceTreeMultiplier wm_01 (mm1, mm2, clk, prod);
//     nDFF #(64) ndff_prod (prod, clk, 1'b1, prodD);
//     /*
//         Normalizing the result to 1.m3 format
//     */
//     always @(*) begin
//         /*
//             Final exponent is the sum of e1, e2 and -127
//             We take the product for from 47 to 0 (47 and 46 are the bits before the decimal point,
//             for normalizing we need 1 bit before the decimal, we shift one left adding 1 to the exponent.)
//             We also add the 1 we get from normalizing the product from step 3
//         */
//         ex = e1 + e2 - 7'b1111110;
//         i = 0;
//         /*
//             Loop and increment the counter until we find a 1 in the product
//         */
//         while (prodD[47 - i] == 1'b0) begin
//             i = i + 1;
//         end
//         /*
//             Shift the product i steps left for normalizing
//             Decrement the exponent by i amounts
//         */
//         ex = ex - i;
//     end
//     barrelLeft #(48, 6) br (prodD[47:0], i, mprod);
//     nDFF #(48) blD (mprod, clk, 1'b1, mprodD);
//     /*
//         Copy the exponent, and first 23 bits from the modified product. 
//     */
//     assign e3 = ex;
//     assign m3 = mprodD[46:24];
//     /*
//         Modify the outputs to the edge cases, if any
//     */
//     zeroInf zf_01 (e1, m1, e2, m2, e3, m3, e3F, m3F);
//     nDFF #(23) m3DFF (m3F, clk, 1'b1, m3D);
//     nDFF #(8) e3DFF (e3F, clk, 1'b1, e3D);
//     /*
//         Concat the sign bit, exponent bits and the mantissa bits
//     */
//     assign c = {s3, e3D, m3D};

// endmodule

