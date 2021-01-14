// watchdog.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 看门狗
module watchdog (

  input rst, // 重置，全部灭灯
  input clk, // 时钟

  //从总线来的数据 所有外设驱动都应有以下信号
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 数据输入（来自cpu）
  input wire we, //写使能

  output reg cpu_rst // 通知CPU复位

);

  reg[15:0] current; // 当前计数值
  reg[1:0] keeper; // 辅助保持4个时钟周期的cpu_rst

  always @(*) begin
    // 自身被rst，或者被访问时，重置
    if (rst == `Enable) begin
      current <= 16'hffff;
      cpu_rst <= `Disable;
      keeper <= 2'd0;
    end
  end

  always @(posedge clk) begin  //写是上升沿写
    current <= current - 16'd1;
    // count-down满，翻回，并开始通知CPU重置
    if(addr == 32'hfffffc50 && en == `Enable && we == `Enable) begin
      current <= 16'hffff;
    end else if (current == 16'd0) begin
      current <= 16'hffff;
      keeper <= 2'b11;
    end
    // 保持4个时钟周期的cpu_rst
    if (keeper == 0) begin
      cpu_rst <= `Disable;
    end
    if (keeper > 0) begin
      cpu_rst <= `Enable;
      keeper = keeper - 2'd1;
    end
  end

endmodule