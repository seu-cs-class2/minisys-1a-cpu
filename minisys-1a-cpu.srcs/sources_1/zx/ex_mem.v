// ex_mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级EX-MEM之间的寄存器
// 先做成直通的
// TODO: MEM用IP核
module ex_mem (
  
  input rst,
  input clk,

  input wire ex_wreg_e,
  input wire[`RegRange] ex_wreg_addr,
  input wire[`WordRange] ex_wreg_data,

  output reg mem_wreg_e,
  output reg[`RegRange] mem_wreg_addr,
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