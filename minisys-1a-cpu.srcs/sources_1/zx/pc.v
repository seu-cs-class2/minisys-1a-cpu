`include "public.v"

// 指令计数器

module program_counter (
  input clk, // 时钟
  input rst, // 同步复位信号
  output reg [`WordRange] pc, // 当前PC
  output reg imemEnable // 指令存储器使能
);

  always @(posedge clk) begin
    if (rst == `Enable) begin
      imemEnable <= `Disable;
    end else begin
      imemEnable <= `Enable;
    end
  end

  always @(posedge clk) begin
    if (rst == `Enable) begin
      pc <= `ZeroWord; // 复位地址0x0
    end else begin
      pc <= pc + 4'd4;
    end
  end

endmodule

