`include "..\\public.v"

module Extender(num_16, sign, num_32);
    input [15:0] num_16;
	input sign;
	output [31:0] num_32;
	reg [31:0] num_32;
	
	always@(num_16, sign)
	begin
	    if(sign==`ZERO_EXT)
		    num_32 = {16'b0, num_16};
		else //sign == SIGN_EXT
		begin
		    if(num_16[15] == 1)
			    num_32 = {16'hFFFF, num_16};
			else
			    num_32 = {16'b0, num_16};
		end
	end
endmodule
