
`include "..\\public.v"

module testbench();
	reg clk, reset;
	reg [31:0] din;
	mini_machine U_MINI_MACHINE(clk, reset, din, dout1, dout2, sel1, sel2);
	//mips the_mips(clk, ~reset, CPUAddr, BE, CPUIn, CPUOut, IOWe, clk_out, HardInt_in);
	
	initial 
	begin
	    clk=0;
		reset=1;
		din = 0;
		#10 reset=0;
		#70 reset=1;
		$readmemh("..\\code.txt", U_MINI_MACHINE.U_MIPS.the_IM.im);
		//$readmemh("..\\code_handler.txt", U_MINI_MACHINE.U_MIPS.the_IM.im, 1120); 
		//1120: 4180h >>2 - C00(3000>>2) and then to decimal
		//$display(U_MINI_MACHINE.U_MIPS.the_IM.im[0]);
		//$display(U_MINI_MACHINE.U_MIPS.the_IM.im[1120]);
		//$display(U_MINI_MACHINE.U_MIPS.pc_out);
		
		//#1000 din = 12345;
	
	end
	
	always
	    #(50) clk = ~clk;	
	
	//always
		//#(1000) din = din+1;
endmodule







