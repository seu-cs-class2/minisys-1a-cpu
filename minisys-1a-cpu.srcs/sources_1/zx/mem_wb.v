// mem_wb.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级MEM-WB之间的寄存器
// TODO: 目前先写成直通的
module mem_wb (

  input rst,
  input clk,

  input wire mem_wreg_e,
  input wire[`RegRange] mem_wreg_addr,
  input wire[`WordRange] mem_wreg_data,

  output reg wb_wreg_e,
  output reg[`RegRange] wb_wreg_addr,
  output reg[`WordRange] wb_wreg_data

);

  always @(posedge clk) begin
    if (rst == `Enable) begin
      wb_wreg_e <= `Disable;
      wb_wreg_data <= `ZeroWord;
    end else begin
      wb_wreg_e <= `Enable;
      wb_wreg_addr <= mem_wreg_addr;
      wb_wreg_data <= mem_wreg_data;
    end
  end

endmodule