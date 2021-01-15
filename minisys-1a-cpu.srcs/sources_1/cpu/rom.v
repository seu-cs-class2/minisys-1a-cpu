
module rom(
    //cpu
    input wire clk,
    input wire[`WordRange] addr,
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

blk_mem_gen_0 u_blk_mem_gen_0 (
    .addra                    (kickOff ? addr[15:2]                 :   upg_adr),
    .clka                     (kickOff ? clk                        :   upg_clk),
    .douta                    (data_out),
    .wea                      (kickOff ? 1'b0			            :   upg_wen),
    .dina                     (kickOff ? 32'h00000000			    :   upg_dat)
);

endmodule