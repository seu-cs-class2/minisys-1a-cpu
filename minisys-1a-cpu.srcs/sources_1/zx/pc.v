// pc.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令计数器
module pc (

  input clk, // 时钟
  input rst, // 同步复位信号
  output reg[`WordRange] pc, // 当前PC
  output reg imem_e_out, // 指令存储器使能
  
  input wire pause,

  input wire branch_e_in, //是否转移
  input wire[`WordRange] branch_addr_in  //转移的地址

);

  // 如果非rst，则使能IMEM读取
  always @(posedge clk) begin
    if (rst == `Enable) begin
      imem_e_out <= `Disable;
    end else begin
      imem_e_out <= `Enable;
    end
  end

  // 如果rst，则复位到0x0，否则+4
  always @(posedge clk) begin
    if (rst == `Enable) begin
      pc <= `ZeroWord;
    end else if (pause == `Enable) begin
      pc <= pc;
    end else if (branch_e_in == `Enable) begin  //如果要转移，则pc直接赋值为转移地址
      pc <= branch_addr_in;
    end else begin
      pc <= pc + 32'd4;
    end
  end

endmodule
