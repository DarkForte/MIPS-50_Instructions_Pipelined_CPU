
module PC(clk, next_pc, pc_wr, pc_out, reset);
    input clk;
	input [31:2] next_pc;
	input reset;
	input pc_wr;
	output [31:2] pc_out;
	reg [31:2] pc_out;
	
	always@(posedge clk)
	begin
	    if(reset)
		    pc_out <= 30'h0000_3000 >>2 ;
		else if(pc_wr)
		    pc_out <= next_pc;
		
	end

endmodule
