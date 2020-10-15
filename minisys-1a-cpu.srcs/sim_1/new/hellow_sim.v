`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 12:07:52
// Design Name: 
// Module Name: hellow_sim
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


module hellow_sim( );
    //input
    reg [7:0] sw = 8'h00;
    //output
    wire [7:0] led;
    //instantiate the Unit under test
    hellow uut(
        .sw(sw),
        .led(led)
    );
    always #10 sw = sw+1;
endmodule
