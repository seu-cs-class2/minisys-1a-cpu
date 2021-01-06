`include "../../../sources_1/cpu/public.v"

// IF-ID测试
module if_id_tb();
  // 产生时钟
  reg CLOCK_50MHZ; // T = 20ns
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end
  
  // 被测信号
  reg rst; // 复位
  reg [`WordRange] if_pc; // IF级PC
  reg [`WordRange] if_ins; // IF级指令
  wire [`WordRange] id_pc; // ID级PC
  wire [`WordRange] id_ins; // ID级指令
  reg pause; // 流水线暂停信号

  // 例化被测模块
  if_id u_if_id(
    .clk(CLOCK_50MHZ),
    .rst(rst),
    .if_pc(if_pc),
    .if_ins(if_ins),
    .id_pc(id_pc),
    .id_ins(id_ins),
    .pause(pause)
  );

  initial begin
    // 送0
    rst <= `Enable;
    pause <= `Disable;
    #100 begin
      // 直接传递
      rst <= `Disable;
      if_pc <= 32'hffff_1234;
      if_ins <= 32'h1234_ffff;
    end
    #100 begin
      // 不变
      pause = `Enable;
      if_pc <= 32'hffff_ffff;
      if_ins <= 32'hffff_ffff;  
    end
    #100 begin
      // 变化
      pause = `Disable;
    end
    #100 $stop;
  end

endmodule