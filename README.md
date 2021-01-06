
Minisys 体系五级流水CPU。

## 流水级

  - 取指 IF (Instruction Fetch)
  - 译码 ID (Instruction Decode)
  - 执行 EX (EXecute)
  - 访存 MEM (MEMory)
  - 写回 WB (Write Back)
## 外设端口、规范与引脚信息
### 板上器件

| 板上器件                            | 类型 | 芯片引脚                                                     | 编址       | 重写进度 |
| ----------------------------------- | ---- | ------------------------------------------------------------ | ---------- | -------- |
| 拨码开关 SW0 ~ SW23                 | IN   | W4, R4, T4, T5, U5, W6, W5, U6, V5, R6, T6, Y6, <br>AA6, V7, AB7, AB6, V9, V8, AA8, AB8, Y8, Y7, W9, Y9 | 0xFFFFFC70 | 已完成   |
| 按钮 S1 ~ S5（右左上中下）          | IN   | R1, P1, P5, P4, P2                                           |            | 需要     |
| 4×4 矩阵键盘（左上-右下）           | IN   | 0 ~ 3 行 M2, K6, J6, L5；0 ~ 3 列 K4, J4, L3, K3             | 0xFFFFFC10 | 需要     |
| 八位七段共阳极数码管（左-右，A-DP） | OUT  | 使能：A18, A20, B20, E18, F18, D19, E19, C19<br>段选：F15, F13, F14, F16, E17, C14, C15, E13 | 0xFFFFFC00 | 已完成   |
| 蜂鸣器                              | OUT  | A19                                                          | 0xFFFFFD10 | 已完成   |
| LED 灯（0-7）                       | OUT  | 红：N19, N20, M20, K13, K14, M13, L13, K17<br>黄：J17, L14, L15, L16, K16, M15, M16, M17<br>绿：A21, E22, D22, E21, D21, G21, G22, F21 | 0xFFFFFC60 | 已完成   |

### 内部端口

| 部件             | 编址       | 重写进度 |
| ---------------- | ---------- | -------- |
| 定时器           | 0xFFFFFC20 | 需要     |
| PWM 脉冲宽度调制 | 0xFFFFFC30 | 需要     |
| UART 串口通讯    | 0xFFFFFC40 | 需要     |
| Watch Dog        | 0xFFFFFC50 | 需要     |

### 外设驱动规范

cpu使用总线连接RAM与外设，总线包括`地址总线` `写入数据总线` `控制总线` 与 `读数据总线`   

其中，地址总线、写数据总线与控制总线的主设备只可能是CPU，因此不需要仲裁 ，读数据总线的主设备可能是任意外设（RAM），因此需要一个控制部件来控制总线的使用权。  

所有的外设驱动应包含总线的输入输出，包括：  

```
input wire rst,  					// 重置
input wire clk,						// 时钟
input wire[`WordRange] addr,		// 数据总线（32bits）
input wire en, 						// 控制-使能（高电平有效）
input wire[3:0] byte_sel,			// 控制-自己额选择
input wire[`WordRange] data_in, 	// 写入数据总线（32bits）
input wire we, 						// 控制-写使能（高电平有效）

output reg[`WordRange] data_out		// 读数据总线（32bits，接到仲裁器上）
```

同时，所有外设都是用端口（寄存器）来缓存数据，每个外设最多拥有16字节（4个字）的端口，外设驱动应指明端口所对应的物理地址，并在驱动内部进行地址译码判断CPU是否读/写此外设端口。  

对于直通型外设（如led灯、蜂鸣器）也同样适用上述规范。


## 测试记录

### 上次测试使用指令

指令目的：持续读拨码开关的状态，并直接写入led端口点亮对应灯

```
lui $1,0	|	3C01000A	|	将立即数0赋值给1号寄存器
addi $1,$1,fc70	|	fffffc70	|	$1 <- FFFFFC70(拨码开关地址)
lui $2,0	|	3C020000	|	将立即数0赋值给2号寄存器
addi $2,$2,fc60	|	2042FC60	|	$2 <- FFFFFC60(led灯地址)
lw $3,0($1)	|	8C230000	|	读拨码开关端口（寄存器）
sw $2,0($2)	|	AC430000	|	写led端口（寄存器）
j 0	|	0800000	|	跳回第一条指令
```

### 测试结果 

发现了存储器相关指令的数据冲突，已使用转发法解决，上述测试指令的功能仿真已经通过，外设总线与端口功能正常，可以准备上板。

