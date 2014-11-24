addi $sp, $sp, -8
sw $8, 4($sp)
sw $9, 0($sp)
ori $8, $0, 0
ori $9, $0, 0x00007F00
sw $8, 0($9)
ori $8, $0, 30
sw $8, 4($9)
ori $8, $0, 25
sw $8, 0($9)
lw $9, 0($sp)
lw $8, 4($sp)
addi $sp, $sp, 8
eret
