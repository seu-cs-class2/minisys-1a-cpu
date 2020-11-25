`timescale 1ns / 1ps

`include "../../sources_1/zx/public.v"

// testbench of host
module host_tb();

  reg rst;
  reg CLOCK_50MHZ;

  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end

  initial begin
    rst = `Enable;
    #200 rst = `Disable;
    #5000 $stop;
  end

  host u_host(
    .rst(rst),
    .clk(CLOCK_50MHZ)
  );

endmodule