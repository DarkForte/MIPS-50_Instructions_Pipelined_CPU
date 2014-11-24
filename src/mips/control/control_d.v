`include "..\\public.v"

module Control_D(opcode, rs, rt, funct, err_PC_ready, eret_PC_ready,
				ExtSign, PCSource, Cmp2Source, BranchOK, zero, pos);
    input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt;
	
	input err_PC_ready;
	input eret_PC_ready;
    
	input zero;
	input pos;
	
	output ExtSign;
	output [2:0] PCSource;
	output Cmp2Source;
	output BranchOK;

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
		
	
	wire branch_ok;
	assign branch_ok =( (beq && zero) || (bne && !zero) || (blez && !pos ) || 
			(bgtz && pos) || (bltz && (!pos && !zero) ) || (bgez && (pos || zero) ) ) ? 1:0;
			
	assign BranchOK = branch_ok;
			
	assign PCSource = (err_PC_ready) ? `PC_ERROR :
					(eret_PC_ready) ? `PC_EPC :
					(btype && branch_ok) ? `PC_ADD :
					(j || jal) ? `PC_J :
					(jr || jalr) ? `PC_JR :
					`PC_NORMAL;
	
	assign ExtSign = (ori || andi || xori) ? `ZERO_EXT : `SIGN_EXT ;
	
	assign Cmp2Source = (bltz || bgez) ? `CMP2_CONSTZERO : `CMP2_REG;
	
endmodule








