// alu.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// ALU
module alu (

  input [`WordRange] data1,
  input [`WordRange] data2,
  input [`ALUOpRange] op,
  
  output [`WordRange] res,
  output wire zf, // zero-flag
  output wire cf, // carry-flag
  output wire sf, // sign-flag
  output wire of // overflow-flag

);

  reg [32:0] result;
  wire signed [31:0] s_data1;
  wire signed [31:0] s_data2;

  assign res = result[`WordRange];

  always @(*) begin
    case (op)
      `ALUOP_NOP: begin
        result <= `ZeroWord;
      end
      `ALUOP_ADDU: begin
        result <= data1 + data2;
      end
      `ALUOP_ADD: begin
        result <= s_data1 + s_data2;
      end
      `ALUOP_SUBU: begin
        result <= data1 - data2;
      end
      `ALUOP_SUB: begin
        result <= s_data1 - s_data2;
      end
      // TODO: 下面四条运算要多周期执行，需要阻塞流水、访问HILO
      `ALUOP_MULTU: begin
        
      end
      `ALUOP_MULT: begin
        
      end
      `ALUOP_DIVU: begin
        
      end
      `ALUOP_DIV: begin
        
      end
      `ALUOP_AND: begin
        result = data1 & data2;
      end
      `ALUOP_OR: begin
        result = data1 | data2;
      end
      `ALUOP_XOR: begin
        result = data1 ^ data2;
      end
      `ALUOP_NOR: begin
        result = ~(data1 | data2);
      end
      `ALUOP_SLL: begin
        result = data2 << data1[4:0]; // 注意data1才是移动的位数
      end
      `ALUOP_SRL: begin
        result = data2 >> data1[4:0];
      end
      `ALUOP_SRA: begin
        result = data2 >>> data1[4:0];
      end
      `ALUOP_SLT: begin
        result = s_data1 < s_data2 ? 33'd1 : 33'd0;
      end
      `ALUOP_SLTU: begin
        result = data1 < data2 ? 33'd1 : 33'd0;  
      end
    endcase
  end

  assign cf = result[32];
  assign zf = result[31:0] == 32'd0 ? 1'b1 : 1'b0;
  assign sf = result[31];
  assign of = result[32];

endmodule
