// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Jan  7 10:57:19 2021
// Host        : DESKTOP-ED5SFTK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/ProgramSave/minisys-1a-cpu/minisys-1a-cpu.srcs/sources_1/ip/multiplier_unsigned/multiplier_unsigned_stub.v
// Design      : multiplier_unsigned
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_14,Vivado 2018.3" *)
module multiplier_unsigned(A, B, P)
/* synthesis syn_black_box black_box_pad_pin="A[31:0],B[31:0],P[63:0]" */;
  input [31:0]A;
  input [31:0]B;
  output [63:0]P;
endmodule
