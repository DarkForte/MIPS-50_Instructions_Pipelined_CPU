
module timecounter(CLK_I, RST_I, ADD_I, WE_I, DAT_I, DAT_O, IRQ, be);
    input CLK_I, RST_I;
    input [3:2] ADD_I;
	input WE_I;
	input [31:0] DAT_I;
	input [3:0] be;
	output [31:0] DAT_O;
	output IRQ;
	//reload:4 int_mask:3  mode:2~1 enable:0
	reg reload;
	reg int_mask;
	reg [2:1] mode;
	reg enable;
	
	reg [31:0] preset;
	reg [31:0] count;
	
	assign DAT_O = count;
	assign IRQ = (count == 0 && int_mask && enable);
	
	always@(posedge CLK_I or posedge RST_I)
	begin
	    if(RST_I)
		begin
		    int_mask = 0;
			mode = 2'b00;
			enable = 0;
			
			preset = 32'b0;
			count = 32'b0;
		end
		
		else
		begin
			
			if(enable)	
			begin
			    if(count == 0)
				    if(mode == 2'b01)
					    count = preset;
					else
					    count = 0;
				else
				    count = count-1;
			end
			
			if(WE_I)
				case(ADD_I)
					2'b00:	begin//ctrl reg
								if(be[0])
								begin
									reload = DAT_I[4];
									int_mask = DAT_I[3];
									mode = DAT_I[2:1];
									enable = DAT_I[0];
								end
							end
					
					2'b01: 	begin
								if(be[3])
									preset[31:24] = DAT_I[31:28];
								if(be[2])
									preset[23:16] = DAT_I[23:16];
								if(be[1])
									preset[15:8] = DAT_I[15:8];
								if(be[0])
									preset[7:0] = DAT_I[7:0];
								
								count = preset;
							end
				endcase
		end
	end

endmodule











