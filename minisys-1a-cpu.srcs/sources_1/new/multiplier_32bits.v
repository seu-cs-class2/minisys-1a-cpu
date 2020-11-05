`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 12:08:40
// Design Name: 
// Module Name: multiplier_32bits
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


module multiplier_32bits(
    input[31:0] multiplicand,
    input[31:0] multiplier,
    input is_signed,
    input clk_mul,
    output[31:0] product_high,
    output[31:0] product_low
    );
    
    reg product[63:0];
    
endmodule
