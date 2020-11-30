// mem_wb.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ��ˮ��MEM-WB֮��ļĴ���
// TODO: Ŀǰ��д��ֱͨ��
module mem_wb (

  input rst, // ����
  input clk, // ʱ��

  input wire mem_wreg_e, // MEM������ - �Ĵ�����дʹ��
  input wire[`RegRangeLog2] mem_wreg_addr, // MEM������ - �Ĵ�����д��ַ
  input wire[`WordRange] mem_wreg_data, // MEM������ - �Ĵ�����д����

  output reg wb_wreg_e, // WB����� - �Ĵ�����дʹ��
  output reg[`RegRangeLog2] wb_wreg_addr, // WB����� - �Ĵ�����д��ַ
  output reg[`WordRange] wb_wreg_data, // WB����� - �Ĵ�����д����

  input wire mem_hilo_we,
  input wire[`WordRange] mem_hi_data,
  input wire[`WordRange] mem_lo_data,

  output reg wb_hilo_we,
  output reg[`WordRange] wb_hi_data,
  output reg[`WordRange] wb_lo_data

);

  always @(posedge clk) begin
    // ����ʱ��disbale��0x0
    if (rst == `Enable) begin
      wb_wreg_e <= `Disable;
      wb_wreg_data <= `ZeroWord;
      wb_hilo_we <= `Disable;
      wb_hi_data <= `ZeroWord;
      wb_lo_data <= `ZeroWord;
    // ����͸
    end else begin
      wb_wreg_e <= `Enable;
      wb_wreg_addr <= mem_wreg_addr;
      wb_wreg_data <= mem_wreg_data;
      wb_hilo_we <= mem_hilo_we;
      wb_hi_data <= mem_hi_data;
      wb_lo_data <= mem_lo_data;
    end
  end

endmodule