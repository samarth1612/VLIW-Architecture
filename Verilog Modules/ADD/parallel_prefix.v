module parallel_prefix (
	input [1:0]  in, input [1:0] in_carry, output reg [1:0] out_carry
); 
	always@(in, in_carry)
	begin
		if( in == 2'b00 || in == 2'b11)
			assign out_carry = in;
		else
			assign out_carry = in_carry;
	end
	
endmodule
