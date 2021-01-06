// minisys.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 顶层
module minisys (

  input rst, // 板上重置
  input board_clk, // 板上时钟

  // 拨码开关
  input wire[23:0] switches_in,
  // 按钮
  input wire[4:0] buttons_in,
  // 矩阵键盘
  input wire[3:0] keyboard_cols_in,
  output wire[3:0] keyboard_rows_out,
  // 数码管
  output wire[7:0] digits_sel_out,
  output wire[7:0] digits_data_out,
  // 蜂鸣器
  output wire beep_out,
  // LED灯
  output wire[7:0] led_RLD_out,
  output wire[7:0] led_YLD_out,
  output wire[7:0] led_GLD_out

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

  wire [`WordRange] cpu_dmem_data_in;
  wire [`WordRange] cpu_dmem_addr_out;
  wire [`WordRange] cpu_dmem_store_data_out;
  wire cpu_dmem_e_out;

  wire [`WordRange] dmem_dmem_data_out;
  wire [`WordRange] dmem_dmem_addr_in;
  wire dmem_dmem_e_in;
  
  assign cpu_dmem_data_in = dmem_dmem_data_out;
  assign dmem_dmem_addr_in = cpu_dmem_addr_out;
  assign dmem_dmem_e_in = cpu_dmem_e_out;


  wire beep_en_out; // 0xFFFF_FD10
  wire digits_en_out; // 0xFFFF_FC00
  wire keyboard_en_out; // 0xFFFF_FC10
  wire leds_en_out; // 0xFFFF_FC60
  wire pwm_en_out; // 0xFFFF_FC30
  wire switches_en_out; // 0xFFFF_FC70
  wire timer_en_out; // 0xFFFF_FC20
  wire watchdog_en_out; // 0xFFFF_FC50

  // CPU
  // CPU
  cpu u_cpu (
  .rst                      (rst),
  .clk                      (clk),
  .imem_data_in             (cpu_imem_data_in),
  .imem_addr_out            (cpu_imem_addr_out),
  .imem_e_out               (cpu_imem_e_out),
  .bus_addr_out             (bus_addr),
  .bus_write_data_out       (bus_write_data),
  .bus_eable_out            (bus_eable),
  .bus_we_out               (bus_we),
  .bus_byte_sel_out         (bus_byte_sel),
  .bus_read_in              (bus_read_data)
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
  
  leds u_leds(
    .rst(rst),
    .clk(cpu_clk),
    .cs(leds_en_out),
    .port(cpu_dmem_addr_out[2:0]),
    .data(cpu_dmem_store_data_out[15:0]),
    .RLD(led_RLD_out),
    .YLD(led_YLD_out),
    .GLD(led_GLD_out)
  );

endmodule