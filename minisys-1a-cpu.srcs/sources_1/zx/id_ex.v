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
  input id_wreg_e,
  input wire[`RegRangeLog2] id_wreg_addr,
  input wire[`WordRange] id_link_addr,

  output reg[`ALUOpRange] ex_aluop,
  output reg[`WordRange] ex_data1,
  output reg[`WordRange] ex_data2,
  output reg ex_wreg_e,
  output reg[`RegRangeLog2] ex_wreg_addr,
  output reg[`WordRange] ex_link_addr,

  input wire id_is_in_delayslot,  //当前处在译码阶段的指令是否是延迟槽内指令
  input wire next_is_in_delayslot,    //新增加的与延迟槽相关，下�?条进入译码阶段的指令是否是延迟槽内指�?
  output reg ex_is_in_delayslot,    //当前处在执行阶段的指令是否是延迟槽内指令
  output reg is_in_delayslot,   //当前在译码阶段的指令是否是延迟槽内指�?

  input wire pause
  
);

  wire clk_pause;
  assign clk_pause = clk | pause;

  always @(posedge clk_pause) begin
    if (rst == `Enable) begin
      ex_aluop <= `ALUOP_NOP;
      ex_data1 <= `ZeroWord;
      ex_data2 <= `ZeroWord;
      ex_wreg_e <= `Disable;
      //ex_branch_e <= `Disable;
      //ex_branch_addr <= `ZeroWord;
      ex_link_addr <= `ZeroWord;
      ex_is_in_delayslot <= `Disable;
      is_in_delayslot <= `Disable;
    end else if (pause == `Enable) begin  //这里肯定有问题，如果此处修改了exaluop的�?�则ex部分直接无法保持乘除法，流水暂停直接失效�?
      ex_aluop <= id_aluop;
      ex_data1 <= id_data1;
      ex_data2 <= id_data2;
      ex_wreg_e <= id_wreg_e;
      ex_wreg_addr <= id_wreg_addr;
      ex_link_addr <= id_link_addr;
      ex_is_in_delayslot <= id_is_in_delayslot;
      is_in_delayslot <= next_is_in_delayslot;
    end else begin
      ex_aluop <= id_aluop;
      ex_data1 <= id_data1;
      ex_data2 <= id_data2;
      ex_wreg_e <= id_wreg_e;
      ex_wreg_addr <= id_wreg_addr;
      ex_link_addr <= id_link_addr;
      ex_is_in_delayslot <= id_is_in_delayslot;
      is_in_delayslot <= next_is_in_delayslot;
    end
  end

endmodule