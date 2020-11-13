`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 13:45:33
// Design Name: 
// Module Name: mux2_32bits
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


module mux2_32bits(in0,in1,ctr,out);
    input[31:0] in0;
    input[31:0] in1;
    input ctr;
    output[31:0] out;
    reg[31:0] out;
    always @(ctr)
        begin
            case(ctr)
                1'b0: out = in0;
                1'b1: out = in1;
            endcase
        end
endmodule
