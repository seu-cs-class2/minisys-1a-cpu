// minisys.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 顶层
module minisys (

  input board_rst, // 板上重置
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
  output wire[7:0] led_GLD_out,


  input wire rx, //UART接收
  output wire tx // UART发送

  //测试
  // output wire[`WordRange] pc_out,
  // output wire clk_debug,
  // output wire[`WordRange] ins_out,
  // output wire[`WordRange] bus_bug_addr,
  // output wire[`WordRange] bus_bug_read_data,
  // output wire[`WordRange] bus_bug_write_data,
  // output wire[`WordRange] mem_addr_debug_out,
  // output wire[`WordRange] dataA,
  // output wire[`WordRange] dataB
);

  wire cpu_clk;
  wire uart_clk;
  // 时钟分频

  wire spg_bufg;
  BUFG U1(.I(buttons_in[3]), .O(spg_bufg)); 
  //去抖
  reg upg_rst;
  always @(posedge board_clk)begin
    if(spg_bufg)begin
      upg_rst = 0;
    end
    if(board_rst)begin
      upg_rst = 1;
    end
  end
  assign rst = board_rst | !upg_rst;

  clocking u_clocking(
    .clk_in1(board_clk), // 100MHz
    .cpu_clk(cpu_clk), // 5MHz
    .uart_clk(uart_clk) // 10MHz
  );

  //uart相关
  wire upg_clk_o, upg_wen_o, upg_done_o;
  wire[14:0] upg_adr_o;
  wire[31:0] upg_dat_o;


  wire [`WordRange] cpu_imem_data_in;
  wire [`WordRange] cpu_imem_addr_out;
  wire cpu_imem_e_out;
  
  wire [`WordRange] imem_imem_data_out;
  wire [`WordRange] imem_imem_addr_in;
  wire imem_imem_e_in;

  assign cpu_imem_data_in = imem_imem_data_out;
  assign imem_imem_addr_in = cpu_imem_addr_out;

  assign imem_imem_e_in = cpu_imem_e_out;


 //debug******
  // assign clk_debug = cpu_clk;
  // assign pc_out = cpu_imem_addr_out;
  // assign ins_out = cpu_imem_data_in;
  // assign bus_bug_addr = bus_addr;
  // assign bus_bug_read_data =  bus_read_data;
  // assign bus_bug_write_data = bus_write_data;

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

  //测试相关
  assign counter_data = {32'hffffffff};
  assign pwm_data = {32'hffffffff};
  assign uart_data = {32'hffffffff};
  assign watch_dog_data = {32'hffffffff};
  assign buzzer_data = {32'hffffffff};
  //测试相关




  wire beep_en_out; // 0xFFFF_FD10
  wire digits_en_out; // 0xFFFF_FC00
  wire keyboard_en_out; // 0xFFFF_FC10
  wire leds_en_out; // 0xFFFF_FC60
  wire pwm_en_out; // 0xFFFF_FC30
  wire switches_en_out; // 0xFFFF_FC70
  wire timer_en_out; // 0xFFFF_FC20
  wire watchdog_en_out; // 0xFFFF_FC50


  //中断线
  wire interrupt0;
  wire interrupt1;
  wire interrupt2;
  wire interrupt3;
  wire interrupt4;
  wire interrupt5;

  assign interrupt5 = 1'b0;
  assign interrupt4 = 1'b0;
  assign interrupt3 = 1'b0;
  assign interrupt2 = 1'b0;
  assign interrupt1 = 1'b0;
  assign interrupt0 = 1'b0;

  //uart串口
  uart_bmpg_0 u_uartpg(
		.upg_clk_i		(uart_clk),		// 10MHz   
		.upg_rst_i		(upg_rst),		// 高电平有效
		// blkram signals
		.upg_clk_o		(upg_clk_o),
		.upg_wen_o		(upg_wen_o),
		.upg_adr_o		(upg_adr_o),
		.upg_dat_o		(upg_dat_o),
		.upg_done_o		(upg_done_o),
		// uart signals
		.upg_rx_i		(rx),
		.upg_tx_o		(tx)
  );



  // CPU
  // CPU
  cpu u_cpu (
  .rst                      (rst),
  .clk                      (cpu_clk),
  .imem_data_in             (cpu_imem_data_in),
  .imem_addr_out            (cpu_imem_addr_out),
  .imem_e_out               (cpu_imem_e_out),
  .bus_addr_out             (bus_addr),
  .bus_write_data_out       (bus_write_data),
  .bus_eable_out            (bus_eable),
  .bus_we_out               (bus_we),
  .bus_byte_sel_out         (bus_byte_sel),
  .bus_read_in              (bus_read_data),
  .interrupt_in             ({interrupt5, interrupt4, interrupt3, interrupt2, interrupt1, interrupt0})
  );

  // IMEM
  rom u_rom(
    .clk                  (~cpu_clk),
    .addr                 (imem_imem_addr_in),
    .data_out             (imem_imem_data_out),
    .upg_rst              (upg_rst),
    .upg_clk              (upg_clk_o),
    .upg_wen              (upg_wen_o & !upg_adr_o[14]),
    .upg_adr              (upg_adr_o[13:0]),
    .upg_dat              (upg_dat_o),
    .upg_done             (upg_done_o)
  );

  // DMEM
  ram u_ram(
  .clk                    (~cpu_clk),
  .eable                  (bus_eable),
  .we                     (bus_we),
  .addr                   (bus_addr),
  .byte_sel               (bus_byte_sel),
  .data_in                (bus_write_data),
  .data_out               (ram_data),
  .upg_rst                (upg_rst),
  .upg_clk                (upg_clk_o),
  .upg_wen                (upg_wen_o & upg_adr_o),
  .upg_adr                (upg_adr_o[13:0]),
  .upg_dat                (upg_dat_o),
  .upg_done               (upg_done_o)
  );


  arbitration u_abt(
  .clk                      (~cpu_clk),
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
  .addr                     (bus_addr),
  .data_out                 (bus_read_data)
  );


  // 接口部分 后续再添加
  
  leds u_leds(
    .rst                    (rst),
    .clk                    (~cpu_clk),
    .addr                   (bus_addr),
    .en                     (bus_eable),
    .byte_sel               (bus_byte_sel),
    .data_in                (bus_write_data),
    .we                     (bus_we),
    .data_out               (led_light_data),
    .RLD                    (led_RLD_out),
    .YLD                    (led_YLD_out),
    .GLD                    (led_GLD_out)
  );

  switches u_switches(
    .rst                    (rst),
    .clk                    (~cpu_clk),
    .addr                   (bus_addr),
    .en                     (bus_eable),
    .byte_sel               (bus_byte_sel),
    .data_in                (bus_write_data),
    .we                     (bus_we),
    .data_out               (switch_data),
    .switch_in              (switches_in)
  );

  keyboard u_keyboard(
    .rst                    (rst),
    .clk                    (~cpu_clk),
    .addr                   (bus_addr),
    .en                     (bus_eable),
    .byte_sel               (bus_byte_sel),
    .data_in                (bus_write_data),
    .we                     (bus_we),
    .data_out               (keyboard_data),
    .cols                   (keyboard_cols_in),
    .rows                   (keyboard_rows_out)
  );

  digits u_digits(
    .rst                    (rst),
    .clk                    (~cpu_clk),
    .addr                   (bus_addr),
    .en                     (bus_eable),
    .byte_sel               (bus_byte_sel),
    .data_in                (bus_write_data),
    .we                     (bus_we),
    .data_out               (seven_display_data),
    .sel_out                (digits_sel_out),
    .digital_out            (digits_data_out)
  );

  beep u_beep(
    .rst                    (rst),
    .clk                    (~cpu_clk),
    .addr                   (bus_addr),
    .en                     (bus_eable),
    .byte_sel               (bus_byte_sel),
    .data_in                (bus_write_data),
    .we                     (bus_we),
    .data_out               (buzzer_data),
    .signal_out             (beep_out)
  );

endmodule