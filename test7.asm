ori $19, $0, 64513
mtc0 $19, $12
ori $s6, $0,0x00007F10
lw $s1, 0($s6)
add $s3, $0, $s1
ori $t0, $0, 10000000 #the initial value
ori $s7, $0, 0x00007F00
sw $t0, 4($s7)
or $t0, $0, 9
sw $t0, 0($s7)
loop:lw $s2, 0($s6)
bne $s1, $s2, adjust
j loop
adjust: add $s1,$0, $s2
add $s3, $0, $s1
j loop 
