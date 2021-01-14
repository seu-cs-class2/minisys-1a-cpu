module mul(
    input wire clk,
    input wire[`WordRange] dataA,
    input wire[`WordRange] dataB,
    input wire start,
    input wire if_signed,
    output reg[`DivMulResultRange] result,
    output reg  valid
);

reg[4:0] count;
reg[`WordRange] dataA_temp;
reg[`WordRange] dataB_temp;
wire[`DivMulResultRange] signed_result_wire;
wire[`DivMulResultRange] unsigned_result_wire;
always@(posedge clk)begin
    if(start == `Disable)begin
        count = 5'd0;
        dataA_temp = `ZeroWord;
        dataB_temp = `ZeroWord;
        valid <= `Disable;
    end else begin
        count <= count + 5'd1;
        dataA_temp = dataA;
        dataB_temp = dataB;
        if(count == 5'd6)begin
            valid = `Enable;
            if(if_signed)begin
                result = signed_result_wire;
            end else begin
                result = unsigned_result_wire;
            end
        end
    end
end

multiplier_signed u_mul_signed(
.CLK        (clk),
.A          (dataA_temp),
.B          (dataB_temp),
.P          (signed_result_wire)
);

multiplier_unsigned u_mul_unsigned(
.CLK        (clk),
.A          (dataA_temp),
.B          (dataB_temp),
.P          (unsigned_result_wire)
);


endmodule


