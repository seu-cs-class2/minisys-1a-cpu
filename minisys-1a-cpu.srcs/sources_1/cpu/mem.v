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
  output wire[`WordRange] mem_store_data_out,   //发给写数据总线的数据
  output reg mem_e_out,  //发给控制总线的总使能 （好像没什么用？？先留着了

  //cp0相关
  input wire cp0_we_in,
  input wire[4:0] cp0_waddr_in,
  input wire[`WordRange] cp0_wdata_in,
  output reg cp0_we_out,
  output reg[4:0] cp0_waddr_out,
  output reg[`WordRange] cp0_wdata_out,

  //异常处理相关
  input wire[`WordRange] current_mem_pc_addr_in,
  input wire[`WordRange] abnormal_type_in,
  input wire[`WordRange] cp0_status_in,
  input wire[`WordRange] cp0_cause_in,
  input wire[`WordRange] cp0_epc_in,
  //此处要不要解决写cp0寄存器造成的数据相关？ 感觉不需要 因为cp0几乎不会去写 而且读到的三个寄存器也不应该去写
  output reg[`WordRange] abnormal_type_out,
  output reg[`WordRange] current_mem_pc_addr_out

);

  assign mem_store_data_out = mem_store_data_in;
  //先判断异常
  always @(*) begin
    if(rst == `Enable) begin
      abnormal_type_out = `ZeroWord;
    end else begin
      if(current_mem_pc_addr_in != `ZeroWord) begin //如果是0指令就根本不变异常的输出
        if(cp0_status_in[0] == `Enable)begin  //如果屏蔽了中断和异常则输出没有异常
          //否则直接把上级传下来的异常类型输出
          abnormal_type_out = {16'h0000, cp0_cause_in[13:8], 1'b0, abnormal_type_in[6:2], 2'b00};  
          current_mem_pc_addr_out = current_mem_pc_addr_in;
        end else begin
          if(abnormal_type_in[6:2] == `ABN_ERET)begin //在屏蔽中断时候如果遇到了ERET还是要发送异常给cp0和ppl
            abnormal_type_out = {16'h0000, cp0_cause_in[13:8], 1'b0, abnormal_type_in[6:2], 2'b00};
          end else begin
            abnormal_type_out = `ZeroWord;
          end      
        end 
      end else begin
        abnormal_type_out = `ZeroWord;
      end
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      wreg_e_out = `Disable;
      wreg_data_out = `ZeroWord;
      hilo_we_out = `Disable;
      hi_data_out = `ZeroWord;
      lo_data_out = `ZeroWord;
      mem_addr_out = `ZeroWord;
      mem_we_out = `Disable;
      mem_byte_sel_out = 4'b0000;
      mem_e_out = `Disable;
      cp0_we_out = `Disable;
      cp0_waddr_out = 5'b00000;
      cp0_wdata_out = `ZeroWord;
    end else begin
      wreg_e_out = wreg_e_in;
      wreg_data_out = wreg_data_in;
      wreg_addr_out = wreg_addr_in;
      hilo_we_out = hilo_we_in;
      hi_data_out = hi_data_in;
      lo_data_out = lo_data_in;
      mem_addr_out = `ZeroWord;
      mem_we_out = `Disable;
      mem_byte_sel_out = 4'b1111;
      mem_e_out = `Disable;
      cp0_we_out = cp0_we_in;
      cp0_waddr_out = cp0_waddr_in;
      cp0_wdata_out = cp0_wdata_in;
      case (aluop_in)
        `EXOP_LB: begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Disable;
          mem_e_out = `Enable;  //Fix me：此处以后肯定要修改，因为板子上的存储器是256*16bits的，为了满足按字节编址、对齐与小端存储
          case (mem_addr_in[1:0])  // 此处的逻辑可能需要改变！
            2'b00: begin
              wreg_data_out = {{24{mem_read_data_in[7]}},mem_read_data_in[7:0]};  //符号拓展
              mem_byte_sel_out = 4'b0001; //小端存储  取四个字节的最低位作为地址最低位
            end
            2'b01: begin
              wreg_data_out = {{24{mem_read_data_in[15]}},mem_read_data_in[15:8]};
              mem_byte_sel_out = 4'b0010;
            end
            2'b10: begin
              wreg_data_out = {{24{mem_read_data_in[23]}},mem_read_data_in[23:16]};
              mem_byte_sel_out = 4'b0100;
            end
            2'b11: begin
              wreg_data_out = {{24{mem_read_data_in[31]}},mem_read_data_in[31:24]};
              mem_byte_sel_out = 4'b1000;
            end
          endcase
        end
        `EXOP_LBU:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Disable;
          mem_e_out = `Enable;  //Fix me：此处以后肯定要修改，因为板子上的存储器是256*16bits的，为了满足按字节编址、对齐与小端存储
          case (mem_addr_in[1:0])  // 此处的逻辑可能需要改变！
            2'b00: begin
              wreg_data_out = {{24{1'b0}},mem_read_data_in[7:0]};  //零拓展
              mem_byte_sel_out = 4'b0001; //小端存储  取四个字节的最低位作为地址最低位
            end
            2'b01: begin
              wreg_data_out = {{24{1'b0}},mem_read_data_in[15:8]};
              mem_byte_sel_out = 4'b0010;
            end
            2'b10: begin
              wreg_data_out = {{24{1'b0}},mem_read_data_in[23:16]};
              mem_byte_sel_out = 4'b0100;
            end
            2'b11: begin
              wreg_data_out = {{24{1'b0}},mem_read_data_in[31:24]};
              mem_byte_sel_out = 4'b1000;
            end
          endcase
        end
        `EXOP_LH:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Disable;
          mem_e_out = `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              wreg_data_out = {{16{mem_read_data_in[15]}},mem_read_data_in[15:0]};
              mem_byte_sel_out = 4'b0011;  //小端存储 这样做对吗？ 感觉书上的大端存储是错误的
            end
            2'b10,
            2'b11:begin
              wreg_data_out = {{16{mem_read_data_in[31]}},mem_read_data_in[31:16]};
              mem_byte_sel_out = 4'b1100;
            end
          endcase
        end
        `EXOP_LHU:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Disable;
          mem_e_out = `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              wreg_data_out = {{16{1'b0}},mem_read_data_in[15:0]};
              mem_byte_sel_out = 4'b0011;  //小端存储 这样做对吗？ 感觉书上的大端存储是错误的
            end
            2'b10,
            2'b11:begin
              wreg_data_out = {{16{1'b0}},mem_read_data_in[31:16]};
              mem_byte_sel_out = 4'b1100;
            end
          endcase
        end
        `EXOP_SB:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Enable;
          mem_e_out = `Enable;
          case (mem_addr_in[1:0])
            2'b00:begin
              mem_byte_sel_out = 4'b0001;
            end
            2'b01:begin
              mem_byte_sel_out = 4'b0010;
            end
            2'b10:begin
              mem_byte_sel_out = 4'b0100;
            end
            2'b11:begin
              mem_byte_sel_out = 4'b1000;
            end
          endcase
        end
        `EXOP_SH:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Enable;
          mem_e_out = `Enable;
          case (mem_addr_in[1:0])
            2'b00,
            2'b01:begin
              mem_byte_sel_out = 4'b0011;
            end
            2'b10,
            2'b11:begin
              mem_byte_sel_out = 4'b1100;
            end
          endcase
        end
        `EXOP_LW:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Disable;
          mem_e_out = `Enable;
          wreg_data_out = mem_read_data_in;
          mem_byte_sel_out = 4'b1111;
        end
        `EXOP_SW:begin
          mem_addr_out = mem_addr_in;
          mem_we_out = `Enable;
          mem_e_out = `Enable;
          mem_byte_sel_out = 4'b1111;
        end
      endcase
    end
  end


endmodule