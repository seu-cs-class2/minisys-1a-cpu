// mem_wb.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级MEM-WB之间的寄存器
// TODO: 目前先写成直通的
module mem_wb (

  input rst, // 重置
  input clk, // 时钟

  input wire mem_wreg_e, // MEM级输入 - 寄存器组写使能
  input wire[`RegRangeLog2] mem_wreg_addr, // MEM级输入 - 寄存器组写地址
  input wire[`WordRange] mem_wreg_data, // MEM级输入 - 寄存器组写数据

  output reg wb_wreg_e, // WB级输出 - 寄存器组写使能
  output reg[`RegRangeLog2] wb_wreg_addr, // WB级输出 - 寄存器组写地址
  output reg[`WordRange] wb_wreg_data // WB级输出 - 寄存器组写数据

);

  always @(posedge clk) begin
    // 重置时送disbale、0x0
    if (rst == `Enable) begin
      wb_wreg_e <= `Disable;
      wb_wreg_data <= `ZeroWord;
    // 否则穿透
    end else begin
      wb_wreg_e <= `Enable;
      wb_wreg_addr <= mem_wreg_addr;
      wb_wreg_data <= mem_wreg_data;
    end
  end

endmodule