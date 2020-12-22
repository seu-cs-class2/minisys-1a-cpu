// leds.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// LED 灯
module leds (

  input rst, // 重置，全部灭灯
  input clk, // 时钟

  input cs, // 片选
  input[2:0] port, // 0-红，2-黄，4-绿
  input[15:0] data, // 仅低8位有效

  output reg[7:0] RLD, // 红灯
  output reg[7:0] YLD, // 黄灯
  output reg[7:0] GLD  // 绿灯

);

  // 内部寄存器
  reg[7:0] RLD_ctrl;
  reg[7:0] YLD_ctrl;
  reg[7:0] GLD_ctrl;

  always @(posedge clk) begin
    // 重置时清空内部寄存器
    if (rst == `Enable) begin
      RLD_ctrl <= 8'd0;
      YLD_ctrl <= 8'd0;
      GLD_ctrl <= 8'd0;
    end else begin
      if (cs == `Enable) begin
        // 配置内部寄存器
        if (port == 3'd0) begin
          RLD_ctrl <= data[7:0];
        end
        if (port == 3'd2) begin
          YLD_ctrl <= data[7:0];
        end
        if (port == 3'd4) begin
          GLD_ctrl <= data[7:0];
        end
      end
    end
    // 将内部寄存器的结果送到外部LED灯
    RLD <= RLD_ctrl;
    YLD <= YLD_ctrl;
    GLD <= GLD_ctrl;
  end

endmodule