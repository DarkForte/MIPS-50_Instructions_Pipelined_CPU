ori $16, $0, 1
ori $17, $0, 3
ori $8, $0, 1 
lui $12, 1
lui $13, 10
start:addu $16, $16, $8 
subu $17,$17,$8 
beq $16, $17, start
ori $8, $0,4
ori $9, $0, 4
ori $10, $0, 8
start2:sw $12, 0($8)
lw $14, 0($8)
sw $13,4($8)
lw $15,4($8)
sw $14, -4($8)
lw $18, -4($8)
addu $8, $9, $8
beq $8, $10,start2
subu $8, $10, $8
beq $8, $0, end
lui $12, 65535
end: