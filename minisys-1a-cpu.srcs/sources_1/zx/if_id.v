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
    if (rst == `Enable) begin
      id_pc <= `ZeroWord;
      id_ins <= `ZeroWord;
    end else begin
      id_pc <= if_pc;
      id_ins <= if_ins;
    end
  end


endmodule