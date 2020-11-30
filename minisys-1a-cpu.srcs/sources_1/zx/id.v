// id.v
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

  // ָ��ĸ����������
  wire[5:0] op = ins_in[`OpRange];
  wire[4:0] rs = ins_in[`RsRange];
  wire[4:0] rt = ins_in[`RtRange];
  wire[4:0] rd = ins_in[`RdRange];
  wire[4:0] shamt = shamt;
  wire[5:0] func = ins_in[`FuncRange];
  wire[15:0] immediate = ins_in[`ImmedRange];
  wire[15:0] offset = ins_in[`OffsetRange];
  wire[25:0] address = ins_in[`AddressRange];

  reg[`WordRange] immed; // ָ���е�����������չ���

  // ָ������
  always @(*) begin
    // rstʱ�ص�����ʹ�ܣ�����������ݴ�
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
    // ���������߼�
    end else begin
      // �ȸ�Ĭ��ֵ��������Щָ���Ҫ�޸�����һЩֵʱ���ִ���
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
      // ����op����
      // R��ָ��
      if (op == `OP_RTYPE) begin
        case (func)
          `FUNC_OR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_AND: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;  
          end
          `FUNC_XOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_NOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_NOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRAV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRA;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          `FUNC_SRL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          `FUNC_SRA: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          // ע��HI/LO����32���Ĵ������У�ʹ�ܲ�Ҫ����
          `FUNC_MFHI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFHI;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MFLO: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFLO;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTHI: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_MTHI;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTLO: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_MTLO;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
        endcase
      end else begin
        // I���J��
        case (op)
          `OP_ORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_ANDI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_XORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_LUI: begin
            // ����rsΪ$0�����ԣ��ɵȼ�����ʵ��
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {ins_in[`ImmedRange], 16'h0};
          end
          default: begin 
          end
        endcase
      end
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