`include "public.v"

module id (

  input rst,
  input wire[`WordRange] pc_in,
  input wire[`WordRange] ins_in,

  input wire[`WordRange] reg1_data_in,
  input wire[`WordRange] reg2_data_in,

  output reg reg1_re_out,
  output reg reg2_re_out,
  output reg[`RegRangeLog2] reg1_addr_out,
  output reg[`RegRangeLog2] reg2_addr_out,

  output reg[`ALUOpRange] aluop_out,
  output reg[`ALUSelRange] alusel_out,

  output reg[`WordRange] reg1_data_out,
  output reg[`WordRange] reg2_data_out,
  
  output reg wreg_e_out, // 写寄存器组使能输出
  output reg[`RegRangeLog2] wreg_addr_out // 写寄存器组地址输出

);

  wire[5:0] op = ins_in[31:26];

  reg[`WordRange] immed;

  // 指令译码
  always @(*) begin
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      alusel_out <= 3'b000;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
    end else begin
      
      wreg_e_out <= `Disable;
      
      case (op)
        `OP_ORI: begin
          wreg_e_out <= `Enable;
          aluop_out <= `ALUOP_OR;
          reg1_re_out <= `Enable;
          reg1_addr_out <= ins_in[25:21];
          reg2_re_out <= `Disable;
          immed <= {16'h0, ins_in[15:0]};
          wreg_e_out <= `Enable;
          wreg_addr_out <= ins_in[20:16];
        end
        default: begin 
        end
      endcase
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      reg1_data_out <= `ZeroWord;
    end else if (reg1_re_out == `Enable) begin
      reg1_data_out <= reg1_data_in;
    end else if (reg1_re_out == `Disable) begin
      reg1_data_out <= immed;
    end else begin
      reg1_data_out <= `ZeroWord;
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      reg2_data_out <= `ZeroWord;
    end else if (reg2_re_out == `Enable) begin
      reg2_data_out <= reg1_data_in;
    end else if (reg2_re_out == `Disable) begin
      reg2_data_out <= immed;
    end else begin
      reg2_data_out <= `ZeroWord;
    end
  end

endmodule