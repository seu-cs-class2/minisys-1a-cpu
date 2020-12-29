// cp0.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 协处理器CP0
module cp0 (

  input clk,
  input rst,

  input wire we_in,
  input wire[2:0] waddr_in,
  input wire[`WordRange] data_in,
  input wire[2:0] raddr_in,

  input wire[5:0] int_in,

  output reg[`WordRange] data_out,
  output reg[`WordRange] count_out,// Count寄存器，用于定时中断的产生
  output reg[`WordRange] compare_out,// Compare寄存器，配合count实现定时中断
  // Status寄存器，存放中断屏蔽信息等
  // 31..16   15..8   7..1      0
  // Reserved IntMask Reserved  0
  // *** IntMask
  //     1..0: priority ctrl
  //     7..2: 6 mask bits
  output reg[`WordRange] status_out,
  // Cause寄存器，存储异常或中断源的信息
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

  output reg timer_int_o
);

//对CP0中寄存器的写操作
  always @(posedge clk) begin
	if(rst == `Enable) begin
		//初始化
		count_out <= `ZeroWord;
		compare_out <= `ZeroWord;
		status_out <= 32'b00010000000000000000000000000000;//CU字段为4b0001表示CP0存在，其他协处理器不存在
		cause_out <= `ZeroWord;
		epc_out <= `ZeroWord;
		config_out <= 32'b00000000000000000000000000000000;//BE字段为0表示工作在小端模式
		timer_int_out <= `InterruptNotAssert;
	end else begin

		count_out <= count_out + 1;//count寄存器的值在每个时钟周期+1
		cause_out[15:10] <= int_in;//cause的第10~15bit保存外部中断声明

		//当compare寄存器不为0，且count寄存器的值等于compare寄存器的值时，
		//将输出信号timer_int_out置为1，表示时钟中断发生
		if(compare_out != `ZeroWord && count_out == compare_out) begin
			timer_int_out <= `InterruptAssert;
		end

		if(we_in == `Enable) begin
			case(waddr_in)
				`CP0_REG_COUNT:	begin//写count寄存器
					count_out <= data_in;
				end 

				`CP0_REG_COMPARE:	begin//写compare寄存器
					compare_out <= data_in;
					timer_int_out <= `InterruptNotAssert;
				end 

				`CP0_REG_STATUS:	begin//写status寄存器
					status_out <= data_in;
				end 

				`CP0_REG_EPC:	begin//写EPC寄存器
					epc_out <= data_in;
				end 

				`CP0_REG_CAUSE:	begin//写cause寄存器
					cause_out[9:8] <= data_in[9:8];
					cause_out[23] <= data_in[23];
					cause_out[22] <= data_in[22];
				end 
			endcase
		end
	end
  end

  //对CP0中寄存器的读操作
  always @(posedge clk) begin
	if(rst == `Enable) begin
		data_out <= `ZeroWord;
	end else begin
		case (raddr_in)
			`CP0_REG_COUNT:	begin//读count寄存器
				data_out <= count_out;
			end 

			`CP0_REG_COMPARE:	begin//读compare寄存器
				data_out <= compare_out;
			end 

			`CP0_REG_STATUS:	begin//读status寄存器
				data_out <= status_out;
			end 

			`CP0_REG_EPC:	begin//读EPC寄存器
				data_out <= epc_out;
			end 

			`CP0_REG_CAUSE:	begin//读cause寄存器
				data_out <= cause_out;
			end 

			`CP0_REG_CONFIG:	begin//读config寄存器
				data_out <= cause_out;
			end 
		endcase
	end
 end
endmodule
