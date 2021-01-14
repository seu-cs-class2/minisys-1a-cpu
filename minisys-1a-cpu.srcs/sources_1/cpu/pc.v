// pc.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令计数器PC
module pc (

  input clk, // 时钟
  input rst, // 同步复位信号
  output reg[`WordRange] pc, // 当前PC
  
  input wire pause, // 流水暂停信号

  input wire branch_en_in, // 是否转移
  input wire[`WordRange] branch_addr_in, // 转移的地址

  //异常相关
  input wire flush,
  input wire[`WordRange] interrupt_pc

);

  // 如果rst，则复位到0x0，否则+4
  always @(posedge clk) begin
    if (rst == `Enable) begin
      pc = `ZeroWord;
    end else if(flush == `Enable) begin
      //若有异常则让pc取入口地址
      pc = interrupt_pc;
    end else if (pause == `Enable) begin
      // 流水暂停时保持PC不变
      pc = pc;
    end else if (branch_en_in == `Enable) begin  // 如果要转移，则PC直接赋值为转移地址
      pc = branch_addr_in;
    end else begin
      pc = pc + 32'd4;
    end
  end

endmodule
