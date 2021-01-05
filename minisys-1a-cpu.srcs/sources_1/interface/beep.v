// beep.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 蜂鸣器驱动
// by zx
// edit by wxy in 2021/01/05
module beep (
  //从总线来的数据
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 声信号输入
  input wire ew, //写使能

  //发送给仲裁器
  output reg[`WordRange] data_out,
  output reg abt_eable,

  //发送给外设的信号
  output reg signal_out // 声信号输出

);

 always @(*) begin
    abt_eable <= `Disable;
    data_out <= `ZeroWord;
    if (en == `Enable && addr[31:4] == 28'hfffffd1) begin //使能有效  地址在范围内
      abt_eable <= `Enable;
      if(ew == `Enable && addr[3:0] == 4'h0)begin  //如果是写  且写的是最低字节（不用管字节位）
        signal_out <= data_in[0];
      end else if(ew == `Disable && addr[3:0] == 4'h0)begin //如果是读 且读的是最低字节（不用管字节位）
        data_out <= {28'hfffffff, 3'b000, signal_out};
      end
    end
 end

endmodule