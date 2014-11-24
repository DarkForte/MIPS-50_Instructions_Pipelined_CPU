.text
.globl main
.ent main
main:

#### No.1 Instr-sequence 
ori $2, $0, 0x0f0f
ori $4, $0, 0x0008
ori $3, $0, 0x1111
ori $5, $0, 0x0004
sw   $4, 0($0)
ori $28, $28, 0x1
ori $6, 0x03
andi $7, $6, 0x01		# I.E_RS -- Cal.M


#### No.2 Instr-sequence
addi $8, $6, 0x02		# I.E_RS -- Cal.W


#### No.3 Instr-sequence
lw   $5, 0($0)
ori $9, $5, 0x4444		# I.E_RS -- Load.M & I.E_RS -- Load.W


#### No.3 Instr-sequence
ori $10, $5, 0x2222
jal f1					# I.E_RS -- Jal.M(impossible)  I.E_RS -- Jal.W

#### No.4 Instr-sequence
jal f2					


#### No.5 Instr-sequence
jal f3					


#### No.6 Instr-sequence
addu $13, $0, $9
addu $14, $13, $0
addu $15, $14, $0		# R.E_RS -- Cal.M


#### No.7 Instr-sequence
addu $16, $14, $0		# R.E_RS -- Cal.W


#### No.8 Instr-sequence
ori $25, $0, 0x4
sw $2, 0($25)			# Store.E_RS -- Cal.M


#### No.9 Instr-sequence
ori $24, $0, 0x8
nop
sw $5, 0($24)			# Store.E_RS -- Cal.W


#### No.10 Instr-sequence
ori $25, $0, 0x8
lw $17, 0($25)			# Load.E_RS -- Cal.M


#### No.11 Instr-sequence
ori $24, $0, 0x4
nop
lw $18, 0($24)			# Load.E_RS -- Cal.W


#### No.12 Instr-sequence
nop
beq $18, $2, _lbl1 		# Br.D_RS -- Load.M
ori $19, $0, 0x9999		# No Execute

#### No.13 Instr-sequence
_lbl1:
nop
lw $17, 0($24)
beq $17, $2, _lbl2 		# Br.D_RS -- Load.E
ori $19, $0, 0x9999		# No Execute


#### No.14 Instr-sequence
_lbl2:
lw $5, 0($24)
nop
nop
beq $5, $2, _lbl3 		# Br.D_RS -- Load.W
ori $6, $0, 0xbbbb		# No Execute
_lbl3:


#### No.15 Instr-sequence
addu $7, $2, $0
addu $8, $3, $0
beq $8, $7, _lbl4 		# Br.D_RS -- Cal.E && Br.D_RS -- Cal.M && Br.D_RT -- Cal.W

#### No.16 Instr-sequence
ori $9, $0, 0x0916
_lbl4:
ori $10, $0, 0x1111
bne $10, $9, _lbl5 		# Br.D_RT -- Cal.E && Br.D_RT -- Cal.M && Br.D_RS -- Cal.W
ori $11, $0, 0x2222

#### No.17 Instr-sequence
_lbl5:
lw $12, 0($24)
nop
nop
beq $2, $12, _lbl6 		# Br.D_RT -- Load.W
ori $13, $0, 0x4444
_lbl6:

#### No.18 Instr-sequence
ori $14, $0, 0x5555
addu $15, $2, $14		# R.E_RT -- Cal.M


#### No.19 Instr-sequence
addu $16, $3, $14		# R.E_RT -- Cal.W


#### No.20 Instr-sequence
sw $16, 0x10($0)		# STORE.M_RT -- Cal.W


#### No.21 Instr-sequence
lw $17, 0($0)
addu $18, $17, $2		# R.E_RS -- Load.M


#### No.22 Instr-sequence
lw $19, 0x8($0)
nop
addu $20, $19, $2		# R.E_RS -- Load.W


#### No.23 Instr-sequence
ori $21, $0, 4
sw $4, 0($0)			# prepare for store_rs load_rs
lw $5, 8($0)
addu $6, $0, $5			# R.E_RT -- Load.M & R.E_RT -- Load.W


#### No.24 Instr-sequence
addu $7, $0, $5
lw $8, 0($0)
lw $9, 0($8)			# Load.E_RS -- Load.M & Load.E_RS -- Load.W


#### No.25 Instr-sequence
lw $10, 0($8)
sw $10, 0x34($0)		# STORE.M_RT -- Load.W


#### No.26 Instr-sequence
lw $22, 0($0)
sw $2, 0x38($22)		# Store.E_RS -- Load.M & Store.E_RS -- Load.W


#### No.27 Instr-sequence
addu $9,$31,$0
jal f4


#### No.28 Instr-sequence
jal f5


#### No.29 Instr-sequence
jal f6


#### No.30 Instr-sequence
jal f7


#### No.31 Instr-sequence
la $16, f8 
jalr $16		# JALR.D_RS -- Cal.E & JALR.D_RS -- Cal.M


#### No.32 Instr-sequence
nop
nop
nop	
la $18, f10 
nop
nop
jalr $18		# JALR.D_RS -- Cal.W


#### No.33 Instr-sequence
sw $16, 0x44($0)
sw $17, 0x48($0)
sw $18, 0x4c($0)
and $13, $0, $0
and $14, $0, $0
xor $16, $15, $16
lw $16, 0x44($0)
jalr $16				# JALR.D_RS -- Load.E


#### No.34 Instr-sequence
lw $16, 0x48($0)
beq $4, $16, _lbl7		# Br.D_RT -- Load.E & Br.D_RT -- Load.M & Br.D_RT -- Load.W
addiu $16, $16, 2
addiu $16, $16, 2

#### died loop
_lbl7:
lw $18, 0x48($0)
addiu $18, $18, 2
addiu $19, $18, 2
_loop:
j _loop		


.end main

.globl f1
f1:
.ent f1
ori $11, $31, 0xff	# I.E_RS -- Jal.M
ori $12, $31, 0x0f
jr $31
.end f1

.globl f2
f2:
.ent f2
jalr $26, $31		# JALR.D -- JAL.M
.end f2

.globl f3
f3:
.ent f3
nop
jalr $26, $31		# JALR.D -- JAL.W
.end f3

.globl f4
f4:
.ent f4
bne $31, $9, _f4_lbl	# Br.D_RS -- JAL.M
ori $5, $0, 0x0987
_f4_lbl:
jr $31
.end f4

.globl f5
f5:
.ent f5
addu $9,$0,$31
beq $31, $9, _f5_lbl	# Br.D_RT -- JAL.W
ori $6, $0, 0x0987
_f5_lbl:
jr $31
.end f5

.globl f6
f6:
.ent f6
addu $8, $31, $31		# R.E_RS&RT -- JAL.W
addu $9, $31, $31		
jr $31
.end f6

.globl f7
f7:
.ent f7
sw $31, 0x40($0)		# Store.E_RT -- JAL.W
jr $31
.end f7

.globl f8
f8:
.ent f8
addiu $13, $0, 0x1111
jr $31
.end f8

.globl f9
f9:
.ent f9
addiu $14, $0, 0x2222
jr $31
.end f9

.globl f10
f10:
.ent f10
addiu $15, $0, 0x3333
jr $31
.end f10
