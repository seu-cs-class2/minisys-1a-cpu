// cp0.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 协处理器CP0
// 内部寄存器请参考补充讲义P93
module cp0 (

  input clk,
  input rst,

  input wire we_in,
  input wire[2:0] waddr_in,
  input wire[`WordRange] data_in,
  input wire[2:0] raddr_in,

  input wire[5:0] int_in,

  output reg[`WordRange] data_out,
  output reg[`WordRange] count_out, // Count寄存器，用于定时中断的产生
  output reg[`WordRange] compare_out, // Compare寄存器，配合count实现定时中断
  // Status寄存器，存放中断屏蔽信息等
  // 31..16   15..8   7..1      0
  // Reserved IntMask Reserved  0
  // *** IntMask
  //     1..0: priority ctrl
  //     7..2: 6 mask bits
  output reg[`WordRange] status_out,
  // Cause寄存器，存储异常或中断源的信息
  // 31..14   13..8   7  6..2    1..0
  // Reserved IntPend 0  ExcCode 00
  // *** ExcCode
  //     00000: ext int
  //     01000: syscall
  //     01001: break
  //     01010: not implemented
  //     01100: ovf
  output reg[`WordRange] cause_out,
  // EPC寄存器，异常或中断的返回地址寄存器
  // 31..0
  // IRetAddr
  output reg[`WordRange] epc_out,
  output reg[`WordRange] config_out,

  output reg timer_int_o
);


endmodule
