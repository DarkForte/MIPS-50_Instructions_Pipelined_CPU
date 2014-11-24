`include "..\\public.v"

module Control_M(opcode, rs, rt, funct, now_device, BeOP, MemWrite, IOWrite, MeOP);
    input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt;
	input now_device;
	
	output MemWrite;
	output IOWrite;
	output [1:0] BeOP;
	output [2:0] MeOP;

	wire rtype, itype, btype, mtype, jtype, stype, ltype, mfttype;
	wire add, addu, sub, subu, sll, srl, sra, sllv, srlv, srav, and1, or1, xor1, nor1, slt, sltu;
	wire addi, addiu, andi, xori, lui, ori;
	wire slti, sltiu;
	wire bltzbgez;
	wire beq, bne, blez, bgtz, bltz, bgez;
	wire sw, sh, sb, lb, lbu, lh, lhu, lw;
	wire j, jal, jr, jalr;
	
	wire mult, multu, div, divu;
	wire mthi, mtlo, mfhi, mflo;
	
	wire cp0type;
	wire eret, mfc0, mtc0;
	
	Decoder the_decoder(opcode, rs, rt, funct, rtype, itype, btype, mtype, jtype, stype, ltype, mfttype,
		add, addu, sub, subu, sll, srl, sra, sllv, srlv, srav, and1, or1, xor1, nor1, slt, sltu,
		addi, addiu, andi, xori, lui, ori, slti, sltiu,
		bltzbgez, beq, bne, blez, bgtz, bltz, bgez,
		sw, sh, sb, lb, lbu, lh, lhu, lw,
		j, jal, jr, jalr,
		mult, multu, div, divu, mthi, mtlo, mfhi, mflo,
		cp0type,eret, mfc0, mtc0);
		
	
	assign BeOP = (sb) ? `BE_SB :
				(sh) ? `BE_SH :
				(sw) ? `BE_SW :
				2'b00;
				
	assign MeOP = (lb) ? `ME_LB :
				(lbu) ? `ME_LBU :
				(lh) ? `ME_LH :
				(lhu) ? `ME_LHU :
				(lw) ? `ME_LW :
				3'b000;
	
	assign MemWrite = (stype && now_device == `NOWDEVICE_MEMO) ? 1:0;
	assign IOWrite = (stype && now_device == `NOWDEVICE_IO) ? 1:0;
	
endmodule








