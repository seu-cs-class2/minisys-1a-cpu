// cp0.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 协处理器CP0
module cp0 (

  input clk,
  input rst,

  input wire we_in,
  input wire[2:0] waddr_in,
  input wire[`WordRange] wdata_in,
  input wire[2:0] raddr_in,

  // Count寄存器，用于定时中断的产生
  // 31..0
  // count
  output reg[`WordRange] count_out,
  // Compare寄存器，配合count实现定时中断
  output reg[`WordRange] compare_out,
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
  // Status寄存器，存放中断屏蔽信息等
  // 31..16   15..8   7..1      0
  // Reserved IntMask Reserved  0
  // *** IntMask
  //     1..0: priority ctrl
  //     7..2: 6 mask bits
  output reg[`WordRange] status_out

);

  always @(posedge clk) begin
    
  end

endmodule