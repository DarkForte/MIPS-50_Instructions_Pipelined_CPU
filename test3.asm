ori $16, $0, 1
ori $17, $0, 3
ori $8, $0, 1
lui $12, 1
lui $13, 10; 预定义的数据完毕
start:addu $4, $0,$16;第一段程序开始
addu $5, $0,$8
jal newadd;将之前所有的addu指令都改由子函数执行，上两步准备好参数
addu $16, $0, $2;将结果回写到$16里
subu $17,$17,$8
beq $16, $17, start;应该循环一次
ori $8, $0,4;在此对比各寄存器的值即可知道是否正确
ori $9, $0, 4
ori $10, $0, 8
start2:sw $12, 0($8);第二段程序开始
lw $14, 0($8)
sw $13,4($8)
lw $15,4($8)
sw $14, -4($8)
lw $18, -4($8)
addu $4,$0,$8
addu $5,$0,$9
jal newadd
addu $8, $0, $2
beq $8, $10,start2
subu $8, $10, $8
beq $8, $0, end1
lui $12, 65535
end1:ori $0, $0, 1;第二段程序结束，在此对比各寄存器的值和内存的值即可知道是否正确
lui $8, 5
lui $9, 50
start3:addu $4, $0, $8;第三段程序开始
addu $5, $0, $9
jal newadd
addu $8, $0, $2
addu $4, $0, $8
addu $5, $0, $9
jal newadd
addu $9, $0, $2
addu $9, $8, $9
subu $9, $9, $8
lui $10, 0x69
beq $9, $10, start4;应该跳转
beq $0, $0, start3;如果上一句没有跳转，就会永远循环下去
start4:j end;在此对比寄存器的值即可知道是否正确
newadd:addu $2, $4, $5;用于计算addu的子程序
jr $31
end:

