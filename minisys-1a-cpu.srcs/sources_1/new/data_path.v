`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: wxy
// 
// Create Date: 2020/11/05 10:14:47
// Design Name: 
// Module Name: data_path
// Project Name: minisys-1a-cpu
// Target Devices: 
// Tool Versions: 
// Description: the top level of cpu, include the core units which will be controled by CU 
// 
// Dependencies: other down unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module data_path(
    input[7:0] ip,
    output[7:0] op
    );   
    hellow h1(ip,op);
endmodule
