`timescale 1ns / 1ps

`include "../../sources_1/cpu/public.v"

// 数码管测试
module digits_tb();

  reg CLOCK_50MHZ; // T = 20ns
  
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end

  // 被测信号
  reg rst; // 复位
  reg [2:0] sel_in; // 要显示的位置
  reg [3:0] data_in; // 要显示的数据
  wire [7:0] sel_out; // 位使能
  wire [7:0] data_out; // 段使能（DP G-A）

  // 例化被测模块
  digits u_digits(
    .rst(rst),
    .clk(CLOCK_50MHZ),
    .sel_in(sel_in),
    .data_in(data_in),
    .sel_out(sel_out),
    .data_out(data_out)
  );

  initial begin
    rst <= `Enable;
    #100 begin
      rst <= `Disable;
    end
    #100 begin
      sel_in <= 3'd5;
      data_in <= 4'hf;
    end
    #100 $stop;
  end

endmodule