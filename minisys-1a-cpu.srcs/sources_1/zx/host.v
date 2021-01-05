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

  //相关总线(共六个，四种)
  wire[`WordRange] bus_addr;  //地址总线（仅有一个主设备cpu
  wire[`WordRange] bus_write_data; //写数据总线（仅有一个主设备cpu
  wire[`WordRange] bus_read_data; //读数据总线（主设备很多，需要仲裁）
  wire bus_eable; //控制总线之一
  wire bus_we; //控制总线
  wire[3:0] bus_byte_sel; //控制总线 主设备也仅有cpu，无需仲裁

  //相关输出（包含ram与io设备，目前共十个）
  wire[`WordRange] ram_data;
  wire[`WordRange] seven_display_data;
  wire[`WordRange] keyboard_data;
  wire[`WordRange] counter_data;
  wire[`WordRange] pwm_data;
  wire[`WordRange] uart_data;
  wire[`WordRange] watch_dog_data;
  wire[`WordRange] led_light_data;
  wire[`WordRange] switch_data;
  wire[`WordRange] buzzer_data;

  wire ram_read_eable;
  wire seven_display_read_eable;
  wire keyboard_read_eable;
  wire counter_read_eable;
  wire pwm_read_eable;
  wire uart_read_eable;
  wire watch_dog_read_eable;
  wire led_light_read_eable;
  wire switch_read_eable;
  wire buzzer_read_eable;

  //
  assign cpu_imem_data_in = imem_imem_data_out;
  assign imem_imem_addr_in = cpu_imem_addr_out;
  assign imem_imem_e_in = cpu_imem_e_out;


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
  .addra                    (imem_imem_addr_in[15:2]), // 16->14，65536/4=16384
  .clka                     (~clk), //为什么这里不是相反的时钟，这样在pc上升沿变化的时候mem会取的是当前pc的值还是下一个pc的值？
  .ena                      (imem_imem_e_in),
  .douta                    (imem_imem_data_out)
  );

  arbitration u_abt(
  .clk                      (~clk),
  .ram_data                 (ram_data),
  .seven_display_data       (seven_display_data),
  .keyboard_data            (keyboard_data),
  .counter_data             (counter_data),
  .pwm_data                 (pwm_data),
  .uart_data                (uart_data),
  .watch_dog_data           (watch_dog_data),
  .led_light_data           (led_light_data),
  .switch_data              (switch_data),
  .buzzer_data              (buzzer_data),
  .device_eable             ({buzzer_read_eable,switch_read_eable,led_light_read_eable,watch_dog_read_eable,uart_read_eable,pwm_read_eable,counter_read_eable,keyboard_read_eable,seven_display_read_eable,ram_read_eable}),
  .data_out                 (bus_read_data)
  );

  ram u_ram(
  .clk                    (~clk),
  .eable                  (bus_eable),
  .we                     (bus_we),
  .addr                   (bus_addr),
  .byte_sel               (bus_byte_sel),
  .data_in                (bus_write_data),
  .data_out               (ram_data),
  .abt_eable              (ram_read_eable)
  );


endmodule