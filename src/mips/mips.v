`include "..\\public.v"

module mips(clk, rst, CPUAddr, BE, CPUIn, CPUOut, IOWe, clk_out, HardInt_in);
    input clk ;  // clock
	input rst ;   // reset
	input [31:0] CPUIn;
	input [7:2] HardInt_in;
	
	output [31:2] CPUAddr;
	output [3:0] BE;
	output [31:0] CPUOut;
	output IOWe;
	output clk_out;
	
	
	////////////////////////////////////////////////////Phase F/////////////////
	wire [31:2] next_pc;
	wire [31:2] pc_out;
	wire pc_wr;
	PC the_PC(clk, next_pc, pc_wr, pc_out, rst);
	
	wire [31:2] pc;
	wire [15:0] imm_16_in;
	wire [25:0] imm_26_in;
	wire [31:0] reg_32_in;
	wire [31:2] EPC_in;
	wire [2:0] PCSource_in;
	wire [31:2] next_pc_out;
	NextPC the_NextPC(pc, imm_16_in, imm_26_in, reg_32_in, EPC_in, PCSource_in, next_pc_out);
	
	wire [12:2] im_addr;
	wire [31:0] im_dout;
	im_4k the_IM(clk, im_addr, im_dout);
	
	//////////////////////////////////////////////////Phase D//////////////////////////////
	
	wire clear_d;
	wire we_d;
	wire [31:0] instr_d;
	wire [31:2] PC_d;
	wire [31:0] InstrD;
	wire [31:2] PCD;
	Reg_D the_RegD(clk, rst, we_d, clear_d, instr_d, PC_d, InstrD, PCD);
	
	wire [5:0] opcode_d;
	wire [4:0] rs_d;
	wire [4:0] rt_d;
	wire [5:0] funct_d;
	wire err_PC_ready, eret_PC_ready;
	wire ExtSign;
	wire [2:0] PCSource_out;
	wire Cmp2Source;
	wire BranchOK;
	wire zero;
	wire pos;
	Control_D the_ControllerD(opcode_d, rs_d, rt_d, funct_d, err_PC_ready, eret_PC_ready, ExtSign, PCSource_out, Cmp2Source, BranchOK, zero, pos);
    
	wire RegWE;
	wire [4:0] w_adrs;
	wire [31:0] w_data;
	wire [4:0] adrs1;
	wire [4:0] adrs2;
	wire [31:0] data1;
	wire [31:0] data2;
	RegFile the_RegFile(clk, RegWE, rst, w_adrs, w_data, adrs1, adrs2, data1, data2);
	
	wire [31:0] cmp_num1;
	wire [31:0] cmp_num2;
	Comparer the_Comparer(cmp_num1, cmp_num2, zero, pos);
	
	wire [15:0] num_16;
	wire sign;
	wire [31:0] num_32;
	Extender the_Extender(num_16, sign, num_32);
	
	///////////////////////////////////////////////////////phase E///////////////////////
	
	wire clear_e;
	wire we_e;
	wire [31:0] instr_e;
	wire [31:2] PC_e;
	wire [31:0] reg_num1_e;
	wire [31:0] reg_num2_e;
	wire [31:0] num32_e;
	wire [31:0] InstrE;
	wire [31:2] PCE;
	wire [31:0] RegNum1E;
	wire [31:0] RegNum2E;
	wire [31:0] Num32E;
	Reg_E the_RegE(clk, rst, we_e, clear_e, instr_e, PC_e, reg_num1_e, reg_num2_e, num32_e, InstrE, PCE, 			RegNum1E, RegNum2E, Num32E);
	
	wire [5:0] opcode_e;
	wire [4:0] rs_e;
	wire [4:0] rt_e;
	wire [5:0] funct_e;
	wire [3:0] ALUCommand;
	wire [1:0] ALUSrc;
	wire [4:0] ALUShift_out;
	wire [2:0] HILOop;
	wire HILOwe;
	wire CP0We;
	Control_E the_ControllerE(opcode_e, rs_e, rt_e, funct_e, 
								ALUCommand, ALUSrc, ALUShift_out, HILOop, HILOwe, CP0We);
	
	wire [31:0] HLA_din;
	wire [31:0] HLB_din;
	wire [2:0] hilo_op;
	wire hilo_we;
	wire [31:0] Hi_out;
	wire [31:0] Lo_out;
	HILO the_HiLo(clk, HLA_din, HLB_din, hilo_op, hilo_we, Hi_out, Lo_out);
	
	wire [3:0] command;
	wire [31:0] num1;
	wire [31:0] num2;
	wire [4:0] ALUShift;
	wire [31:0] res;
	ALU the_ALU(command, num1, num2, ALUShift, res);
	
	wire [31:0] cp0_din;
	wire [31:2] pc_in;
	wire CP0We_in;
	wire [15:10] hard_int;
	wire [4:0] cp0_sel;
	wire EXL_set;
	wire EXL_clr;
	wire IntReq;
	wire [31:2] EPC_out;
	wire [31:0] cp0_dout;
	cp0 the_cp0(clk, rst, cp0_din, pc_in, CP0We_in, hard_int, cp0_sel, EXL_set, EXL_clr, IntReq, EPC_out, 		cp0_dout);
	
	////////////////////////////////////Phase M/////////////////////////
	
	wire clear_m;
	wire we_m;
	wire [31:0] instr_m;
	wire [31:2] PC_m;
	wire [31:0] reg_num2_m;
	wire [31:0] aluout_m;
	wire [31:0] hiout_m;
	wire [31:0] loout_m;
	wire [31:0] cp0out_m;
	wire [31:0] InstrM;
	wire [31:2] PCM;
	wire [31:0] RegNum2M;
	wire [31:0] AluOutM;
	wire [31:0] HiOutM;
	wire [31:0] LoOutM;
	wire [31:0] CP0outM;
	Reg_M the_RegM(clk, rst, we_m, clear_m, instr_m, PC_m, reg_num2_m, aluout_m, hiout_m, loout_m, cp0out_m, InstrM, PCM, RegNum2M, AluOutM, HiOutM, LoOutM, CP0outM);
	
	wire [5:0] opcode_m;
	wire [4:0] rs_m;
	wire [4:0] rt_m;
	wire [5:0] funct_m;
	wire now_device;
	wire [1:0] BeOP_out;
	wire [2:0] meOP_out;
	wire MemWrite;
	wire IOWrite;
	Control_M the_ControllerM(opcode_m, rs_m, rt_m, funct_m, now_device, BeOP_out, MemWrite, IOWrite, meOP_out);
	
	wire [31:0] AA_din;
	wire NowDevice;
	AddrAnalyzer the_AddrAnalyzer(AA_din, NowDevice);
	
	wire [1:0] be_aluout;
	wire [1:0] be_op_in;
	wire [3:0] be_out;
	becalc the_BECalc(be_aluout, be_op_in, be_out);
	
	wire [13:2] dm_addr;
	wire [3:0] be_in;
	wire [31:0] dm_din;
	wire dm_we;
	wire [31:0] dm_dout;
	dm_4k the_DM( dm_addr, be_in, dm_din, dm_we, clk, dm_dout );
	
	wire [1:0] me_aluout;
	wire [2:0] me_op_in;
	wire [31:0] me_din;
	wire [31:0] me_dout;
	MemExtender the_MemExtender(me_aluout, me_op_in, me_din, me_dout);
	
	////////////////////////////////////Phase W///////////////////////
	
	wire [31:0] instr_w;
	wire [31:2] PC_w;
	wire [31:0] aluout_w;
	wire [31:0] memout_w;
	wire [31:0] hiout_w;
	wire [31:0] loout_w;
	wire [31:0] cp0out_w;
	wire [31:0] InstrW;
	wire [31:2] PCW;
	wire [31:0] AluOutW;
	wire [31:0] MemOutW;
	wire [31:0] HiOutW;
	wire [31:0] LoOutW;
	wire [31:0] CP0outW;
	Reg_W the_RegW(clk, rst, instr_w, PC_w, aluout_w, memout_w, hiout_w, loout_w, cp0out_w, InstrW, PCW, AluOutW, MemOutW, HiOutW, LoOutW, CP0outW);
	
	wire [5:0] opcode_w;
	wire [4:0] rs_w;
	wire [4:0] rt_w;
	wire [5:0] funct_w;
	wire [1:0] WAdrs;
	wire [2:0] WDataSrc;
	Control_W the_ControllerW(opcode_w, rs_w, rt_w, funct_w, RegWE, WAdrs, WDataSrc);
	
	
	///////////////////////////////////////////// THE CLEVEREST MODULE IS HERE!! 
	
	wire [31:0] instr_D;
	wire [31:0] instr_E;
	wire [31:0] instr_M;
	wire [31:0] instr_W;
	wire branch_ok_D;
	wire int_req;
	wire EXLSet;
	wire EXLClr;
	wire ERR_PCReady, ERET_PCReady;
	
	wire [3:0] Sel_PCR, Sel_CmpA, Sel_CmpB, Sel_ALUA, Sel_ALUB, Sel_MemoData, Sel_RegNum2M;
	wire [3:0] Sel_CP0, Sel_Hi, Sel_Lo, Sel_CPUout;
	wire we_D, we_E, we_M, clear_D, clear_E, clear_M;
	wire PCWr_out;		
	HazardHandler the_HazardHandler(instr_D, instr_E, instr_M, instr_W, branch_ok_D, int_req,
					Sel_PCR, Sel_CmpA, Sel_CmpB, Sel_ALUA, Sel_ALUB, Sel_MemoData, Sel_RegNum2M,
					Sel_CP0, Sel_Hi, Sel_Lo, Sel_CPUout,
					we_D, we_E, we_M, clear_D, clear_E, clear_M, PCWr_out,
					EXLSet, EXLClr, ERR_PCReady, ERET_PCReady);

	
	///////////////////////////////////Phase F//////////////////////
	
	//PC PC(clk, next_pc, pc_wr, pc_out, reset);
	assign next_pc = next_pc_out;
	assign pc_wr = PCWr_out;
	
	//im_4k the_IM( im_addr, im_dout);
	assign im_addr = pc_out[12:2];
	
	///////////////////////////////////////////Phase D/////////////////////////////
	
	//Reg_D the_RegD(clk, rst, we_d, clear_d, instr_d, PC_d, InstrD, PCD);
	assign instr_d = im_dout;
	assign PC_d = pc_out+1;
	assign we_d = we_D;
	assign clear_d = clear_D;
	
	//Control_D the_ControllerD(opcode_d, rs_d, rt_d, funct_d, err_PC_ready, eret_PC_ready, ExtSign, PCSource_out, Cmp2Source, BranchOK, zero, pos)
	assign opcode_d = InstrD[31:26];
	assign rs_d = InstrD[25:21];
	assign rt_d = InstrD[20:16];
	assign funct_d = InstrD[5:0];
	assign err_PC_ready = ERR_PCReady;
	assign eret_PC_ready = ERET_PCReady;
	
	//NextPC ...(pc, imm_16_in, imm_26_in, reg_32_in, EPC_in, PCSource_in, next_pc_out);
	assign pc = pc_out+1;
	assign imm_16_in = InstrD[15:0];
	assign imm_26_in = InstrD[25:0];
	assign reg_32_in = (Sel_PCR == `SEL_FROME_PC) ? PCE<<2 :
					(Sel_PCR == `SEL_FROMM_PC) ? PCM<<2 :
					(Sel_PCR == `SEL_FROMW_PC) ? PCW<<2 :
					
					(Sel_PCR == `SEL_FROMM) ? AluOutM :
					(Sel_PCR == `SEL_FROMW_ALU) ? AluOutW :
					(Sel_PCR == `SEL_FROMW_MEM) ? MemOutW :
					
					(Sel_PCR == `SEL_FROMM_HI) ? HiOutM :
					(Sel_PCR == `SEL_FROMM_LO) ? LoOutM :
					(Sel_PCR == `SEL_FROMM_CP0) ? CP0outM :
					
					(Sel_PCR == `SEL_FROMW_HI) ? HiOutW :
					(Sel_PCR == `SEL_FROMW_LO) ? LoOutW :
					(Sel_PCR == `SEL_FROMW_CP0) ? CP0outW :
					data1;
					
	assign EPC_in = EPC_out;
	assign PCSource_in = PCSource_out;
	
	// RegFile the_RegFile(clk, RegWE, rst, w_adrs, w_data, adrs1, adrs2, data1, data2);
	assign adrs1 = rs_d;
	assign adrs2 = rt_d;
	
	//Comparer the_Comparer(cmp_num1, cmp_num2, zero, pos);
					  
	assign cmp_num1 = (Sel_CmpA == `SEL_FROME_PC) ? PCE<<2 :
					(Sel_CmpA == `SEL_FROMM_PC) ? PCM<<2 :
					(Sel_CmpA == `SEL_FROMW_PC) ? PCW<<2 :
					
					(Sel_CmpA == `SEL_FROMM) ? AluOutM :
					(Sel_CmpA == `SEL_FROMW_ALU) ? AluOutW :
					(Sel_CmpA == `SEL_FROMW_MEM) ? MemOutW :
					
					(Sel_CmpA == `SEL_FROMM_HI) ? HiOutM :
					(Sel_CmpA == `SEL_FROMM_LO) ? LoOutM :
					(Sel_CmpA == `SEL_FROMM_CP0) ? CP0outM :
					
					(Sel_CmpA == `SEL_FROMW_HI) ? HiOutW :
					(Sel_CmpA == `SEL_FROMW_LO) ? LoOutW :
					(Sel_CmpA == `SEL_FROMW_CP0) ? CP0outW :
					data1;
					
	assign cmp_num2 = (Sel_CmpB == `SEL_FROME_PC) ? PCE<<2 :
					(Sel_CmpB == `SEL_FROMM_PC) ? PCM<<2 :
					(Sel_CmpB == `SEL_FROMW_PC) ? PCW<<2 :
					
					(Sel_CmpB == `SEL_FROMM) ? AluOutM :
					(Sel_CmpB == `SEL_FROMW_ALU) ? AluOutW :
					(Sel_CmpB == `SEL_FROMW_MEM) ? MemOutW :
					
					(Sel_CmpB == `SEL_FROMM_HI) ? HiOutM :
					(Sel_CmpB == `SEL_FROMM_LO) ? LoOutM :
					(Sel_CmpB == `SEL_FROMM_CP0) ? CP0outM :
					
					(Sel_CmpB == `SEL_FROMW_HI) ? HiOutW :
					(Sel_CmpB == `SEL_FROMW_LO) ? LoOutW :
					(Sel_CmpB == `SEL_FROMW_CP0) ? CP0outW :
					
					(Cmp2Source == `CMP2_REG) ? data2:
					32'd0;
	
	//Extender the_Extender(num_16, sign, num_32);
	assign num_16 = InstrD[15:0];
	assign sign = ExtSign;
	
	////////////////////////////////////////////Phase E////////////////////////////
	
	//Reg_E the_RegE(clk, instr_e, PC_e, reg_num1_e, reg_num2_e, num32_e, InstrE, PCE, RegNum1E, RegNum2E,
		//Num32E)；
	assign instr_e = InstrD;
	assign PC_e = PCD;
	assign reg_num1_e = data1;
	assign reg_num2_e = data2;
	assign num32_e = num_32;
	assign we_e = we_E;
	assign clear_e = clear_E;
	
	//Control_E the_ControllerE(opcode_e, rs_e, rt_e, funct_e, ALUCommand, ALUSrc, ALUShift_out, HILOop, HILOwe);
	assign opcode_e = InstrE[31:26];
	assign rs_e = InstrE[25:21];
	assign rt_e = InstrE[20:16];
	assign funct_e = InstrE[5:0];
	
	//HILO the_HiLo(HLA_din, HLB_din, hilo_op, hilo_we, Hi_out, Lo_out);
	assign HLA_din = (Sel_Hi == `SEL_FROMM_PC) ? PCM <<2 :
				(Sel_Hi == `SEL_FROMW_PC) ? PCW <<2 :
				
				(Sel_Hi == `SEL_FROMM) ? AluOutM :
				(Sel_Hi == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_Hi== `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_Hi == `SEL_FROMM_HI) ? HiOutM :
				(Sel_Hi == `SEL_FROMM_LO) ? LoOutM :
				(Sel_Hi == `SEL_FROMM_CP0) ? CP0outM :
					
				(Sel_Hi == `SEL_FROMW_HI) ? HiOutW :
				(Sel_Hi == `SEL_FROMW_LO) ? LoOutW :
				(Sel_Hi == `SEL_FROMW_CP0) ? CP0outW :
				
				RegNum1E;
				
	assign HLB_din = (Sel_Lo == `SEL_FROMM_PC) ? PCM <<2 :
				(Sel_Lo == `SEL_FROMW_PC) ? PCW <<2 :
				
				(Sel_Lo == `SEL_FROMM) ? AluOutM :
				(Sel_Lo == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_Lo == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_Lo == `SEL_FROMM_HI) ? HiOutM :
				(Sel_Lo == `SEL_FROMM_LO) ? LoOutM :
				(Sel_Lo == `SEL_FROMM_CP0) ? CP0outM :
					
				(Sel_Lo == `SEL_FROMW_HI) ? HiOutW :
				(Sel_Lo == `SEL_FROMW_LO) ? LoOutW :
				(Sel_Lo == `SEL_FROMW_CP0) ? CP0outW :
	
				RegNum2E;
	
	assign hilo_op = HILOop;
	assign hilo_we = HILOwe;
	
	//ALU the_ALU(command, num1, num2, ALUShift, res);
	assign command = ALUCommand;
	assign num1 = (Sel_ALUA == `SEL_FROMM_PC) ? PCM <<2 :
				(Sel_ALUA == `SEL_FROMW_PC) ? PCW <<2 :
				
				(Sel_ALUA == `SEL_FROMM) ? AluOutM :
				(Sel_ALUA == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_ALUA == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_ALUA == `SEL_FROMM_HI) ? HiOutM :
				(Sel_ALUA == `SEL_FROMM_LO) ? LoOutM :
				(Sel_ALUA == `SEL_FROMM_CP0) ? CP0outM :
					
				(Sel_ALUA == `SEL_FROMW_HI) ? HiOutW :
				(Sel_ALUA == `SEL_FROMW_LO) ? LoOutW :
				(Sel_ALUA == `SEL_FROMW_CP0) ? CP0outW :
				RegNum1E;
				
	assign num2 = (Sel_ALUB == `SEL_FROMM_PC) ? PCM<<2 :
				(Sel_ALUB == `SEL_FROMW_PC) ? PCW<<2 :
				
				(Sel_ALUB == `SEL_FROMM) ? AluOutM :
				(Sel_ALUB == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_ALUB == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_ALUB == `SEL_FROMM_HI) ? HiOutM :
				(Sel_ALUB == `SEL_FROMM_LO) ? LoOutM :
				(Sel_ALUB == `SEL_FROMM_CP0) ? CP0outM :
					
				(Sel_ALUB == `SEL_FROMW_HI) ? HiOutW :
				(Sel_ALUB == `SEL_FROMW_LO) ? LoOutW :
				(Sel_ALUB == `SEL_FROMW_CP0) ? CP0outW :
				
					(ALUSrc == `ALUSRC_RT) ? RegNum2E : 
					(ALUSrc == `ALUSRC_IMM) ? Num32E :
					(ALUSrc == `ALUSRC_CONSTZERO) ? 32'd0 :
					32'd0;
	assign ALUShift = (ALUShift_out == `ALUSHIFT_SHAMT) ? InstrE[10:6] :
					(ALUShift_out == `ALUSHIFT_RS) ? RegNum1E[4:0] :
					(ALUShift_out == `ALUSHIFT_16) ? 5'd16 :
					5'd0;
					
    //cp0 the_cp0(clk, rst, cp0_din, pc_in, CP0We_in, hard_int, cp0_sel, EXLSet, EXLClr, IntReq ,EPC_out, 	cp0_dout);
	assign cp0_din = (Sel_CP0 == `SEL_FROMM_PC) ? PCM<<2 :
				(Sel_CP0 == `SEL_FROMW_PC) ? PCW<<2 :
				
				(Sel_CP0 == `SEL_FROMM) ? AluOutM :
				(Sel_CP0 == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_CP0 == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_CP0 == `SEL_FROMM_HI) ? HiOutM :
				(Sel_CP0 == `SEL_FROMM_LO) ? LoOutM :
				(Sel_CP0 == `SEL_FROMM_CP0) ? CP0outM :
					
				(Sel_CP0 == `SEL_FROMW_HI) ? HiOutW :
				(Sel_CP0 == `SEL_FROMW_LO) ? LoOutW :
				(Sel_CP0 == `SEL_FROMW_CP0) ? CP0outW :
				RegNum2E;
				
	assign pc_in = pc_out;
	assign CP0We_in = CP0We;
	assign hard_int = HardInt_in;
	assign cp0_sel = InstrE[15:11];
	assign EXL_set = EXLSet;
	assign EXL_clr = EXLClr;
	
	////////////////////////////////////////////Phase M//////////////////////
	
	//the_RegM(clk, instr_m, PC_m, reg_num2_m, aluout_m, hiout_m, loout_m, InstrM, PCM, RegNum2M, AluOutM, HiOutM, LoOutM);
	assign instr_m = InstrE;
	assign PC_m = PCE;
	assign reg_num2_m = (Sel_RegNum2M == `SEL_FROMW_PC) ? PCW<<2 :
						
						(Sel_RegNum2M == `SEL_FROMW_ALU) ? AluOutW :
						(Sel_RegNum2M == `SEL_FROMW_MEM) ? MemOutW :
						
						(Sel_CP0 == `SEL_FROMW_HI) ? HiOutW :
						(Sel_CP0 == `SEL_FROMW_LO) ? LoOutW :
						(Sel_CP0 == `SEL_FROMW_CP0) ? CP0outW :
						RegNum2E;
						
	assign aluout_m = res;
	assign hiout_m = Hi_out;
	assign loout_m = Lo_out;
	assign cp0out_m = cp0_dout;
	assign we_m = we_M;
	assign clear_m = clear_M;
	
	//Control_M the_ControllerM(opcode_m, rs_m, rt_m, funct_m, now_device, BeOP, MemWrite, IOWrite, meOP_out);
	assign opcode_m = InstrM[31:26];
	assign rs_m = InstrM[25:21];
	assign rt_m = InstrM[20:16];
	assign funct_m = InstrM[5:0];
	assign now_device = NowDevice;
	
	//becalc the_BECalc(be_aluout, be_op_in, be_out);
	assign be_aluout = AluOutM[1:0];
	assign be_op_in = BeOP_out;
	
	//AddrAnalyzer the_AddrAnalyzer(AA_din, NowDevice);
	assign AA_din = AluOutM; 
	
	//dm_4k the_DM( dm_addr, be_in, dm_din, dm_we, clk, dm_dout );
	assign dm_addr = AluOutM[13:2];
	assign be_in = be_out;
	assign dm_din = (Sel_MemoData == `SEL_FROMW_PC) ? PCW<<2 :
				(Sel_MemoData == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_MemoData == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_MemoData == `SEL_FROMW_HI) ? HiOutW :
				(Sel_MemoData == `SEL_FROMW_LO) ? LoOutW :
				(Sel_MemoData == `SEL_FROMW_CP0) ? CP0outW :
				RegNum2M;
				
	assign dm_we = MemWrite;
	
	//MemExtender the_MemExtender(me_aluout, me_op_in, me_din, me_dout);
	assign me_aluout = AluOutM[1:0];
	assign me_op_in = meOP_out;
	assign me_din = (NowDevice == `NOWDEVICE_MEMO) ? dm_dout : CPUIn;
	
	////////////////////////////////////////////Phase W
	
	//Reg_W the_RegW(clk, instr_w, PC_w, aluout_w, memout_w, hiout_w, loout_w, InstrW, PCW, AluOutW, MemOutW, HiOutW, LoOutW);
	assign instr_w = InstrM;
	assign PC_w = PCM;
	assign aluout_w = AluOutM;
	assign memout_w = me_dout;
	assign hiout_w = HiOutM;
	assign loout_w = LoOutM;
	assign cp0out_w = CP0outM;
	
	//Control_W the_ControllerW(opcode_w, rs_w, rt_w, funct_w, WAdrs, WDataSrc);
	assign opcode_w = InstrW[31:26];
	assign rs_w = InstrW[25:21];
	assign rt_w = InstrW[20:16];
	assign funct_w = InstrW[5:0];
	
	assign w_adrs = (WAdrs == `WADRS_RT) ? InstrW[20:16] :
					(WAdrs == `WADRS_RD) ? InstrW[15:11] :
					(WAdrs == `WADRS_31) ? 5'd31:
					4'd0;
					
	assign w_data = (WDataSrc == `WDATA_ALURES)? AluOutW : 
					(WDataSrc == `WDATA_PC) ? {PCW,2'b00}: 
					(WDataSrc == `WDATA_MEMRES) ? MemOutW :
					(WDataSrc == `WDATA_CP0) ? cp0_dout :
					(WDataSrc == `WDATA_HI) ? HiOutW :
					(WDataSrc == `WDATA_LO) ? LoOutW :
					32'd0;
	
	//the_HazardHandler(instr_D, instr_E, instr_M, instr_W, branch_ok_D, int_req,
				//	Sel_PCR, Sel_CmpA, Sel_CmpB, Sel_ALUA, Sel_ALUB, Sel_MemoData, 
					//we_D, we_E, we_M, clear_D, clear_E, clear_M, PCWr_out);
					
	assign instr_D = InstrD;
    assign instr_E = InstrE;
	assign instr_M = InstrM;
	assign instr_W = InstrW;
	assign int_req = IntReq;
	assign branch_ok_D = BranchOK;
	
	
	
	//mips(clk, rst, CPUAddr, BE, CPUIn, CPUOut, IOWe, clk_out, HardInt_in);
	assign CPUAddr = AluOutM[31:2];
	assign BE = be_out;
	assign CPUOut =(Sel_MemoData == `SEL_FROMW_PC) ? PCW<<2 :
				(Sel_MemoData == `SEL_FROMW_ALU) ? AluOutW :
				(Sel_MemoData == `SEL_FROMW_MEM) ? MemOutW :
				
				(Sel_MemoData == `SEL_FROMW_HI) ? HiOutW :
				(Sel_MemoData == `SEL_FROMW_LO) ? LoOutW :
				(Sel_MemoData == `SEL_FROMW_CP0) ? CP0outW :
				RegNum2M;
	assign IOWe = IOWrite;
	assign clk_out = clk;
	
	
endmodule
