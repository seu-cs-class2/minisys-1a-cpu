`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 15:52:39
// Design Name: 
// Module Name: program_counter_adder_sim
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


module program_counter_adder_sim();

reg[31:0] in;
wire[31:0] out;
reg clock;

program_counter_adder test(
    .in(in),
    .out(out)
);

initial begin
    clock = 0;
    in = 0;
    forever begin
        #5 clock = ~clock;
        if(clock == 1)
            in = in + 4;
    end
end 

endmodule
