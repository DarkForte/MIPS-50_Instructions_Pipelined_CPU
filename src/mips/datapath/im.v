
module im_4k( clk, addr, dout ) ;
	input clk;
	input [12:2] addr ;  // address bus
	output [31:0] dout ;  // 32-bit memory output
	reg [31:0] im[2047:0] ;
	
	wire [12:2] pc_base = 11'd3072; //3072:C00 -> decimal
	assign dout = im[addr - pc_base];
	//IM_4B2K im(~clk, addr - pc_base, dout);

endmodule
