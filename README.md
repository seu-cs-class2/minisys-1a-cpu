# minisys-1a-cpu

Minisys 体系五级流水CPU。

## 流水级

  - 取指 IF (Instruction Fetch)
  - 译码 ID (Instruction Decode)
  - 执行 EX (EXecute)
  - 访存 MEM (MEMory)
  - 写回 WB (Write Back)
### 上次测试使用指令
`lui $1,10	|	3C01000A	|	将立即数赋值给1号寄存器`
`lui $2,1	|	3C020001	|	将立即数赋值给2号寄存器`
`div $1,$2	|	0022001A	|	$1除以$2，商为10，余数为0`
`mflo $3		|	00001812	|	将LO寄存器的值赋给$3`
`divu $1,$2	|	0022001B	|	$1除以$2（无符号），结果同上`
`mflo $4		|	00002012	|	将LO寄存器的值赋给$4`

### 测试结果 

暂停流水正常，div结果正常，数据冲突解决bug已修复，写HILO与读HILO冲突解决正常