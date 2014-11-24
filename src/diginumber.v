
module DigiNumber(clk, din, we, sel, dout);
    input clk;
	input [15:0] din;
	input we;
	output [4:1] sel;
	output [7:0] dout;
	
	reg [3:0] inner_d [3:0];
	reg [4:1] sel;
	
	wire [3:0] now_num;
	
	assign now_num = (sel[1]) ? inner_d[0] :
				(sel[2]) ? inner_d[1] :
				(sel[3]) ? inner_d[2] :
				(sel[4]) ? inner_d[3] :
				4'b0;
	
	assign dout = (now_num == 4'h0) ? ~(8'b11111100) :
					(now_num == 4'h1) ? ~(8'b01100000):
					(now_num == 4'h2) ? ~(8'b11011010):
					(now_num == 4'h3) ? ~(8'b11110010):
					(now_num == 4'h4) ? ~(8'b01100110):
					(now_num == 4'h5) ? ~(8'b10110110):
					(now_num == 4'h6) ? ~(8'b10111110):
					(now_num == 4'h7) ? ~(8'b11100000):
					(now_num == 4'h8) ? ~(8'b11111110):
					(now_num == 4'h9) ? ~(8'b11110110):
					(now_num == 4'hA) ? ~(8'b11101110):
					(now_num == 4'hB) ? ~(8'b00111110):
					(now_num == 4'hC) ? ~(8'b10011100):
					(now_num == 4'hD) ? ~(8'b01111010):
					(now_num == 4'hE) ? ~(8'b10011110):
					(now_num == 4'hF) ? ~(8'b10001110):
					8'b11111111;
	
	
	always@(posedge clk)
	begin
	    case(sel)
		    4'b0001: sel<=4'b1000;
			4'b0010: sel<=4'b0001;
			4'b0100: sel<=4'b0010;
			4'b1000: sel<=4'b0100;
			default: sel<=4'b1000;
		endcase
		
		if(we)
		begin
		    inner_d[3] <= din[15:12];
			inner_d[2] <= din[11:8];
			inner_d[1] <= din[7:4];
			inner_d[0] <= din[3:0];
		end 
		
		
	end
endmodule