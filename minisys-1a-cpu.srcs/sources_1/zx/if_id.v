// if_id.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水级IF-ID之间的寄存器
module if_id (
  
  input clk, // 时钟
  input rst, // 复位

  input wire[`WordRange] if_pc, // IF级PC
  input wire[`WordRange] if_ins, // IF级指令

  output reg[`WordRange] id_pc, // ID级PC
  output reg[`WordRange] id_ins // ID级指令

);

  always @(posedge clk) begin
    // 重置时向下级送0x0
    if (rst == `Enable) begin
      id_pc <= `ZeroWord;
      id_ins <= `ZeroWord;
    // 否则向下级直通传递
    end else begin
      id_pc <= if_pc;
      id_ins <= if_ins;
    end
  end

endmodule