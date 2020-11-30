// cpu.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// CPU
module cpu (

  input rst, // 重置
  input clk, // 时钟

  input [`WordRange] imem_data_in,
  output wire[`WordRange] imem_addr_out,
  output wire imem_e_out

);

  // ID输入
  wire[`WordRange] pc;
  assign imem_addr_out = pc;
  wire[`WordRange] id_pc_in;
  wire[`WordRange] id_ins_in;

  // ID输出
  wire[`ALUOpRange] id_aluop_out;
  wire[`WordRange] id_data1_out;
  wire[`WordRange] id_data2_out;
  wire id_wreg_e_out;
  wire[`RegRangeLog2] id_wreg_addr_out;

  // EX输入
  wire[`ALUOpRange] ex_aluop_in;
  wire[`WordRange] ex_data1_in;
  wire[`WordRange] ex_data2_in;
  wire ex_wreg_e_in;
  wire[`RegRangeLog2] ex_wreg_addr_in;
  wire ex_hilo_we_in;
  wire[`WordRange] ex_hi_data_in;
  wire[`WordRange] ex_lo_data_in;

  // EX输出
  wire ex_wreg_e_out;
  wire[`RegRangeLog2] ex_wreg_addr_out;
  wire[`WordRange] ex_wreg_data_out;
  wire ex_hilo_we_out;
  wire[`WordRange] ex_hi_data_out;
  wire[`WordRange] ex_lo_data_out;

  // MEM输入
  wire mem_wreg_e_in;
  wire[`RegRangeLog2] mem_wreg_addr_in;
  wire[`WordRange] mem_wreg_data_in;
  wire mem_hilo_we_in;
  wire[`WordRange] mem_hi_data_in;
  wire[`WordRange] mem_lo_data_in;

  // MEM输出
  wire mem_wreg_e_out;
  wire[`RegRangeLog2] mem_wreg_addr_out;
  wire[`WordRange] mem_wreg_data_out;
  wire mem_hilo_we_out;
  wire[`WordRange] mem_hi_data_out;
  wire[`WordRange] mem_lo_data_out;

  // WB输入
  wire wb_wreg_e_in;
  wire[`RegRangeLog2] wb_wreg_addr_in;
  wire[`WordRange] wb_wreg_data_in;
  // 下面三根线直接送到HILO
  wire wb_hilo_we_in;
  wire[`WordRange] wb_hi_data_in;
  wire[`WordRange] wb_lo_data_in;

  // 寄存器组相关
  wire reg1_re;
  wire reg2_re;
  wire[`WordRange] reg1_data;
  wire[`WordRange] reg2_data;
  wire[`RegRangeLog2] reg1_addr;
  wire[`RegRangeLog2] reg2_addr;

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

  // reg_group
  reg_group  u_reg_group (
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
  .rdata2                   (reg2_addr)
  );

  // IF
  program_counter  u_program_counter (
  .clk                      (clk),
  .rst                      (rst),
  .pc                       (pc),
  .imem_e_out               (imem_e_out)
  );

  // IF-ID
  if_id  u_if_id (
  .clk                      (clk),
  .rst                      (rst),
  .if_pc                    (pc),
  .if_ins                   (imem_data_in),
  .id_pc                    (id_pc_in),
  .id_ins                   (id_ins_in)
  );

  // ID
  id  u_id (
  .rst                  		(rst),
  .pc_in                		(id_pc_in),
  .ins_in               		(id_ins_in),
  .reg1_data_in         		(reg1_data),
  .reg2_data_in         		(reg2_data),
  .reg1_re_out          		(reg1_re),
  .reg2_re_out          		(reg2_re),
  .reg1_addr_out        		(reg1_addr),
  .reg2_addr_out        		(reg2_addr),
  .aluop_out            		(id_aluop_out),
  .data1_out            		(id_data1_out),
  .data2_out            		(id_data2_out),
  .wreg_e_out           		(id_wreg_e_out),
  .wreg_addr_out        		(id_wreg_addr_out),
  .ex_wreg_e_in             (ex_wreg_e_out),
  .ex_wreg_data_in          (ex_wreg_data_out),
  .ex_wreg_addr_in          (ex_wreg_addr_out),
  .mem_wreg_e_in            (mem_wreg_e_out),
  .mem_wreg_data_in         (mem_wreg_data_out),
  .mem_wreg_addr_in         (mem_wreg_addr_out)
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
  .ex_aluop                 (ex_aluop_in),
  .ex_data1                 (ex_data1_in),
  .ex_data2                 (ex_data2_in),
  .ex_wreg_addr             (ex_wreg_addr_in),
  .ex_wreg_e                (ex_wreg_e_in)
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
  .lo_data_out              (ex_lo_data_out)
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
  .mem_lo_data              (mem_lo_data_in)
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
  .lo_data_out            (mem_lo_data_out)
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
  .wb_lo_data               (wb_lo_data_in)
  );

endmodule