// ex.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令执行模块
// 主要有ALU
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

  // 暂存各类运算的结果
  reg[`WordRange] logic_out;

  // 进行并发计算，每种计算类型都做
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

  // 最后再把各种计算类型的结果MUX选择
  always @(*) begin
    // TODO: 
    wreg_data_out <= logic_out;
  end

endmodule