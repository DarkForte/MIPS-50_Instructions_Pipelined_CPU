start1:ori $s1, $0, 1
addi $18, $0, 10
fill:sb $s1,0($s0)
addi $s0,$s0,1
addi $s1, $s1, 1
bne $s1, $18, fill
start2:lb $8, 0($0)
lbu $9, 1($0)
lhu $10, 2($0)
lw $11, 4($0) 
lui $12, 65535
add $13, $8, $10
sub $14, $11, $10
and $15, $10, $11
or $16, $10, $11
xor $17, $10, $11
nor $18, $10, $11
sll $19, $8, 4
sllv $20, $8, $9
srl $21, $10, 4
srlv $22, $10, $9
sra $23, $12, 16
srav $24, $12, $9
traps:blez $0, jp1
beq $0, $0, start2
jp1:bgez $0, jp2
j start2
jp2: bltz $23, jp3
j start2
jp3: slti $25, $15, 1026
bgtz $25, start3
j start2
start3:addi $9, $0, 0x00003098
jalr $22, $9
addi $4, $0, 3
jal roller
add $15, $0, $2
j end
extra_test:xori $8, $0, 10
andi $9, $8, 65535
addu $10, $8, $9
subu $11, $8, $9
sltiu $12, $11,0
bgtz $12, extra_test
jr $22
roller: addi $8, $0, 1
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp) 
beq $4, $8, exit_roller
addi $a0, $a0, -1
jal roller
exit_roller:addi $v0, $v0, 1
lw $ra, 4($sp)
lw $a0, 0($sp)
addi $sp, $sp, 8
jr $31
end:

