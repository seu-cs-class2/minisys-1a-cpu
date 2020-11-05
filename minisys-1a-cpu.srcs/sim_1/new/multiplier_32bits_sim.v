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
reg clock;
 // Outputs
wire [63:0] result;
integer i;

multiplier_32bits test(
.multiplicand(input1),
.multiplier(input2),
.clk(clock),
.product(result)
);

initial begin
  // Initialize Inputs
  clock = 0;
  input1 = 32'h7fffffff;
  input2 = 1;
  i = 66;
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
