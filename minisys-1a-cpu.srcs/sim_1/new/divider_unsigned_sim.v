`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/06 11:37:53
// Design Name: 
// Module Name: divider_unsigned_sim
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


module divider_unsigned_sim();

reg[31:0] inputA;
reg A_valid;
reg[31:0] inputB;
reg B_valid;
wire[63:0] result;
wire valid;

div_32bits_signed test(
   .s_axis_divisor_tdata(inputA),
   .s_axis_divisor_tvalid(A_valid),
   .s_axis_dividend_tdata(inputB),
   .s_axis_dividend_tvalid(B_valid),
   .m_axis_dout_tdata(result),
   .m_axis_dout_tvalid(valid)
);

initial begin
    inputA = 25;
    inputB = -627;
    A_valid = 1;
    B_valid = 1;
end
endmodule
