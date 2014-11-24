`include "..\\public.v"

module Decoder(opcode, rs, rt, funct, rtype, itype, btype, mtype, jtype, stype, ltype, mfttype,
		add, addu, sub, subu, sll, srl, sra, sllv, srlv, srav, and1, or1, xor1, nor1, slt, sltu,
		addi, addiu, andi, xori, lui, ori, slti, sltiu,
		bltzbgez, beq, bne, blez, bgtz, bltz, bgez,
		sw, sh, sb, lb, lbu, lh, lhu, lw,
		j, jal, jr, jalr,
		mult, multu, div, divu, mthi, mtlo, mfhi, mflo,
		cp0type,eret, mfc0, mtc0);

	input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt; 

	output rtype, itype, btype, mtype, jtype, stype, ltype, mfttype;
	output add, addu, sub, subu, sll, srl, sra, sllv, srlv, srav, and1, or1, xor1, nor1, slt, sltu;
	output addi, addiu, andi, xori, lui, ori;
	output slti, sltiu;
	output bltzbgez;
	output beq, bne, blez, bgtz, bltz, bgez;
	output sw, sh, sb, lb, lbu, lh, lhu, lw;
	output j, jal, jr, jalr;
	
	output mult, multu, div, divu;
	output mthi, mtlo, mfhi, mflo;
	
	output cp0type;
	output eret, mfc0, mtc0;
	
	
	
	assign rtype = (opcode == `OP_RTYPE)? 1:0;
	
    assign addu = (rtype && funct == `FUNCT_ADDU) ? 1:0;
    assign subu = (rtype && funct == `FUNCT_SUBU) ? 1:0;
	assign jr = (rtype && funct == `FUNCT_JR) ? 1:0;
	
	assign add = (rtype && funct == `FUNCT_ADD) ? 1:0;
    assign sub = (rtype && funct == `FUNCT_SUB) ? 1:0;
	assign and1 = (rtype && funct == `FUNCT_AND) ? 1:0;
	assign sll = (rtype && funct == `FUNCT_SLL) ? 1:0;
	assign srl = (rtype && funct == `FUNCT_SRL) ? 1:0;
	assign sra = (rtype && funct == `FUNCT_SRA) ? 1:0;
    assign sllv = (rtype && funct == `FUNCT_SLLV) ? 1:0;
	assign srlv = (rtype && funct == `FUNCT_SRLV) ? 1:0;
	assign srav = (rtype && funct == `FUNCT_SRAV) ? 1:0;
    assign and1 = (rtype && funct == `FUNCT_AND) ? 1:0;
	assign or1 = (rtype && funct == `FUNCT_OR) ? 1:0;
    assign xor1 = (rtype && funct == `FUNCT_XOR) ? 1:0;
	assign nor1 = (rtype && funct == `FUNCT_NOR) ? 1:0;
	assign jalr = (rtype && funct == `FUNCT_JALR) ? 1:0;
	assign slt = (rtype && funct == `FUNCT_SLT) ? 1:0;
	assign sltu = (rtype && funct == `FUNCT_SLTU) ? 1:0;
	
	assign addi = (opcode == `OP_ADDI) ? 1:0;
	assign addiu = (opcode == `OP_ADDIU) ? 1:0;
	assign andi = (opcode == `OP_ANDI) ? 1:0;
	assign xori = (opcode == `OP_XORI) ? 1:0;
	
	assign slti = (opcode == `OP_SLTI) ? 1:0;
	assign sltiu = (opcode == `OP_SLTIU) ? 1:0;
	
	assign bltzbgez = (opcode == `OP_BLTZBGEZ) ? 1:0;
	assign bltz = (bltzbgez && rt == `RT_BLTZ) ? 1:0;
	assign bgez = (bltzbgez && rt == `RT_BGEZ) ? 1:0;
	
	assign bne = (opcode == `OP_BNE) ? 1:0;
	assign blez = (opcode == `OP_BLEZ) ? 1:0;
	assign bgtz = (opcode == `OP_BGTZ) ? 1:0;
	
    assign lw = (opcode == `OP_LW) ? 1:0;
	assign sw = (opcode == `OP_SW) ? 1:0;
	assign beq = (opcode == `OP_BEQ) ? 1:0;
	assign lui = (opcode == `OP_LUI) ? 1:0;
	assign ori = (opcode == `OP_ORI) ? 1:0;
	assign j = (opcode == `OP_J) ? 1:0;
	assign jal = (opcode == `OP_JAL) ? 1:0;
	
	assign sb = (opcode == `OP_SB) ? 1:0;
	assign sh = (opcode == `OP_SH) ? 1:0;
	assign lb = (opcode == `OP_LB) ? 1:0;
	assign lbu = (opcode == `OP_LBU) ? 1:0;
	assign lh = (opcode == `OP_LH) ? 1:0;
	assign lhu = (opcode == `OP_LHU) ? 1:0;
	
	assign cp0type = (opcode == `OP_CP0) ? 1:0;
	
	assign eret = (cp0type && rs == `RS_ERET) ? 1 : 0;
	assign mfc0 = (cp0type && rs == `RS_MFC0) ? 1 : 0;
	assign mtc0 = (cp0type && rs == `RS_MTCO) ? 1 : 0;
	
	assign mult = (rtype && funct == `FUNCT_MULT) ? 1:0;
	assign multu = (rtype && funct == `FUNCT_MULTU) ? 1:0;
	assign div = (rtype && funct == `FUNCT_DIV) ? 1:0;
	assign divu = (rtype && funct == `FUNCT_DIVU) ? 1:0;
	assign mthi = (rtype && funct == `FUNCT_MTHI) ? 1:0;
	assign mtlo = (rtype && funct == `FUNCT_MTLO) ? 1:0;
	assign mfhi = (rtype && funct == `FUNCT_MFHI) ? 1:0;
	assign mflo = (rtype && funct == `FUNCT_MFLO) ? 1:0;
	
	
	assign itype = (addi || addiu || andi || xori || lui || ori || slti || sltiu) ? 1:0;
	assign btype = (beq || bne || blez || bgtz || bltz || bgez) ? 1:0;
	assign mtype = (sw || sh || sb || lb || lbu || lh || lhu || lw) ? 1:0;
	assign jtype = (j || jal || jalr || jr) ? 1:0;
	assign stype = (sw || sh || sb) ? 1:0;
	assign ltype = (lb || lbu || lh || lhu || lw) ? 1:0;
	assign mfttype = (mult || multu || div || divu || mfhi || mflo || mthi || mtlo || mfc0 || mtc0)? 1:0;
	
		
endmodule