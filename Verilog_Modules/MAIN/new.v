thegamingbot
#7412
strange, bugttchi

bugttchi — 03/20/2021
cuz PK said Sharan mailed noor and he said some packet something n all
anyway I asked Sharan too
thegamingbot — 03/20/2021
yea like u gotta give multiple instructions at the same time na
so u create a packet of thos inst n pass it to verilog
bugttchi — 03/20/2021
avo thaana?
that we will do by rewriting the files ig
thegamingbot — 03/20/2021
rewriting what files?
bugttchi — 03/20/2021
the .v file
thegamingbot — 03/20/2021
Ya
bugttchi — 03/20/2021
like that's the only way to take input na
thegamingbot — 03/20/2021
ya
modifying the testbenches
bugttchi — 03/20/2021
haan
okk
cool cool
so still same as planned
thegamingbot — 03/20/2021
ya
till now
bugttchi
 started a call that lasted an hour.
 — 03/22/2021
bugttchi
 started a call that lasted an hour.
 — 03/22/2021
strange — 03/22/2021
https://www.google.co.in/search?q=encoder+for+processor+opcode&source=lnms&tbm=isch&sa=X&ved=2ahUKEwimz5jXwcPvAhWWILcAHWs8CG0Q_AUoAXoECAEQAw&biw=1879&bih=939#imgrc=gzkwlGnlyDITeM

strange
 started a call that lasted 31 minutes.
 — 03/22/2021
bugttchi — 03/22/2021
1 sec
strange
 started a call that lasted 3 hours.
 — 04/11/2021
strange — 04/11/2021
xD
np xD
thegamingbot — 04/11/2021
// Arithmatic Instructions
00000 ADD  Rd, Rs1, Rs2         Addition
00001 ADC  Rd, Rs1, Rs2         Addition with carry
00010 SUB  Rd, Rs1, Rs2         Subtraction
00011 SBB  Rd, Rs1, Rs2         Subtraction with borrow
00100 MUL  Rd1, Rd2, Rs1, Rs2   Multiplication
00101 FPA  Rd, Rs1, Rs2         Floating Addition
00110 FAC  Rd, Rs1, Rs2         Floating Addition with carry
00111 FPS  Rd, Rs1, Rs2         Floating Subtraction
01000 FSB  Rd, Rs1, Rs2         Floating Subtraction with borrow
01001 FPM  Rd, Rs1, Rs2         Floating Multiplication
// Logical Instructions
01010 AND  Rd, Rs1, Rs2         Bitwise AND
01011 OR   Rd, Rs1, Rs2         Bitwise OR
01100 XOR  Rd, Rs1, Rs2         Bitwise XOR
01101 NAND Rd, Rs1, Rs2         Bitwise NAND
01110 NOR  Rd, Rs1, Rs2         Bitwise NOR
01111 XNOR Rd, Rs1, Rs2         Bitwise XNOR
10000 NOT  Rd, Rs1, Rs2         Bitwise NOT
10001 TCM  Rd, Rs1, Rs2         2s Complement
// Memory Instructions
10010 LDR  Rd, Rs               Load
10011 STR  Rd, Rs               Store
11111 HLT                       Halt
thegamingbot
 started a call that lasted an hour.
 — 04/15/2021
thegamingbot
 started a call that lasted a minute.
 — 04/18/2021
thegamingbot
 started a call that lasted an hour.
 — 04/18/2021
thegamingbot — 04/18/2021
ADD R2 R1 R3
SUB R4 R2 R6
MUL R8 R19 R15 R10
LDR R4 #4000
ADD R23 R2 R24
ADD R2 R2 R8
MOV R8 R10
ADD R5 R1 R4
STR R3 R22
strange — 04/18/2021

thegamingbot
 started a call that lasted 3 hours.
 — 04/18/2021
thegamingbot — 04/18/2021
Attachment file type: archive
VLIW-Architecture.zip
5.89 MB
thegamingbot — 04/19/2021
https://thegamingbot.github.io/thegamingbot/
Sai Kaushik S
bugttchi — 04/19/2021
https://thesrsakabuvttchi.github.io/website/
strange — 04/19/2021
Ahh shit , here we go again :slight_smile:
bugttchi
 started a call that lasted 4 hours.
 — 04/19/2021
thegamingbot — 04/19/2021
1. The L1 data cache is checked. If it holds the data requested, the data is returned.
2. If the data is not in the L1 cache, the victim cache is checked. If it holds the data requested,
the data is moved into the L1 cache and sent back to the processor. The data evicted from the
L1 cache is put in the victim cache, and put at the end of the FIFO replacement queue.
3. If neither of the caches holds the data, it is retrieved from memory, and put in the L1 cache.
If the L1 cache needs to evict old data to make space for the new data, the old data is put in
the victim cache and placed at the end of the FIFO replacement queue. Any data that needs to
be evicted from the victim cache to make space is written back to memory or discarded, if
unmodified.
Note that the two caches are exclusive. That means that the same data cannot be stored in both
L1 and victim caches at the same time.
thegamingbot — 04/19/2021
https://www3.ntu.edu.sg/home/smitha/ParaCache/Paracache/dmc.html
Direct Mapped Cache Simulator
strange — 04/19/2021

8*8 bytes
bugttchi — 04/19/2021

strange — 04/19/2021
my calc for q1 (i) 3 X 2^20 (ii) 3 x 2^16
what you got
tk asking
strange — 04/19/2021
voice still breaking
thegamingbot — 04/19/2021
Q02.pdf
Attachment file type: acrobat
Q02.pdf
317.06 KB
strange — 04/19/2021

bugttchi — 04/19/2021


strange — 04/19/2021

bugttchi
 started a call.
 — Today at 21:04
thegamingbot — Today at 21:10
https://stackoverflow.com/questions/287871/how-to-print-colored-text-to-the-terminal
Stack Overflow
How to print colored text to the terminal?
How can I output colored text to the terminal in Python?

strange — Today at 21:12

thegamingbot — Today at 21:42
A=11010111111111011011100010101111         B=11010111111111011011100010110000
strange — Today at 21:48

bugttchi — Today at 21:52
`include "Mul.v"
`include "swap.v"
`include "shifters.v"
`include "split.v"
`include "triArr.v"
`include "cla.v"


module top;

    reg [31:0] I1,I2;
    wire [31:0]out,outbuff2;
    reg clk;

    wire [31:0]A,B;
    Swap SW1(I1,I2,A,B);

    wire S1,S2;
    wire [7:0] E1,E2;
    wire [22:0] M1,M2;

    Split SP1(A,S1,E1,M1);
    Split SP2(B,S2,E2,M2);

    // Summing up the Exponents
    wire [31:0]Ednm,Eout,Eoutbuff,Eoutbuff1;
    wire  Carr;
    CLA CL1(clk,Ednm,Carr,{24'b0,E1},{24'b0,E2},1'b0); 
    CLA CL2(clk,Eout,Carr,Ednm,~(32'd127),1'b1);

    clockDelay #(13,32) cd1 (clk,Eout,Eoutbuff);    

    wire [31:0]N1,N2;
    wire [63:0]P,Pbuff;
    assign N1 = {|E1,M1};
    assign N2 = {|E2,M2};

    WallaceMul Wm(clk,N1,N2,P);

    clockDelay #(12,64) cd2 (clk,P,Pbuff);

    // A is is inf or NAN and B is not zero
    TriArr T1(A,&E1 & |B[30:0],outbuff2);

    // B is zero and A is Not INF or NAN
    TriArr T2(B,~(|B[30:0]) & ~&E1,outbuff2);

    // A is INF or NAN and B is zero
    TriArr T3({32{1'b1}},&E1 & ~(|B[30:0]),outbuff2);

    clockDelay #(25,32) cd4 (clk,outbuff2,out);

    //Case of overflow(no inf/NAN/zero/Denormal)
    wire [31:0]EoutShift;
    CLA CL3(clk,EoutShift,Carr,Eoutbuff,32'b1,1'b0);
    TriArr T4({S1^S2,EoutShift[7:0],Pbuff[46:24]},Pbuff[47] & ~(&E1 | ~(|B[30:0])),out);

    //Normal Case (no inf/NAN/zero/Denormal)
    clockDelay #(4,32) cd3 (clk,Eoutbuff,Eoutbuff1);
    TriArr T5({S1^S2,Eoutbuff1[7:0],Pbuff[45:23]},~Pbuff[47] & Pbuff[46] & ~(&E1 | ~(|B[30:0])),out);

    integer j;
    initial 
    begin
        #0 clk = 0;
        for(j=0;j<500;j++)
            #5 clk = ~clk;
    end

    initial
    begin
        // case infinity and zero (out = NAN)
        #0 I2={1'b0,{8{1'b1}},23'b0}; I1=32'b0;     

        // 2 , 9
        #10 I1 = 32'b01000000000000000000000000000000; I2 = 32'b01000001000100000000000000000000;

        //1.234 , 63.201 = 77.990034 
        #10 I1=32'b00111111100111011111001110110110; I2=32'b01000010011111001100110111010011;

        #10 I1=32'b11010111111111011011100010101111;  I2=32'b11010111111111011011100010110000;
    end
    initial
    begin
        $monitor($time, " A=%b B=%b\tC=%b\n",I1,I2,out);
   end

endmodule
Collapse
message.txt
3 KB
﻿
`include "Mul.v"
`include "swap.v"
`include "shifters.v"
`include "split.v"
`include "triArr.v"
`include "cla.v"


module top;

    reg [31:0] I1,I2;
    wire [31:0]out,outbuff2;
    reg clk;

    wire [31:0]A,B;
    Swap SW1(I1,I2,A,B);

    wire S1,S2;
    wire [7:0] E1,E2;
    wire [22:0] M1,M2;

    Split SP1(A,S1,E1,M1);
    Split SP2(B,S2,E2,M2);

    // Summing up the Exponents
    wire [31:0]Ednm,Eout,Eoutbuff,Eoutbuff1;
    wire  Carr;
    CLA CL1(clk,Ednm,Carr,{24'b0,E1},{24'b0,E2},1'b0); 
    CLA CL2(clk,Eout,Carr,Ednm,~(32'd127),1'b1);

    clockDelay #(13,32) cd1 (clk,Eout,Eoutbuff);    

    wire [31:0]N1,N2;
    wire [63:0]P,Pbuff;
    assign N1 = {|E1,M1};
    assign N2 = {|E2,M2};

    WallaceMul Wm(clk,N1,N2,P);

    clockDelay #(12,64) cd2 (clk,P,Pbuff);

    // A is is inf or NAN and B is not zero
    TriArr T1(A,&E1 & |B[30:0],outbuff2);

    // B is zero and A is Not INF or NAN
    TriArr T2(B,~(|B[30:0]) & ~&E1,outbuff2);

    // A is INF or NAN and B is zero
    TriArr T3({32{1'b1}},&E1 & ~(|B[30:0]),outbuff2);

    clockDelay #(25,32) cd4 (clk,outbuff2,out);

    //Case of overflow(no inf/NAN/zero/Denormal)
    wire [31:0]EoutShift;
    CLA CL3(clk,EoutShift,Carr,Eoutbuff,32'b1,1'b0);
    TriArr T4({S1^S2,EoutShift[7:0],Pbuff[46:24]},Pbuff[47] & ~(&E1 | ~(|B[30:0])),out);

    //Normal Case (no inf/NAN/zero/Denormal)
    clockDelay #(4,32) cd3 (clk,Eoutbuff,Eoutbuff1);
    TriArr T5({S1^S2,Eoutbuff1[7:0],Pbuff[45:23]},~Pbuff[47] & Pbuff[46] & ~(&E1 | ~(|B[30:0])),out);

    integer j;
    initial 
    begin
        #0 clk = 0;
        for(j=0;j<500;j++)
            #5 clk = ~clk;
    end

    initial
    begin
        // case infinity and zero (out = NAN)
        #0 I2={1'b0,{8{1'b1}},23'b0}; I1=32'b0;     

        // 2 , 9
        #10 I1 = 32'b01000000000000000000000000000000; I2 = 32'b01000001000100000000000000000000;

        //1.234 , 63.201 = 77.990034 
        #10 I1=32'b00111111100111011111001110110110; I2=32'b01000010011111001100110111010011;

        #10 I1=32'b11010111111111011011100010101111;  I2=32'b11010111111111011011100010110000;
    end
    initial
    begin
        $monitor($time, " A=%b B=%b\tC=%b\n",I1,I2,out);
   end

endmodule
