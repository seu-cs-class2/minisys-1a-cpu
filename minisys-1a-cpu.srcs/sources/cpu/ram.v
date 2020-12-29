// 集成写一个ram 包含四个8位block_mem
// 相当于对一个block_mem做位拓展
// 每次读直接出来32bit
// 写根据byte_sel的情况来写

`include "public.v"

// 四体交叉RAM，8bit*4
module ram(
  input wire clk,
  input wire we,
  input wire[`WordRange] addr,
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in,
  output wire[`WordRange] data_out
);

  wire weA, weB, weC, weD;
  assign weA = byte_sel[0] & we;
  assign weB = byte_sel[1] & we;
  assign weC = byte_sel[2] & we;
  assign weD = byte_sel[3] & we;

  blk_mem_ram_byte ramA(
    .addra         (addr[17:2]),
    .clka          (clk),
    .dina          (data_in[7:0]),
    .douta         (data_out[7:0]),
    .wea           (weA)
  ); // 00
  blk_mem_ram_byte ramB(
    .addra         (addr[17:2]),
    .clka          (clk),
    .dina          (data_in[15:8]),
    .douta         (data_out[15:8]),
    .wea           (weB)
  ); // 01
  blk_mem_ram_byte ramC(
    .addra         (addr[17:2]),
    .clka          (clk),
    .dina          (data_in[23:16]),
    .douta         (data_out[23:16]),
    .wea           (weC)
  ); // 10
  blk_mem_ram_byte ramD(
    .addra         (addr[17:2]),
    .clka          (clk),
    .dina          (data_in[31:24]),
    .douta         (data_out[31:24]),
    .wea           (weD)
  ); // 11

endmodule