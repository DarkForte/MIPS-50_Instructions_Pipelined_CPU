`define ADD 4'd1
`define ADDU 4'd2
`define SUB 4'd3
`define SUBU 4'd4
`define SLL 4'd5
`define SRL 4'd6
`define SRA 4'd7
`define AND 4'd8
`define OR 4'd9
`define XOR 4'd10
`define NOR 4'd11
`define SLT 4'd12
`define SLTU 4'd13

`define ALUSHIFT_SHAMT 2'd0
`define ALUSHIFT_RS 2'd1
`define ALUSHIFT_16 2'd2
///////////////////////////////

`define ZERO_EXT 1'b0
`define SIGN_EXT 1'b1

///////////////////////////////

`define OP_RTYPE 6'b000000
`define OP_ORI 6'b001101
`define OP_LW 6'b100011
`define OP_SW 6'b101011
`define OP_BEQ 6'b000100
`define OP_LUI 6'b001111
`define OP_J 6'b000010
`define OP_JAL 6'b000011

`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101

`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_ANDI 6'b001100
`define OP_XORI 6'b001110
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011

`define OP_BNE 6'b000101
`define OP_BLEZ 6'b000110
`define OP_BGTZ 6'b000111

`define OP_CP0 6'b010000
`define RS_ERET 5'b10000
`define RS_MFC0 5'b00000
`define RS_MTCO 5'b00100

`define OP_BLTZBGEZ 6'b000001
`define RT_BGEZ 5'b00001
`define RT_BLTZ 5'b00000


`define FUNCT_ADDU 6'b100001
`define FUNCT_SUBU 6'b100011
`define FUNCT_JR 6'b001000
`define FUNCT_ADD 6'b100000
`define FUNCT_AND 6'b100100
`define FUNCT_SUB 6'b100010
`define FUNCT_SLL 6'b000000
`define FUNCT_SRL 6'b000010
`define FUNCT_SRA 6'b000011
`define FUNCT_SLLV 6'b000100
`define FUNCT_SRLV 6'b000110
`define FUNCT_SRAV 6'b000111
`define FUNCT_OR 6'b100101
`define FUNCT_XOR 6'b100110
`define FUNCT_NOR 6'b100111
`define FUNCT_JALR 6'b001001
`define FUNCT_SLT 6'b101010
`define FUNCT_SLTU 6'b101011
`define FUNCT_MULT 6'b011000
`define FUNCT_MULTU 6'b011001
`define FUNCT_DIV 6'b011010
`define FUNCT_DIVU 6'b011011

`define FUNCT_MFHI 6'b010000
`define FUNCT_MFLO 6'b010010
`define FUNCT_MTHI 6'b010001
`define FUNCT_MTLO 6'b010011 

`define WADRS_RT 2'b01
`define WADRS_RD 2'b00
`define WADRS_31 2'b10

`define ALUSRC_IMM 2'd1
`define ALUSRC_RT 2'd0
`define ALUSRC_CONSTZERO 2'd2

`define ALUSHIFT_SHAMT 2'd0
`define ALUSHIFT_RS 2'd1
`define ALUSHIFT_16 2'd2

`define WDATA_ALURES 3'b001
`define WDATA_MEMRES 3'b000
`define WDATA_PC 3'b011
`define WDATA_ALUSIGN 3'b010
`define WDATA_CP0 3'b100
`define WDATA_HI 3'b101
`define WDATA_LO 3'b110

`define NOWDEVICE_MEMO 'd0
`define NOWDEVICE_IO 'd1

`define PC_NORMAL 3'b000
`define PC_ADD 3'b001
`define PC_J 3'b010
`define PC_JR 3'b011
`define PC_ERROR 3'b100
`define PC_EPC 3'b101

`define BE_SB 2'b00
`define BE_SH 2'b01
`define BE_SW 2'b10

`define ME_LB 3'b000
`define ME_LBU 3'b001
`define ME_LH 3'b010
`define ME_LHU 3'b011
`define ME_LW 3'b100

`define MULT 3'd0
`define MULTU 3'd1
`define DIV 3'd2
`define DIVU 3'd3
`define MTHI 3'd4
`define MTLO 3'd5

`define SEL_NORMAL 4'd0
`define SEL_FROME 4'd1
`define SEL_FROMM 4'd2
`define SEL_FROMW_ALU 4'd3
`define SEL_FROMW_MEM 4'd4
`define SEL_FROME_PC 4'd5
`define SEL_FROMM_PC 4'd6
`define SEL_FROMW_PC 4'd7

`define SEL_FROMM_HI 4'd8
`define SEL_FROMM_LO 4'd9
`define SEL_FROMM_CP0 4'd10

`define SEL_FROMW_HI 4'd11
`define SEL_FROMW_LO 4'd12
`define SEL_FROMW_CP0 4'd13

`define CMP2_REG 1'd0
`define CMP2_CONSTZERO 1'd1

///////////////////////////////

`define CP0_SR 4'd12
`define CP0_CAUSE 4'd13
`define CP0_EPC 4'd14
`define CP0_PRID 4'd15

`define CLK_FRQ             100000      // 100KHz : system clock
`define CYCLE               (1000000000/`CLK_FRQ)

`timescale 1ns/1ns





