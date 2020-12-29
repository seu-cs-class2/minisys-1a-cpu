// digits.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 八位七段共阳极数码管
module digits (

  input rst, // 复位
  input clk, // 时钟

  input[2:0] sel_in, // 要显示的位置
  input[3:0] data_in, // 要显示的数据

  output reg[7:0] sel_out, // 位使能
  output reg[7:0] data_out // 段使能（DP, G-A）

);

  always @(posedge clk) begin
    if (rst == `Enable) begin
      sel_out <= 8'hff;
      data_out <= 8'hff;
    end else begin
      sel_out <= ~(1'b1 << sel_in);
      case (data_in)
        //                GEF_DCBA
        4'h0: begin
          data_out <= 8'b1100_0000; // ABCDEF
        end
        4'h1: begin
          data_out <= 8'b1111_1001; // BC
        end
        4'h2: begin
          data_out <= 8'b1010_0100; // ABDEG
        end
        4'h3: begin
          data_out <= 8'b1011_0000; // ABCDG
        end
        4'h4: begin
          data_out <= 8'b1010_1001; // BCFG
        end
        4'h5: begin
          data_out <= 8'b1010_0010; // ACDFG
        end
        4'h6: begin
          data_out <= 8'b1000_0010; // ACDEFG
        end
        4'h7: begin
          data_out <= 8'b1111_1000; // ABC
        end
        4'h8: begin
          data_out <= 8'b1000_0000; // ABCDEFG
        end
        4'h9: begin
          data_out <= 8'b1010_1000; // ABCFG
        end
        4'ha: begin
          data_out <= 8'b1000_1000; // ABCEFG
        end
        4'hb: begin
          data_out <= 8'b1000_0011; // CDEFG
        end
        4'hc: begin
          data_out <= 8'b1010_0111; // DEG
        end
        4'hd: begin
          data_out <= 8'b1010_0001; // BCDEG
        end
        4'he: begin
          data_out <= 8'b1000_0110; // ADEFG
        end
        4'hf: begin
          data_out <= 8'b1000_1110; // AEFG
        end
      endcase
    end
  end

endmodule