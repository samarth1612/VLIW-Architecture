module level_1(
    input [63:0] kgp, output [63:0] temp_1
);

    parallel_prefix mod0(kgp[1:0], 2'b00, temp_1[1:0]);
    parallel_prefix mod1(kgp[3:2], temp_1[1:0], temp_1[3:2]);
    parallel_prefix mod2(kgp[5:4], temp_1[3:2], temp_1[5:4]);
    parallel_prefix mod3(kgp[7:6], temp_1[5:4], temp_1[7:6]);
    parallel_prefix mod4(kgp[9:8], temp_1[7:6], temp_1[9:8]);
    parallel_prefix mod5(kgp[11:10], temp_1[9:8], temp_1[11:10]);
    parallel_prefix mod6(kgp[13:12], temp_1[11:10], temp_1[13:12]);
    parallel_prefix mod7(kgp[15:14], temp_1[13:12], temp_1[15:14]);
    parallel_prefix mod8(kgp[17:16], temp_1[15:14], temp_1[17:16]);
    parallel_prefix mod9(kgp[19:18], temp_1[17:16], temp_1[19:18]);
    parallel_prefix mod10(kgp[21:20], temp_1[19:18], temp_1[21:20]);
    parallel_prefix mod11(kgp[23:22], temp_1[21:20], temp_1[23:22]);
    parallel_prefix mod12(kgp[25:24], temp_1[23:22], temp_1[25:24]);
    parallel_prefix mod13(kgp[27:26], temp_1[25:24], temp_1[27:26]);
    parallel_prefix mod14(kgp[29:28], temp_1[27:26], temp_1[29:28]);
    parallel_prefix mod15(kgp[31:30], temp_1[29:28], temp_1[31:30]);
    parallel_prefix mod16(kgp[33:32], temp_1[31:30], temp_1[33:32]);
    parallel_prefix mod17(kgp[35:34], temp_1[33:32], temp_1[35:34]);
    parallel_prefix mod18(kgp[37:36], temp_1[35:34], temp_1[37:36]);
    parallel_prefix mod19(kgp[39:38], temp_1[37:36], temp_1[39:38]);
    parallel_prefix mod20(kgp[41:40], temp_1[39:38], temp_1[41:40]);
    parallel_prefix mod21(kgp[43:42], temp_1[41:40], temp_1[43:42]);
    parallel_prefix mod22(kgp[45:44], temp_1[43:42], temp_1[45:44]);
    parallel_prefix mod23(kgp[47:46], temp_1[45:44], temp_1[47:46]);
    parallel_prefix mod24(kgp[49:48], temp_1[47:46], temp_1[49:48]);
    parallel_prefix mod25(kgp[51:50], temp_1[49:48], temp_1[51:50]);
    parallel_prefix mod26(kgp[53:52], temp_1[51:50], temp_1[53:52]);
    parallel_prefix mod27(kgp[55:54], temp_1[53:52], temp_1[55:54]);
    parallel_prefix mod28(kgp[57:56], temp_1[55:54], temp_1[57:56]);
    parallel_prefix mod29(kgp[59:58], temp_1[57:56], temp_1[59:58]);
    parallel_prefix mod30(kgp[61:60], temp_1[59:58], temp_1[61:60]);
    parallel_prefix mod31(kgp[63:62], temp_1[61:60], temp_1[63:62]);

endmodule
