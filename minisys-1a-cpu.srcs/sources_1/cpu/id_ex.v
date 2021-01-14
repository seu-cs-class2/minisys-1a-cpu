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

  input wire id_in_delayslot, // 当前处在译码阶段的指令是否是延迟槽内指令
  input wire id_next_in_delayslot, // 新增加的与延迟槽相关，译码阶段的指令通知是否下一条指令在延迟槽内
  output reg ex_in_delayslot, // 当前处在执行阶段的指令是否是延迟槽内指令
  output reg ex_next_in_delayslot, // 下一条要进入执行阶段的指令是不是延迟槽内指令

  input wire pause,

  input wire[`WordRange] id_ins,
  output reg[`WordRange] ex_ins,

  // 中断异常相关
  input wire flush,
  input wire[`WordRange] f_id_current_pc_addr_in,
  input wire[`WordRange] f_id_abnormal_type_in,
  output reg[`WordRange] t_ex_current_pc_addr_out,
  output reg[`WordRange] t_ex_abnormal_type_out
  
);

  always @(posedge clk) begin
    if (rst == `Enable) begin
      ex_aluop = `ALUOP_NOP;
      ex_data1 = `ZeroWord;
      ex_data2 = `ZeroWord;
      ex_wreg_e = `Disable;
      ex_link_addr = `ZeroWord;
      ex_in_delayslot = `Disable;
      ex_next_in_delayslot = `Disable;
      ex_ins = `ZeroWord;
      t_ex_current_pc_addr_out = `ZeroWord;
      t_ex_abnormal_type_out = `ZeroWord;
    end else if(flush == `Enable) begin
      ex_aluop = `ALUOP_NOP;
      ex_data1 = `ZeroWord;
      ex_data2 = `ZeroWord;
      ex_wreg_e = `Disable;
      ex_link_addr = `ZeroWord;
      ex_in_delayslot = `Disable;
      ex_next_in_delayslot = `Disable;
      ex_ins = `ZeroWord;
      t_ex_current_pc_addr_out = `ZeroWord;
      t_ex_abnormal_type_out = `ZeroWord;
    end else if (pause == `Enable) begin
      ex_aluop = ex_aluop;
      ex_data1 = ex_data1;
      ex_data2 = ex_data2;
      ex_wreg_e = ex_wreg_e;
      ex_wreg_addr = ex_wreg_addr;
      ex_link_addr = ex_link_addr;
      ex_in_delayslot = ex_in_delayslot;
      ex_next_in_delayslot = ex_next_in_delayslot;
      ex_ins = ex_ins;
      t_ex_current_pc_addr_out = t_ex_current_pc_addr_out;
      t_ex_abnormal_type_out = t_ex_abnormal_type_out;
    end else begin
      ex_aluop = id_aluop;
      ex_data1 = id_data1;
      ex_data2 = id_data2;
      ex_wreg_e = id_wreg_e;
      ex_wreg_addr = id_wreg_addr;
      ex_link_addr = id_link_addr;
      ex_in_delayslot = id_in_delayslot;
      ex_next_in_delayslot = id_next_in_delayslot;
      ex_ins = id_ins;
      t_ex_current_pc_addr_out = f_id_current_pc_addr_in;
      t_ex_abnormal_type_out = f_id_abnormal_type_in;
    end
  end

endmodule