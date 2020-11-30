// cp0.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// Э������CP0
module cp0 (

  input clk,
  input rst,

  input wire we_in,
  input wire[2:0] waddr_in,
  input wire[`WordRange] wdata_in,
  input wire[2:0] raddr_in,

  // Count�Ĵ��������ڶ�ʱ�жϵĲ���
  output reg[`WordRange] count_out,
  // Compare�Ĵ��������countʵ�ֶ�ʱ�ж�
  output reg[`WordRange] compare_out,
  // Cause�Ĵ������洢�쳣���ж�Դ����Ϣ
  output reg[`WordRange] cause_out,
  // EPC�Ĵ������쳣���жϵķ��ص�ַ�Ĵ���
  output reg[`WordRange] epc_out,
  // Status�Ĵ���������ж�������Ϣ��
  output reg[`WordRange] status_out

);

  always @(posedge clk) begin
    
  end

endmodule