
module Numbers(clk, din, we, dout1, dout2, sel1, sel2);
    input clk;
	input [31:0] din;
	input we;
	
	output [7:0] dout1;
	output [7:0] dout2;
	output [4:1] sel1;
	output [4:1] sel2;
	
	DigiNumber u_diginumber1(clk, din[31:16], we, sel1, dout1);
	DigiNumber u_diginumber2(clk, din[15:0] , we, sel2, dout2);
endmodule