// if_id.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ָ������ģ��
// ��ָ��������룬���������
// Դ������1��Դ������2��д���Ŀ�ļĴ������������ͣ��߼�����λ��������
module id (

  input rst, // ��λ
  input wire[`WordRange] pc_in, // �����PCֵ
  input wire[`WordRange] ins_in, // �����ָ��

  // ������д����ֱͨ����Ϊ������ˮ�ݴ��ṩ����
  input wire[`WordRange] reg1_data_in, // ����ļĴ�������1
  input wire[`WordRange] reg2_data_in, // ����ļĴ�������2

  output reg reg1_re_out, // �Ĵ�����ʹ��1
  output reg reg2_re_out, // �Ĵ�����ʹ��2
  output reg[`RegRangeLog2] reg1_addr_out, // �Ĵ�������ַ1
  output reg[`RegRangeLog2] reg2_addr_out, // �Ĵ�������ַ2

  output reg[`ALUOpRange] aluop_out, // �����ALUOp
  output reg[`ALUSelRange] alusel_out, // �����ALUSel

  output reg[`WordRange] data1_out, // ���������1
  output reg[`WordRange] data2_out, // ���������2
  
  output reg wreg_e_out, // д�Ĵ���ʹ�����
  output reg[`RegRangeLog2] wreg_addr_out, // д�Ĵ�����ַ���

  // ���沿�����ڲ�������ǰ�ͷ�������0����ID-EX�������1����ID-MEM���׶ε�RAW�������
  // EX�׶�������
  input wire ex_wreg_e_in,
  input wire[`WordRange] ex_wreg_data_in,
  input wire[`RegRangeLog2] ex_wreg_addr_in,
  // MEM�׶�������
  input wire mem_wreg_e_in,
  input wire[`WordRange] mem_wreg_data_in,
  input wire[`RegRangeLog2] mem_wreg_addr_in

);

  wire[5:0] op = ins_in[`OpRange]; // op�����ָ���31:26
  reg[`WordRange] immed; // ָ���е�������

  // ָ������
  always @(*) begin
    // rstʱ�ص�����ʹ�ܣ�����������ݴ�
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      alusel_out <= 3'b000;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
    // ���������߼�
    end else begin
      // �ȸ�Ĭ��ֵ��������Щָ���Ҫ�޸�����һЩֵʱ���ִ���
      aluop_out <= `ALUOP_NOP;
      alusel_out <= 3'b000;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
      // ����op����
      case (op)
        `OP_ORI: begin
          // ��Ҫд�ؼĴ���
          wreg_e_out <= `Enable;
          // д�صļĴ�����rt
          wreg_addr_out <= ins_in[`RtRange];
          // ֻҪ��һ���Ĵ���rs
          reg1_re_out <= `Enable;
          reg1_addr_out <= ins_in[`RsRange];
          reg2_re_out <= `Disable;
          reg2_addr_out <= `RegCountLog2'h0;
          // ALU��Ҫ�����߼�������
          aluop_out <= `ALUOP_OR;
          // ��������Ҫ������չ
          immed <= {16'h0, ins_in[`ImmedRange]};
        end
        // TODO: ��Ӹ����ָ��
        default: begin 
        end
      endcase
    end
  end

  // ���濪ʼȷ���͵�ALU�����ݾ�����ʲô
  // ��ȡ������Դ���ǼĴ���������������
  always @(*) begin
    // rstʱ�̶���0x0
    if (rst == `Enable) begin
      data1_out <= `ZeroWord;
    // ������0����ID-EX������ˮ�������
    // ���ǰ���EXҪд�ľ��Ǻ����IDҪ���ģ���͸
    end else if (ex_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == ex_wreg_addr_in) begin
      data1_out <= ex_wreg_data_in;
    // ������1����ID-MEM������ˮ�������
    // ���ǰ���MEMҪд�ľ��Ǻ����IDҪ���ģ���͸
    end else if (mem_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == mem_wreg_addr_in) begin
      data1_out <= mem_wreg_data_in;  
    // ���ָ������Ľ����Ҫ��reg1����˵��������1���ԼĴ���
    end else if (reg1_re_out == `Enable) begin
      data1_out <= reg1_data_in;
    // ���ָ������Ľ������Ҫ��reg1����˵��������1����������
    end else if (reg1_re_out == `Disable) begin
      data1_out <= immed;
    // ����
    end else begin
      data1_out <= `ZeroWord;
    end
  end

  // �߼�ͬ��
  always @(*) begin
    if (rst == `Enable) begin
      data2_out <= `ZeroWord;
    end else if (ex_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == ex_wreg_addr_in) begin
      data2_out <= ex_wreg_data_in;
    end else if (mem_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == mem_wreg_addr_in) begin
      data2_out <= mem_wreg_data_in;  
    end else if (reg2_re_out == `Enable) begin
      data2_out <= reg2_data_in;
    end else if (reg2_re_out == `Disable) begin
      data2_out <= immed;
    end else begin
      data2_out <= `ZeroWord;
    end
  end

endmodule