// id_ex.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级ID-EX之间的寄存器
module id_ex(

  input clk,
  input rst,

  input wire[`ALUOpRange] id_aluop,
  input wire[`WordRange] id_data1,
  input wire[`WordRange] id_data2,
  input wire[`RegRangeLog2] id_wreg_addr,
  input id_wreg_e,

  output reg[`ALUOpRange] ex_aluop,
  output reg[`WordRange] ex_data1,
  output reg[`WordRange] ex_data2,
  output reg[`RegRangeLog2] ex_wreg_addr,
  output reg ex_wreg_e,

  input wire pause
  
);


  always @(posedge clk) begin
    if (rst == `Enable) begin
      ex_aluop <= `ALUOP_NOP;
      ex_data1 <= `ZeroWord;
      ex_data2 <= `ZeroWord;
      ex_wreg_e <= `Disable;
    end else if (pause == `Enable) begin
      ex_aluop <= `ALUOP_NOP;
      ex_data1 <= `ZeroWord;
      ex_data2 <= `ZeroWord;
      ex_wreg_e <= `Disable;  
    end else begin
      ex_aluop <= id_aluop;
      ex_data1 <= id_data1;
      ex_data2 <= id_data2;
      ex_wreg_e <= id_wreg_e;
      ex_wreg_addr <= id_wreg_addr;
    end
  end

endmodule