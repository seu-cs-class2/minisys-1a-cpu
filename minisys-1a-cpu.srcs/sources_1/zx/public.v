// public.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`timescale 1ns / 1ps

`define Enable 1'b1
`define Disable 1'b0

// Minisys��ϵ�ṹ���
`define ZeroWord 32'h00000000 // 0x0��
`define RegCount 32 // �Ĵ�����
`define RegCountLog2 5 // �Ĵ�����Log2
`define RegRange 31:0 // �Ĵ�������Χ
`define RegRangeLog2 4:0 // �Ĵ�����Log2��Χ����ַ��
`define WordLength 32 // �ֳ�
`define WordRange 31:0 // �ֳ���Χ
`define OpRange 31:26 // ָ������op�ķ�Χ
`define RsRange 25:21 // ָ������rs�ķ�Χ
`define RtRange 20:16 // ָ������rt�ķ�Χ
`define RdRange 15:11 // ָ������rd�ķ�Χ
`define ShamtRange 10:6 // ָ������shamt�ķ�Χ
`define FuncRange 5:0 // ָ������func�ķ�Χ
`define ImmedRange 15:0 // ָ������immediate�ķ�Χ
`define OffsetRange 15:0 // ָ������offset�ķ�Χ
`define AddressRange 25:0 // ָ������address�ķ�Χ

// ������
// ALU���
`define ALUOpRange 7:0 // ALUOp��Χ
`define ALUSelRange 2:0 // ALUSel��Χ
// ALUOP����
`define ALUOP_OR 8'b00100101
`define ALUOP_NOP 8'b00000000

// Minisysָ�
// OP����
`define OP_ADD 6'b000000
`define OP_ADDU 6'b000000
`define OP_SUB 6'b000000
`define OP_SUBU 6'b000000
`define OP_AND 6'b000000
`define OP_MULT 6'b000000
`define OP_MULTU 6'b000000
`define OP_DIV 6'b000000
`define OP_DIVU 6'b000000
`define OP_MFHI 6'b000000
`define OP_MFLO 6'b000000
`define OP_MTHI 6'b000000
`define OP_MTLO 6'b000000
`define OP_MFC0 6'b010000
`define OP_MTC0 6'b010000
`define OP_OR 6'b000000
`define OP_XOR 6'b000000
`define OP_NOR 6'b000000
`define OP_SLT 6'b000000
`define OP_SLTU 6'b000000
`define OP_SLL 6'b000000
`define OP_SRL 6'b000000
`define OP_SRA 6'b000000
`define OP_SLLV 6'b000000
`define OP_SRLV 6'b000000
`define OP_SRAV 6'b000000
`define OP_JR 6'b000000
`define OP_JALR 6'b000000
`define OP_BREAK 6'b000000
`define OP_SYSCALL 6'b000000
`define OP_ERET 6'b010000
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
`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_NOP 6'b000000
