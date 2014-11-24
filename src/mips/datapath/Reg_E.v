
module Reg_E(clk, rst, we, clear, instr_e, PC_e, reg_num1_e, reg_num2_e, num32_e, InstrE, PCE, RegNum1E, 			RegNum2E, Num32E);
		
    input clk;
	input rst;
	input we;
	input clear;
	input [31:0] instr_e;
	input [31:2] PC_e;
	input [31:0] reg_num1_e;
	input [31:0] reg_num2_e;
	input [31:0] num32_e;
	
	output [31:0] InstrE;
	output [31:2] PCE;
	output [31:0] RegNum1E;
	output [31:0] RegNum2E;
	output [31:0] Num32E;
	
	reg [31:0] instr_reg;
	reg [31:2] PC_reg;
	reg [31:0] reg_num1_reg;
	reg [31:0] reg_num2_reg;
	reg [31:0] num32_reg;
	
	assign InstrE = instr_reg;
	assign PCE = PC_reg;
	assign RegNum1E = reg_num1_reg;
	assign RegNum2E = reg_num2_reg;
	assign Num32E = num32_reg;

    always@(posedge clk)
    begin
	    if(rst || clear)
		begin
		    instr_reg = 32'b0;
			PC_reg = 30'b0;
			reg_num1_reg = 32'b0;
			reg_num2_reg = 32'b0;
			num32_reg = 32'b0;
		end
		else if(we)
		begin
			instr_reg = instr_e;
			PC_reg = PC_e;
			reg_num1_reg = reg_num1_e;
			reg_num2_reg = reg_num2_e;
			num32_reg = num32_e;
		end
    end	
	
endmodule


