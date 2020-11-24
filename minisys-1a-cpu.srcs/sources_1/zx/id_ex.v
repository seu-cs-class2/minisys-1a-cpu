`include "public.v"

module id_ex(

  input clk,
  input rst,

  input wire[`ALUOpRange] id_aluop,
  input wire[`ALUSelRange] id_alusel,
  input wire[`WordRange] id_reg1_data,
  input wire[`WordRange] id_reg2_data,
  input wire[`RegRangeLog2] id_wreg_addr,
  input id_wreg_e,

  output reg[`ALUOpRange] ex_aluop,
  output reg[`ALUSelRange] ex_alusel,
  output reg[`WordRange] ex_reg1_data,
  output reg[`WordRange] ex_reg2_data,
  output reg[`RegRangeLog2] ex_wreg_addr,
  output reg ex_wreg_e
  
);


  always @(posedge clk) begin
    
    if (rst == `Enable) begin
      ex_aluop <= `ALUOP_NOP;
      ex_reg1_data <= `ZeroWord;
      ex_reg2_data <= `ZeroWord;
      // TODO:
    end else begin
      ex_aluop <= id_aluop;
      ex_alusel <= id_alusel;
      ex_reg1_data <= id_reg1_data;
      ex_reg2_data <= id_reg2_data;
      ex_wreg_e <= id_wreg_e;
      ex_wreg_addr <= id_wreg_addr;
    end

  end

endmodule 