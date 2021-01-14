
module minsys_sim();

reg rst;
reg board_clk;

initial begin
    forever begin
        #5
        board_clk = ~board_clk;
    end
end


reg[23:0] switches_in;
reg[4:0] buttons_in;
reg[3:0] keyboard_cols_in;
wire[7:0] led_rld_out;
wire[7:0] led_yld_out;
wire[7:0] led_gld_out;
wire[31:0] pc;
wire clk_out;
wire[31:0] ins;
wire[31:0] bus_addr;
wire[31:0] bus_read_data;
wire[31:0] bus_write_data;
wire[31:0] mem_addr_debug_out;
wire[31:0] dataA;
wire[31:0] dataB;

minisys my_minisys(
    .rst                (rst),
    .board_clk          (board_clk),
    .switches_in        (switches_in),
    .buttons_in         (buttons_in),
    .keyboard_cols_in   (keyboard_cols_in),
    .led_RLD_out        (led_rld_out),
    .led_YLD_out        (led_yld_out),
    .led_GLD_out        (led_gld_out)
    // .pc_out             (pc),
    // .clk_debug          (clk_out),
    // .ins_out            (ins),
    // .bus_bug_addr       (bus_addr),
    // .bus_bug_read_data  (bus_read_data),
    // .bus_bug_write_data (bus_write_data),
    // .mem_addr_debug_out (mem_addr_debug_out),
    // .dataA              (dataA),
    // .dataB              (dataB)
);


initial begin
    assign switches_in = {24'h123456};
    assign buttons_in = {5'b00000};
    assign keyboard_cols_in = {4'h0};
    rst <= 1'b1;
    board_clk <= 1'b0;
    #10000
    rst <= 1'b0;
end 

endmodule