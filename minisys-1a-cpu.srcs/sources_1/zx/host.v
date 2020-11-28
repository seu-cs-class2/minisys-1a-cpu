// host.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"
 
// 主机
module host (

  input rst, // 重置
  input clk // 时钟

);
  (* mark_debug="true" *)
  wire [`WordRange] cpu_imem_data_in;
  (* mark_debug="true" *)
  wire [`WordRange] cpu_imem_addr_out;
  (* mark_debug="true" *)
  wire cpu_imem_e_out;
  
  (* mark_debug="true" *)
  wire [`WordRange] imem_imem_data_out;
  (* mark_debug="true" *)
  wire [`WordRange] imem_imem_addr_in;
  (* mark_debug="true" *)
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
  .clka                     (clk),
  .ena                      (imem_imem_e_in),
  .douta                    (imem_imem_data_out)
  );

endmodule