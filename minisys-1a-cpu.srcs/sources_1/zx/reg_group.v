`include "public.v"

module reg_group(

  input rst,
  input clk,

  input we,
  input wire[`RegRangeLog2] waddr,
  input wire[`WordRange] wdata,

  input re1,
  input wire[`RegRangeLog2] raddr1,
  output reg[`WordRange] rdata1,

  input re2,
  input wire[`RegRangeLog2] raddr2,
  output reg[`WordRange] rdata2

);


  // 定义32个寄存器
  reg[`RegRange] regs[`WordRange];

  always @(posedge clk) begin
    if (rst == `Disable) begin
      // 禁止写入0号寄存器
      if ((we == `Enable) && (waddr != `RegCountLog2'd0)) begin
        regs[waddr] <= wdata;
      end
    end
  end

  always @(*) begin
    if (rst == `Enable || raddr1 == `RegCountLog2'd0) begin
      rdata1 <= `ZeroWord;
    end else if ((raddr1 == waddr) && (we == `Enable) && (re1 == `Enable)) begin
      // 数据直通，避免冒险
      rdata1 <= wdata;
    end else if (re1 == `Enable) begin
      rdata1 <= regs[raddr1];
    end else begin // re == `Disable
      rdata1 <= `ZeroWord;
    end
  end

  always @(*) begin
    if (rst == `Enable || raddr2 == `RegCountLog2'd0) begin
      rdata2 <= `ZeroWord;
    end else if ((raddr2 == waddr) && (we == `Enable) && (re2 == `Enable)) begin
      // 数据直通，避免冒险
      rdata2 <= wdata;
    end else if (re2 == `Enable) begin
      rdata2 <= regs[raddr2];
    end else begin // re == `Disable
      rdata2 <= `ZeroWord;
    end
  end


endmodule