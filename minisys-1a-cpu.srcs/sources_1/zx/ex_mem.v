// ex_mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ��ˮ��EX-MEM֮��ļĴ���
// ������ֱͨ��
// TODO: MEM��IP��
module ex_mem (
  
  input rst,
  input clk,

  input wire ex_wreg_e,
  input wire[`RegRangeLog2] ex_wreg_addr,
  input wire[`WordRange] ex_wreg_data,

  output reg mem_wreg_e,
  output reg[`RegRangeLog2] mem_wreg_addr,
  output reg[`WordRange] mem_wreg_data

);

  always @(posedge clk) begin
    if (rst == `Enable) begin
      mem_wreg_e <= `Disable;
      mem_wreg_data <= `ZeroWord;
    end else begin
      mem_wreg_e <= `Enable;
      mem_wreg_addr <= ex_wreg_addr;
      mem_wreg_data <= ex_wreg_data;
    end
  end

endmodule