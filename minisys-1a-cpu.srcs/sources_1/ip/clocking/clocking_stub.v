// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Jan  8 12:29:29 2021
// Host        : DESKTOP-ED5SFTK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/ProgramSave/minisys-1a-cpu/minisys-1a-cpu.srcs/sources_1/ip/clocking/clocking_stub.v
// Design      : clocking
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clocking(cpu_clk, uart_clk, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="cpu_clk,uart_clk,clk_in1" */;
  output cpu_clk;
  output uart_clk;
  input clk_in1;
endmodule
