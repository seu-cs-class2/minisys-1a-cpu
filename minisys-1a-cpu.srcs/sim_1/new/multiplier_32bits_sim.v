`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 16:52:42
// Design Name: 
// Module Name: multiplier_32bits_sim
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


module multiplier_32bits_sim;
// Inputs
reg [31:0] input1;
reg [31:0] input2;
 // Outputs
wire [63:0] result;

mul_32bits_unsigned test(
.A(input1),
.B(input2),
.P(result)
);

initial begin
  // Initialize Inputs
  input1 = 32'hffffffff;
  input2 = 2;

  // Add stimulus here
end

endmodule
