
module Comparer(num1, num2, zero, pos);
    input signed [31:0] num1;
	input signed [31:0] num2;
	output zero;
	output pos;
	
	assign zero = (num1 == num2) ? 1:0;
	assign pos = (num1 > num2 ) ? 1:0;

endmodule