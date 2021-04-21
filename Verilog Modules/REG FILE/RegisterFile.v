/*
    A module that manages the register files
    Input: 32-bit number for writing (W), three 5-bit addresses (RA, RB for reading, RW for writing), 1-bit select for read / write, clock
    Output: Two 32-bit numbers read from the address RA and RB (A, B) 
*/
module RegisterFile();

    reg [31:0] registerFile [31:0];
    /*
        Initializing the register files with random numbers
    */
    task initialize;
        /*
            For each register index, assign a random 32-bit number
        */
        integer i;
        for (i = 0; i < 32; i = i + 1) begin : registerFileInit
            registerFile[i] = $random;
        end
    endtask
    /*
        Assign the value at addresses RA and RB to A and B
    */
    task readReg (input [4:0] RA, output [31:0] A); 
        A = registerFile[RA];
    endtask

    task writeReg (input [4:0] RW, input [31:0] W);
        registerFile[RW] = W;
    endtask

endmodule
