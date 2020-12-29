// minisys.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"
 
// 主机
module host (

  input rst, // 重置
  input clk // 时钟

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
  .clk                      (clk),
  .imem_data_in             (cpu_imem_data_in),
  .imem_addr_out            (cpu_imem_addr_out),
  .imem_e_out               (cpu_imem_e_out)
  );

  // IMEM
  blk_mem_gen_0 u_blk_mem_gen_0 (
  .addra                    (imem_imem_addr_in[15:2]), // 16->14，65536/4=16384
  .clka                     (~clk), //为什么这里不是相反的时钟，这样在pc上升沿变化的时候mem会取的是当前pc的值还是下一个pc的值？
  .ena                      (imem_imem_e_in),
  .douta                    (imem_imem_data_out)
  );

  ram u_ram(
  .clk                    (~clk),
  .we                     (mem_we_out),
  .addr                   (mem_addr_out),
  .byte_sel               (mem_byte_sel_out),
  .data_in                (mem_store_data_out),
  .data_out               (mem_read_data_in)
  );

  // 接口部分
  

endmodule