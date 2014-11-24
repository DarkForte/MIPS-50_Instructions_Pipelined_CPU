`include "..\\public.v"
module HILO(clk, A_din, B_din, hilo_op, hilo_we, Hi_out, Lo_out);
    input clk;
	input signed [31:0] A_din;
	input signed [31:0] B_din;
	input [2:0] hilo_op;
	input hilo_we;
	
	output signed [31:0] Hi_out;
	output signed [31:0] Lo_out;
	
	reg [31:0] Hi;
	reg [31:0] Lo;
	
	reg [63:0] tmp;
	
	assign Hi_out = Hi;
	assign Lo_out = Lo;
	
	always@(posedge clk)
	begin
	    if(hilo_we)
			case(hilo_op)
			    `MULT:	begin
						    tmp = A_din * B_din;
							Hi = tmp[63:32];
							Lo = tmp[31:0];
						end
				`MULTU:	begin
							tmp = {1'b0, A_din} * {1'b0, B_din};
							Hi = tmp[63:32];
							Lo = tmp[31:0];
						end
				`DIV:	begin
							Hi = A_din % B_din;
							Lo = A_din / B_din;
						end
				`DIVU:	begin
							Hi = {1'b0, A_din} % {1'b0, B_din};
							Lo = {1'b0, A_din} / {1'b0, B_din};
						end
				`MTHI:	Hi = A_din;
				`MTLO:	Lo = A_din;
			endcase
	end
endmodule









