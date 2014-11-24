
module Reg_M(clk, rst, we, clear, instr_m, PC_m, reg_num2_m, aluout_m, hiout_m, loout_m, cp0out_m, InstrM, PCM, RegNum2M, AluOutM, HiOutM, LoOutM, CP0outM);
    input clk;
	input rst;
	input clear;
	input we;
	input [31:0] instr_m;
	input [31:2] PC_m;
	input [31:0] reg_num2_m;
	input [31:0] aluout_m;
	input [31:0] hiout_m;
	input [31:0] loout_m;
	input [31:0] cp0out_m;
	
	output [31:0] InstrM;
	output [31:2] PCM;
	output [31:0] RegNum2M;
	output [31:0] AluOutM;
	output [31:0] HiOutM;
	output [31:0] LoOutM;
	output [31:0] CP0outM;
	
	reg [31:0] instr_reg;
	reg [31:2] PC_reg;
	reg [31:0] regnum2_reg;
	reg [31:0] aluout_reg;
	reg [31:0] hiout_reg;
	reg [31:0] loout_reg;
	reg [31:0] cp0out_reg;
	
	assign InstrM = instr_reg;
	assign PCM = PC_reg;
	assign RegNum2M = regnum2_reg;
	assign AluOutM = aluout_reg;
	assign HiOutM = hiout_reg;
	assign LoOutM = loout_reg;
	assign CP0outM = cp0out_reg;
	
	always@(posedge clk)
	begin
	    if(rst || clear)
		begin
		    instr_reg = 32'b0;
			PC_reg = 30'b0;
			regnum2_reg = 32'b0;
			aluout_reg = 32'b0;
			hiout_reg = 32'b0;
			loout_reg = 32'b0;
			cp0out_reg = 32'b0;
		end
		else if(we)
		begin
			instr_reg = instr_m;
			PC_reg = PC_m;
			regnum2_reg = reg_num2_m;
			aluout_reg = aluout_m;
			hiout_reg = hiout_m;
			loout_reg = loout_m;
			cp0out_reg = cp0out_m;
		end
		
	end
endmodule








