module testbench_minitest();
    reg clk;
	mini_test U_mini_test(clk);
	
	initial 
	begin
	    clk=0;
		assign U_mini_test.din = 32'h12345678;
	end   
	
	always
	    #(50) clk = ~clk;
endmodule