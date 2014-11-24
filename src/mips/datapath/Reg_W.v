
module Reg_W(clk, rst, instr_w, PC_w, aluout_w, memout_w, hiout_w, loout_w, cp0out_w, InstrW, PCW, AluOutW, MemOutW, HiOutW, LoOutW, CP0outW); // no clear or we in W.
    input clk;
	input rst;
	input [31:0] instr_w;
	input [31:2] PC_w;
	input [31:0] aluout_w;
	input [31:0] memout_w;
	input [31:0] hiout_w;
	input [31:0] loout_w;
	input [31:0] cp0out_w;
	
	output [31:0] InstrW;
	output [31:2] PCW;
	output [31:0] AluOutW;
	output [31:0] MemOutW;
	output [31:0] HiOutW;
	output [31:0] LoOutW;
	output [31:0] CP0outW;
	
	reg [31:0] instr_reg;
	reg [31:2] PC_reg;
	reg [31:0] aluout_reg;
	reg [31:0] memout_reg;
	reg [31:0] hiout_reg;
	reg [31:0] loout_reg;
	reg [31:0] cp0out_reg;
	
	assign InstrW = instr_reg;
	assign PCW = PC_reg;
	assign AluOutW = aluout_reg;
	assign MemOutW = memout_reg;
	assign HiOutW = hiout_reg;
	assign LoOutW = loout_reg;
	assign CP0outW = cp0out_reg;
	
	always@(posedge clk)
	begin
	    if(rst)
		begin
		    instr_reg = 32'b0;
			PC_reg = 30'b0;
			aluout_reg = 32'b0;
			memout_reg = 32'b0;
			hiout_reg = 32'b0;
			loout_reg = 32'b0;
			cp0out_reg = 32'b0;
		end
		else 
		begin
		    instr_reg = instr_w;
			PC_reg = PC_w;
			aluout_reg = aluout_w;
			memout_reg = memout_w;
			hiout_reg = hiout_w;
			loout_reg = loout_w;
			cp0out_reg = cp0out_w;
		end
	    
	end
endmodule










