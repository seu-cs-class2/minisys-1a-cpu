// pc.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ָ�������
module program_counter (

  input clk, // ʱ��
  input rst, // ͬ����λ�ź�
  output reg [`WordRange] pc, // ��ǰPC
  output reg imem_e_out // ָ��洢��ʹ��
  
);

  // �����rst����ʹ��IMEM��ȡ
  always @(posedge clk) begin
    if (rst == `Enable) begin
      imem_e_out <= `Disable;
    end else begin
      imem_e_out <= `Enable;
    end
  end

  // ���rst����λ��0x0������+4
  always @(posedge clk) begin
    if (rst == `Enable) begin
      pc <= `ZeroWord;
    end else begin
      pc <= pc + 4'd4;
    end
  end

endmodule
