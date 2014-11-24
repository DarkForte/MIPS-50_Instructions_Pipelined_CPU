`include "..\\public.v"
module cp0(clk, rst, din, pc_in, we, HardInt, sel, EXLSet, EXLClr, IntReq, EPC_out, dout);
    input clk, rst;
	input we;// we is for MTC0
	input [31:0] din;
	input [31:2] pc_in;
	input [5:0] HardInt;
	input [4:0] sel;
	input EXLSet;//EXLSet = 1 means the system is ready to step in interrupt mode 
	input EXLClr;//EXLClr = 1 means the system is ready to exit interrupt mode
	
    output IntReq;
	output [31:2] EPC_out;
	output [31:0] dout;
	
	reg [31:2] EPC;
	reg [15:10] cause_hwint;
	reg EXL;
	reg int_enable;
	reg [15:10] int_mask;
	reg [31:0] PrID;
	
	assign IntReq = ( |(HardInt & int_mask) ) && int_enable && !EXL; 
	assign EPC_out = EPC;
	
	assign dout = (sel == `CP0_SR) ? {16'b0, int_mask, 8'b0, EXL, int_enable} :
				(sel == `CP0_CAUSE) ? {16'b0, cause_hwint, 10'b0} :
				(sel == `CP0_EPC) ? {EPC, 2'b0} :
				(sel == `CP0_PRID) ? PrID :
				32'd0;
	
	always@(posedge clk or posedge rst)
	begin
		//cause_hwint = HardInt;
	    if(rst)
		begin
		    EPC = 30'b0;
			cause_hwint = 6'b0;
			EXL = 0;
			int_enable = 1;
			int_mask = 6'b1;
			PrID = 32'h66047320;
		end
		else if(we)// normal write
		begin
		    case(sel)
			    `CP0_SR:
				begin
				    int_mask = din[15:10];
					EXL = din[1];
					int_enable = din[0];
				end
				`CP0_EPC: EPC = din[31:2];
				//`CP0_CAUSE: cause_hwint = din[15:10];
				`CP0_PRID: PrID = din;
			endcase
		end
		
		else if(EXLSet)// step in interrupt
		begin
		    EXL = 1;
			EPC = pc_in;
		end
		
		else if(EXLClr)// out from interrupt mode
		begin
		    EXL = 0;
			EPC = 32'b0;
		end
		
		
	end

endmodule









