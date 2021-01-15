// beep.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"


// 所有驱动都应该以寄存器为中介（即最后的输出信号应该是reg类型）
// 蜂鸣器驱动
// 蜂鸣器物理地址范围：0xFFFFFD10~0xFFFFFD1F
// 唯一寄存器地址: 0xFFFFFD10
// by zx
// edit by wxy in 2021/01/05
module beep (
  //从总线来的数据 所有外设驱动都应有以下信号
  input wire rst,
  input wire clk,
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 声信号输入
  input wire we, //写使能

  //发送给仲裁器 所有外设都应有此输出
  output reg[`WordRange] data_out,

  //发送给外设的信号
  output reg signal_out // 声信号输出

);

reg[15:0] count;

always @(posedge clk) begin  //写是上升沿
  if(rst == `Enable) begin
    signal_out <= 1'b0;
    count <= 16'd0;
  end else begin
    if(en == `Enable && addr == 32'hfffffd10 && we == `Enable) begin //使能有效  地址正确  并且是写操作
      if(data_in != 32'd0)begin
        signal_out <= 1'b1;
      end else begin
        signal_out <= 1'b0;
      end
    end
    // count <= count + 16'd1;
    // if(count < 16'd10000)begin
    //   signal_out <= 1'b0;
    // end
    // if(count >= 16'd10000)begin
    //   signal_out <= 1'b1;
    // end
    // if(count >= 16'd20000)begin
    //   count <= 16'd0;
    //   signal_out <= 1'b0; 
    // end
  end
  
  
end

always @(*) begin //读是随时读
  if(rst == `Enable)begin
    data_out <= `ZeroWord;
  end else if(en == `Enable && addr == 32'hfffffd10 && we == `Disable) begin
    data_out <= {28'h0000000,3'b000,signal_out};
  end else begin
    data_out <= `ZeroWord;
  end
end

endmodule