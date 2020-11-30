// reg_group.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// �Ĵ�����
// ע�⵽Minisysָ�R��ָ���Ҫ��ͬʱ��ȡ�����Ĵ�������˽��Ĵ�����
// ���Ϊ���롢˫��ģʽ��������ͬʱ���������Ĵ�����ͬʱд��һ���Ĵ���
module reg_group(

  input rst, // ��λ�ź�
  input clk, // ʱ��

  input we, // дʹ��
  input wire[`RegRangeLog2] waddr, // д��ַ���Ĵ����ţ�
  input wire[`WordRange] wdata, // д����

  input re1, // ��ʹ��1
  input wire[`RegRangeLog2] raddr1, // ����ַ1
  output reg[`WordRange] rdata1, // ��������1

  input re2, // ��ʹ��2
  input wire[`RegRangeLog2] raddr2, // ����ַ2
  output reg[`WordRange] rdata2 // ��������2

);

  // ����32���Ĵ������ֳ�Ϊ32λ
  reg[`RegRange] regs[`WordRange];

  // ����д���߼���������д�룩
  always @(posedge clk) begin
    if (rst == `Disable) begin
      // ע���ֹд��0�żĴ���
      if (we == `Enable && waddr != `RegCountLog2'h0) begin
        regs[waddr] <= wdata;
      end
    end
  end

  // ��������߼�1����ʱ������
  always @(*) begin
    // rst���$0ʱ�̶���0
    if (rst == `Enable || raddr1 == `RegCountLog2'd0) begin
      rdata1 <= `ZeroWord;
    // �����������ָ���ID��WB�׶Σ�����RAW���ʱ��IDȡ��$i��ֵ��ͬʱWBд��$i
    // �涨WBд��ֱֵ�Ӵ�͸��ID����������ˮ�����ݳ�ͻ֮һ
    end else if (raddr1 == waddr && we == `Enable && re1 == `Enable) begin
      rdata1 <= wdata;
    // ����ʹ��ʱ�̶���0
    end else if (re1 == `Disable) begin
      rdata1 <= `ZeroWord;
    // ��ͨ���
    end else if (re1 == `Enable) begin
      rdata1 <= regs[raddr1];
    end
  end

  // ��������߼�2����������ͬ
  always @(*) begin
    if (rst == `Enable || raddr2 == `RegCountLog2'd0) begin
      rdata2 <= `ZeroWord;
    end else if (raddr2 == waddr && we == `Enable && re2 == `Enable) begin
      rdata2 <= wdata;
    end else if (re2 == `Disable) begin
      rdata2 <= `ZeroWord;
    end else if (re2 == `Enable) begin
      rdata2 <= regs[raddr2];
    end
  end

endmodule