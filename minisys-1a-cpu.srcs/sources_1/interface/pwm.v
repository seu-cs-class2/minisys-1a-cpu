// pwm.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// PWM 脉冲宽度调制
module pwm (

  input wire rst, // 重置
  input wire clk, // 时钟

  input wire cs, // 片选，应结合端口基地址给出
  input wire en, // 工作使能
  // 内部端口选择（地址线的最低三位）
  // 0-最大值寄存器，2-对比值寄存器，4-控制寄存器
  input wire[2:0] port,
  input wire[15:0] data, // 数据输入

  output reg result // PWM调制结果

);

  reg[15:0] threshold; // 最大值寄存器
  reg[15:0] compare; // 对比值寄存器
  reg[15:0] ctrl; // 控制寄存器
  reg[15:0] current; // 当前值

  always @(posedge clk) begin
    // 重设
    if (rst == `Enable) begin
      threshold <= 16'hffff;
      compare <= 16'h7fff;
      ctrl <= 16'd1;
      current <= 16'd0;
      result <= `Enable;
    end else begin
      // 当前工作，且CPU选中本模块
      if (en == `Enable && cs == `Enable) begin
        if (port == 3'd0) begin
          // 写最大值寄存器
          threshold <= data;
        end else if (port == 3'd2) begin
          // 写对比值寄存器
          compare <= data;
        end else if (port == 3'd4) begin
          // 写控制寄存器
          ctrl <= data;
        end
      end
      // 当前在工作
      if (en == `Enable) begin
        // 计到最大值时翻转回0
        if (current == threshold) begin
          current <= 16'd0;
          result <= `Enable;
        end
        // 一般情况下加一即可
        current = current + 16'd1;
      end
      // 只有在使能，且控制寄存器[0]位有效时，才保证输出可靠
      if (en == `Enable && ctrl[0]) begin
        if (current > compare) begin
          result <= `Disable;
        end else begin
          result <= `Enable;
        end
      end
    end
  end

endmodule