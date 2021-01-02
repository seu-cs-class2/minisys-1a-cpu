`include "../../../sources_1/cpu/public.v"

// ID测试
module id_tb();
  // 产生时钟
  reg CLOCK_50MHZ; // T = 20ns
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end
  
  // 被测信号
  reg rst; // 复位
  reg [`WordRange] pc_in; // 输入的PC值，译码阶段指令地址
  reg [`WordRange] ins_in; // 输入的指令，即取出的指令
  reg [`WordRange] reg1_data_in; // 输入的寄存器数据1
  reg [`WordRange] reg2_data_in; // 输入的寄存器数据2
  wire reg1_ren_out; // 寄存器读使能1
  wire reg2_ren_out; // 寄存器读使能2
  wire [`RegRangeLog2] reg1_addr_out; // 寄存器读地址1
  wire [`RegRangeLog2] reg2_addr_out; // 寄存器读地址2
  wire [`ALUOpRange] exop_out; // 输出的ALUOp
  wire [`WordRange] data1_out; // 输出的数据1
  wire [`WordRange] data2_out; // 输出的数据2
  wire wreg_wen_out; // 写寄存器使能输出
  wire [`RegRangeLog2] wreg_addr_out; // 写寄存器地址输出
  reg ex_wreg_en_in;
  reg [`WordRange] ex_wreg_data_in;
  reg [`RegRangeLog2] ex_wreg_addr_in;
  reg mem_wreg_en_in;
  reg [`WordRange] mem_wreg_data_in;
  reg [`RegRangeLog2] mem_wreg_addr_in;
  wire pause_req; // 要求进行流水暂停信号
  reg in_delayslot_in; // 当前要进入（译码阶段）指令是否是延迟槽内指令（必须执行）
  wire in_delayslot_out; // 当前要出（译码阶段）指令是否是延迟槽内指令（必须执行）
  wire next_in_delayslot_out; // 下条指令是否处是延迟槽内指令（即当前指令是否要跳转）
  wire branch_en_out; // 分支生效信号
  wire [`WordRange] branch_addr_out; // 分支跳转地址
  wire [`WordRange] link_addr_out; // 转移指令需要保存的地址
  wire [`WordRange] ins_out; // 向流水线后续传递的指令 在添加存储指令时需要用到

  // 例化被测模块
  id u_id(
    .rst(rst),
    .pc_in(pc_in),
    .ins_in(ins_in),
    .reg1_data_in(reg1_data_in),
    .reg2_data_in(reg2_data_in),
    .reg1_ren_out(reg1_ren_out),
    .reg2_ren_out(reg2_ren_out),
    .reg1_addr_out(reg1_addr_out),
    .reg2_addr_out(reg2_addr_out),
    .exop_out(exop_out),
    .data1_out(data1_out),
    .data2_out(data2_out),
    .wreg_wen_out(wreg_wen_out),
    .wreg_addr_out(wreg_addr_out),
    .ex_wreg_en_in(ex_wreg_en_in),
    .ex_wreg_data_in(ex_wreg_data_in),
    .ex_wreg_addr_in(ex_wreg_addr_in),
    .mem_wreg_en_in(mem_wreg_en_in),
    .mem_wreg_data_in(mem_wreg_data_in),
    .mem_wreg_addr_in(mem_wreg_addr_in),
    .pause_req(pause_req),
    .in_delayslot_in(in_delayslot_in),
    .in_delayslot_out(in_delayslot_out),
    .next_in_delayslot_out(next_in_delayslot_out),
    .branch_en_out(branch_en_out),
    .branch_addr_out(branch_addr_out),
    .link_addr_out(link_addr_out),
    .ins_out(ins_out)
  );

  initial begin
    
  end

endmodule