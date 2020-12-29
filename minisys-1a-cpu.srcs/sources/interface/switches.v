// switches.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 拨码开关
module switches (

  input rst, // 复位
  input clk, // 时钟

  input[23:0] data_in, // 24位拨码

  output reg[23:0] data_out // 24位输出

);

  always @(posedge clk) begin
    if (rst) begin
      data_out <= 24'd0;
    end else begin
      data_out <= data_in;
    end
  end

endmodule