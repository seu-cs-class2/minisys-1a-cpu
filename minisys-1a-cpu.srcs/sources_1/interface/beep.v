// beep.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 蜂鸣器
module beep (

  input en, // 使能
  input signal_in, // 声信号输入

  output reg signal_out // 声信号输出

);

 always @(*) begin
    if (en == `Enable) begin
      signal_out <= signal_in;
    end
 end

endmodule