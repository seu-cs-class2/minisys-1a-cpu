// if_id.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令译码模块
// 对指令进行译码，输出包括：
// 源操作数1、源操作数2、写入的目的寄存器、运算类型（逻辑、移位、算术）
module id (

  input rst, // 复位
  input wire[`WordRange] pc_in, // 输入的PC值
  input wire[`WordRange] ins_in, // 输入的指令

  // 先这样写，不直通，这为后面流水暂存提供条件
  input wire[`WordRange] reg1_data_in, // 输入的寄存器数据1
  input wire[`WordRange] reg2_data_in, // 输入的寄存器数据2

  output reg reg1_re_out, // 寄存器读使能1
  output reg reg2_re_out, // 寄存器读使能2
  output reg[`RegRangeLog2] reg1_addr_out, // 寄存器读地址1
  output reg[`RegRangeLog2] reg2_addr_out, // 寄存器读地址2

  output reg[`ALUOpRange] aluop_out, // 输出的ALUOp
  output reg[`ALUSelRange] alusel_out, // 输出的ALUSel

  output reg[`WordRange] data1_out, // 输出的数据1
  output reg[`WordRange] data2_out, // 输出的数据2
  
  output reg wreg_e_out, // 写寄存器使能输出
  output reg[`RegRangeLog2] wreg_addr_out // 写寄存器地址输出

);

  wire[5:0] op = ins_in[`OpRange]; // op组分在指令的31:26
  reg[`WordRange] immed; // 指令中的立即数

  // 指令译码
  always @(*) begin
    // rst时关掉所有使能，清空立即数暂存
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      alusel_out <= 3'b000;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
    // 具体译码逻辑
    end else begin
      // 先赋默认值，以免有些指令不需要修改其中一些值时出现错误
      aluop_out <= `ALUOP_NOP;
      alusel_out <= 3'b000;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
      // 根据op翻译
      case (op)
        `OP_ORI: begin
          // 需要写回寄存器
          wreg_e_out <= `Enable;
          // 写回的寄存器是rt
          wreg_addr_out <= ins_in[`RtRange];
          // 只要读一个寄存器rs
          reg1_re_out <= `Enable;
          reg1_addr_out <= ins_in[`RsRange];
          reg2_re_out <= `Disable;
          reg2_addr_out <= `RegCountLog2'h0;
          // ALU需要进行逻辑或运算
          aluop_out <= `ALUOP_OR;
          // 立即数需要做零扩展
          immed <= {16'h0, ins_in[`ImmedRange]};
        end
        // TODO: 添加更多的指令
        default: begin 
        end
      endcase
    end
  end

  // 下面开始确定送到ALU的数据具体是什么
  // 这取决于来源：是寄存器，还是立即数
  always @(*) begin
    // rst时固定出0x0
    if (rst == `Enable) begin
      data1_out <= `ZeroWord;
    // 如果指令译码的结果需要读reg1，就说明操作数1来自寄存器
    end else if (reg1_re_out == `Enable) begin
      data1_out <= reg1_data_in;
    // 如果指令译码的结果不需要读reg1，就说明操作数1来自立即数
    end else if (reg1_re_out == `Disable) begin
      data1_out <= immed;
    // 兜底
    end else begin
      data1_out <= `ZeroWord;
    end
  end

  // 逻辑同上
  always @(*) begin
    if (rst == `Enable) begin
      data2_out <= `ZeroWord;
    end else if (reg2_re_out == `Enable) begin
      data2_out <= reg1_data_in;
    end else if (reg2_re_out == `Disable) begin
      data2_out <= immed;
    end else begin
      data2_out <= `ZeroWord;
    end
  end

endmodule