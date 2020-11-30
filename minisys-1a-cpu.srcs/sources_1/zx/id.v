// id.v
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

  output reg[`WordRange] data1_out, // 输出的数据1
  output reg[`WordRange] data2_out, // 输出的数据2
  
  output reg wreg_e_out, // 写寄存器使能输出
  output reg[`RegRangeLog2] wreg_addr_out, // 写寄存器地址输出

  // 下面部分用于采用数据前送法解决相隔0条（ID-EX）和相隔1条（ID-MEM）阶段的RAW数据相关
  // EX阶段运算结果
  input wire ex_wreg_e_in,
  input wire[`WordRange] ex_wreg_data_in,
  input wire[`RegRangeLog2] ex_wreg_addr_in,
  // MEM阶段运算结果
  input wire mem_wreg_e_in,
  input wire[`WordRange] mem_wreg_data_in,
  input wire[`RegRangeLog2] mem_wreg_addr_in

);

  // 指令的各个可能组分
  wire[5:0] op = ins_in[`OpRange];
  wire[4:0] rs = ins_in[`RsRange];
  wire[4:0] rt = ins_in[`RtRange];
  wire[4:0] rd = ins_in[`RdRange];
  wire[4:0] shamt = shamt;
  wire[5:0] func = ins_in[`FuncRange];
  wire[15:0] immediate = ins_in[`ImmedRange];
  wire[15:0] offset = ins_in[`OffsetRange];
  wire[25:0] address = ins_in[`AddressRange];

  reg[`WordRange] immed; // 指令中的立即数的扩展结果

  // 指令译码
  always @(*) begin
    // rst时关掉所有使能，清空立即数暂存
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
    // 具体译码逻辑
    end else begin
      // 先赋默认值，以免有些指令不需要修改其中一些值时出现错误
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
      // 根据op翻译
      // R类指令
      if (op == `OP_RTYPE) begin
        case (func)
          `FUNC_OR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_AND: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;  
          end
          `FUNC_XOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_NOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_NOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRAV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRA;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          `FUNC_SRL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          `FUNC_SRA: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          // 注意HI/LO不在32个寄存器组中，使能不要给错
          `FUNC_MFHI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFHI;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MFLO: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFLO;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTHI: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_MTHI;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTLO: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_MTLO;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
        endcase
      end else begin
        // I类或J类
        case (op)
          `OP_ORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_ANDI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_XORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_LUI: begin
            // 借助rs为$0的特性，可等价如下实现
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {ins_in[`ImmedRange], 16'h0};
          end
          default: begin 
          end
        endcase
      end
    end
  end

  // 下面开始确定送到ALU的数据具体是什么
  // 这取决于来源：是寄存器，还是立即数
  always @(*) begin
    // rst时固定出0x0
    if (rst == `Enable) begin
      data1_out <= `ZeroWord;
    // 解决相隔0条（ID-EX）的流水数据相关
    // 如果前面的EX要写的就是后面的ID要读的，则穿透
    end else if (ex_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == ex_wreg_addr_in) begin
      data1_out <= ex_wreg_data_in;
    // 解决相隔1条（ID-MEM）的流水数据相关
    // 如果前面的MEM要写的就是后面的ID要读的，则穿透
    end else if (mem_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == mem_wreg_addr_in) begin
      data1_out <= mem_wreg_data_in;  
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
    end else if (ex_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == ex_wreg_addr_in) begin
      data2_out <= ex_wreg_data_in;
    end else if (mem_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == mem_wreg_addr_in) begin
      data2_out <= mem_wreg_data_in;  
    end else if (reg2_re_out == `Enable) begin
      data2_out <= reg2_data_in;
    end else if (reg2_re_out == `Disable) begin
      data2_out <= immed;
    end else begin
      data2_out <= `ZeroWord;
    end
  end

endmodule