
module dm_4k( addr, be, din, we, clk, dout ) ;
	input [13:2] addr ;  // address bus
	input [3:0] be;
	input [31:0] din ;  // 32-bit input data
	input we ;  // memory write enable
	input clk ;  // clock
	output [31:0] dout ;  // 32-bit memory output
	
	reg [31:0] dm[3071:0] ;

	assign dout = dm[addr];
	always@(posedge clk)
	begin
	    if(we)
		begin
		    case (be)
				4'b1111: dm[addr] = din;
				
				4'b1100: dm[addr][31:16] = din[15:0];
				4'b0011: dm[addr][15:0] = din[15:0];
				
				4'b1000: dm[addr][31:24] = din[7:0];
				4'b0100: dm[addr][23:16] = din[7:0];
				4'b0010: dm[addr][15:8] = din[7:0];
				4'b0001: dm[addr][7:0] = din[7:0];
			endcase
		end
	end
	
	/*wire [3:0] be_real;
	assign be_real[3] = be[3] & we;
	assign be_real[2] = be[2] & we;
	assign be_real[1] = be[1] & we;
	assign be_real[0] = be[0] & we;
	DM_4B4K dm_bram(~clk, be_real, addr, din, dout);*/

endmodule


