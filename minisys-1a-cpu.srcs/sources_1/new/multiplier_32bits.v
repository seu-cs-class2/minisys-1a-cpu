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


module multiplier_32bits(multiplicand,multiplier,product,clk);
input[31:0]  multiplicand, multiplier;
input clk;
output product;

reg [63:0] product;
reg [5:0] bit; 
wire ready = !bit;
reg lostbit;
   
initial bit = 0;

always @( posedge clk )
begin
    if(ready)
    begin
        bit = 32;
        product = { 32'd0, multiplier };
        lostbit = 0;
    end
    else if( bit > 0 ) 
    begin:A
    case ({product[0],lostbit})
        2'b01: product[63:32] = product[63:32] + multiplicand;
        2'b10: product[63:32] = product[63:32] - multiplicand;
    endcase
    lostbit = product[0];
    product = { product[63], product[63:1] };
    bit = bit - 1;
    end
end                       
endmodule
