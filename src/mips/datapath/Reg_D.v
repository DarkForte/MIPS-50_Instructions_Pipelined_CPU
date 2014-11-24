
module Reg_D(clk, rst, we, clear, instr_d, PC_d, InstrD, PCD);
    input [31:0] instr_d;
	input [31:2] PC_d;
	input clk;
	input rst;
	input we;
	input clear;
	
	output [31:0] InstrD;
	output [31:2] PCD;
	
	reg [31:0] instr_reg;
	reg [31:2] PC_reg;
	
	assign InstrD = instr_reg;
	assign PCD = PC_reg;
	
	always@(posedge clk)
	begin
	    if(rst || clear)
		begin
		    instr_reg = 32'b0;
			PC_reg = 30'b0;
		end
	    else if(we)
		begin
			instr_reg = instr_d;
			PC_reg = PC_d;
		end
	end
    
endmodule

