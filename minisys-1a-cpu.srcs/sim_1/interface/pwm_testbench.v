`timescale 1ns / 1ps

`include "../../sources_1/zx/public.v"

// PWM 测试
module pwm_testbench();

  reg rst;
  reg CLOCK_50MHZ; // T = 20ns
  reg cs;
  reg en;
  reg[2:0] port;
  reg[15:0] data;
  reg[15:0] result;

  pwm u_pwm(
  .rst(rst),
  .clk(CLOCK_50MHZ),
  .cs(cs),
  .en(en),
  .port(port),
  .data(data),
  .result(result)
  );

  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;

    rst = `Enable;
    cs = `Disable;
    en = `Disable;
    port = 3'd0;
    data = 16'd0;

    #200 begin
      en = `Enable;
      cs = `Enable;
      port = 3'd0;
      data = 16'd16; // threshold
    end
    
    #400 begin
      port = 3'd2;
      data = 16'd8; // compare
    end
    
    #3000 $stop;
  end

endmodule