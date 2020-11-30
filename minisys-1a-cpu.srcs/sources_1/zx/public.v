// public.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`timescale 1ns / 1ps

`define Enable 1'b1
`define Disable 1'b0

// Minisys体系结构相关
`define ZeroWord 32'h00000000 // 0x0字
`define RegCount 32 // 寄存器数
`define RegCountLog2 5 // 寄存器数Log2
`define RegRange 31:0 // 寄存器数范围
`define RegRangeLog2 4:0 // 寄存器数Log2范围（地址）
`define WordLength 32 // 字长
`define WordRange 31:0 // 字长范围
`define OpRange 31:26 // 指令字中op的范围
`define RsRange 25:21 // 指令字中rs的范围
`define RtRange 20:16 // 指令字中rt的范围
`define RdRange 15:11 // 指令字中rd的范围
`define ShamtRange 10:6 // 指令字中shamt的范围
`define FuncRange 5:0 // 指令字中func的范围
`define ImmedRange 15:0 // 指令字中immediate的范围
`define OffsetRange 15:0 // 指令字中offset的范围
`define AddressRange 25:0 // 指令字中address的范围

// 设计相关
// ALU相关
`define ALUOpRange 4:0 // ALUOp范围，最高32种操作
// ALUOP定义
`define ALUOP_NOP 5'd0
`define ALUOP_ADDU 5'd1
`define ALUOP_ADD 5'd2
`define ALUOP_SUBU 5'd3
`define ALUOP_SUB 5'd4
`define ALUOP_MULTU 5'd5
`define ALUOP_MULT 5'd6
`define ALUOP_DIVU 5'd7
`define ALUOP_DIV 5'd8
`define ALUOP_AND 5'd9
`define ALUOP_OR 5'd10
`define ALUOP_XOR 5'd11
`define ALUOP_NOR 5'd12
`define ALUOP_SLL 5'd13 // 逻辑左移
`define ALUOP_SRL 5'd14 // 逻辑右移
`define ALUOP_SRA 5'd15 // 算术右移
// EXOP
`define EXOP_MFHI 5'd16
`define EXOP_MFLO 5'd17
`define EXOP_MTHI 5'd18
`define EXOP_MTLO 5'd19

// Minisys指令集
// R型指令
`define OP_RTYPE 6'b000000
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_MULT 6'b011000
`define FUNC_MULTU 6'b011001
`define FUNC_DIV 6'b011010
`define FUNC_DIVU 6'b011011
`define FUNC_MFHI 6'b010000
`define FUNC_MFLO 6'b010010
`define FUNC_MTHI 6'b010001
`define FUNC_MTLO 6'b010011
// `define FUNC_MFC0 6'?
// `define FUNC_MTC0 6'?
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_JR 6'b001000
`define FUNC_JALR 6'b001001
`define FUNC_BREAK 6'b001101
`define FUNC_SYSCALL 6'b001100
`define FUNC_ERET 6'b011000
// I型指令
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_ANDI 6'b001100
`define OP_ORI 6'b001101
`define OP_XORI 6'b001110
`define OP_LUI 6'b001111
`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_LW 6'b100011
`define OP_SW 6'b101011
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGEZ 6'b000001
`define OP_BGTZ 6'b000111
`define OP_BLEZ 6'b000110
`define OP_BLTZ 6'b000111
`define OP_BGEZAL 6'b000001
`define OP_BLTZAL 6'b000001
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
// J型指令
`define OP_J 6'b000010
`define OP_JAL 6'b000011
// FIXME NOP
`define OP_NOP 6'b000000
