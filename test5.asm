start1:ori $s1, $0, 1; 第一端程序会在内存中顺序写入1~9
addi $18, $0, 10
fill:sb $s1,0($s0)
addi $s0,$s0,1
addi $s1, $s1, 1
bne $s1, $18, fill
start2:lb $8, 0($0); 在这里对比内存数据即可，内存数据应为04030201 08070605 xxxxxx09
lbu $9, 1($0); 本段程序将大量测试运算指令，一个寄存器存储一种运算指令的结果
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
traps:blez $0, jp1; 在此对比所有寄存器即可知道运算指令是否正确
beq $0, $0, start2; 本端程序测试各种跳转指令，所有的branch指令都应该跳转
jp1:bgez $0, jp2; 路线为traps->jp1->jp2->jp3->start3, 只要一句出错就会死循环
j start2
jp2: bltz $23, jp3
j start2
jp3: slti $25, $15, 1026
bgtz $25, start3
j start2
start3:addi $9, $0, 0x00003098; 成功到达这里说明跳转指令执行正确
jalr $22, $9; 用9号寄存器跳转，当前地址存在了22寄存器里
addi $4, $0, 3; 对比$4即可知道是否正确
jal roller; roller是递归调用函数
add $15, $0, $2; 若$15=3, 则正确
j end; 程序应在此结束
extra_test:xori $8, $0, 10; extra_test将会测试之前没有测试过的立即数运算指令
andi $9, $8, 65535
addu $10, $8, $9
subu $11, $8, $9
sltiu $12, $11,0
bgtz $12, extra_test
jr $22; 在此对比寄存器数据即可判断是否正确
roller: addi $8, $0, 1; roller是一个递归函数，f(x) = f(x-1) +1, f(1) = 1
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
jr $31; 最后返回值应该为3
end:

