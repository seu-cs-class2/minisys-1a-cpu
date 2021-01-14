module mul_sim();

reg clk;
reg[31:0] data1;
reg[31:0] data2;
reg start;
reg is_signed;

initial begin
    clk = 1'b0;
    forever begin
        #5
        clk = ~clk;
    end
end

wire[63:0] result;
wire valid;


mul u_mul(
    .clk            (clk),
    .dataA          (data1),
    .dataB          (data2),
    .start          (start),
    .if_signed      (is_signed),
    .result         (result),
    .valid          (valid)
);

initial begin
   data1 = 32'd5;
   data2 = 32'd2;
   is_signed = 1'b0;
   start = 1'b0;
   #22
   start = 1'b1;
   #80
   start = 1'b0;
end

endmodule