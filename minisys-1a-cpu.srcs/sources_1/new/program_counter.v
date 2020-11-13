`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 10:35:05
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: program counter will store the instruction address
// @@ sequential  unit
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(in, clock, out);
    input[31:0] in;
    input clock;
    output[31:0] out;
    reg[31:0] out;
    always @(posedge clock)
    begin
//        assign out = in; // check OK
        out <= in;
    end 
endmodule
