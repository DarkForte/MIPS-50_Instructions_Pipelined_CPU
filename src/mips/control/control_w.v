`include "..\\public.v"

module Control_W(opcode, rs, rt, funct, RegWE, WAdrs, WDataSrc);
    input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt;
	
	output [1:0] WAdrs;
	output [2:0] WDataSrc;
	output RegWE;

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
		
	
	assign WAdrs = (itype || ltype || mfc0) ? `WADRS_RT : 
					(jal) ? `WADRS_31:
					`WADRS_RD ;
					
	assign WDataSrc = (ltype) ? `WDATA_MEMRES: 
					(jal || jalr) ? `WDATA_PC : 
					(mfc0)? `WDATA_CP0 : 
					(mfhi)? `WDATA_HI :
					(mflo)? `WDATA_LO :
					`WDATA_ALURES;
	
	assign RegWE = (!mtype && !btype && !jtype && !eret && !mfttype) ? 1:
					(jal || jalr) ? 1:
					(ltype) ? 1:
					(mfc0 || mfhi || mflo) ? 1:
					0;
endmodule








