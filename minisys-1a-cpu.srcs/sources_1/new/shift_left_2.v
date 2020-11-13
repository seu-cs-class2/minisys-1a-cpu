`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 15:47:34
// Design Name: 
// Module Name: shift_left_2
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


module shift_left_2(in,out);
    input[31:0] in;
    output[31:0] out;
    reg[31:0] out;
    always @(in)
        out = (in << 2);
endmodule
