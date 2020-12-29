`timescale 1ns / 1ps

`include "../../sources/cpu/public.v"

// PWM 测试
module pwm_tb();

  reg rst;
  reg CLOCK_50MHZ; // T = 20ns
  reg cs;
  reg en;
  reg[2:0] port;
  reg[15:0] data;
  wire result;

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
  end

  initial begin
    rst = `Enable;
    cs = `Disable;
    en = `Disable;
    port = 3'd0;
    data = 16'd0;

    #100 begin
      rst = `Disable;
    end

    #200 begin
      en = `Enable;
      cs = `Enable;
      port = 3'd0;
      data = 16'd32; // threshold
    end
    
    #300 begin
      port = 3'd2;
      data = 16'd16; // compare
    end
    
    #3000 $stop;
  end

endmodule