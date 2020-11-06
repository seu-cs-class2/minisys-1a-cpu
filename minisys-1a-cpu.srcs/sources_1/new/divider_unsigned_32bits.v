`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/06 11:22:23
// Design Name: 
// Module Name: divider_unsigned_32bits
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


module divider_unsigned_32bits(
    input clk,  
    input  reset,  
    input  start,  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] D,  
    output [31:0] R,  
    output ok ,   // =1 when ready to get the result   
    output err  
);  
reg active;   // True if the divider is running  
reg [4:0]    cycle;   // Number of cycles to go  
reg [31:0]   result;   // Begin with A, end with D  
reg [31:0]   denom;   // B  
reg [31:0]   work;    // Running R  
   // Calculate the current digit  
wire [32:0]   sub = { work[30:0], result[31] } - denom;  
       assign err = !B;  
   // Send the results to our master  
assign D = result;  
assign R = work;  
assign ok = ~active;
always @(posedge clk,posedge reset) begin  
    if (reset) begin  
        active <= 0;  
        cycle <= 0;  
        result <= 0;  
        denom <= 0;  
        work <= 0;  
    end  
    else if(start) begin  
        if (active) begin  
            if (sub[32] == 0) begin  
                work <= sub[31:0];  
                 result <= {result[30:0], 1'b1};  
            end  
            else begin  
                work <= {work[30:0], result[31]};  
                result <= {result[30:0], 1'b0};  
            end  
            if (cycle == 0) begin  
                active <= 0;  
            end  
            cycle <= cycle - 5'd1;  
        end  
        else begin  
            cycle <= 5'd31;  
            result <= A;  
            denom <= B;  
            work <= 32'b0;  
            active <= 1;  
        end  
    end  
end  
endmodule
