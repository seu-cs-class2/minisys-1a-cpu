// digits.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 八位七段共阳极数码管驱动
// 地址范围：0xFFFFFC00 ~ 0xFFFFFC0F
// 寄存器个数：2（每个寄存器的位数都是机器字长）
// 寄存器地址： 0xFFFFFC00  0xFFFFFC04
// 寄存器功能：  显示的数据  显示的位数
module digits (

  input rst, // 复位
  input clk, // 时钟

  //从总线来的数据 所有外设驱动都应有以下信号
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 数据输入（来自cpu）
  input wire we, //写使能

  //发送给仲裁器 所有外设都应有此输出
  output reg[`WordRange] data_out,

  //发送给外设
  output reg[7:0] sel_out, // 位使能
  output reg[7:0] digital_out // 段使能（DP, G-A）

);

  always @(posedge clk) begin  //写是上升沿
    if (rst == `Enable) begin
      sel_out <= 8'hff;
      digital_out <= 8'hff;
    end else if(addr == 32'hfffffc00 && en == `Enable && we == `Enable) begin //写的是显示数据寄存器 且使能有效
      case (data_in[7:0])
        //                GEF_DCBA
        4'h0: begin
          digital_out <= 8'b1100_0000; // ABCDEF
        end
        4'h1: begin
          digital_out <= 8'b1111_1001; // BC
        end
        4'h2: begin
          digital_out <= 8'b1010_0100; // ABDEG
        end
        4'h3: begin
          digital_out <= 8'b1011_0000; // ABCDG
        end
        4'h4: begin
          digital_out <= 8'b1010_1001; // BCFG
        end
        4'h5: begin
          digital_out <= 8'b1010_0010; // ACDFG
        end
        4'h6: begin
          digital_out <= 8'b1000_0010; // ACDEFG
        end
        4'h7: begin
          digital_out <= 8'b1111_1000; // ABC
        end
        4'h8: begin
          digital_out <= 8'b1000_0000; // ABCDEFG
        end
        4'h9: begin
          digital_out <= 8'b1010_1000; // ABCFG
        end
        4'ha: begin
          digital_out <= 8'b1000_1000; // ABCEFG
        end
        4'hb: begin
          digital_out <= 8'b1000_0011; // CDEFG
        end
        4'hc: begin
          digital_out <= 8'b1010_0111; // DEG
        end
        4'hd: begin
          digital_out <= 8'b1010_0001; // BCDEG
        end
        4'he: begin
          digital_out <= 8'b1000_0110; // ADEFG
        end
        4'hf: begin
          digital_out <= 8'b1000_1110; // AEFG
        end
      endcase
    end else if(addr == 32'hfffffc04 && en == `Enable && we == `Enable)begin //写的是位数使能寄存器
        sel_out <= ~(1'b1 << data_in[7:0]); //这里存疑 实现方式可以更改
    end
  end

  always @(*) begin
    if(rst == `Enable) begin
      data_out <= `ZeroWord;
    end else if (addr == 32'hfffffc00 && en == `Enable && we ==`Disable) begin
      data_out <= {24'b000000,data_out};
    end else if (addr == 32'hfffffc04 && en == `Enable && we == `Disable) begin
      data_out <= {24'b000000,sel_out};
    end else begin
      data_out <= `ZeroWord;
    end
  end
endmodule