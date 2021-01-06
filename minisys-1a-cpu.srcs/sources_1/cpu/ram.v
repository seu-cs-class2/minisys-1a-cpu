//集成写一个ram 包含四个8位block_mem
//相当于对�?个block_mem做位拓展
//每次读直接出�?32bit
//写根据byte_sel的情况来�?

`include "public.v"

module ram(
    input wire clk,
    input wire eable,
    input wire we,
    input wire[`WordRange] addr,
    input wire[3:0] byte_sel,
    input wire[`WordRange] data_in,
    output wire[`WordRange] data_out
);

wire ram_eable;
wire weA,weB,weC,weD;

assign ram_eable = (~|addr[31:16]) & eable;  //�?16位全0且eable有效 才真正有�?

assign weA = byte_sel[0] & we;
assign weB = byte_sel[1] & we;
assign weC = byte_sel[2] & we;
assign weD = byte_sel[3] & we;


blk_mem_ram_byte ramA(
    .addra         (addr[15:2]),
    .clka          (clk),
    .dina          (data_in[7:0]),
    .douta         (data_out[7:0]),
    .ena           (ram_eable),
    .wea           (weA)
);  //�?低位字节�?00�?
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
);  //�?高位字节�?11�?

endmodule