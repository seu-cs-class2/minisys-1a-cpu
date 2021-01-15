//集成写一个ram 包含四个8位block_mem
//相当于对1个block_mem做位拓展
//每次读直接出32bit
//写根据byte_sel的情况来写字节

`include "public.v"

module ram(
    //cpu
    input wire clk,
    input wire eable,
    input wire we,
    input wire[`WordRange] addr,
    input wire[3:0] byte_sel,
    input wire[`WordRange] data_in,
    output wire[`WordRange] data_out,

    //uart
    input wire upg_rst,
    input wire upg_clk,
    input wire upg_wen,
    input wire[13:0] upg_adr,
    input wire[31:0] upg_dat,
    input wire upg_done
);

wire kickOff = upg_rst | (~upg_rst & upg_done);

wire ram_eable;
wire weA,weB,weC,weD;

assign ram_eable = (~|addr[31:16]) & eable;  //地址高16位全0且eable有效 才真正有效

assign weA = byte_sel[0] & we;
assign weB = byte_sel[1] & we;
assign weC = byte_sel[2] & we;
assign weD = byte_sel[3] & we;


blk_mem_ram_byte ramA(
    .addra         (kickOff ?   addr[15:2]      :   upg_adr),
    .clka          (kickOff ?   clk             :   upg_clk),
    .dina          (kickOff ?   data_in[7:0]    :   upg_dat[7:0]),
    .douta         (data_out[7:0]),
    .ena           (kickOff ?   ram_eable       :   1'b1),
    .wea           (kickOff ?   weA             :   upg_wen)
);  //最低位字节(00)
blk_mem_ram_byte ramB(
    .addra         (kickOff ?   addr[15:2]      :   upg_adr),
    .clka          (kickOff ?   clk             :   upg_clk),
    .dina          (kickOff ?   data_in[15:8]   :   upg_dat[7:0]),
    .douta         (data_out[15:8]),
    .ena           (kickOff ?   ram_eable       :   1'b1),
    .wea           (kickOff ?   weA             :   upg_wen)
);//(01)
blk_mem_ram_byte ramC(
    .addra         (kickOff ?   addr[15:2]      :   upg_adr),
    .clka          (kickOff ?   clk             :   upg_clk),
    .dina          (kickOff ?   data_in[23:16]  :   upg_dat[7:0]),
    .douta         (data_out[23:16]),
    .ena           (kickOff ?   ram_eable       :   1'b1),
    .wea           (kickOff ?   weA             :   upg_wen)
);//(10)
blk_mem_ram_byte ramD(
    .addra         (kickOff ?   addr[15:2]      :   upg_adr),
    .clka          (kickOff ?   clk             :   upg_clk),
    .dina          (kickOff ?   data_in[31:24]  :   upg_dat[7:0]),
    .douta         (data_out[31:24]),
    .ena           (kickOff ?   ram_eable       :   1'b1),
    .wea           (kickOff ?   weA             :   upg_wen)
);  //最高位字节(11)

endmodule