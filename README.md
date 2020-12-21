# *minisys*-1a-cpu

Minisys 体系五级流水CPU。

## 流水级

  - 取指 IF (Instruction Fetch)
  - 译码 ID (Instruction Decode)
  - 执行 EX (EXecute)
  - 访存 MEM (MEMory)
  - 写回 WB (Write Back)
## 端口与引脚信息
### 板上器件

| 板上器件                            | 类型 | 芯片引脚                                                     | 编址       |
| ----------------------------------- | ---- | ------------------------------------------------------------ | ---------- |
| 拨码开关 SW0 ~ SW23                 | IN   | W4, R4, T4, T5, U5, W6, W5, U6, V5, R6, T6, Y6, <br>AA6, V7, AB7, AB6, V9, V8, AA8, AB8, Y8, Y7, W9, Y9 | 0xFFFFFC70 |
| 按钮 S1 ~ S5（右左上中下）          | IN   | R1, P1, P5, P4, P2                                           |            |
| 4×4 矩阵键盘（左上-右下）           | IN   | 0 ~ 3 行 M2, K6, J6, L5；0 ~ 3 列 K4, J4, L3, K3             | 0xFFFFFC10 |
| 八位七段共阳极数码管（左-右，A-DP） | OUT  | 使能：A18, A20, B20, E18, F18, D19, E19, C19<br>段选：F15, F13, F14, F16, E17, C14, C15, E13 | 0xFFFFFC00 |
| 蜂鸣器                              | OUT  | A19                                                          | 0xFFFFFD10 |
| LED 灯（0-7）                       | OUT  | 红：N19, N20, M20, K13, K14, M13, L13, K17<br>黄：J17, L14, L15, L16, K16, M15, M16, M17<br>绿：A21, E22, D22, E21, D21, G21, G22, F21 | 0xFFFFFC60 |

### 内部端口

| 部件             | 编址       |
| ---------------- | ---------- |
| 定时器           | 0xFFFFFC20 |
| PWM 脉冲宽度调制 | 0xFFFFFC30 |
| UART 串口通讯    | 0xFFFFFC40 |
| Watch Dog        | 0xFFFFFC50 |

## 测试记录

### 上次测试使用指令
```
lui $1,10	|	3C01000A	|	将立即数赋值给1号寄存器
lui $2,1	|	3C020001	|	将立即数赋值给2号寄存器
sw $1,0($2)	|	AC410000	|	将0001000地址开始的4个字节存储为($1)，同时测试数据相关
nop		|	00000000	|	空指令填充流水
nop		|	00000000	|	空指令填充流水
nop		|	00000000	|	空指令填充流水
sw $2,0($1)	|	AC220000	|	将000a000地址开始的四个字节存储为($2)
lw $3,0($1)	|	8C230000	|	将000a000地址开始的四个字节赋给$3
lw $4,0($2)	|	8C440000	|	将0001000地址开始的四个字节赋给$4
```

### 测试结果 

解决了部分bug，lw/sw指令正常工作，对于ram的clk是否需要相反还持怀疑态度。

