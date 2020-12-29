// minisys.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 顶层
module minisys (

  input rst, // 板上重置
  input board_clk // 板上时钟

);

  wire cpu_clk;
  wire uart_clk;
  // 时钟分频
  clocking u_clocking(
    .clk_in1(board_clk), // 100MHz
    .cpu_clk(cpu_clk), // 22MHz
    .uart_clk(uart_clk) // 10MHz
  );

  wire [`WordRange] cpu_imem_data_in;
  wire [`WordRange] cpu_imem_addr_out;
  wire cpu_imem_e_out;
  
  wire [`WordRange] imem_imem_data_out;
  wire [`WordRange] imem_imem_addr_in;
  wire imem_imem_e_in;

  assign cpu_imem_data_in = imem_imem_data_out;
  assign imem_imem_addr_in = cpu_imem_addr_out;
  assign imem_imem_e_in = cpu_imem_e_out;

  // CPU
  cpu u_cpu (
  .rst                      (rst),
  .clk                      (cpu_clk),
  .imem_data_in             (cpu_imem_data_in),
  .imem_addr_out            (cpu_imem_addr_out),
  .imem_e_out               (cpu_imem_e_out)
  );

  // IMEM
  blk_mem_gen_0 u_blk_mem_gen_0 (
  .addra                    (imem_imem_addr_in[15:2]),
  .clka                     (~cpu_clk),
  .douta                    (imem_imem_data_out)
  );

  // DMEM
  ram u_ram(
  .clk                    (~cpu_clk),
  .we                     (mem_we_out),
  .addr                   (mem_addr_out),
  .byte_sel               (mem_byte_sel_out),
  .data_in                (mem_store_data_out),
  .data_out               (mem_read_data_in)
  );

  // 接口部分
  // TODO

endmodule