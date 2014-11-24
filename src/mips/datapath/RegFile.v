
module RegFile(clk, we, reset, w_adrs, w_data, adrs1, adrs2, data1, data2);

    input clk;
	input we;
	input reset;
	input [4:0] w_adrs;
	input [31:0] w_data;
	
	input [4:0] adrs1;
	input [4:0] adrs2;
	
	output [31:0] data1;
	//reg [31:0] data1;
	output [31:0] data2;
	//reg [31:0] data2;
	
	reg [31:0] register[31:0];
	
	integer i;
	
	assign data1 = (w_adrs == adrs1 && w_adrs != 'd0) ? w_data : register[adrs1];
	assign data2 = (w_adrs == adrs2 && w_adrs != 'd0) ? w_data : register[adrs2];
	
	always @(posedge clk)
	begin
	    if(reset)
		begin
		    for(i=0;i<=31;i=i+1)
			    register[i] = 32'b0;
			register[28] = 32'h00001800;
			register[29] = 32'h00002ffc;
		end
	
	    else
		begin
			if(we)
			begin
			    if(w_adrs != 0)
					register[w_adrs] = w_data;
			end
			//data1 <= register[adrs1];
			//data2 <= register[adrs2];
		end
		
	end
	
endmodule
