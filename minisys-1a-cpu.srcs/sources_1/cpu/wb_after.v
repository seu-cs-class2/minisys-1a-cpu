module wb_after(
    input clk,
    input rst,
    input pause,

    input wire reg_we_in,
    input wire[`RegRangeLog2] reg_addr_in,
    input wire[`WordRange] reg_data_in,

    output reg reg_we_out,
    output reg[`RegRangeLog2] reg_addr_out,
    output reg[`WordRange] reg_data_out
);


always @(posedge clk) begin
    if(rst == `Enable)begin
        reg_we_out = `Disable;
        reg_addr_out = 5'b00000;
        reg_data_out = `ZeroWord;
    end else if(pause == `Enable) begin
        reg_we_out = reg_we_out;
        reg_addr_out = reg_addr_out;
        reg_data_out = reg_data_out;
    end else begin
        reg_we_out = reg_we_in;
        reg_addr_out = reg_addr_in;
        reg_data_out = reg_data_in;
    end
end

endmodule