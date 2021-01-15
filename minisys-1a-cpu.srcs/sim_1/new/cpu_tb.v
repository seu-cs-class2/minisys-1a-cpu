`include "../../../sources_1/cpu/public.v"

// 指令测试
module cpu_tb();
  // 产生时钟
  reg CLOCK_50MHZ; // T = 20ns
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end
  
  // 被测信号
  // ======= 输入 =======
	reg rst; // 重置
	reg [`WordRange] imem_data_in; // 指令存储器发给cpu的指令
	reg [`WordRange] bus_read_in; // 从读控制总线读入的外设/ram数据
	reg [5:0] interrupt_in; // 外部中断信号 共六根
  // ======= 输出 =======
  wire[`WordRange] imem_addr_out; // cpu发给指令存储器的地址
  wire imem_e_out; // cpu发给指令存储器的使能信号
  wire[`WordRange] bus_addr_out; // 发给数据总线的地址
  wire[`WordRange] bus_write_data_out; // 发给写数据总线的数据
  wire bus_eable_out; // 发给控制总线的读写使能信号
  wire bus_we_out; // 发给控制总线的写使能信号（0代表读）
  wire[3:0] bus_byte_sel_out; // 发给控制总线的比特选择信号
  wire[`WordRange] mem_addr_debug; // debug MEM级输入：从上级流水来的存储器地址
  wire[`WordRange] ex_dataA_in; // debug EX级输入数据A
  wire[`WordRange] ex_dataB_in; // debug EX级输入数据B
	wire[`WordRange] ex_data_out; // EX级结果：写寄存器数据
	wire[`WordRange] ex_addr_out; // EX级结果：写寄存器地址

  // 例化被测模块
  cpu u_cpu(
    .clk(CLOCK_50MHZ),
    .rst(rst),
		.imem_data_in(imem_data_in),
		.bus_read_in(bus_read_in),
		.interrupt_in(interrupt_in),
		.imem_addr_out(imem_addr_out),
		.imem_e_out(imem_e_out),
		.bus_addr_out(bus_addr_out),
		.bus_write_data_out(bus_write_data_out),
		.bus_eable_out(bus_eable_out),
		.bus_we_out(bus_we_out),
		.bus_byte_sel_out(bus_byte_sel_out),
		.mem_addr_debug(mem_addr_debug),

		.ex_dataA_in(ex_dataA_in),
		.ex_dataB_in(ex_dataB_in),
		.ex_data_out(ex_data_out),
		.ex_addr_out(ex_addr_out)
  );

	// 描述测试过程
	initial begin
		// 重置
    rst <= `Enable;
		bus_read_in <= `ZeroWord;
		interrupt_in <= 6'b000000;
		// 开始测试
    #20 begin
      rst <= `Disable;
			imem_data_in <= 32'h34011100; // ori $1, $0, 0x1100
			bus_read_in <= `ZeroWord;
			interrupt_in <= 6'b000000;
		end
		#20 begin
			imem_data_in <= 32'h34020020; // ori $2, $0, 0x0020
		end
		#20 begin
			imem_data_in <= 32'h3403ff00; // ori $3, $0, 0xff00
		end
		#20 begin
			imem_data_in <= 32'h3404ffff; // ori $4, $0, 0xffff
		end

		// 结束
		#40 $stop;
	end
endmodule