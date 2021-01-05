// mem.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 访存控制模块
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

  input wire[`ALUOpRange] aluop_in, //从上级流水来的aluop
  input wire[`WordRange] mem_addr_in,  //从上级流水来的存储器地址
  input wire[`WordRange] mem_store_data_in,  //从上级流水来的要存入存储器的数据

  input wire[`WordRange] mem_read_data_in,   //从存储器来的读出的数据
 
  output reg[`WordRange] mem_addr_out,  //发给地址总线的地址
  output reg mem_we_out,   //发给控制总线的写使能
  output reg[3:0] mem_byte_sel_out,   //发给控制总线的比特使能
  output reg[`WordRange] mem_store_data_out,   //发给写数据总线的数据
  output reg mem_e_out  //发给控制总线的总使能 （好像没什么用？？先留着了

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
      mem_e_out <= `Disable;
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
      mem_e_out <= `Disable;  
      case (aluop_in)
        `EXOP_LB: begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          mem_e_out <= `Enable;  //Fix me：此处以后肯定要修改，因为板子上的存储器是256*16bits的，为了满足按字节编址、对齐与小端存储
          case (mem_addr_in[1:0])  // 此处的逻辑可能需要改变！
            2'b00: begin
              wreg_data_out <= {{24{mem_read_data_in[7]}},mem_read_data_in[7:0]};  //符号拓展
              mem_byte_sel_out <= 4'b0001; //小端存储  取四个字节的最低位作为地址最低位
            end
            2'b01: begin
              wreg_data_out <= {{24{mem_read_data_in[15]}},mem_read_data_in[15:8]};
              mem_byte_sel_out <= 4'b0010;
            end
            2'b10: begin
              wreg_data_out <= {{24{mem_read_data_in[23]}},mem_read_data_in[23:16]};
              mem_byte_sel_out <= 4'b0100;
            end
            2'b11: begin
              wreg_data_out <= {{24{mem_read_data_in[31]}},mem_read_data_in[31:24]};
              mem_byte_sel_out <= 4'b1000;
            end
          endcase
        end
        `EXOP_LBU:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          mem_e_out <= `Enable;  //Fix me：此处以后肯定要修改，因为板子上的存储器是256*16bits的，为了满足按字节编址、对齐与小端存储
          case (mem_addr_in[1:0])  // 此处的逻辑可能需要改变！
            2'b00: begin
              wreg_data_out <= {{24{1'b0}},mem_read_data_in[7:0]};  //零拓展
              mem_byte_sel_out <= 4'b0001; //小端存储  取四个字节的最低位作为地址最低位
            end
            2'b01: begin
              wreg_data_out <= {{24{1'b0}},mem_read_data_in[15:8]};
              mem_byte_sel_out <= 4'b0010;
            end
            2'b10: begin
              wreg_data_out <= {{24{1'b0}},mem_read_data_in[23:16]};
              mem_byte_sel_out <= 4'b0100;
            end
            2'b11: begin
              wreg_data_out <= {{24{1'b0}},mem_read_data_in[31:24]};
              mem_byte_sel_out <= 4'b1000;
            end
          endcase
        end
        `EXOP_LH:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          mem_e_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              wreg_data_out <= {{16{mem_read_data_in[15]}},mem_read_data_in[15:0]};
              mem_byte_sel_out <= 4'b0011;  //小端存储 这样做对吗？ 感觉书上的大端存储是错误的
            end
            2'b10,
            2'b11:begin
              wreg_data_out <= {{16{mem_read_data_in[31]}},mem_read_data_in[31:16]};
              mem_byte_sel_out <= 4'b1100;
            end
          endcase
        end
        `EXOP_LHU:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          mem_e_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              wreg_data_out <= {{16{1'b0}},mem_read_data_in[15:0]};
              mem_byte_sel_out <= 4'b0011;  //小端存储 这样做对吗？ 感觉书上的大端存储是错误的
            end
            2'b10,
            2'b11:begin
              wreg_data_out <= {{16{1'b0}},mem_read_data_in[31:16]};
              mem_byte_sel_out <= 4'b1100;
            end
          endcase
        end
        `EXOP_SB:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          mem_e_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00:begin
              mem_store_data_out <= {{24{1'b0}},mem_store_data_in[7:0]};
              mem_byte_sel_out <= 4'b0001;
            end
            2'b01:begin
              mem_store_data_out <= { {16{1'b0}} ,mem_store_data_in[7:0], {8{1'b0}} };
              mem_byte_sel_out <= 4'b0010;
            end
            2'b10:begin
              mem_store_data_out <= {{8{1'b0}},mem_store_data_in[7:0],{16{1'b0}}};
              mem_byte_sel_out <= 4'b0100;
            end
            2'b11:begin
              mem_store_data_out <= {mem_store_data_in[7:0],{24{1'b0}}};
              mem_byte_sel_out <= 4'b1000;
            end
          endcase
        end
        `EXOP_SH:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          mem_e_out <= `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              mem_store_data_out <= {{24{1'b0}},mem_store_data_in[15:0]};
              mem_byte_sel_out <= 4'b0011;
            end
            2'b10,
            2'b11:begin
              mem_store_data_out <= {mem_store_data_in[15:0],{24{1'b0}}};
              mem_byte_sel_out <= 4'b1100;
            end
          endcase
        end
        `EXOP_LW:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Disable;
          mem_e_out <= `Enable;
          wreg_data_out <= mem_read_data_in;
          mem_byte_sel_out <= 4'b1111;
        end
        `EXOP_SW:begin
          mem_addr_out <= mem_addr_in;
          mem_we_out <= `Enable;
          mem_e_out <= `Enable;
          mem_store_data_out <= mem_store_data_in;
          mem_byte_sel_out <= 4'b1111;
        end
      endcase
    end
  end

endmodule