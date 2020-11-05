`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 19:33:54
// Design Name: 
// Module Name: multiplier_unsigned_sim
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


module multiplier_unsigned_sim;
// Inputs
reg [31:0] input1;
reg [31:0] input2;
reg clock;
 // Outputs
wire [63:0] result;
integer i;

multiplier_unsigned_32bits test2(
.multiplicand(input1),
.multiplier(input2),
.clk(clock),
.product(result)
);

initial begin
  // Initialize Inputs
  clock = 0;
  input1 = 25;
  input2 = 25;
  i = 70;
  forever
  begin
    if(i>0)
    begin
        #2 clock = ~clock;
        i = i-1;
    end
    else
        clock = clock;
  end

  // Add stimulus here
 end

endmodule
