`include "../../../sources_1/cpu/public.v"

// 程序计数器PC测试
module pc_tb();
  // 产生时钟
  reg CLOCK_50MHZ; // T = 20ns
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end
  
  // 被测信号
  // ======= 输入 =======
  reg rst; // 同步复位信号
  reg pause; // 流水暂停信号
  reg branch_en_in; // 是否转移
  reg[`WordRange] branch_addr_in;  // 转移的地址
  // ======= 输出 =======
  wire[`WordRange] pc; // 当前PC

  // 例化被测模块
  pc u_pc(
    .clk(CLOCK_50MHZ),
    .rst(rst),
    .pc(pc),
    .pause(pause),
    .branch_en_in(branch_en_in),
    .branch_addr_in(branch_addr_in)
  );

  // 描述测试过程
  initial begin
    // 重置
    rst <= `Enable;
    pause <= `Disable;
    branch_en_in <= `Disable;
    branch_addr_in <= `ZeroWord;
    #100 begin
      rst <= `Disable;
    end
    // 平常应不断+4，且使能IMEM读取
    #100 begin
      // do nothing
    end
    // 流水暂停时PC不变
    #100 begin
      pause <= `Enable;
    end
    // 转移时覆盖PC
    #100 begin
      pause <= `Disable;
      branch_addr_in <= 32'd12345;
      branch_en_in <= `Enable;
    end
    #100 begin
      branch_en_in <= `Disable;
    end
    // 结束
    #100 $stop;
  end

endmodule