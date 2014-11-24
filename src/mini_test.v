module mini_test(clk, din, dout1, dout2, sel1, sel2);
	input clk;
	wire real_clk;
	input [31:0] din;
	output [7:0] dout1;
	output [7:0] dout2;
	output [4:1] sel1;
	output [4:1] sel2;
	wire [31:0] data;
	wire we=1;
	//wire [15:0] din;
	clk_50to10 clk_changer(clk,real_clk);
    Switches switches(din, data);
	DigiNumber diginumber1(real_clk, data[31:16], we, sel1, dout1);
	DigiNumber diginumber2(real_clk, data[15:0] , we, sel2, dout2);
endmodule