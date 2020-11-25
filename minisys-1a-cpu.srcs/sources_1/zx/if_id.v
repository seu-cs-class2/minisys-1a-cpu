// if_id.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ��ˮ��IF-ID֮��ļĴ���
module if_id (
  
  input clk, // ʱ��
  input rst, // ��λ

  input wire[`WordRange] if_pc, // IF��PC
  input wire[`WordRange] if_ins, // IF��ָ��

  output reg[`WordRange] id_pc, // ID��PC
  output reg[`WordRange] id_ins // ID��ָ��

);

  always @(posedge clk) begin
    // ����ʱ���¼���0x0
    if (rst == `Enable) begin
      id_pc <= `ZeroWord;
      id_ins <= `ZeroWord;
    // �������¼�ֱͨ����
    end else begin
      id_pc <= if_pc;
      id_ins <= if_ins;
    end
  end

endmodule