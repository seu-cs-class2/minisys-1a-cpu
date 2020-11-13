`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 15:34:10
// Design Name: 
// Module Name: program_counter_adder
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


module program_counter_adder(in,out);
    input[31:0] in;
    output[31:0] out;
    wire[31:0] out;
    assign out = in + 4;
endmodule