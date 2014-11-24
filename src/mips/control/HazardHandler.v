`include "..\\public.v"

module HazardHandler(instr_D, instr_E, instr_M, instr_W, branch_ok_D, int_req, 
					Sel_PCR, Sel_CmpA, Sel_CmpB, Sel_ALUA, Sel_ALUB, Sel_MemoData, Sel_RegNum2M, 
					Sel_CP0, Sel_Hi, Sel_Lo, Sel_CPUout,
					we_D, we_E, we_M, clear_D, clear_E, clear_M, PCWr, 
					EXLSet, EXLClr, ERR_PCReady, ERET_PCReady);

    input [31:0] instr_D, instr_E, instr_M, instr_W;
	input branch_ok_D;
	input int_req;
	
	output [3:0] Sel_PCR, Sel_CmpA, Sel_CmpB, Sel_ALUA, Sel_ALUB;
	output [3:0] Sel_MemoData, Sel_RegNum2M;
	output [3:0] Sel_CP0, Sel_Hi, Sel_Lo, Sel_CPUout;
	output we_D, we_E, we_M;
	output clear_D, clear_E, clear_M;
	output PCWr;
	
	output EXLSet, EXLClr, ERR_PCReady, ERET_PCReady;
	
	reg we_D, we_E, we_M, we_W;
	reg clear_D, clear_E, clear_M, clear_W;
	reg PCWr;
	reg EXLSet, EXLClr;
	
	////////////////////////////////////////////////////////////////Phase D
	
	wire [5:0] opcode_D;
	wire [5:0] funct_D;
	wire [4:0] rs_D;
	wire [4:0] rt_D;
	
	wire req_btype_one_D;
	wire req_btype_two_D;
	wire req_jrtype_D;
	
	wire rtype_D, itype_D, btype_D, mtype_D, jtype_D, stype_D, ltype_D, mfttype_D;
	wire add_D, addu_D, sub_D, subu_D, sll_D, srl_D, sra_D, sllv_D, srlv_D, srav_D, and1_D, or1_D, xor1_D, nor1_D, slt_D, sltu_D;
	wire addi_D, addiu_D, andi_D, xori_D, lui_D, ori_D;
	wire slti_D, sltiu_D;
	wire bltzbgez_D;
	wire beq_D, bne_D, blez_D, bgtz_D, bltz_D, bgez_D;
	wire sw_D, sh_D, sb_D, lb_D, lbu_D, lh_D, lhu_D, lw_D;
	wire j_D, jal_D, jr_D, jalr_D;
	
	wire mult_D, multu_D, div_D, divu_D;
	wire mthi_D, mtlo_D, mfhi_D, mflo_D;
	
	wire cp0type_D;
	wire eret_D, mfc0_D, mtc0_D;
	
	assign opcode_D = instr_D[31:26];
	assign rs_D = instr_D[25:21];
	assign rt_D = instr_D[20:16];
	assign funct_D = instr_D[5:0];
	
	Decoder the_Decoder_D(
		opcode_D, rs_D, rt_D, funct_D, rtype_D, itype_D, btype_D, mtype_D, jtype_D, stype_D, ltype_D, mfttype_D,
		add_D, addu_D, sub_D, subu_D, sll_D, srl_D, sra_D, sllv_D, srlv_D, srav_D, and1_D, or1_D, xor1_D, nor1_D, slt_D, sltu_D,
		addi_D, addiu_D, andi_D, xori_D, lui_D, ori_D, slti_D, sltiu_D, bltzbgez_D, beq_D, bne_D, blez_D, bgtz_D, bltz_D, bgez_D,
		sw_D, sh_D, sb_D, lb_D, lbu_D, lh_D, lhu_D, lw_D,
		j_D, jal_D, jr_D, jalr_D,
		mult_D, multu_D, div_D, divu_D, mthi_D, mtlo_D, mfhi_D, mflo_D,
		cp0type_D,eret_D, mfc0_D, mtc0_D);
		
	assign req_btype_two_D = (beq_D || bne_D) ? 1:0;
	assign req_btype_one_D = (blez_D || bgtz_D || bltz_D || bgez_D) ? 1:0;
	assign req_jrtype_D = (jr_D || jalr_D) ? 1:0;
		
	////////////////////////////////////////////////Phase E
	wire [5:0] opcode_E;
	wire [5:0] funct_E;
	wire [4:0] rs_E;
	wire [4:0] rt_E;
	wire req_calctype_E;
	wire req_rtype_E;
	wire req_itype_E;
	wire req_memtype_E;
	wire req_hilo_one_E;
	wire req_hilo_two_E;
	wire req_CP0_E;
	wire [4:0] prov_rd_E;
	wire prov_ALUtoReg_E;
	wire prov_jal_E;
	
	wire rtype_E, itype_E, btype_E, mtype_E, jtype_E, stype_E, ltype_E, mfttype_E;
	wire add_E, addu_E, sub_E, subu_E, sll_E, srl_E, sra_E, sllv_E, srlv_E, srav_E, and1_E, or1_E, xor1_E, nor1_E, slt_E, sltu_E;
	wire addi_E, addiu_E, andi_E, xori_E, lui_E, ori_E;
	wire slti_E, sltiu_E;
	wire bltzbgez_E;
	wire beq_E, bne_E, blez_E, bgtz_E, bltz_E, bgez_E;
	wire sw_E, sh_E, sb_E, lb_E, lbu_E, lh_E, lhu_E, lw_E;
	wire j_E, jal_E, jr_E, jalr_E;
	
	wire mult_E, multu_E, div_E, divu_E;
	wire mthi_E, mtlo_E, mfhi_E, mflo_E;
	
	wire cp0type_E;
	wire eret_E, mfc0_E, mtc0_E;
	
	assign opcode_E = instr_E[31:26];
	assign rs_E = instr_E[25:21];
	assign rt_E = instr_E[20:16];
	assign funct_E = instr_E[5:0];
	
	Decoder the_Decoder_E(
		opcode_E, rs_E, rt_E, funct_E, rtype_E, itype_E, btype_E, mtype_E, jtype_E, stype_E, ltype_E, mfttype_E,
		add_E, addu_E, sub_E, subu_E, sll_E, srl_E, sra_E, sllv_E, srlv_E, srav_E, and1_E, or1_E, xor1_E, nor1_E, slt_E, sltu_E,
		addi_E, addiu_E, andi_E, xori_E, lui_E, ori_E, slti_E, sltiu_E, bltzbgez_E, beq_E, bne_E, blez_E, bgtz_E, bltz_E, bgez_E,
		sw_E, sh_E, sb_E, lb_E, lbu_E, lh_E, lhu_E, lw_E,
		j_E, jal_E, jr_E, jalr_E,
		mult_E, multu_E, div_E, divu_E, mthi_E, mtlo_E, mfhi_E, mflo_E,
		cp0type_E,eret_E, mfc0_E, mtc0_E);
	
	assign req_calctype_E = (!btype_E && !mtype_E && !jtype_E && !mfttype_E && !eret_E) ? 1:0;
	assign req_rtype_E = (req_calctype_E && rtype_E) ? 1:0;
	assign req_itype_E = (req_calctype_E && itype_E) ? 1:0;
	assign req_memtype_E = (mtype_E) ? 1:0;
	assign req_stype_E = (stype_E) ? 1:0;
	assign req_hilo_one_E = (mthi_E || mtlo_E) ? 1:0;
	assign req_hilo_two_E = (mult_E || multu_E || div_E || divu_E) ? 1:0;
	assign req_CP0_E = (mtc0_E) ? 1:0;
	
	assign prov_rd_E = (rtype_E || mfhi_E || mflo_E) ? instr_E[15:11] : rt_E;
	assign prov_jal_E = (jal_E || jalr_E) ? 1:0;
	assign prov_ALUtoReg_E = req_calctype_E;
	assign prov_mfhilocp0_E = (mfhi_E || mflo_E || mfc0_E) ? 1:0;
		
	//////////////////////////////////////////////////////Phase M
	
	wire [5:0] opcode_M;
	wire [5:0] funct_M;
	wire [4:0] rs_M;
	wire [4:0] rt_M;
	wire [4:0] prov_rd_M;
	wire req_store_M;
	wire prov_ALUtoReg_M;
	wire prov_MemtoReg_M;
	wire prov_HitoReg_M;
	wire prov_LotoReg_M;
	wire prov_CP0toReg_M;
	wire prov_jal_M;
	
	wire rtype_M, itype_M, btype_M, mtype_M, jtype_M, stype_M, ltype_M, mfttype_M;
	wire add_M, addu_M, sub_M, subu_M, sll_M, srl_M, sra_M, sllv_M, srlv_M, srav_M, and1_M, or1_M, xor1_M, nor1_M, slt_M, sltu_M;
	wire addi_M, addiu_M, andi_M, xori_M, lui_M, ori_M;
	wire slti_M, sltiu_M;
	wire bltzbgez_M;
	wire beq_M, bne_M, blez_M, bgtz_M, bltz_M, bgez_M;
	wire sw_M, sh_M, sb_M, lb_M, lbu_M, lh_M, lhu_M, lw_M;
	wire j_M, jal_M, jr_M, jalr_M;
	
	wire mult_M, multu_M, div_M, divu_M;
	wire mthi_M, mtlo_M, mfhi_M, mflo_M;
	
	wire cp0type_M;
	wire eret_M, mfc0_M, mtc0_M;
	
	assign opcode_M = instr_M[31:26];
	assign rs_M = instr_M[25:21];
	assign rt_M = instr_M[20:16];
	assign funct_M = instr_M[5:0];
	
	Decoder the_Decoder_M(
		opcode_M, rs_M, rt_M, funct_M, rtype_M, itype_M, btype_M, mtype_M, jtype_M, stype_M, ltype_M, mfttype_M,
		add_M, addu_M, sub_M, subu_M, sll_M, srl_M, sra_M, sllv_M, srlv_M, srav_M, and1_M, or1_M, xor1_M, nor1_M, slt_M, sltu_M,
		addi_M, addiu_M, andi_M, xori_M, lui_M, ori_M, slti_M, sltiu_M, bltzbgez_M, beq_M, bne_M, blez_M, bgtz_M, bltz_M, bgez_M,
		sw_M, sh_M, sb_M, lb_M, lbu_M, lh_M, lhu_M, lw_M,
		j_M, jal_M, jr_M, jalr_M,
		mult_M, multu_M, div_M, divu_M, mthi_M, mtlo_M, mfhi_M, mflo_M,
		cp0type_M,eret_M, mfc0_M, mtc0_M);
		
	assign req_store_M = (stype_M) ? 1:0;
	
	assign prov_rd_M = (rtype_M || mfhi_M || mflo_M) ? instr_M[15:11] : rt_M;
	assign prov_ALUtoReg_M = (!btype_M && !mtype_M && !jtype_M && !mfttype_M && !eret_M) ? 1:0;
	assign prov_MemtoReg_M = (ltype_M) ? 1:0;
	assign prov_jal_M = (jal_M || jalr_M) ? 1:0;
	assign prov_HitoReg_M = (mfhi_M) ? 1:0;
	assign prov_LotoReg_M = (mflo_M) ? 1:0;
	assign prov_CP0toReg_M = (mfc0_M) ? 1:0;
		
	//////////////////////////////////////////////////Phase W
	
	wire [5:0] opcode_W;
	wire [5:0] funct_W;
	wire [4:0] rs_W;
	wire [4:0] rt_W;
	wire [4:0] prov_rd_W;
	wire prov_jal_W;
	wire prov_HitoReg_W;
	wire prov_LotoReg_W;
	wire prov_CP0toReg_W;
	
	wire rtype_W, itype_W, btype_W, mtype_W, jtype_W, stype_W, ltype_W, mfttype_W;
	wire add_W, addu_W, sub_W, subu_W, sll_W, srl_W, sra_W, sllv_W, srlv_W, srav_W, and1_W, or1_W, xor1_W, nor1_W, slt_W, sltu_W;
	wire addi_W, addiu_W, andi_W, xori_W, lui_W, ori_W;
	wire slti_W, sltiu_W;
	wire bltzbgez_W;
	wire beq_W, bne_W, blez_W, bgtz_W, bltz_W, bgez_W;
	wire sw_W, sh_W, sb_W, lb_W, lbu_W, lh_W, lhu_W, lw_W;
	wire j_W, jal_W, jr_W, jalr_W;
	
	wire mult_W, multu_W, div_W, divu_W;
	wire mthi_W, mtlo_W, mfhi_W, mflo_W;
	
	wire cp0type_W;
	wire eret_W, mfc0_W, mtc0_W;
	
	assign opcode_W = instr_W[31:26];
	assign rs_W = instr_W[25:21];
	assign rt_W = instr_W[20:16];
	assign funct_W = instr_W[5:0];
	
	Decoder the_Decoder_W(
		opcode_W, rs_W, rt_W, funct_W, rtype_W, itype_W, btype_W, mtype_W, jtype_W, stype_W, ltype_W, mfttype_W,
		add_W, addu_W, sub_W, subu_W, sll_W, srl_W, sra_W, sllv_W, srlv_W, srav_W, and1_W, or1_W, xor1_W, nor1_W, slt_W, sltu_W,
		addi_W, addiu_W, andi_W, xori_W, lui_W, ori_W, slti_W, sltiu_W, bltzbgez_W, beq_W, bne_W, blez_W, bgtz_W, bltz_W, bgez_W,
		sw_W, sh_W, sb_W, lb_W, lbu_W, lh_W, lhu_W, lw_W,
		j_W, jal_W, jr_W, jalr_W,
		mult_W, multu_W, div_W, divu_W, mthi_W, mtlo_W, mfhi_W, mflo_W,
		cp0type_W,eret_W, mfc0_W, mtc0_W);
	
	assign prov_rd_W = (rtype_W || mfhi_W || mflo_W) ? instr_W[15:11] : rt_W;
	assign prov_ALUtoReg_W = (!btype_W && !mtype_W && !jtype_W && !mfttype_W && !eret_W) ? 1:0;
	assign prov_MemtoReg_W = (ltype_W) ? 1:0;
	assign prov_jal_W = (jal_W || jalr_W ) ? 1:0;
	assign prov_HitoReg_W = (mfhi_W) ? 1:0;
	assign prov_LotoReg_W = (mflo_W) ? 1:0;
	assign prov_CP0toReg_W = (mfc0_W) ? 1:0;
	
	/////////////////////////////////////////////////////////////////////////////Sel
	
	assign Sel_PCR = (!req_jrtype_D) ? `SEL_NORMAL : // JR uses this
					(prov_jal_E && (rs_D == 5'd31 && jal_E) || (rs_D == prov_rd_E && jalr_E) ) ? `SEL_FROME_PC :
					(prov_jal_M && (rs_D == 5'd31 && jal_M) || (rs_D == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rs_D == 5'd31 && jal_W) || (rs_D == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					
					(rs_D == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rs_D == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rs_D == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rs_D == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rs_D == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rs_D == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rs_D == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rs_D == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rs_D == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;

	assign Sel_CmpA = (!(req_btype_one_D || req_btype_two_D)) ? `SEL_NORMAL :
					(prov_jal_E && (rs_D == 5'd31 && jal_E) || (rs_D == prov_rd_E && jalr_E) ) ? `SEL_FROME_PC :
					(prov_jal_M && (rs_D == 5'd31 && jal_M) || (rs_D == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rs_D == 5'd31 && jal_W) || (rs_D == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
	
					(rs_D == prov_rd_E && prov_ALUtoReg_E) ? `SEL_FROME :
					(rs_D == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rs_D == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rs_D == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rs_D == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rs_D == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rs_D == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rs_D == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rs_D == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rs_D == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;

	assign Sel_CmpB = (!req_btype_two_D) ? `SEL_NORMAL :
					(prov_jal_E && (rt_D == 5'd31 && jal_E) || (rt_D == prov_rd_E && jalr_E) ) ? `SEL_FROME_PC :
					(prov_jal_M && (rt_D == 5'd31 && jal_M) || (rt_D == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rt_D == 5'd31 && jal_W) || (rt_D == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
	
					(rt_D == prov_rd_E && prov_ALUtoReg_E) ? `SEL_FROME :
					(rt_D == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rt_D == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rt_D == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_D == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rt_D == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rt_D == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rt_D == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_D == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_D == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
    assign Sel_ALUA = (!req_memtype_E && !req_calctype_E) ? `SEL_NORMAL :
					(prov_jal_M && (rs_E == 5'd31 && jal_M) || (rs_E == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rs_E == 5'd31 && jal_W) || (rs_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					
					(rs_E == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rs_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rs_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rs_E == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rs_E == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rs_E == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rs_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rs_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rs_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
	assign Sel_ALUB = (!req_rtype_E) ? `SEL_NORMAL :
					(prov_jal_M && (rt_E == 5'd31 && jal_M) || (rt_E == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rt_E == 5'd31 && jal_W) || (rt_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rt_E == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rt_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rt_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_E == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rt_E == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rt_E == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rt_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
					
	assign Sel_RegNum2M = (!req_stype_E) ? `SEL_NORMAL : // sw's data in E
					(prov_jal_W && (rt_E == 5'd31 && jal_W) || (rt_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					
					(rt_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rt_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
					
	assign Sel_MemoData = (!req_store_M) ? `SEL_NORMAL : //SW USES IN M
					(prov_jal_W && (rt_M == 5'd31 && jal_W) || (rt_M == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rt_M == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU : 
					(rt_M == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_M == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_M == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_M == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
	assign Sel_CP0 = (!req_CP0_E) ? `SEL_NORMAL :
					(prov_jal_M && (rt_E == 5'd31 && jal_M) || (rt_E == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rt_E == 5'd31 && jal_W) || (rt_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rt_E == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rt_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rt_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_E == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rt_E == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rt_E == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rt_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
	assign Sel_Hi = (!(req_hilo_one_E || req_hilo_two_E) ) ? `SEL_NORMAL :
					(prov_jal_M && (rs_E == 5'd31 && jal_M) || (rs_E == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rs_E == 5'd31 && jal_W) || (rs_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rs_E == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rs_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rs_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rs_E == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rs_E == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rs_E == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rs_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rs_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rs_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
					
	assign Sel_Lo =  (!req_hilo_two_E ) ? `SEL_NORMAL :
					(prov_jal_M && (rt_E == 5'd31 && jal_M) || (rt_E == prov_rd_M && jalr_M) ) ? `SEL_FROMM_PC :
					(prov_jal_W && (rt_E == 5'd31 && jal_W) || (rt_E == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rt_E == prov_rd_M && prov_ALUtoReg_M) ? `SEL_FROMM :
					(rt_E == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU :
					(rt_E == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_E == prov_rd_M && prov_HitoReg_M) ? `SEL_FROMM_HI :
					(rt_E == prov_rd_M && prov_LotoReg_M) ? `SEL_FROMM_LO :
					(rt_E == prov_rd_M && prov_CP0toReg_M) ? `SEL_FROMM_CP0 :
					
					(rt_E == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_E == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_E == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
	assign Sel_CPUout = (!req_store_M) ? `SEL_NORMAL : //SW USES IN M
					(prov_jal_W && (rt_M == 5'd31 && jal_W) || (rt_M == prov_rd_W && jalr_W) ) ? `SEL_FROMW_PC :
					(rt_M == prov_rd_W && prov_ALUtoReg_W) ? `SEL_FROMW_ALU : 
					(rt_M == prov_rd_W && prov_MemtoReg_W) ? `SEL_FROMW_MEM :
					
					(rt_M == prov_rd_W && prov_HitoReg_W) ? `SEL_FROMW_HI :
					(rt_M == prov_rd_W && prov_LotoReg_W) ? `SEL_FROMW_LO :
					(rt_M == prov_rd_W && prov_CP0toReg_W) ? `SEL_FROMW_CP0 :
					`SEL_NORMAL;
	
	always@(*)
	begin
		if(req_rtype_E && prov_MemtoReg_M && (rs_E == prov_rd_M || rt_E == prov_rd_M)) //XXX ADD LW
		begin
		    PCWr = 0;
			clear_D = 0;
			clear_E = 0;
			clear_M = 1;
			we_D = 0;
			we_E = 0;
			we_M = 0;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_itype_E && prov_MemtoReg_M && rs_E == prov_rd_M)// XXX ADDI LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 0;
			clear_M = 1;
			we_D = 0;
			we_E = 0;
			we_M = 0;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_memtype_E && prov_MemtoReg_M && rs_E == prov_rd_M)// XXX LW LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 0;
			clear_M = 1;
			we_D = 0;
			we_E = 0;
			we_M = 0;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_one_D && ltype_E && (rs_D == rt_E)) // BLTZ LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_two_D && ltype_E && (rs_D == rt_E || rt_D == rt_E)) // BEQ LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_two_D && prov_ALUtoReg_E && 
				( (rs_D == rt_E  && rs_D!=5'd0 ) || (rt_D == rt_E && rt_D != 5'd0) ) )//BEQ ADD
		begin
		    PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_one_D && prov_ALUtoReg_E && (rs_D == rt_E && rs_D != 5'd0)) //BLEZ ADD
		begin
		    PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_two_D && prov_mfhilocp0_E && 
				( (rs_D == prov_rd_E  && rs_D!=5'd0 ) || (rt_D == prov_rd_E && rt_D != 5'd0) ) )//BEQ MFHI
		begin
		    PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_one_D && prov_mfhilocp0_E && (rs_D == prov_rd_E && rs_D != 5'd0)) //BLEZ MFHI
		begin
		    PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_one_D && prov_MemtoReg_M && (rs_D == prov_rd_M) ) //BLEZ XXX LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_btype_two_D && prov_MemtoReg_M && (rs_D == prov_rd_M || rt_D == prov_rd_M) ) // BEQ XXX LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_jrtype_D && ltype_E && (rs_D == rt_E) ) // JR LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_jrtype_D && prov_MemtoReg_M && (rs_D == prov_rd_M) ) // JR xxx LW
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 0;
			clear_M = 1;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_jrtype_D && prov_ALUtoReg_E && (rs_D == prov_rd_E && rs_D != 5'd0)) // JR ADD
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else if(req_jrtype_D && prov_mfhilocp0_E && (rs_D == prov_rd_E && rs_D != 5'd0)) // JR MFHI
		begin
			PCWr = 0;
			clear_D = 0;
			clear_E = 1;
			clear_M = 0;
			we_D = 0;
			we_E = 0;
			we_M = 1;
			EXLSet = 0;
			EXLClr = 0;
		end
		else
		begin
		    if(jtype_D || (btype_D && branch_ok_D))
			begin
			    PCWr = 1;
			    clear_D = 1;
				clear_E = 0;
				clear_M = 0;
				we_D = 0;
				we_E = 1;
				we_M = 1;
				EXLSet = 0;
				EXLClr = 0;
			end
		    else if(eret_D)
			begin
			    PCWr = 1;
			    clear_D = 1;
				clear_E = 0;
				clear_M = 0;
				we_D = 0;
				we_E = 1;
				we_M = 1;
				EXLSet = 0;
				EXLClr = 1;
			end
			else
			begin
			    ////////////////////////////Interrupt 
				if(int_req) // If you can see this, it means all control hazards are handled. 
							// That's to say, D cannot be branch or jump.
				begin
				    PCWr = 1;
					clear_D = 1; // you have to clear the next instr, who is in the main program.
					clear_E = 0;
					clear_M = 0;
					we_D = 0;
					we_E = 1;
					we_M = 1;
					EXLSet = 1;
					EXLClr = 0;
				end
				else
				begin
					PCWr = 1;
					clear_D = 0;
					clear_E = 0;
					clear_M = 0;
					we_D = 1;
					we_E = 1;
					we_M = 1;
					EXLSet = 0;
					EXLClr = 0;
				end
			    
			end
		end
		
	end
	
	assign ERR_PCReady = EXLSet;
	assign ERET_PCReady = EXLClr;
	
endmodule













