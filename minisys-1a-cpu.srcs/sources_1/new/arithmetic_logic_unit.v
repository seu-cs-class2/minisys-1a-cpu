`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 10:54:15
// Design Name: 
// Module Name: arithmetic_logic_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: alu is the core unit of the data path,will implement arithmtic and logic calculate
// @@logical unit
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arithmetic_logic_unit(
    input[31:0] dataA,
    input[31:0] dataB,
    input[4:0] calculate_type,
    output[31:0] result,
    output[31:0] mlu_div_high,
    output[31:0] mlu_div_low,
    output flag_of,
    output flag_cf,
    output flag_zf,
    output flag_sf   
    );
    
    wire adder_out[31:0];
    wire suber_out[31:0];
    wire muler_out[63:0];
    wire diver_out_divide[31:0];
    wire diver_out_rest[31:0];
    
    wire adder_carry_N_1;
    wire adder_carry_N_2;
    
    
    
    
    
    
     
    
    
    
endmodule
