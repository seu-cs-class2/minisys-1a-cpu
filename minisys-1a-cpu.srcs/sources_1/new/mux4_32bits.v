`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 15:09:10
// Design Name: 
// Module Name: mux4_32bits
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


module mux4_32bits(in0,in1,in2,in3,ctr,out);
    input[31:0] in0,in1,in2,in3;
    input[1:0] ctr;
    output[31:0] out;
    reg[31:0] out;
    
    always @(ctr)
        begin
            case(ctr)
                2'b00: out = in0;
                2'b01: out = in1;
                2'b10: out = in2;
                2'b11: out = in3;
            endcase
        end
endmodule
