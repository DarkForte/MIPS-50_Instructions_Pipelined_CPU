`include "..\\public.v"

module NextPC(pc, imm_16, imm_26, imm_32, EPC_in, pc_source, pc_out);
    input [31:2] pc;
	input [15:0] imm_16;
	input [25:0] imm_26;
	input [31:0] imm_32;
	input [31:2] EPC_in;
	input [2:0] pc_source;
	output [31:2] pc_out;
	reg [31:2] pc_out;
	
	always@(*)
    begin
	    if(pc_source==`PC_NORMAL)
			pc_out = pc ;
			
		else if(pc_source == `PC_ADD)
			pc_out = pc - 1 + { { 14{imm_16[15]} }, imm_16};
		
		else if(pc_source == `PC_J)
		begin
			pc_out = {pc[31:28],imm_26};
		end
		
		else if(pc_source == `PC_JR)
		    pc_out = imm_32[31:2];
			
		else if(pc_source == `PC_EPC)
		    pc_out = EPC_in;
			
		else if(pc_source == `PC_ERROR)
		    pc_out = 32'h00004180 >>2 ;
		
		
	end
	
endmodule
