`include "..\\public.v"

module Control_E(opcode, rs, rt, funct, ALUCommand, ALUSrc, ALUShift, HILOop, HILOwe, CP0We);
    input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt;
	
	output [3:0] ALUCommand;
	output [1:0] ALUSrc;
	output [4:0] ALUShift;

	output [2:0] HILOop;
	output HILOwe;
	
	output CP0We;
	
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
		
	
	assign ALUCommand = (add || addi || mtype) ? `ADD :
						(addu || addiu) ? `ADDU : 
						(sub || btype) ? `SUB :
						(subu) ? `SUBU :
						(sll || sllv || lui) ? `SLL :
						(srl || srlv) ? `SRL :
						(sra || srav) ? `SRA :
						(and1 || andi) ? `AND :
						(or1 || ori) ? `OR :
						(xor1 || xori) ? `XOR :
						(nor1) ? `NOR :
						(slt || slti) ? `SLT :
						(sltu || sltiu) ? `SLTU :
						4'b0;
						
	assign ALUSrc = (mtype || itype) ? `ALUSRC_IMM : 
					`ALUSRC_RT ;
	
	assign ALUShift = (sll || srl || sra) ? `ALUSHIFT_SHAMT :
					(sllv || srlv || srav) ? `ALUSHIFT_RS :
					(lui) ? `ALUSHIFT_16 : 
					5'd0;
	
	assign HILOwe = (mthi|| mtlo || mult || multu || div || divu) ? 1:0;
	
	assign HILOop = (mult) ? `MULT :
					(multu) ? `MULTU :
					(div) ? `DIV :
					(divu) ? `DIVU :
					(mthi) ? `MTHI :
					(mtlo) ? `MTLO :
					3'b111;
endmodule








