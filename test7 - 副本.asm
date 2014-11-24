ori $19, $0, 64513
mtc0 $19, $12 // 开中断
ori $s6, $0,0x00007F10 // S6：开关得只
lw $s1, 0($s6) // S1：现在的base
add $s3, $0, $s1 //S3：现在的真正的值
ori $t0, $0, 10
ori $s7, $0, 0x00007F00
sw $t0, 4($s7) //设置初值
or $t0, $0, 9 // 开启计数器
sw $t0, 0($s7)
loop:lw $s2, 0($s6)//S2：现在的开关值
bne $s1, $s2, adjust
j loop
adjust: add $s1,$0, $s2
add $s3, $0, $s1 //把现在真正的值改成新base
j loop 
