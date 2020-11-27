// mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// �ô����ģ��
module mem (

  input rst,
  input wire wreg_e_in,
  input wire[`WordRange] wreg_data_in,
  input wire[`RegRangeLog2] wreg_addr_in,

  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out,
  output reg[`RegRangeLog2] wreg_addr_out

);

  // TODO: ��ʱ����ֱͨ�߼�
  always @(*) begin
    if (rst == `Enable) begin
      wreg_e_out <= `Disable;
      wreg_data_out <= `ZeroWord;
    end else begin
      wreg_e_out <= wreg_e_in;
      wreg_data_out <= wreg_data_in;
      wreg_addr_out <= wreg_addr_in;
    end
  end

endmodule