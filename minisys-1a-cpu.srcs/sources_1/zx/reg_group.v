// reg_group.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 寄存器组
// 注意到Minisys指令集R类指令会要求同时读取两个寄存器，因此将寄存器组
// 设计为单入、双出模式，即可以同时读出两个寄存器，同时写入一个寄存器
module reg_group(

  input rst, // 复位信号
  input clk, // 时钟

  input we, // 写使能
  input wire[`RegRangeLog2] waddr, // 写地址（寄存器号）
  input wire[`WordRange] wdata, // 写数据

  input re1, // 读使能1
  input wire[`RegRangeLog2] raddr1, // 读地址1
  output reg[`WordRange] rdata1, // 读出数据1

  input re2, // 读使能2
  input wire[`RegRangeLog2] raddr2, // 读地址2
  output reg[`WordRange] rdata2 // 读出数据2

);

  // 定义32个寄存器，字长为32位
  reg[`RegRange] regs[`WordRange];

  // 处理写入逻辑（上升沿写入）
  always @(posedge clk) begin
    if (rst == `Disable) begin
      // 注意禁止写入0号寄存器
      if (we == `Enable && waddr != `RegCountLog2'h0) begin
        regs[waddr] <= wdata;
      end
    end
  end

  // 处理读出逻辑1（随时读出）
  always @(*) begin
    // rst或读$0时固定出0
    if (rst == `Enable || raddr1 == `RegCountLog2'd0) begin
      rdata1 <= `ZeroWord;
    // 考虑相隔两条指令（即ID、WB阶段）存在RAW相关时，ID取得$i的值，同时WB写入$i
    // 规定WB写的值直接穿透到ID，则解决了流水的数据冲突之一
    end else if (raddr1 == waddr && we == `Enable && re1 == `Enable) begin
      rdata1 <= wdata;
    // 读不使能时固定出0
    end else if (re1 == `Disable) begin
      rdata1 <= `ZeroWord;
    // 普通情况
    end else if (re1 == `Enable) begin
      rdata1 <= regs[raddr1];
    end
  end

  // 处理读出逻辑2，和上面相同
  always @(*) begin
    if (rst == `Enable || raddr2 == `RegCountLog2'd0) begin
      rdata2 <= `ZeroWord;
    end else if (raddr2 == waddr && we == `Enable && re2 == `Enable) begin
      rdata2 <= wdata;
    end else if (re2 == `Disable) begin
      rdata2 <= `ZeroWord;
    end else if (re2 == `Enable) begin
      rdata2 <= regs[raddr2];
    end
  end

endmodule