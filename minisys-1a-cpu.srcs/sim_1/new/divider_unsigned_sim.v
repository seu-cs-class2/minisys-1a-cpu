`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/06 11:37:53
// Design Name: 
// Module Name: divider_unsigned_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divider_unsigned_sim();

reg[31:0] inputA;
reg[31:0] inputB;
reg clock;
reg reset;
reg start;
integer i;
wire ok;
wire error;
wire[31:0] result;
wire[31:0] rest;

divider_unsigned_32bits test(
    .clk(clock),
    .reset(reset),
    .start(start),
    .A(inputA),
    .B(inputB),
    .D(result),
    .R(rest),
    .ok(ok),
    .err(error)
);

initial begin
    reset = 0;
    i = 0;
    start = 1;
    clock = 0;
    inputA = 626;
    inputB = 25;
    forever begin
        #2 clock = ~clock;
        i = i + 1;
    end
end
endmodule
