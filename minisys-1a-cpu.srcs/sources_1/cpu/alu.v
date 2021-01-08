// alu.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ALU，处理除了乘除法以外的所有算术-逻辑运算
module alu (

  input[`WordRange] data1,
  input[`WordRange] data2,
  input[`ALUOpRange] op,
  
  output[`WordRange] res,
  output wire zf, // zero-flag，结果为0时为1
  output wire cf, // carry-flag，无符号进位时为1
  output wire sf, // sign-flag，为负数时为1
  output wire of // overflow-flag，有符号溢出时为1

);

  // 结果暂存，最高位放溢出结果
  reg [32:0] result;

  // data的有符号版本
  wire signed [31:0] s_data1;
  wire signed [31:0] s_data2;
  assign s_data1 = data1;
  assign s_data2 = data2;

  // 输出32位结果
  assign res = result[`WordRange];

  always @(*) begin
    case (op)
      `ALUOP_NOP: begin // 无操作
        result = `ZeroWord;
      end
      `ALUOP_ADDU: begin // 无符号加
        result = data1 + data2;
      end
      `ALUOP_ADD: begin // 有符号加
        result = s_data1 + s_data2;
      end
      `ALUOP_SUBU: begin // 无符号减
        result = data1 - data2;
      end
      `ALUOP_SUB: begin // 有符号减
        result = s_data1 - s_data2;
      end
      `ALUOP_AND: begin // 按位与
        result = data1 & data2;
      end
      `ALUOP_OR: begin // 按位或
        result = data1 | data2;
      end
      `ALUOP_XOR: begin // 按位异或
        result = data1 ^ data2;
      end
      `ALUOP_NOR: begin // 按位或非
        result = ~(data1 | data2);
      end
      `ALUOP_SLL: begin // 逻辑左移
        result = data2 << data1[4:0]; // 注意data1才是移动的位数
      end
      `ALUOP_SRL: begin // 逻辑右移
        result = data2 >> data1[4:0];
      end
      `ALUOP_SRA: begin // 算术右移
        // https://blog.csdn.net/qq_41634276/article/details/80414488
        result = s_data2 >>> s_data1[4:0];
      end
      `ALUOP_SLT: begin // less-than（有符号）
        result = s_data1 < s_data2 ? 33'd1 : 33'd0;
      end
      `ALUOP_SLTU: begin // less-than（无符号）
        result = data1 < data2 ? 33'd1 : 33'd0;  
      end
    endcase
  end

  // 输出各flag
  assign cf = result[32];
  assign zf = result[31:0] == 32'd0 ? 1'b1 : 1'b0;
  assign sf = result[31];
  assign of = result[32];

endmodule
