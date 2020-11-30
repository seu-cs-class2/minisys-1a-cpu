// ex.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令执行模块
module ex (

  input rst,
  input wire[`ALUOpRange] aluop_in,
  input wire[`WordRange] data1_in,
  input wire[`WordRange] data2_in,
  input wire[`RegRangeLog2] wreg_addr_in,
  input wire wreg_e_in,

  output reg[`RegRangeLog2] wreg_addr_out,
  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out,

  input wire[`WordRange] hi_data_in,
  input wire[`WordRange] lo_data_in,
  input wire mem_hilo_we_in,
  input wire[`WordRange] mem_hi_data_in,
  input wire[`WordRange] mem_lo_data_in,
  input wire wb_hilo_we_in,
  input wire[`WordRange] wb_hi_data_in,
  input wire[`WordRange] wb_lo_data_in,
  
  output reg hilo_we_out,
  output reg[`WordRange] hi_data_out,
  output reg[`WordRange] lo_data_out

);

  reg[`WordRange] alu_res;
  reg[`WordRange] mov_res;
  
  reg[`WordRange] hi_temp;
  reg[`WordRange] lo_temp;

  alu u_alu (
  .data1      (data1_in),
  .data2      (data2_in),
  .op         (aluop_in),
  .res        (alu_res)
  );

  always @(*) begin
    if (rst == `Enable) begin
      alu_res <= `ZeroWord;
      wreg_e_out <= `Disable;
    end else begin
      wreg_e_out <= wreg_e_in;
      wreg_addr_out <= wreg_addr_in;
      // TODO: is it right?
      wreg_data_out <= alu_res;
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      hi_temp <= `ZeroWord;
      lo_temp <= `ZeroWord;
    // 解决MEM-EX流水冲突
    end else if (mem_hilo_we_in == `Enable) begin
      hi_temp <= mem_hi_data_in;
      lo_temp <= mem_lo_data_in;
    // 解决WB-EX流水冲突
    end else if (wb_hilo_we_in == `Enable) begin
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