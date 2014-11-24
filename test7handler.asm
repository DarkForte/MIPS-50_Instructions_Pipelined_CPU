ori $s7, $0, 0x00007F00
ori $t2, $0, 0
sw $t2, 0($s7)
ori $t2, $0, 10000000 #the initial value
sw $t2, 4($s7)
addi $s3, $s3,1
ori $t1, $0, 0x00007F20
sw $s3, 0($t1)
ori $t2,$0, 9
sw $t2, 0($s7)
eret
