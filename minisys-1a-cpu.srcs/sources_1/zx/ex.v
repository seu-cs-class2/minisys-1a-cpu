// ex.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ָ��ִ��ģ��
// ��Ҫ��ALU
module ex (

  input rst,
  input wire[`ALUOpRange] aluop_in,
  input wire[`WordRange] data1_in,
  input wire[`WordRange] data2_in,
  input wire[`RegRangeLog2] wreg_addr_in,
  input wire wreg_e_in,

  output reg[`RegRangeLog2] wreg_addr_out,
  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out

);

  // �ݴ��������Ľ��
  reg[`WordRange] logic_out;

  // ���в������㣬ÿ�ּ������Ͷ���
  always @(*) begin
    if (rst == `Enable) begin
      logic_out <= `ZeroWord;
    end else begin
      case (aluop_in)
        // TODO: 
        `ALUOP_OR: begin
          logic_out <= data1_in | data2_in;
        end
        default: begin
          logic_out <= `ZeroWord;
        end
      endcase
    end
  end

  // ����ٰѸ��ּ������͵Ľ��MUXѡ��
  always @(*) begin
    // TODO: 
    wreg_e_out <= wreg_e_in;
    wreg_addr_out <= wreg_addr_in;
    wreg_data_out <= logic_out;
  end

endmodule