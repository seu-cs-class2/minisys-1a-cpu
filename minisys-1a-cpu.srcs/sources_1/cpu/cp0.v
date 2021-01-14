// cp0.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 协处理器CP0
// 内部寄存器请参考补充讲义P93
module cp0 (

  input clk,
  input rst,

  input wire we_in,  //写使能
  input wire[4:0] waddr_in,  //写的寄存器地址
  input wire[`WordRange] data_in,   //写的数据
  input wire[4:0] raddr_in,  //读的地址

  input wire[5:0] int_in, //外设中断

  output reg[`WordRange] data_out,
  output reg[`WordRange] count_out, // Count寄存器，用于定时中断的产生
  output reg[`WordRange] compare_out, // Compare寄存器，配合count实现定时中断
  // Status寄存器，存放中断屏蔽信息等
  // 可读   可写
  // 31..16   15..8   7..1      0
  // Reserved IntMask Reserved  0
  // *** IntMask
  //     1..0: priority ctrl
  //     7..2: 6 mask bits
  output reg[`WordRange] status_out, 
  // Cause寄存器，存储异常或中断源的信息，记录最近一次异常原因
  // 31..14   13..8   7  6..2    1..0
  // Reserved IntPend 0  ExcCode 00
  // *** ExcCode
  //     00000: ext int
  //     01000: syscall
  //     01001: break
  //     01010: not implemented
  //     01100: ovf
  output reg[`WordRange] cause_out,
  // EPC寄存器，异常或中断的返回地址寄存器
  // 31..0
  // IRetAddr
  output reg[`WordRange] epc_out,
  output reg[`WordRange] config_out,

  output reg timer_int_o,



  //异常处理时增加的接口
  input wire[`WordRange] abnormal_type,
  input wire[`WordRange] current_pc_addr_in
);

always @(posedge clk)begin
  if(rst == `Enable)begin
    data_out <= `ZeroWord;
    count_out <= `ZeroWord;
    compare_out <= `ZeroWord;
    status_out <= 32'd1;
    cause_out <= `ZeroWord;
    epc_out <= `ZeroWord;
    config_out <= `ZeroWord;
    timer_int_o <= `Disable;
  end else begin
    count_out <= count_out + 32'd1;
    cause_out[13:8] <= int_in; //cause的8-13位表示外部中断的情况
    if(compare_out != `ZeroWord && count_out == compare_out) begin
      timer_int_o <= `Enable;
    end

    //当有异常
    if(abnormal_type != `ZeroWord)begin
      epc_out <= current_pc_addr_in;
      status_out[0] <= `Disable; //关闭终端
      cause_out[6:2] <= abnormal_type[6:2];
      if(abnormal_type[6:2] == `ABN_ERET)begin
        epc_out <= `ZeroWord;
        status_out[0] <= `Enable; //开中断
      end
    end


    if(we_in == `Enable)begin
      case (waddr_in)
        `CP0_REG_COUNT: begin
          count_out <= data_in;
        end  
        `CP0_REG_COMPARE: begin
          compare_out <= data_in;
          timer_int_o <= `Disable;
        end
        `CP0_REG_STATUE:begin
          status_out <= data_in;
        end
        `CP0_REG_EPC:begin
          epc_out <= data_in;
        end
        `CP0_REG_CAUSE:begin
          cause_out[6:2] = data_in[6:2];
        end
        default: begin
        end
      endcase
    end
  end
end

always @(*) begin //随时读
  if(rst == `Enable)begin
    data_out = `ZeroWord;
  end else begin
    case (raddr_in)
      `CP0_REG_COUNT: begin
        data_out = count_out;
      end  
      `CP0_REG_COMPARE: begin
        data_out = compare_out;
      end
      `CP0_REG_STATUE:begin
        data_out = status_out;
      end
      `CP0_REG_EPC:begin
        data_out = epc_out;
      end
      `CP0_REG_CAUSE:begin
        data_out = cause_out;
      end
      default: begin
      end
    endcase
  end
end


endmodule
