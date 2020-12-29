// mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 访存控制模块
// TODO: 统一编址访接口怎么控制？
module mem (

  input rst,
  input wire wreg_e_in,
  input wire[`WordRange] wreg_data_in,
  input wire[`RegRangeLog2] wreg_addr_in,

  output reg wreg_e_out,
  output reg[`WordRange] wreg_data_out,
  output reg[`RegRangeLog2] wreg_addr_out,

  input wire hilo_we_in,
  input wire[`WordRange] hi_data_in,
  input wire[`WordRange] lo_data_in,
  
  output reg hilo_we_out,
  output reg[`WordRange] hi_data_out,
  output reg[`WordRange] lo_data_out,

  input wire[`ALUOpRange] aluop_in, // 从上级流水来的aluop
  input wire[`WordRange] mem_addr_in, // 从上级流水来的存储器地址
  input wire[`WordRange] mem_store_data_in, // 从上级流水来的要存入存储器的数据

  input wire[`WordRange] mem_read_data_in, // 从存储器来的读出的数据

  output reg[`WordRange] mem_addr_out, // 发给存储器的地址信息
  output reg mem_we_out, // 发给存储器的写使能信号
  output reg[3:0] mem_byte_sel_out, // 发给存储器的字节选择信号
  output reg[`WordRange] mem_store_data_out // 发给存储器的写入数据

);

  always @(*) begin
    if (rst == `Enable) begin
      wreg_e_out <= `Disable;
      wreg_data_out <= `ZeroWord;
      hilo_we_out <= `Disable;
      hi_data_out <= `ZeroWord;
      lo_data_out <= `ZeroWord;
      mem_addr_out <= `ZeroWord;
      mem_we_out <= `Disable;
      mem_byte_sel_out <= 4'b0000;
      mem_store_data_out <= `ZeroWord;
    end else begin
      wreg_e_out <= wreg_e_in;
      wreg_data_out <= wreg_data_in;
      wreg_addr_out <= wreg_addr_in;
      hilo_we_out <= hilo_we_in;
      hi_data_out <= hi_data_in;
      lo_data_out <= lo_data_in;
      mem_addr_out <= `ZeroWord;
      mem_we_out <= `Disable;
      mem_byte_sel_out <= 4'b1111;
      mem_store_data_out <= `ZeroWord;
      case (aluop_in)
        `EXOP_LB: begin // load byte
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          case (mem_addr_in[1:0])
            2'b00: begin
              wreg_data_out <= {{24{mem_read_data_in[7]}}, mem_read_data_in[7:0]}; // 符号拓展
            end
            2'b01: begin
              wreg_data_out <= {{24{mem_read_data_in[15]}}, mem_read_data_in[15:8]};
            end
            2'b10: begin
              wreg_data_out <= {{24{mem_read_data_in[23]}}, mem_read_data_in[23:16]};
            end
            2'b11: begin
              wreg_data_out <= {{24{mem_read_data_in[31]}}, mem_read_data_in[31:24]};
            end
          endcase
        end
        `EXOP_LBU: begin // load byte unsigned
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          case (mem_addr_in[1:0])
            2'b00: begin
              wreg_data_out <= {{24{1'b0}}, mem_read_data_in[7:0]}; // 零拓展
            end
            2'b01: begin
              wreg_data_out <= {{24{1'b0}}, mem_read_data_in[15:8]};
            end
            2'b10: begin
              wreg_data_out <= {{24{1'b0}}, mem_read_data_in[23:16]};
            end
            2'b11: begin
              wreg_data_out <= {{24{1'b0}}, mem_read_data_in[31:24]};
            end
          endcase
        end
        `EXOP_LH: begin // load半字
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          case (mem_addr_in[1:0])
            2'b00: begin
              wreg_data_out <= {{16{mem_read_data_in[15]}}, mem_read_data_in[15:0]};
            end
            2'b10: begin
              wreg_data_out <= {{16{mem_read_data_in[31]}}, mem_read_data_in[31:16]};
            end
          endcase
        end
        `EXOP_LHU: begin // load无符号半字
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          case (mem_addr_in[1:0])
            2'b00: begin
              wreg_data_out <= {{16{1'b0}}, mem_read_data_in[15:0]};
            end
            2'b10: begin
              wreg_data_out <= {{16{1'b0}}, mem_read_data_in[31:16]};
            end
          endcase
        end
        `EXOP_SB: begin // 存byte
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00: begin
              mem_store_data_out <= {{24{1'b0}}, mem_store_data_in[7:0]};
              mem_byte_sel_out <= 4'b0001;
            end
            2'b01: begin
              mem_store_data_out <= {{16{1'b0}}, mem_store_data_in[7:0], {8{1'b0}}};
              mem_byte_sel_out <= 4'b0010;
            end
            2'b10: begin
              mem_store_data_out <= {{8{1'b0}}, mem_store_data_in[7:0], {16{1'b0}}};
              mem_byte_sel_out <= 4'b0100;
            end
            2'b11: begin
              mem_store_data_out <= {mem_store_data_in[7:0], {24{1'b0}}};
              mem_byte_sel_out <= 4'b1000;
            end
          endcase
        end
        `EXOP_SH: begin // 存半字
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00: begin
              mem_store_data_out <= {{24{1'b0}}, mem_store_data_in[15:0]};
              mem_byte_sel_out <= 4'b0011;
            end
            2'b10: begin
              mem_store_data_out <= {mem_store_data_in[15:0], {24{1'b0}}};
              mem_byte_sel_out <= 4'b1100;
            end
          endcase
        end
        `EXOP_LW: begin // 读字
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          wreg_data_out <= mem_read_data_in;
          mem_byte_sel_out <= 4'b1111;
        end
        `EXOP_SW: begin // 存字
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          mem_store_data_out <= mem_store_data_in;
          mem_byte_sel_out <= 4'b1111;
        end
      endcase
    end
  end

endmodule