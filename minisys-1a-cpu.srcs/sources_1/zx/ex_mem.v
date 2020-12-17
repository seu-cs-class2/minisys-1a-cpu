// ex_mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级EX-MEM之间的寄存器
module ex_mem (
  
  input rst,
  input clk,

  input wire ex_wreg_e,
  input wire[`RegRangeLog2] ex_wreg_addr,
  input wire[`WordRange] ex_wreg_data,

  output reg mem_wreg_e,
  output reg[`RegRangeLog2] mem_wreg_addr,
  output reg[`WordRange] mem_wreg_data,

  input wire ex_hilo_we,
  input wire[`WordRange] ex_hi_data,
  input wire[`WordRange] ex_lo_data,
  
  output reg mem_hilo_we,
  output reg[`WordRange] mem_hi_data,
  output reg[`WordRange] mem_lo_data,

  input wire pause

);

  wire clk_pause;
  assign clk_pause = clk | pause;

  always @(posedge clk_pause) begin
    if (rst == `Enable) begin
      mem_wreg_e <= `Disable;
      mem_wreg_data <= `ZeroWord;
      mem_hilo_we <= `Disable;
      mem_hi_data <= `ZeroWord;
      mem_lo_data <= `ZeroWord;
    end else begin
      mem_wreg_e <= ex_wreg_e;
      mem_wreg_addr <= ex_wreg_addr;
      mem_wreg_data <= ex_wreg_data;
      mem_hilo_we <= ex_hilo_we;
      mem_hi_data <= ex_hi_data;
      mem_lo_data <= ex_lo_data;
    end
  end

endmodule