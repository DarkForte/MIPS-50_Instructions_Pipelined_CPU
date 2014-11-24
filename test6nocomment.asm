ori $8, $0, 3
ori $9, $0, 4
mult $8, $9
mflo $10
addi $11, $0, -3
ori $12, $0, 4
mult $11, $12
mflo $13
multu $11, $12
mflo $14
mfhi $15
slt $16, $14, $15
sltu $17, $14, $15
div $9, $8
mfhi $20
mflo $21
divu $12, $11
mfhi $22
mflo $23
addi $24, $0, 17
addi $25, $0, -6
mult $24, $25
mfhi $18
mflo $19
mthi $8
mtlo $9
start2:
ori $19, $0, 64513
ori $20, $0, 12
mtc0 $19, $12
mfc0 $8, $12
ori $16, $0, 30
ori $17, $0, 0x00007F00
sw $16, 4($17) 
ori $16, $0, 25    
sw $16, 0($17)
loop:j loop
