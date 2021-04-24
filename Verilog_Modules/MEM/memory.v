module memory #(
    parameter size = 2**22
) ();

    reg [31:0] mem [size-1:0];

    task initialize;
        /*
            For each memory index, assign a random 32-bit number
        */
        integer i;
        for (i = 0; i < size; i = i + 1) begin : memoryInit
            mem[i] = i;
        end
    endtask

    task readMem (input [$clog2(size)-1:0] idx, output [31:0] A);
        begin
            A = mem[idx];
        end
    endtask

    task writeMem (input [$clog2(size)-1:0] idx, input [31:0] A);
        begin
            mem[idx] = A;
        end
    endtask

endmodule
