
module ireg(clk, ireg_wr, instr_in, instr_out);
    input clk;
	input ireg_wr;
	input [31:0] instr_in;
	output [31:0] instr_out;
	reg [31:0] instr_out;
	
	always@(posedge clk)
	begin
	    if(ireg_wr)
		    instr_out = instr_in;
	end
endmodule
