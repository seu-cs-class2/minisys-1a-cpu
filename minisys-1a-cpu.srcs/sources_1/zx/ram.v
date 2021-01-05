//集成写一个ram 包含四个8位block_mem
//相当于对一个block_mem做位拓展
//每次读直接出来32bit
//写根据byte_sel的情况来写

`include "public.v"

module ram(
    input wire clk,
    input wire eable,
    input wire we,
    input wire[`WordRange] addr,
    input wire[3:0] byte_sel,
    input wire[`WordRange] data_in,
    output wire[`WordRange] data_out,
    output reg abt_eable
);

wire ram_eable;
wire weA,weB,weC,weD;

assign ram_eable = (~|addr[31:16]) & eable;  //高16位全0且eable有效 才真正有效

assign weA = byte_sel[0] & we;
assign weB = byte_sel[1] & we;
assign weC = byte_sel[2] & we;
assign weD = byte_sel[3] & we;


always @(*)begin
    abt_eable <= `Disable;
    if(addr[31:16] == 16'h0000 && eable == `Enable)begin 
        abt_eable <= `Enable;   //如果地址正确  就向仲裁器提交申请
    end
end





blk_mem_ram_byte ramA(
    .addra         (addr[15:2]),
    .clka          (clk),
    .dina          (data_in[7:0]),
    .douta         (data_out[7:0]),
    .ena           (ram_eable),
    .wea           (weA)
);  //最低位字节（00）
blk_mem_ram_byte ramB(
    .addra         (addr[15:2]),
    .clka          (clk),
    .dina          (data_in[15:8]),
    .douta         (data_out[15:8]),
    .ena           (ram_eable),
    .wea           (weB)
);//(01)
blk_mem_ram_byte ramC(
    .addra         (addr[15:2]),
    .clka          (clk),
    .dina          (data_in[23:16]),
    .douta         (data_out[23:16]),
    .ena           (ram_eable),
    .wea           (weC)
);//(10)
blk_mem_ram_byte ramD(
    .addra         (addr[15:2]),
    .clka          (clk),
    .dina          (data_in[31:24]),
    .douta         (data_out[31:24]),
    .ena           (ram_eable),
    .wea           (weD)
);  //最高位字节（11）

endmodule