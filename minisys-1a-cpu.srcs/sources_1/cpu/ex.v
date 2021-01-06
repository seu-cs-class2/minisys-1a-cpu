// ex.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令执行模块
module ex (

  input rst,
  input wire[`ALUOpRange] aluop_in,
  input wire[`WordRange] data1_in,  // 一般是rs
  input wire[`WordRange] data2_in,  // 一般是rt
  input wire[`RegRangeLog2] wreg_addr_in,
  input wire wreg_e_in,

  output reg[`RegRangeLog2] wreg_addr_out,
  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out,

  input wire[`WordRange] hi_data_in,  // 此条指令（译码阶段）hi给出的结果
  input wire[`WordRange] lo_data_in,  // lo给出的结果
  input wire mem_hilo_we_in, // 目前处于访存阶段的hi,lo的写使能（即此条指令的上一条指令）
  input wire[`WordRange] mem_hi_data_in,  // 访存阶段写入hi的值
  input wire[`WordRange] mem_lo_data_in,  // 访存阶段写入lo的值
  input wire wb_hilo_we_in,  // 目前处于写回阶段的hilo写使能（即词条指令的上两条指令）
  input wire[`WordRange] wb_hi_data_in,  // 写回阶段写入hi的值
  input wire[`WordRange] wb_lo_data_in,  // 写回阶段写入lo的值
  
  output reg hilo_we_out,  // 此条指令是否要写hilo
  output reg[`WordRange] hi_data_out,  // 写入的hi数据
  output reg[`WordRange] lo_data_out,  // 写入的lo数据

  output reg pause_req,

  input wire[`WordRange] link_addr_in, // 保存的返回地址

  output reg[`WordRange] div_data1_signed,  // 有符号除法的被除数
  output reg[`WordRange] div_data2_signed, // 有符号除法的除数
  output reg[`WordRange] div_data1_unsigned, // 无符号除法的被除数
  output reg[`WordRange] div_data2_unsigned, // 无符号除法的除数
  output reg div_data_valid_signed, // 有符号除法数据是否有效（是否开始除法）
  output reg div_data_valid_unsigned, // 无符号除法数据是否有效
  input wire[`DivMulResultRange] div_result_signed,  // 结果64位
  input wire div_result_valid_signed,  // 有符号除法结果是否有效（有效说明除法结束，应该获取结果）
  input wire[`DivMulResultRange] div_result_unsigned, // 结果64位
  input wire div_result_valid_unsigned, // 无符号除法结果是否有效（有效说明除法结束，应该获取结果）

  input is_in_delayslot, // 新增的延迟槽信号，代表处于执行阶段的指令是否是延迟槽指令

  input wire[`WordRange] ins_in, // 新增的指令信号，从id阶段一直传递过来
  output wire[`ALUOpRange] aluop_out, // 要向访存部分传递aluop
  output wire[`WordRange] mem_addr_out, // 要向访存部分传递计算出的内存地址（所有存储相关指令均会用到）
  output wire[`WordRange] mem_data_out, // 要向访存部分传递写入内存的数据（store指令才会用到）


  input wire[`WordRange] cp0_data_in,//从cp0读取的数据

  input wire f_mem_cp0_we_in, //当前处在访存阶段的指令是否要写cp0
  input wire[4:0] f_mem_cp0_w_addr, //要写的地址
  //*******   fix me:为什么地址是五位
  input wire[`WordRange] f_mem_cp0_w_data, //要写入的数据
  input wire f_wb_cp0_we_in,   //同理  当前处在写回阶段的指令是否要写cp0
  input wire[4:0] f_wb_cp0_w_addr, //写入的地址
  input wire[`WordRange] f_wb_cp0_w_data,  //写入的数据

  output reg cp0_we_out,    //cp0是否要被写（当前指令 向下传入流水
  output reg[4:0] cp0_addr,  //cp0读写地址  
  output reg cp0_re_out,    //是否要读cp0（当前指令 不需要传入流水 即刻从cp0处读出
  output reg[`WordRange] cp0_w_data   //要写入cp0的数据
);

  wire[`WordRange] alu_res;  // alu的结果
  reg[`WordRange] mov_res;  // 转移指令（如读hi和lo）的结果
  
  reg[`WordRange] hi_temp;  // 暂存hi
  reg[`WordRange] lo_temp;  // 暂存lo

  reg pause_for_div;

  wire signed [`WordRange] mul_signed_data1;
  wire signed [`WordRange] mul_signed_data2;
  assign mul_signed_data1 = data1_in;
  assign mul_signed_data2 = data2_in;
  reg[`DivMulResultRange] mul_result;

  alu u_alu (
  .data1      (data1_in),
  .data2      (data2_in),
  .op         (aluop_in),
  .res        (alu_res)
  );

  assign aluop_out = aluop_in;
  assign mem_addr_out = data1_in + {{16{ins_in[15]}}, ins_in[15:0]}; // 在这里计算是为了让传递的信号少，并且时序逻辑清晰，增加在ex部分的工作
  assign mem_data_out = data2_in; // 无论是什么存储操作，都会去使用rt的数据

  always @(*) begin
    if (rst == `Enable) begin
      wreg_e_out <= `Disable;
      pause_for_div <= `Disable;
      div_data_valid_signed <= `Disable;
      div_data_valid_unsigned <= `Disable;
      div_data1_signed <= `ZeroWord;
      div_data2_signed <= `ZeroWord;
      div_data1_unsigned <= `ZeroWord;
      div_data2_unsigned <= `ZeroWord;
    end else begin
      wreg_e_out <= wreg_e_in;
      wreg_addr_out <= wreg_addr_in;
      pause_for_div <= `Disable;
      div_data_valid_signed <= `Disable;
      div_data_valid_unsigned <= `Disable;
      div_data1_signed <= `ZeroWord;
      div_data2_signed <= `ZeroWord;
      div_data1_unsigned <= `ZeroWord;
      div_data2_unsigned <= `ZeroWord;
      case (aluop_in)
        `ALUOP_DIV: begin
          if (div_result_valid_signed == `Disable) begin  // 除法尚未结束
            div_data1_signed <= data1_in;
            div_data2_signed <= data2_in;
            div_data_valid_signed <= `Enable;  // 数据有效
            pause_for_div <= `Enable;  // 暂停流水
          end else if (div_result_valid_signed == `Enable) begin  // 除法结束
            div_data1_signed <= data1_in;
            div_data2_signed <= data2_in;
            div_data_valid_signed <= `Disable;  // 数据无效
            pause_for_div <= `Disable;  // 启动流水
          end
        end
        `ALUOP_DIVU: begin
          if (div_result_valid_unsigned == `Disable) begin
            div_data1_unsigned <= data1_in;
            div_data2_unsigned <= data2_in;
            div_data_valid_unsigned <= `Enable;
            pause_for_div <= `Enable;
          end else if (div_result_valid_unsigned == `Enable) begin
            div_data1_unsigned <= data1_in;
            div_data2_unsigned <= data2_in;
            div_data_valid_unsigned <= `Disable;
            pause_for_div <= `Disable;
          end
        end
        `ALUOP_MULT:begin
          mul_result = mul_signed_data1 * mul_signed_data2;
        end
        `ALUOP_MULTU:begin
          mul_result = data1_in * data2_in;
        end
        `EXOP_JR,
        `EXOP_JALR,
        `EXOP_J,
        `EXOP_JAL,
        `EXOP_BEQ,
        `EXOP_BGTZ,
        `EXOP_BLEZ,
        `EXOP_BNE,
        `EXOP_BGEZ,
        `EXOP_BGEZAL,
        `EXOP_BLTZ,
        `EXOP_BLTZAL: begin
          wreg_data_out <= link_addr_in;
        end
        default: begin
          // 不是上述情况，那么结果就是ALU算出来的
          wreg_data_out <= alu_res;  // 这里不需要管存储指令的wreg输出，反正在mem阶段还会再修改
        end
      endcase
    end
  end

  always @(*) begin
    pause_req = pause_for_div; // 如果后续乘法也需要暂停流水线就在此处修改
  end

  always @(*) begin
    if (rst == `Enable) begin
      hi_temp <= `ZeroWord;
      lo_temp <= `ZeroWord;
    // 解决MEM-EX流水冲突
    end else if (mem_hilo_we_in == `Enable) begin  // 如果上一条指令也在写hilo
      hi_temp <= mem_hi_data_in;
      lo_temp <= mem_lo_data_in;
    // 解决WB-EX流水冲突
    end else if (wb_hilo_we_in == `Enable) begin  // 如果上两条指令也在写hilo
      hi_temp <= wb_hi_data_in;
      lo_temp <= wb_lo_data_in;  
    end else begin
      hi_temp <= hi_data_in;
      lo_temp <= lo_data_in;
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      mov_res <= `ZeroWord;
    end else begin
      case (aluop_in)
        `EXOP_MFHI: begin
          mov_res <= hi_temp;
        end
        `EXOP_MFLO: begin
          mov_res <= lo_temp;
        end
      endcase
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      hilo_we_out <= `Disable;
      hi_data_out <= `ZeroWord;
      lo_data_out <= `ZeroWord;
    end else begin
      case (aluop_in)
       `ALUOP_DIV: begin
         hilo_we_out <= `Enable;
         hi_data_out <= div_result_signed[31:0];  // HI存余数，LO存商
         lo_data_out <= div_result_signed[63:32];
       end
       `ALUOP_DIVU: begin
         hilo_we_out <= `Enable;
         hi_data_out <= div_result_unsigned[31:0];
         lo_data_out <= div_result_unsigned[63:32];
       end
       `ALUOP_MULT:begin
         hilo_we_out <= `Enable;
         hi_data_out <= mul_result[63:32];
         lo_data_out <= mul_result[31:0];
       end
       `ALUOP_MULTU:begin
         hilo_we_out <= `Enable;
         hi_data_out <= mul_result[63:32];
         lo_data_out <= mul_result[31:0];
       end
       `EXOP_MTHI: begin
          hilo_we_out <= `Enable;
          hi_data_out <= data1_in;
          lo_data_out <= lo_data_in;
       end
       `EXOP_MTLO: begin
          hilo_we_out <= `Enable;
          hi_data_out <= hi_data_in;
          lo_data_out <= data1_in;
       end
      endcase
    end
  end

endmodule