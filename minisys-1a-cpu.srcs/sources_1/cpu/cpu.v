// cpu.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// CPU
module cpu (

  input rst, // 重置
  input clk, // 时钟

  input [`WordRange] imem_data_in,  //指令存储器发给cpu的指令
  output wire[`WordRange] imem_addr_out,  //cpu发给指令存储器的地址
  output wire imem_e_out,  //cpu发给指令存储器的使能信号

  output wire[`WordRange] bus_addr_out, //发给数据总线的地址
  output wire[`WordRange] bus_write_data_out,  //发给写数据总线的数据
  output wire bus_eable_out, //发给控制总线的读写使能信号
  output wire bus_we_out, //发给控制总线的写使能信号（0代表读）
  output wire[3:0] bus_byte_sel_out, //发给控制总线的比特选择信号
  
  input wire[`WordRange] bus_read_in,//从读控制总线读入的外设/ram数据

  input wire[5:0] interrupt_in, //外部中断信号 共六根

  //debug
  output wire[`WordRange] mem_addr_debug,
  output wire[`WordRange] ex_dataA_in,
  output wire[`WordRange] ex_dataB_in,

  // cpu_tb
  output wire[`WordRange] ex_data_out, // EX级结果：写寄存器数据
  output wire[`WordRange] ex_addr_out // EX级结果：写寄存器地址
);

  // ID输入
  wire[`WordRange] pc;
  assign imem_addr_out = pc;
  wire[`WordRange] id_pc_in;
  wire[`WordRange] id_ins_in;
  wire is_in_delayslot_in;

  // ID输出
  wire[`ALUOpRange] id_aluop_out;
  wire[`WordRange] id_data1_out;
  wire[`WordRange] id_data2_out;
  wire id_wreg_e_out;
  wire[`RegRangeLog2] id_wreg_addr_out;
  wire branch_e_out;
  wire[`WordRange] branch_addr_out;
  wire[`WordRange] link_addr_out;
  wire next_is_in_delayslot;
  wire is_in_delayslot_out;
  wire[`WordRange] id_ins_out;
  wire[`WordRange] id_abnormal_type_out;
  wire[`WordRange] id_current_pc_addr_out;

  // EX输入
  wire[`ALUOpRange] ex_aluop_in;
  wire[`WordRange] ex_data1_in;
  wire[`WordRange] ex_data2_in;
  wire ex_wreg_e_in;
  wire[`RegRangeLog2] ex_wreg_addr_in;
  wire ex_hilo_we_in;
  wire[`WordRange] ex_hi_data_in;
  wire[`WordRange] ex_lo_data_in;
  wire[`DivMulResultRange] div_result_signed;
  wire[`DivMulResultRange] div_result_unsigned;
  wire div_result_valid_signed;
  wire div_result_valid_unsigned;
  wire[`DivMulResultRange] ex_mul_result;
  wire ex_mul_result_valid;
  wire[`WordRange] ex_link_addr_in;
  wire ex_is_in_delayslot;
  wire[`WordRange] ex_ins_in;
  wire[`WordRange] ex_cp0_data_in;
  wire ex_f_mem_cp0_we_in;
  wire[4:0] ex_f_mem_cp0_w_addr;
  wire[`WordRange] ex_f_mem_cp0_w_data;
  wire ex_f_wb_cp0_we_in;
  wire[4:0] ex_f_wb_cp0_w_addr;
  wire[`WordRange] ex_f_wb_cp0_w_data;
  wire[`WordRange] ex_current_pc_addr_in;
  wire[`WordRange] ex_abnormal_type_in;


  // EX输出
  wire ex_wreg_e_out;
  wire[`RegRangeLog2] ex_wreg_addr_out;
  wire[`WordRange] ex_wreg_data_out;
  wire ex_hilo_we_out;
  wire[`WordRange] ex_hi_data_out;
  wire[`WordRange] ex_lo_data_out;
  wire[`WordRange] div_data1_signed;
  wire[`WordRange] div_data2_signed;
  wire[`WordRange] div_data1_unsigned;
  wire[`WordRange] div_data2_unsigned;
  wire div_data_valid_signed;
  wire div_data_valid_unsigned;
  wire[`WordRange] ex_mul_data1;
  wire[`WordRange] ex_mul_data2;
  wire ex_mul_valid;
  wire ex_mul_signed;
  wire[`WordRange] ex_mem_addr_out;
  wire[`WordRange] ex_mem_data_out;
  wire[`ALUOpRange] ex_aluop_out;
  wire[`WordRange] ex_ins_out;
  wire[4:0] ex_cp0_raddr_out;
  wire ex_cp0_we_out;
  wire[4:0] ex_cp0_waddr_out;
  wire[`WordRange] ex_cp0_w_data_out;
  wire[`WordRange] ex_current_pc_addr_out;
  wire[`WordRange] ex_abnormal_type_out;

  // MEM输入
  wire mem_wreg_e_in;
  wire[`RegRangeLog2] mem_wreg_addr_in;
  wire[`WordRange] mem_wreg_data_in;
  wire mem_hilo_we_in;
  wire[`WordRange] mem_hi_data_in;
  wire[`WordRange] mem_lo_data_in;
  wire[`ALUOpRange] mem_aluop_in;
  wire[`WordRange] mem_addr_in;
  wire[`WordRange] mem_store_data_in;
  wire[`WordRange] mem_read_data_in;
  wire[`WordRange] mem_ins_in;
  wire mem_cp0_we_in;
  wire[4:0] mem_cp0_waddr_in;
  wire[`WordRange] mem_cp0_wdata_in;
  wire[`WordRange] mem_current_pc_addr_in;
  wire[`WordRange] mem_abnormal_type_in;
  wire[`WordRange] mem_cp0_status_in;
  wire[`WordRange] mem_cp0_cause_in;
  wire[`WordRange] mem_cp0_epc_in;
  


  // MEM输出
  wire mem_wreg_e_out;
  wire[`RegRangeLog2] mem_wreg_addr_out;
  wire[`WordRange] mem_wreg_data_out;
  wire mem_hilo_we_out;
  wire[`WordRange] mem_hi_data_out;
  wire[`WordRange] mem_lo_data_out;
  wire[`WordRange] mem_addr_out;
  wire[`WordRange] mem_store_data_out;
  wire[3:0] mem_byte_sel_out;
  wire mem_we_out;
  wire mem_e_out;
  wire mem_cp0_we_out;
  wire[4:0] mem_cp0_waddr_out;
  wire[`WordRange] mem_cp0_wdata_out;
  wire[`WordRange] mem_abnormal_type_out;
  wire[`WordRange] mem_current_pc_addr_out;

  // WB输入
  wire wb_wreg_e_in;
  wire[`RegRangeLog2] wb_wreg_addr_in;
  wire[`WordRange] wb_wreg_data_in;
  // 下面三根线直接连到HILO
  wire wb_hilo_we_in;
  wire[`WordRange] wb_hi_data_in;
  wire[`WordRange] wb_lo_data_in;
  //cp0的输入
  wire wb_cp0_we_in;
  wire[4:0] wb_cp0_waddr_in;
  wire[`WordRange] wb_cp0_wdata_in;

  // 寄存器组相关
  wire reg1_re;
  wire reg2_re;
  wire[`WordRange] reg1_data;
  wire[`WordRange] reg2_data;
  wire[`RegRangeLog2] reg1_addr;
  wire[`RegRangeLog2] reg2_addr;

  //流水线暂停相关
  wire pause_req_id;
  wire pause_req_ex;
  wire pause_res_pc;
  wire pause_res_if;
  wire pause_res_id;
  wire pause_res_ex;
  wire pause_res_mem;
  wire pause_res_wb;

  // 流水处理器异常相关
  wire flush;
  wire[`WordRange] interrupt_pc_out;

  //debug
  assign mem_addr_debug = mem_addr_in;
  assign ex_dataA_in = ex_data1_in;
  assign ex_dataB_in = ex_data2_in;
  
  // cpu_tb
  assign ex_data_out = ex_wreg_data_out; // EX级执行结果：写寄存器数据
  assign ex_addr_out = ex_wreg_addr_out;

  // HILO
  hilo  u_hilo (  
  .rst                      (rst),
  .clk                      (clk),
  .we_in                    (wb_hilo_we_in),
  .hi_in                    (wb_hi_data_in),
  .lo_in                    (wb_lo_data_in),
  .hi_out                   (ex_hi_data_in),
  .lo_out                   (ex_lo_data_in)
  );

  // gpr
  gpr  u_gpr (
  .rst                      (rst),
  .clk                      (clk),
  .we                       (wb_wreg_e_in),
  .waddr                    (wb_wreg_addr_in),
  .wdata                    (wb_wreg_data_in),
  .re1                      (reg1_re),
  .raddr1                   (reg1_addr),
  .re2                      (reg2_re),
  .raddr2                   (reg2_addr),
  .rdata1                   (reg1_data),
  .rdata2                   (reg2_data)
  );

  // IF
  pc  u_pc (
  .clk                      (clk),
  .rst                      (rst),
  .pc                       (pc),
  .pause                    (pause_res_pc),
  .branch_en_in             (branch_e_out),
  .branch_addr_in           (branch_addr_out),
  .flush                    (flush),
  .interrupt_pc             (interrupt_pc_out)
  );

  // IF-ID
  if_id  u_if_id (
  .clk                      (clk),
  .rst                      (rst),
  .if_pc                    (pc),
  .if_ins                   (imem_data_in),
  .id_pc                    (id_pc_in),
  .id_ins                   (id_ins_in),
  .pause                    (pause_res_if),
  .flush                    (flush)
  );

  // ID
  id  u_id (
  .rst                  		(rst),
  .pc_in                		(id_pc_in),
  .ins_in               		(id_ins_in),
  .reg1_data_in         		(reg1_data),
  .reg2_data_in         		(reg2_data),
  .reg1_ren_out          		(reg1_re),
  .reg2_ren_out          		(reg2_re),
  .reg1_addr_out        		(reg1_addr),
  .reg2_addr_out        		(reg2_addr),
  .exop_out            		  (id_aluop_out),
  .data1_out            		(id_data1_out),
  .data2_out            		(id_data2_out),
  .wreg_wen_out           	(id_wreg_e_out),
  .wreg_addr_out        		(id_wreg_addr_out),
  .ex_wreg_en_in            (ex_wreg_e_out),
  .ex_wreg_data_in          (ex_wreg_data_out),
  .ex_wreg_addr_in          (ex_wreg_addr_out),
  .mem_wreg_en_in           (mem_wreg_e_out),
  .mem_wreg_data_in         (mem_wreg_data_out),
  .mem_wreg_addr_in         (mem_wreg_addr_out),
  .pause_req                (pause_req_id),
  .branch_en_out            (branch_e_out),
  .branch_addr_out          (branch_addr_out),
  .link_addr_out            (link_addr_out),
  .in_delayslot_in          (is_in_delayslot_in),
  .in_delayslot_out         (is_in_delayslot_out),
  .next_in_delayslot_out    (next_is_in_delayslot),
  .ins_out                  (id_ins_out),
  .abnormal_type_out        (id_abnormal_type_out),
  .current_id_pc_addr_out      (id_current_pc_addr_out)
  );

  // ID-EX
  id_ex  u_id_ex (
  .clk                      (clk),
  .rst                      (rst),
  .id_aluop                 (id_aluop_out),
  .id_data1                 (id_data1_out),
  .id_data2                 (id_data2_out),
  .id_wreg_addr             (id_wreg_addr_out),
  .id_wreg_e                (id_wreg_e_out),
  .id_link_addr             (link_addr_out),
  .ex_aluop                 (ex_aluop_in),
  .ex_data1                 (ex_data1_in),
  .ex_data2                 (ex_data2_in),
  .ex_wreg_addr             (ex_wreg_addr_in),
  .ex_wreg_e                (ex_wreg_e_in),
  .ex_link_addr             (ex_link_addr_in),
  .pause                    (pause_res_ex),
  .id_in_delayslot          (is_in_delayslot_out),
  .id_next_in_delayslot     (next_is_in_delayslot),
  .ex_in_delayslot          (ex_is_in_delayslot),
  .ex_next_in_delayslot     (is_in_delayslot_in),
  .id_ins                   (id_ins_out),
  .ex_ins                   (ex_ins_in),
  .flush                    (flush),
  .f_id_current_pc_addr_in  (id_current_pc_addr_out),
  .f_id_abnormal_type_in    (id_abnormal_type_out),
  .t_ex_current_pc_addr_out (ex_current_pc_addr_in),
  .t_ex_abnormal_type_out   (ex_abnormal_type_in)
  );

  // EX
  ex  u_ex (
  .rst                      (rst),
  .aluop_in                 (ex_aluop_in),
  .data1_in         		    (ex_data1_in),
  .data2_in         	    	(ex_data2_in),
  .wreg_addr_in  		        (ex_wreg_addr_in),
  .wreg_e_in                (ex_wreg_e_in),
  .wreg_addr_out            (ex_wreg_addr_out),
  .wreg_e_out               (ex_wreg_e_out),
  .wreg_data_out            (ex_wreg_data_out),
  .hi_data_in               (ex_hi_data_in),
  .lo_data_in               (ex_lo_data_in),
  .mem_hilo_we_in           (mem_hilo_we_in),
  .mem_hi_data_in           (mem_hi_data_in),
  .mem_lo_data_in           (mem_lo_data_in),
  .wb_hilo_we_in            (wb_hilo_we_in),
  .wb_hi_data_in            (wb_hi_data_in),
  .wb_lo_data_in            (wb_lo_data_in),
  .hilo_we_out              (ex_hilo_we_out),
  .hi_data_out              (ex_hi_data_out),
  .lo_data_out              (ex_lo_data_out),
  .pause_req                (pause_req_ex),
  .link_addr_in             (ex_link_addr_in), //******
  .div_data1_signed         (div_data1_signed),
  .div_data2_signed         (div_data2_signed),
  .div_data1_unsigned       (div_data1_unsigned),
  .div_data2_unsigned       (div_data2_unsigned),
  .div_data_valid_signed    (div_data_valid_signed),
  .div_data_valid_unsigned  (div_data_valid_unsigned),
  .div_result_signed        (div_result_signed),
  .div_result_unsigned      (div_result_unsigned),
  .div_result_valid_signed  (div_result_valid_signed),
  .div_result_valid_unsigned(div_result_valid_unsigned),
  .mul_data1                (ex_mul_data1),
  .mul_data2                (ex_mul_data2),
  .mul_type                 (ex_mul_signed),
  .mul_valid                (ex_mul_valid),
  .mul_result               (ex_mul_result),
  .mul_result_valid         (ex_mul_result_valid),
  .is_in_delayslot          (ex_is_in_delayslot),  //******
  .ins_in                   (ex_ins_in),
  .aluop_out                (ex_aluop_out),
  .mem_addr_out             (ex_mem_addr_out),
  .mem_data_out             (ex_mem_data_out),
  .ins_out                  (ex_ins_out),
  .cp0_data_in              (ex_cp0_data_in),
  .cp0_raddr_out            (ex_cp0_raddr_out),
  .f_mem_cp0_we_in          (ex_f_mem_cp0_we_in),
  .f_mem_cp0_w_addr         (ex_f_mem_cp0_w_addr),
  .f_mem_cp0_w_data         (ex_f_mem_cp0_w_data),
  .f_wb_cp0_we_in           (ex_f_wb_cp0_we_in),
  .f_wb_cp0_w_addr          (ex_f_wb_cp0_w_addr),
  .f_wb_cp0_w_data          (ex_f_wb_cp0_w_data),
  .cp0_we_out               (ex_cp0_we_out),
  .cp0_waddr_out            (ex_cp0_waddr_out),
  .cp0_w_data_out           (ex_cp0_w_data_out),
  .current_ex_pc_addr_in    (ex_current_pc_addr_in),
  .abnormal_type_in         (ex_abnormal_type_in),
  .abnormal_type_out        (ex_abnormal_type_out),
  .current_ex_pc_addr_out   (ex_current_pc_addr_out)      
  );

  div_signed u_div_signed(
    .aclk                   (clk),
    .s_axis_divisor_tdata   (div_data2_signed),
    .s_axis_divisor_tvalid  (div_data_valid_signed),
    .s_axis_dividend_tdata  (div_data1_signed),
    .s_axis_dividend_tvalid (1'b1),
    .m_axis_dout_tdata      (div_result_signed),
    .m_axis_dout_tvalid     (div_result_valid_signed)
  );

  div_unsigned u_div_unsigned(
    .aclk                   (clk),
    .s_axis_divisor_tdata   (div_data2_unsigned),
    .s_axis_divisor_tvalid  (div_data_valid_unsigned),
    .s_axis_dividend_tdata  (div_data1_unsigned),
    .s_axis_dividend_tvalid (1'b1),
    .m_axis_dout_tdata      (div_result_unsigned),
    .m_axis_dout_tvalid     (div_result_valid_unsigned)
  );

  mul u_mul(
    .clk                    (clk),
    .dataA                  (ex_mul_data1),
    .dataB                  (ex_mul_data2),
    .start                  (ex_mul_valid),
    .if_signed              (ex_mul_signed),
    .result                 (ex_mul_result),
    .valid                  (ex_mul_result_valid)
  );






  // EX-MEM
  ex_mem  u_ex_mem (
  .rst                      (rst),
  .clk                      (clk),
  .ex_wreg_e                (ex_wreg_e_out),
  .ex_wreg_addr             (ex_wreg_addr_out),
  .ex_wreg_data             (ex_wreg_data_out),
  .mem_wreg_e               (mem_wreg_e_in),
  .mem_wreg_addr            (mem_wreg_addr_in),
  .mem_wreg_data            (mem_wreg_data_in),
  .ex_hilo_we               (ex_hilo_we_out),
  .ex_hi_data               (ex_hi_data_out),
  .ex_lo_data               (ex_lo_data_out),
  .mem_hilo_we              (mem_hilo_we_in),
  .mem_hi_data              (mem_hi_data_in),
  .mem_lo_data              (mem_lo_data_in),
  .pause                    (pause_res_mem),
  .f_ex_aluop               (ex_aluop_out),
  .f_ex_mem_addr            (ex_mem_addr_out),
  .f_ex_mem_data            (ex_mem_data_out),
  .t_mem_addr               (mem_addr_in),
  .t_mem_aluop              (mem_aluop_in),
  .t_mem_data               (mem_store_data_in),
  .f_ex_ins                 (ex_ins_out),
  .t_mem_ins                (mem_ins_in),
  .f_ex_cp0_we              (ex_cp0_we_out),
  .f_ex_cp0_waddr           (ex_cp0_waddr_out),
  .f_ex_cp0_wdata           (ex_cp0_w_data_out),
  .t_mem_cp0_we             (mem_cp0_we_in),
  .t_mem_cp0_waddr          (mem_cp0_waddr_in),
  .t_mem_cp0_wdata          (mem_cp0_wdata_in),
  .flush                    (flush),
  .f_ex_pc_addr_in          (ex_current_pc_addr_out),
  .f_ex_abnormal_type       (ex_abnormal_type_out),
  .t_mem_pc_addr_out        (mem_current_pc_addr_in),
  .t_mem_abnormal_type      (mem_abnormal_type_in)
  );

  // MEM
  mem  u_mem (
  .rst                    (rst),
  .wreg_e_in              (mem_wreg_e_in),
  .wreg_data_in           (mem_wreg_data_in),
  .wreg_addr_in           (mem_wreg_addr_in),
  .wreg_e_out             (mem_wreg_e_out),
  .wreg_data_out          (mem_wreg_data_out),
  .wreg_addr_out          (mem_wreg_addr_out),
  .hilo_we_in             (mem_hilo_we_in),
  .hi_data_in             (mem_hi_data_in),
  .lo_data_in             (mem_lo_data_in),
  .hilo_we_out            (mem_hilo_we_out),
  .hi_data_out            (mem_hi_data_out),
  .lo_data_out            (mem_lo_data_out),
  .mem_addr_in            (mem_addr_in),
  .aluop_in               (mem_aluop_in),
  .mem_store_data_in      (mem_store_data_in),
  .mem_read_data_in       (bus_read_in),
  .mem_addr_out           (bus_addr_out),
  .mem_store_data_out     (bus_write_data_out),
  .mem_we_out             (bus_we_out),
  .mem_e_out              (bus_eable_out),
  .mem_byte_sel_out       (bus_byte_sel_out),
  .cp0_we_in              (mem_cp0_we_in),
  .cp0_waddr_in           (mem_cp0_waddr_in),
  .cp0_wdata_in           (mem_cp0_wdata_in),
  .cp0_we_out             (mem_cp0_we_out),
  .cp0_waddr_out          (mem_cp0_waddr_out),
  .cp0_wdata_out          (mem_cp0_wdata_out),
  .current_mem_pc_addr_in (mem_current_pc_addr_in),
  .abnormal_type_in       (mem_abnormal_type_in),
  .cp0_status_in          (mem_cp0_status_in),
  .cp0_cause_in           (mem_cp0_cause_in),
  .cp0_epc_in             (mem_cp0_epc_in),
  .abnormal_type_out      (mem_abnormal_type_out),
  .current_mem_pc_addr_out(mem_current_pc_addr_out)
  );


  // MEM-WB
  mem_wb  u_mem_wb (
  .rst                      (rst),
  .clk                      (clk),
  .mem_wreg_e               (mem_wreg_e_out),
  .mem_wreg_addr            (mem_wreg_addr_out),
  .mem_wreg_data            (mem_wreg_data_out),
  .wb_wreg_e                (wb_wreg_e_in),
  .wb_wreg_addr             (wb_wreg_addr_in),
  .wb_wreg_data             (wb_wreg_data_in),
  .mem_hilo_we              (mem_hilo_we_out),
  .mem_hi_data              (mem_hi_data_out),
  .mem_lo_data              (mem_lo_data_out),
  .wb_hilo_we               (wb_hilo_we_in),
  .wb_hi_data               (wb_hi_data_in),
  .wb_lo_data               (wb_lo_data_in),
  .pause                    (pause_res_wb),
  .f_mem_cp0_we             (mem_cp0_we_out),
  .f_mem_cp0_waddr          (mem_cp0_waddr_out),
  .f_mem_cp0_wdata          (mem_cp0_wdata_out),
  .t_wb_cp0_we              (wb_cp0_we_in),
  .t_wb_cp0_waddr           (wb_cp0_waddr_in),
  .t_wb_cp0_wdata           (wb_cp0_wdata_in),
  .flush                    (flush)
  );



  ppl_scheduler u_ppl_sch(
  .rst                      (rst),
  .pause_req_id             (pause_req_id),
  .pause_req_ex             (pause_req_ex),
  .pause_res_pc             (pause_res_pc),
  .pause_res_if             (pause_res_if),
  .pause_res_id             (pause_res_id),
  .pause_res_ex             (pause_res_ex),
  .pause_res_mem            (pause_res_mem),
  .pause_res_wb             (pause_res_wb),
  .abnormal_type            (mem_abnormal_type_out),
  .cp0_epc_in               (mem_cp0_epc_in),
  .interrupt_pc_out         (interrupt_pc_out),
  .flush                    (flush)
  );

  cp0 u_cp0(
    .clk                    (clk),
    .rst                    (rst),
    .we_in                  (wb_cp0_we_in),
    .waddr_in               (wb_cp0_waddr_in),
    .data_in                (wb_cp0_wdata_in),
    .raddr_in               (ex_cp0_raddr_out),
    .int_in                 (interrupt_in),
    .data_out               (ex_cp0_data_in),
    .count_out              (),
    .compare_out            (),
    .status_out             (mem_cp0_status_in),
    .cause_out              (mem_cp0_cause_in),
    .epc_out                (mem_cp0_epc_in),
    .config_out             (),
    .timer_int_o            (),
    .abnormal_type          (mem_abnormal_type_out),
    .current_pc_addr_in     (mem_current_pc_addr_out)
  );

endmodule