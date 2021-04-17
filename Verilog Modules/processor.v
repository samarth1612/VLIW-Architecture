`include "include.v"

module processor (input clk, output[255:0] ans);

    // Required parameters for the processor
    parameter instMemSize = 1024;
    parameter instSize = 320;
    
    // Insitantiation of the register file and memory nlock
    RegisterFile rf ();
    memory mem();

    // Required variables for the processor
    reg [instSize-1:0] inst [instMemSize-1:0];
    reg [31:0] pc;
    reg [0:9][31:0] currentInst;

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

    /*============================================================================================
    Module instantiation for Add 0 instruction
    ============================================================================================*/
    reg [31:0] a0, b0;
    wire [31:0] out0;
    wire cout0;
    add_32_rec_dub add0 (a0, b0, clk, out0, cout0);

    /*============================================================================================
    Module instantiation for Add 1 instruction
    ============================================================================================*/
    reg [31:0] a1, b1;
    wire [31:0] out1;
    wire cout1;
    add_32_rec_dub add1 (a1, b1, clk, out1, cout1);

    /*============================================================================================
    Module instantiation for Mul instruction
    ============================================================================================*/
    reg [31:0] a2, b2;
    wire [63:0] out2;
    wallace_tree_mul mul (a2, b2, clk, out2);

    /*============================================================================================
    Module instantiation for Fadd 0 instruction
    ============================================================================================*/
    reg [31:0] a3, b3;
    wire [31:0] out3;
    float_add fadd0 (a3, b3, clk, out3); 

    /*============================================================================================
    Module instantiation for Fadd 1 instruction
    ============================================================================================*/
    reg [31:0] a4, b4;
    wire [31:0] out4;
    float_add fadd1 (a4, b4, clk, out4); 

    /*============================================================================================
    Module instantiation for Fmul instruction
    ============================================================================================*/
    reg [31:0] a5, b5;
    wire [31:0] out5;
    float_mul fmul (a5, b5, clk, out5); 

    /*============================================================================================
    Module instantiation for Logic instruction
    ============================================================================================*/
    reg [31:0] a6, b6;
    wire [31:0] out6;
    reg [4:0] sel;
    logicUnit #(32) lu (a6, b6, sel, clk, out6);

    /*============================================================================================
    Module instantiation for Load instruction
    ============================================================================================*/
    reg [22:0] memAddr0;
    reg [4:0] regAddr0;
    reg [31:0] data0;
    
    /*============================================================================================
    Module instantiation for Store instruction
    ============================================================================================*/
    reg [22:0] memAddr1;
    reg [4:0] regAddr1;
    reg [31:0] data1;

    /*============================================================================================
    Module instantiation for Move instruction
    ============================================================================================*/
    reg [4:0] regAddr2;
    reg [31:0] data2;

    /*============================================================================================
    Module instantiation for DFF PC instruction
    ============================================================================================*/
    wire [31:0] pc_d;
    dff_n #(32) dff_pc (pc, clk, 1'b1, pc_d);

    /*============================================================================================
    Module instantiation for DFF OP Codes
    ============================================================================================*/
    wire [49:0] op_d;
    dff_n #(50) dff_op (op, clk, 1'b1, op_d);

    /*============================================================================================
    Module instantiation for DFF Output 
    ============================================================================================*/
    wire [255:0] out_d;
    dff_n #(256) dff_out (outData, clk, 1'b1, out_d);

    /*============================================================================================
    Processor Pipeline
    ============================================================================================*/
    
    /*--------------------------------REG Declarations for ID-----------------------------------*/
    reg [31:0] add0_inst, add0_op1Data, add0_op2Data;
    reg [4:0] add0_op1, add0_op2, add0_op, add0_out;
    
    reg [31:0] add1_inst, add1_op1Data, add1_op2Data;
    reg [4:0] add1_op1, add1_op2, add1_op, add1_out;

    reg [31:0] mul_inst, mul_op1Data, mul_op2Data;
    reg [4:0] mul_op1, mul_op2, mul_op, mul_out1, mul_out2;
    
    reg [31:0] fadd0_inst, fadd0_op1Data, fadd0_op2Data;
    reg [4:0] fadd0_op1, fadd0_op2, fadd0_op, fadd0_out;

    reg [31:0] fadd1_inst, fadd1_op1Data, fadd1_op2Data;
    reg [4:0] fadd1_op1, fadd1_op2, fadd1_op, fadd1_out;
    
    reg [31:0] fmul_inst, fmul_op1Data, fmul_op2Data;
    reg [4:0] fmul_op1, fmul_op2, fmul_op, fmul_out;
    
    reg [31:0] logic_inst, logic_op1Data, logic_op2Data;
    reg [4:0] logic_op1, logic_op2, logic_op, logic_out;
        
    reg [31:0] ldr_inst;
    reg [21:0] ldr_addr;
    reg [4:0] ldr_op, ldr_dest;
    
    reg [31:0] str_inst, str_data;
    reg [4:0] str_op1, str_op, str_src;
    
    reg [31:0] mov_inst;
    reg [21:0] mov_data;
    reg [4:0] mov_op, mov_dest;

    reg [49:0] op;

    /*--------------------------------REG Declarations for EX-----------------------------------*/
    reg [31:0] add0_op2_mem;
    
    reg [31:0] add1_op2_mem;

    reg [255:0] outData;

       
    /*--------------------------------REG Declarations for MEM----------------------------------*/
    reg[4:0] ldr_dest_mem;
    
    reg[4:0] str_src_mem;
    reg[31:0] str_data_mem;
    
    reg[4:0] mov_dest_mem;
    reg[31:0] mov_data_mem;


    /*--------------------------------REG Declarations for WB-----------------------------------*/
    wire [31:0] add0_out_mem;

    wire [31:0] add1_out_mem;

    wire [31:0] mul_out1_mem;
    wire [31:0] mul_out2_mem;

    wire [31:0] fadd0_out_mem;
    wire [31:0] fadd1_out_mem;

    wire [31:0] fmul_out_mem;
    
    wire [31:0] logic_out_mem;
    
    always @(*) begin
        /*========================================================================================
        Instruction Fetch (IF)
        ========================================================================================*/
        rf.registerFile[31] = pc_d;
        currentInst = inst[pc_d];
        pc = pc_d + 1;

        /*========================================================================================
        Instruction Decode (ID)
        ========================================================================================*/
        // ADD0 ID

        add0_inst = currentInst[0];
        add0_op = add0_inst[31:27];
        add0_out = add0_inst[26:22];
        add0_op1 = add0_inst[21:17];
        add0_op2 = add0_inst[16:12];
        rf.readReg(add0_op1, add0_op1Data);
        rf.readReg(add0_op2, add0_op2Data);
        mem.writeMem(0, add0_op1Data);
        mem.writeMem(1, add0_op2Data);
        mem.writeMem(2, add0_out);
        
        // ADD1 ID
        
        add1_inst = currentInst[1];
        add1_op = add1_inst[31:27];
        add1_out = add1_inst[26:22];
        add1_op1 = add1_inst[21:17];
        add1_op2 = add1_inst[16:12];
        rf.readReg(add1_op1, add1_op1Data);
        rf.readReg(add1_op2, add1_op2Data);
        mem.writeMem(3, add1_op1Data);
        mem.writeMem(4, add1_op2Data);
        mem.writeMem(5, add1_out);
        
        // MUL ID
        
        mul_inst = currentInst[2];
        mul_op = mul_inst[31:27];
        mul_out1 = mul_inst[26:22];
        mul_out2 = mul_inst[21:17];
        mul_op1 = mul_inst[16:12];
        mul_op2 = mul_inst[11:7];
        rf.readReg(mul_op1, mul_op1Data);
        rf.readReg(mul_op2, mul_op2Data);
        mem.writeMem(6, mul_op1Data);
        mem.writeMem(7, mul_op2Data);
        mem.writeMem(8, mul_out1);
        mem.writeMem(9, mul_out2);
        
        // FADD0 ID
        
        fadd0_inst = currentInst[3];
        fadd0_op = fadd0_inst[31:27];
        fadd0_out = fadd0_inst[26:22];
        fadd0_op1 = fadd0_inst[21:17];
        fadd0_op2 = fadd0_inst[16:12];
        rf.readReg(fadd0_op1, fadd0_op1Data);
        rf.readReg(fadd0_op2, fadd0_op2Data);
        mem.writeMem(10, fadd0_op1Data);
        mem.writeMem(11, fadd0_op2Data);
        mem.writeMem(12, fadd0_out);
        
        // FADD1 ID
        
        fadd1_inst = currentInst[4];
        fadd1_op = add1_inst[31:27];
        fadd1_out = fadd1_inst[26:22];
        fadd1_op1 = fadd1_inst[21:17];
        fadd1_op2 = fadd1_inst[16:12];
        rf.readReg(fadd1_op1, fadd1_op1Data);
        rf.readReg(fadd1_op2, fadd1_op2Data);
        mem.writeMem(13, fadd1_op1Data);
        mem.writeMem(14, fadd1_op2Data);
        mem.writeMem(15, fadd1_out);
        
        
        // FMUL ID
        
        fmul_inst = currentInst[5];
        fmul_op = fmul_inst[31:27];
        fmul_out = fmul_inst[26:22];
        fmul_op1 = fmul_inst[16:12];
        fmul_op2 = fmul_inst[11:7];
        rf.readReg(fmul_op1, fmul_op1Data);
        rf.readReg(fmul_op2, fmul_op2Data);
        mem.writeMem(16, fmul_op1Data);
        mem.writeMem(17, fmul_op2Data);
        mem.writeMem(18, fmul_out);
        
        // LOGIC ID
        
        logic_inst = currentInst[6];
        logic_op = logic_inst[31:27];
        logic_out = logic_inst[26:22];
        logic_op1 = logic_inst[21:17];
        logic_op2 = logic_inst[16:12];
        rf.readReg(logic_op1, logic_op1Data);
        rf.readReg(logic_op2, logic_op2Data);
        mem.writeMem(19, logic_op1Data);
        mem.writeMem(20, logic_op2Data);
        mem.writeMem(21, logic_out);
        
        // LOAD ID
        
        ldr_inst = currentInst[7];
        ldr_op = ldr_inst[31:27];
        ldr_dest = ldr_inst[26:22];
        ldr_addr = ldr_inst[21:0];
        mem.writeMem(22, ldr_addr);
        mem.writeMem(23, ldr_dest);
        
        // STORE ID
        
        str_inst = currentInst[8];
        str_op = str_inst[31:27];
        str_src = str_inst[26:5];
        str_op1 = str_inst[4:0];
        rf.readReg(str_op1, str_data);
        mem.writeMem(24, str_data);
        mem.writeMem(25, str_src);
        
        // MOV ID
        
        mov_inst = currentInst[9];
        mov_op = mov_inst[31:27];
        mov_dest = mov_inst[26:22];
        mov_data = mov_inst[21:0];
        mem.writeMem(26, mov_data);
        mem.writeMem(27, mov_dest);

        op = {add0_op, add1_op, mul_op, fadd0_op, fadd1_op, fmul_op, logic_op, ldr_op, str_op, mov_op};
        /*========================================================================================
        Execute (EX)
        ========================================================================================*/
        // ADD0 EX
        mem.readMem(0, a0);
        mem.readMem(1, add0_op2_mem);
        if (op_d[46] == 1'b1)
            b0 = ~add0_op2_mem + 1;
        else
            b0 = add0_op2_mem;

        // ADD1 EX
        mem.readMem(3, a1);
        mem.readMem(4, add1_op2_mem);
        if (op_d[46] == 1'b1)
            b1 = ~add1_op2_mem + 1;
        else
            b1 = add1_op2_mem;

        // MUL EX
        mem.readMem(6, a2);
        mem.readMem(7, b2);

        // FADD0 EX
        mem.readMem(10, a3);
        mem.readMem(11, b3);

        // FADD1 EX
        mem.readMem(13, a4);
        mem.readMem(14, b4);

        // FMUL EX
        mem.readMem(16, a5);
        mem.readMem(17, b5);

        // LOGIC EX
        sel = op_d[19:15];
        mem.readMem(19, a6);
        mem.readMem(20, b6);

        outData = {out0, out1, out2, out3, out4, out5, out6};

        /*========================================================================================
        Memory Access (MEM)
        ========================================================================================*/
        // LDR MEM

        mem.readMem(22, ldr_addr_mem);
        mem.readMem(23, ldr_dest_mem);
        mem.readMem(ldr_addr_mem, data0);
        rf.writeReg(ldr_dest_mem, data0);
        
        // STR MEM

        mem.readMem(24, str_src_mem);
        mem.readMem(25, str_data_mem);
        mem.writeMem(str_src_mem, str_data_mem);
    
        // MOV MEM

        mem.readMem(26, mov_data_mem);
        mem.readMem(27, mov_dest_mem);
        rf.writeReg(mov_dest_mem, mov_data_mem);

        /*========================================================================================
        Write Back (WB)
        ========================================================================================*/
        // ADD0 WB
        
        mem.readMem(2, add0_out_mem);
        rf.writeReg(add0_out_mem, out_d[255:224]);

        // ADD1 WB

        mem.readMem(5, add1_out_mem);
        rf.writeReg(add0_out_mem, out_d[223:192]);
        
        // MUL WB
        
        mem.readMem(8, mul_out1_mem);
        rf.writeReg(add0_out_mem, out_d[191:160]);
        mem.readMem(9, mul_out2_mem);
        rf.writeReg(add0_out_mem, out_d[159:128]);

        // FADD0 WB

        mem.readMem(12, fadd0_out_mem);
        rf.writeReg(add0_out_mem, out_d[127:96]);

        // FADD1 WB

        mem.readMem(15, fadd1_out_mem);
        rf.writeReg(add0_out_mem, out_d[95:64]);

        // FMUL WB
        
        mem.readMem(18, fmul_out_mem);
        rf.writeReg(add0_out_mem, out_d[63:32]);
        
        // LOGIC WB
        
        mem.readMem(21, logic_out_mem);
        rf.writeReg(add0_out_mem, out_d[31:0]);
    end

    assign ans = out_d;

endmodule
