// mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 访存控制模块
module mem (

  input rst,
  input wire wreg_e_in,
  input wire[`WordRange] wreg_data_in,
  input wire[`RegRangeLog2] wreg_addr_in,

  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out,
  output reg[`RegRangeLog2] wreg_addr_out,

  input wire hilo_we_in,
  input wire[`WordRange] hi_data_in,
  input wire[`WordRange] lo_data_in,
  
  output reg hilo_we_out,
  output reg[`WordRange] hi_data_out,
  output reg[`WordRange] lo_data_out

);

  always @(*) begin
    if (rst == `Enable) begin
      wreg_e_out <= `Disable;
      wreg_data_out <= `ZeroWord;
      hilo_we_out <= `Disable;
      hi_data_out <= `ZeroWord;
      lo_data_out <= `ZeroWord;
    end else begin
      wreg_e_out <= wreg_e_in;
      wreg_data_out <= wreg_data_in;
      wreg_addr_out <= wreg_addr_in;
      hilo_we_out <= hilo_we_in;
      hi_data_out <= hi_data_in;
      lo_data_out <= lo_data_in;
    end
  end

endmodule