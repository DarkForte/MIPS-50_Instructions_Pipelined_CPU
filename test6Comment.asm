.ktext 0x00003000
ori $8, $0, 3; 一开始是乘除法的测试
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
start2:;在这里对比寄存器数据和hi lo 数据即可；从这里开始是针对计数器的操作
ori $19, $0, 64513; 64513:111111 000000 000 1,开启所有设备中断和全局中断
ori $20, $0, 12;12:CP0的Status Reg地址
mtc0 $19, $12
mfc0 $8, $12; 测试mfc0指令，$8应在此时变为64513
ori $16, $0, 30; 30: 计数器的初始值
ori $17, $0, 0x00007F00; 设备的地址
sw $16, 4($17) ; 写初值
ori $16, $0, 25; 25:11001, 从左到右：1=重置开（无用） 1=中断开 00=模式0  1=计数使能开
sb $16, 0($17); 写控制
loop:j loop; 开始循环
