
`include "..\\public.v"
//synthesis loop_limit 4000
module ALU(command, num1, num2, ALUShift, res);
    input [3:0] command;
	input signed [31:0] num1;
	input signed [31:0] num2;
	input [4:0] ALUShift;
	output signed [31:0] res;
	reg signed [31:0]res;
	
	
	always @(*)
	begin
	    case (command)
			`ADD: 	res = num1 + num2;
			`ADDU: 	res = num1 + num2;
			`SUB: 	res = num1 - num2;
			`SUBU: 	res = num1 - num2;
			`SLL: 	res = num2 << ALUShift;
			`SRL: 	res = num2 >> ALUShift;
			`SRA: 	res = num2 >>> ALUShift;
			`AND:	res = num1 & num2;
			`OR:	res = num1 | num2;
			`XOR: 	res = num1 ^ num2;
			`NOR: 	res = ~(num1 | num2);
			`SLT:	res = (num1 < num2) ? 1:0;
			`SLTU:	res = ( {1'b0, num1} < {1'b0, num2} ) ? 1:0;
		endcase
			    
	end
				

endmodule


