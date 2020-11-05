`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 19:23:30
// Design Name: 
// Module Name: multiplier_unsigned_32bits
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


module multiplier_unsigned_32bits(multiplicand,multiplier,product,clk );
input[31:0]  multiplicand, multiplier;
input clk;
output product;

wire [32:0] multiplicand_temp,multiplier_temp;
reg [63:0] product;
reg [65:0] product_temp;
reg [5:0] bit; 
wire ready = !bit;
reg lostbit;
   
assign multiplicand_temp = {1'd0,multiplicand};
assign multiplier_temp = {1'd0,multiplier};
initial bit = 0;

always @( posedge clk )
begin
    if(ready)
    begin
        bit = 33;
        product_temp = { 33'd0, multiplier_temp };
        lostbit = 0;
    end
    else if( bit > 0 ) 
    begin:A
    case ({product_temp[0],lostbit})
        2'b01: product_temp[65:33] = product_temp[65:33] + multiplicand_temp;
        2'b10: product_temp[65:33] = product_temp[65:33] - multiplicand_temp;
    endcase
    lostbit = product_temp[0];
    product_temp = { product_temp[65], product_temp[65:1] };
    product = product_temp[63:0];
    bit = bit - 1;
    end
end                 
endmodule
