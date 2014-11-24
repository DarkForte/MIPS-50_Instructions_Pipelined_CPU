`include "..\\public.v"

module control(clk, rst, opcode, rs, rt, funct, int_req, NowDevice, WAdrs, WDataSrc, ExtSign, RegWE, BeOP, 			MemWrite, IOWrite, MeOP, PCSource, PCWr, IRegWr, ALUCommand, ALUSrc, ALUShift, zero, pos, 			CP0We, EXLSet, EXLClr, HILOop, HILOwe);
    input clk;
	input rst;
	
    input [5:0] opcode;
	input [5:0] funct;
	input [4:0] rs;
	input [4:0] rt;
	input int_req;
	input NowDevice;
	input zero;
	input pos;
	
	output [1:0] WAdrs;
	output [2:0] WDataSrc;
	output ExtSign;
	output RegWE;
	reg RegWE;
	
	output IRegWr;
	reg IRegWr;
	
	output MemWrite;
	reg MemWrite;
	
	output IOWrite;
	reg IOWrite;
	
	output [2:0] PCSource;
	reg [2:0] PCSource;
	
	output [3:0] ALUCommand;
	output [1:0] ALUSrc;
	output [4:0] ALUShift;
	
	output PCWr;
	reg PCWr;
	
	output [1:0] BeOP;
	output [2:0] MeOP;
	
	output CP0We;
	reg CP0We;
	output EXLSet;
	reg EXLSet;
	output EXLClr;
	reg EXLClr;
	
	output [2:0] HILOop;
	output HILOwe;
	reg HILOwe;
	
	reg [3:0] state;
	
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
	
	parameter S_FETCH = 4'd0;
	parameter S_DECODE = 4'd1;
	parameter S_MEMO_ADRS = 4'd2;
	parameter S_MEMO_RD = 4'd3;
	parameter S_MEMO_WRBK = 4'd4;
	parameter S_MEMO_WR = 4'd5;
	parameter S_CALC = 4'd6;
	parameter S_ALU_WRBK = 4'd7;
	parameter S_BRANCH = 4'd8;
	parameter S_J = 4'd9;
	parameter S_INT = 4'd10;
	parameter S_ERET = 4'd11;
	parameter S_MFT = 4'd12;
	
	
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
	
	
	always@(posedge clk or posedge rst)
	begin
	    if(rst)
			state = S_FETCH;
		else
			case(state)
				S_FETCH: 
					state = S_DECODE;
					
				S_DECODE:
					if(mtype)
						state = S_MEMO_ADRS;
						
					else if(btype)
						state = S_BRANCH;
						
					else if(jtype)
						state = S_J;
						
					else if(eret)
					    state = S_ERET;
						
					else if(mfttype)
					    state = S_MFT;
					else
						state = S_CALC;
						
				S_MEMO_ADRS:
					if(ltype)
						state = S_MEMO_RD;
					else
						state = S_MEMO_WR;
						
				S_MEMO_RD:
					state = S_MEMO_WRBK;
				S_MEMO_WR:
					state = S_INT;
				S_MEMO_WRBK:
				    state = S_INT;
				
				S_CALC:
					state = S_ALU_WRBK;
				S_ALU_WRBK:
					state = S_INT;
				
				S_BRANCH:
					state = S_INT;
				
				S_J:
					state = S_INT;
				
				S_ERET: 
				    state = S_INT;
					
				S_MFT:
				    state = S_INT;
					
				S_INT:
				    state = S_FETCH;
				
			endcase
    end
	
	wire branch_ok;
	assign branch_ok =( (beq && zero) || (bne && !zero) || (blez && !pos ) || 
			(bgtz && pos) || (bltz && (!pos && !zero) ) || (bgez && (pos || zero) ) ) ? 1:0;
	
	always@(*)
	begin
	    if(state == S_FETCH ||  ( state == S_BRANCH && branch_ok ) || state == S_J || 
		(state == S_INT && int_req) || state == S_ERET )
		    PCWr = 1;
		else
		    PCWr = 0;
		
		if(state == S_FETCH)
		    IRegWr = 1;
		else
		    IRegWr = 0;
			
		if( state == S_ALU_WRBK || (state == S_J && (jal || jalr)) || state == S_MEMO_WRBK || (state == S_MFT && (mfc0 || mfhi || mflo) ) )
		    RegWE = 1;
		else
			RegWE = 0;
			
		if( stype && state == S_MEMO_WR && NowDevice == `NOWDEVICE_MEMO)
			MemWrite = 1;
		else
		    MemWrite = 0;
			
		if( stype && state == S_MEMO_WR && NowDevice == `NOWDEVICE_IO)
		    IOWrite = 1;
		else 
		    IOWrite = 0;
			
		if(state == S_FETCH)
		    PCSource = `PC_NORMAL;
		else if(state == S_INT && int_req)
		    PCSource = `PC_ERROR;
		else if(btype)
		    PCSource = `PC_ADD;
		else if(j || jal)
		    PCSource = `PC_J;
		else if(jr || jalr)
		    PCSource = `PC_JR;
		else if(eret)
		    PCSource = `PC_EPC;
		else 
			PCSource = `PC_NORMAL;
			
		if(state == S_INT && int_req)
		    EXLSet = 1;
		else
		    EXLSet = 0;
		
		if(state == S_ERET)
		    EXLClr = 1;
		else
		    EXLClr = 0;
			
		if(state == S_MFT && mtc0)
		    CP0We = 1;
		else
		    CP0We = 0;
		
		if(state == S_MFT && (mthi|| mtlo || mult || multu || div || divu))
		    HILOwe = 1;
		else
		    HILOwe = 0;
	end
	
	assign WAdrs = (itype || ltype || mfc0) ? `WADRS_RT : 
					(jal) ? `WADRS_31:
					`WADRS_RD ;
					
	assign WDataSrc = (ltype) ? `WDATA_MEMRES: 
					(jal || jalr) ? `WDATA_PC : 
					(mfc0)? `WDATA_CP0 : 
					(mfhi)? `WDATA_HI :
					(mflo)? `WDATA_LO :
					`WDATA_ALURES;
					
	assign ExtSign = (ori || andi || xori) ? `ZERO_EXT : `SIGN_EXT ;

	assign ALUCommand = (add || addi || mtype) ? `ADD :
						(addu) ? `ADDU : 
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
					(bgez || bltz )? `ALUSRC_CONSTZERO : 
					`ALUSRC_RT ;
					
	assign ALUShift = (sll || srl || sra) ? `ALUSHIFT_SHAMT :
					(sllv || srlv || srav) ? `ALUSHIFT_RS :
					(lui) ? `ALUSHIFT_16 : 
					5'd0;
	
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
				
	assign HILOop = (mult) ? `MULT :
					(multu) ? `MULTU :
					(div) ? `DIV :
					(divu) ? `DIVU :
					(mthi) ? `MTHI :
					(mtlo) ? `MTLO :
					3'b0;
endmodule







