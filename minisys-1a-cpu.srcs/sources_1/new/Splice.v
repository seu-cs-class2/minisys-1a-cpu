`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 17:50:45
// Design Name: 
// Module Name: Splice
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


module Splice(pc_high, addr, out);
    input[3:0] pc_high;
    input[25:0] addr;
    output[31:0] out;
    reg[27:0] sl;
    always @(addr)
        sl = (addr << 2);
    assign out[31:0]={pc_high[3:0],sl[27:0]};
endmodule
