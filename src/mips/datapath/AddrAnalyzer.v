`include "..\\public.v"
module AddrAnalyzer(din, NowDevice);
    input [31:0] din;
	output NowDevice;
	
	assign NowDevice = (din >= 'h0000_0000 && din <= 'h0000_2FFF) ? `NOWDEVICE_MEMO : 
						(din >= 'h0000_7F00 && din <= 'h0000_7FE0) ? `NOWDEVICE_IO :
						'b0;

endmodule