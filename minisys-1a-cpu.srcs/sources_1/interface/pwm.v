// pwm.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// PWM 脉冲宽度调制
// 地址范围：0xFFFFFC30~0xFFFFFC3F
// 寄出器个数：3
// 寄存器地址： 0xFFFFFC30 0xFFFFFC32 0xFFFFFC34
// 寄存器功能：  最大值       对比值       控制
module pwm (
  input rst, // 重置，全部灭灯
  input clk, // 时钟

  //从总线来的数据 所有外设驱动都应有以下信号
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 数据输入（来自cpu）
  input wire we, //写使能

  //发送给仲裁器 所有外设都应有此输出
  output reg[`WordRange] data_out,

  output reg result // PWM调制结果
);

  reg[15:0] threshold; // 最大值寄存器
  reg[15:0] compare; // 对比值寄存器
  reg[7:0] ctrl; // 控制寄存器
  reg[15:0] current; // 当前值


  always @(*)begin //读是随时读
    if(rst == `Enable)begin
      data_out = `ZeroWord;
    end else begin
      if(addr[31:4] == {28'hfffffc3} && en == `Enable && we == `Disable)begin
          if(addr[3:2] == 2'b00)begin
            data_out = {compare,threshold};
          end else if(addr[3:2] == 2'b01)begin
            data_out = {24'h000000, ctrl};
          end else begin
            data_out = `ZeroWord;
          end
      end else begin
        data_out = `ZeroWord;
      end
    end
  end

  always @(posedge clk) begin //写是上升沿写
    if(addr[31:4] == {28'hfffffc3} && en == `Enable && we == `Enable)begin
      if(addr[3:2] == 2'b00) begin
        if(byte_sel[0] == 1'b1)begin
          threshold[7:0] <= data_in[7:0];
        end
        if(byte_sel[1] == 1'b1)begin
          threshold[15:8] <= data_in[15:8];
        end
        if(byte_sel[2] == 1'b1) begin
          compare[7:0] <= data_in[23:16];
        end
        if(byte_sel[3] == 1'b1) begin
          compare[15:8] <= data_in[31:24];
        end
      end else if(addr[3:2] == 2'b01) begin
        if(byte_sel[0] == 1'b1) begin
          ctrl <= data_in[7:0];
        end
      end
    end
  end

  always @(posedge clk) begin
    // 重设
    if (rst == `Enable) begin
      threshold <= 16'hffff;
      compare <= 16'h7fff;
      ctrl <= 8'd1;
      current <= 16'd0;
      result <= `Enable;
    end else begin
      if (current == threshold) begin
        current <= 16'd0;
        result <= `Enable;
      end
        // 一般情况下加一即可
        current = current + 16'd1;
    end
      // 只有在使能，且控制寄存器[0]位有效时，才保证输出可靠
    if ( ctrl[0] ) begin
      if (current > compare) begin
        result <= `Disable;
      end else begin
        result <= `Enable;
      end
    end
  end


endmodule