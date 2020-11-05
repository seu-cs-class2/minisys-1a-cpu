`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 11:06:59
// Design Name: 
// Module Name: adder_32bits
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


module adder_32bits(dataA,dataB,result,carry_N_1,carry_N_2);
    parameter N=32;
    input [N-1:0] dataA,dataB;
    output [N-1:0] result;
    output carry_N_1;
    output carry_N_2;
    wire [N-1:0] carry;
    genvar i;
    generate
        for(i=0;i<N;i = i+1)
            begin: generate_N_bit_Adder
                if(i == 0)
                    half_adder f(dataA[0],dataB[0],result[0],carry[0]);
                else
                    full_adder f(dataA[i],dataB[i],carry[i-1],result[i],carry[i]);
            end
        assign carry_N_1 = carry[N-1];
        assign carry_N_2 = carry[N-2];
    endgenerate
endmodule

module half_adder(x,y,s,c);
   input x,y;
   output s,c;
   assign s=x^y;
   assign c=x&y;
endmodule 

module full_adder(x,y,c_in,s,c_out);
   input x,y,c_in;
   output s,c_out;
   assign s = (x^y) ^ c_in;
   assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule