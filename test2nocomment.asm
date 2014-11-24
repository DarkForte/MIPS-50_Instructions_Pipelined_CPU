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
beq $8, $0, end1
lui $12, 65535
end1:ori $0, $0, 1
lui $8, 5
lui $9, 50
start3:addu $8, $9, $8
addu $9, $8, $9
subu $9, $9, $8
subu $8, $8, $9
lui $10, 5
beq $8, $10, start4
beq $0, $0, start3
start4:ori $16, $0, 12
ori $17, $0, 16
lw $18, 0($16)
sw $18, 0($17)
lw $18, -4($16)
sw $18, 4($17)
lw $18, -8($16)
sw $18, 8($17)
lw $18,-12($16)
sw $18, 12($17)





