
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


minisys my_minisys(
    .rst                (rst),
    .board_clk          (board_clk),
    .switches_in        (switches_in),
    .buttons_in         (buttons_in),
    .keyboard_cols_in   (keyboard_cols_in)
);


initial begin
    assign switches_in = {24'hffffff};
    assign buttons_in = {5'b00000};
    assign keyboard_cols_in = {4'h0};

    rst <= 1'b1;
    board_clk <= 1'b0;
    #10000
    rst <= 1'b0;
end 

endmodule