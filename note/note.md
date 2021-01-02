## PC - DONE

pc 当前PC值

pause 流水暂停，暂停取指

branch_en_in 转移

branch_addr_in 转移到的目标PC

## IF-ID

if_pc 取指的PC

if_ins 取到的指令

id_pc 送去译码的PC

id_ins 送去译码的指令

pause 暂停流水线

## ID

译码的目的是了解oprand1、oprand2是什么，了解res的存放地点，了解op

pc_in PC

ins_in 指令

reg1_data_in 寄存器来向数据1

reg2_data_in 寄存器来向数据2

reg1_re_out 寄存器1读使能

reg2_re_out 寄存器2读使能

reg1_addr_out, // 寄存器读地址1

reg2_addr_out, // 寄存器读地址2