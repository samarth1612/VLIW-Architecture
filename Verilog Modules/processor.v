`include "include.v"

module processor (input clk);

    // Required parameters for the processor
    parameter instMemSize = 1024;
    parameter instSize = 320;
    
    // Insitantiation of the register file and memory nlock
    RegisterFile rf ();
    memory mem();

    // Instruction memory for the processor
    reg [instSize-1:0] inst [instMemSize-1:0];

    // Task to initialize the program counter
    task initPC;
        pc = 32'b0;
    endtask

    // Task to initialize the instruction register
    task initInst;
        integer i;
        for (i = 0; i < instMemSize; i = i + 1) begin : intiialize_instructions
            inst[i] = {instSize{1'b0}};
        end
    endtask

    // Task to write the given instruction packet to instruction register
    task writeInst(input [instSize:0] packet, input [32:0] index);
        inst[index] = packet;
    endtask
    
    /*--------------------------------------------------------------------------------------------
    Reg Declarations for IF
    --------------------------------------------------------------------------------------------*/
    reg [31:0] pc;
    reg [0:9][31:0] currentInst;

    /*--------------------------------------------------------------------------------------------
    Reg Declarations for ID
    --------------------------------------------------------------------------------------------*/
    reg [31:0] add0_inst;
    reg [4:0] add0_out;
    wire [4:0] add0_out_d;
    
    reg [31:0] add1_inst;
    reg [4:0] add1_out;
    wire [4:0] add1_out_d;

    reg [31:0] mul_inst;
    reg [4:0] mul_out1, mul_out2;
    wire [4:0]  mul_out1_d, mul_out2_d;
    
    reg [31:0] fadd0_inst;
    reg [4:0] fadd0_out;
    wire [4:0] fadd0_out_d;

    reg [31:0] fadd1_inst;
    reg [4:0] fadd1_out;
    wire [4:0] fadd1_out_d;
    
    reg [31:0] fmul_inst;
    reg [4:0] fmul_out;
    wire [4:0] fmul_out_d;
    
    reg [31:0] logic_inst;
    reg [4:0] logic_out;
    wire [4:0] logic_out_d;
        
    reg [31:0] ldr_inst;
    
    reg [31:0] str_inst, str_data;
    
    reg [31:0] mov_inst;

    reg [9:0][4:0] op;
    reg [7:0][4:0] out;
    reg [13:0][31:0] operandData;
    reg [2:0][53:0] memoryData;

    /*--------------------------------------------------------------------------------------------
    Reg Declarations for MEM
    --------------------------------------------------------------------------------------------*/
    reg [31:0] data0;

    /*============================================================================================
    Module instantiation for Add 0 instruction
    ============================================================================================*/
    reg [31:0] a0, b0;
    reg cin0;
    wire [31:0] out0;
    wire cout0;
    CLA add0 (clk, out0, cout0, a0, b0, cin0);
    delay #(4, 5) delayAdd0 (clk, add0_out, add0_out_d);

    /*============================================================================================
    Module instantiation for Add 1 instruction
    ============================================================================================*/
    reg [31:0] a1, b1;
    reg cin1;
    wire [31:0] out1;
    wire cout1;
    CLA add1 (clk, out1, cout1, a1, b1, cin1);
    delay #(4, 5) delayAdd1(clk, add1_out, add1_out_d);

    /*============================================================================================
    Module instantiation for Mul instruction
    ============================================================================================*/
    reg [31:0] a2, b2;
    wire [63:0] out2;
    WallaceMul mul (clk, a2, b2, out2);
    delay #(13, 5) delayMul1 (clk, mul_out1, mul_out1_d);
    delay #(13, 5) delayMul2 (clk, mul_out2, mul_out2_d);

    /*============================================================================================
    Module instantiation for Fadd 0 instruction
    ============================================================================================*/
    reg [31:0] a3, b3;
    wire [31:0] out3;
    FPAdder fadd0 (clk, a3, b3, out3); 
    delay #(4, 5) delayFadd0(clk, fadd0_out, fadd0_out_d);

    /*============================================================================================
    Module instantiation for Fadd 1 instruction
    ============================================================================================*/
    reg [31:0] a4, b4;
    wire [31:0] out4;
    FPAdder fadd1 (clk, a4, b4, out4); 
    delay #(4, 5) delayFadd(clk, fadd1_out, fadd1_out_d);

    /*============================================================================================
    Module instantiation for Fmul instruction
    ============================================================================================*/
    reg [31:0] a5, b5;
    wire [31:0] out5;
    FPMul fmul (clk, a5, b5, out5); 
    delay #(26, 5) delayFmul (clk, fmul_out, fmul_out_d);

    /*============================================================================================
    Module instantiation for Logic instruction
    ============================================================================================*/
    reg [31:0] a6, b6;
    wire [31:0] out6;
    reg [4:0] sel;
    logicUnit #(32) lu (a6, b6, sel, out6);

    /*============================================================================================
    Module instantiation for DFF PC instruction
    ============================================================================================*/
    wire [31:0] pc_d;
    dff #(32) dff_pc (pc, clk, 1'b1, pc_d);

    /*============================================================================================
    Module instantiation for DFF OP Codes
    ============================================================================================*/
    wire [9:0][4:0] op_d, op_d_d;
    dff #(50) dff_op1 (op, clk, 1'b1, op_d);
    dff #(50) dff_op2 (op_d, clk, 1'b1, op_d_d);

    /*============================================================================================
    Module instantiation for DFF Operand data
    ============================================================================================*/
    wire [13:0][31:0] operandData_d;
    dff #(14*32) dff_opData (operandData, clk, 1'b1, operandData_d);

    /*============================================================================================
    Module instantiation for DFF Memory data
    ============================================================================================*/
    wire [2:0][53:0]memoryData_d;
    delay #(2, 54*3) delay_mem (clk, memoryData, memoryData_d);

    /*============================================================================================
    Output Pipeline 
    ============================================================================================*/
    wire [7:0][4:0] out_d;
    dff #(8*5) dff_out (out, clk, 1'b1, out_d);

    /*============================================================================================
    Processor Pipeline
    ============================================================================================*/
    
    always @(*) begin

        /*========================================================================================
        Instruction Fetch (IF)
        ========================================================================================*/
        
        rf.registerFile[31] = pc;
        currentInst = inst[pc];
        pc = pc + 1'b1;

        /*========================================================================================
        Instruction Decode (ID)
        ========================================================================================*/
        
        // ADD0 ID

        add0_inst = currentInst[0];
        op[0] = add0_inst[31:27];
        out[0] = add0_inst[26:22];
        rf.readReg(add0_inst[21:17], operandData[0]);
        rf.readReg(add0_inst[16:12], operandData[1]);
        
        // ADD1 ID

        add1_inst = currentInst[1];
        op[1] = add1_inst[31:27];
        out[1] = add1_inst[26:22];
        rf.readReg(add1_inst[21:17], operandData[2]);
        rf.readReg(add1_inst[16:12], operandData[3]);
        
        // MUL ID
        
        mul_inst = currentInst[2];
        op[2] = mul_inst[31:27];
        out[2] = mul_inst[26:22];
        out[3] = mul_inst[21:17];
        rf.readReg(mul_inst[16:12], operandData[4]);
        rf.readReg(mul_inst[11:7], operandData[5]);
        
        // FADD0 ID
        
        fadd0_inst = currentInst[3];
        op[3] = fadd0_inst[31:27];
        out[4] = fadd0_inst[26:22];
        rf.readReg(fadd0_inst[21:17], operandData[6]);
        rf.readReg(fadd0_inst[16:12], operandData[7]);
        
        // // FADD1 ID
        
        fadd1_inst = currentInst[4];
        op[4] = add1_inst[31:27];
        out[5] = fadd1_inst[26:22];
        rf.readReg(fadd1_inst[21:17], operandData[8]);
        rf.readReg(fadd1_inst[16:12], operandData[9]);
        
        
        // FMUL ID
        
        fmul_inst = currentInst[5];
        op[5] = fmul_inst[31:27];
        out[6] = fmul_inst[26:22];
        rf.readReg(fmul_inst[16:12], operandData[10]);
        rf.readReg(fmul_inst[11:7], operandData[11]);
        
        
        // LOGIC ID
        
        logic_inst = currentInst[6];
        op[6] = logic_inst[31:27];
        out[7] = logic_inst[26:22];
        rf.readReg(logic_inst[21:17], operandData[12]);
        rf.readReg(logic_inst[16:12], operandData[13]);
        
        
        // LOAD ID
        
        ldr_inst = currentInst[7];
        op[7] = ldr_inst[31:27];
        // dest, data
        memoryData[0] = {ldr_inst[26:22], ldr_inst[21:0]};
        
        
        // STORE ID
        
        str_inst = currentInst[8];
        op[8] = str_inst[31:27];
        rf.readReg(str_inst[4:0], str_data);
        // src, data
        memoryData[1] = {str_inst[26:5], str_data};
        
        // MOV ID
        
        mov_inst = currentInst[9];
        op[9] = mov_inst[31:27];
        // dest, data
        memoryData[2] = {mov_inst[26:22], mov_inst[21:0]};
        
        /*========================================================================================
        Execute (EX)
        ========================================================================================*/
        
        // ADD0 EX

        a0 = operandData_d[0];
        if (op_d[0][1] == 1'b1)
            b0 = ~operandData_d[1] + 1;
        else
            b0 = operandData_d[1];
        if (op_d[0][0] == 1'b1)
            cin0 = 1'b1;
        else
            cin0 = 1'b0;
        add0_out = out_d[0];

        // ADD1 EX

        a1 = operandData_d[2];
        if (op_d[1][1] == 1'b1)
            b1 = ~operandData_d[3] + 1;
        else
            b1 = operandData_d[3];
        if (op_d[1][0] == 1'b1)
            cin1 = 1'b1;
        else
            cin1 = 1'b0;
        add1_out = out_d[1];

        // MUL EX
        
        a2 = operandData_d[4];
        b2 = operandData_d[5];
        mul_out1 = out_d[2];
        mul_out2 = out_d[3];
        
        // FADD0 EX
        
        a3 = operandData_d[6];
        b3 = operandData_d[7];
        fadd0_out = out_d[4];

        // FADD1 EX

        a4 = operandData_d[8];
        b4 = operandData_d[9];
        fadd1_out = out_d[5];

        // FMUL EX

        a5 = operandData_d[10];
        b5 = operandData_d[11];
        fmul_out = out_d[6];
        
        // LOGIC EX
        
        a6 = operandData_d[12];
        b6 = operandData_d[13];
        sel = op_d[6];
        logic_out = out_d[7];

        /*========================================================================================
        Memory Access (MEM)
        ========================================================================================*/
        
        // LDR MEM

        mem.readMem(memoryData_d[0][21:0], data0);
        if (op_d_d[7] == 5'b10010)
            rf.writeReg(memoryData_d[0][26:22], data0);
        
        // STR MEM
        if (op_d_d[8] == 5'b10011)
            mem.writeMem(memoryData_d[1][53:32], memoryData_d[1][31:0]);
    
        // MOV MEM
        if (op_d_d[9] == 5'b10100)
            rf.writeReg(memoryData_d[2][26:22], memoryData_d[2][21:0]);

        /*========================================================================================
        Write Back (WB)
        ========================================================================================*/
        
        // ADD0 WB
        
        rf.writeReg(add0_out_d, out0);

        // ADD1 WB

        rf.writeReg(add1_out_d, out1);
        
        // MUL WB
        
        rf.writeReg(mul_out1_d, out2[63:32]);
        rf.writeReg(mul_out2_d, out2[31:0]);

        // FADD0 WB

        rf.writeReg(fadd0_out_d, out3);

        // FADD1 WB

        rf.writeReg(fadd1_out_d, out4);

        // FMUL WB
        
        rf.writeReg(fmul_out_d, out5);
        
        // LOGIC WB
        
        rf.writeReg(logic_out, out6);

        rf.registerFile[0] = 32'b0;
    end

endmodule
