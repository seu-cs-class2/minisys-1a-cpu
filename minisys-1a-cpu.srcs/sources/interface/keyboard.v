// keyboard.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 4×4矩阵键盘
module keyboard (

  input rst, // 复位
  input clk, // 时钟
  // 防抖的灵敏度取决于clk的频率（采样频率），可考虑对clk进行倍频

  input[3:0] cols, // 列线（输入线）
  output reg[3:0] rows, // 行线（输出线）
  
  output reg[3:0] value // 按键对应的数值（0~D, E=*, F=#）

);

  // 状态
  parameter NO_KEY = 4'd0; // 初态，没有键按下
  parameter SCAN_ROW0 = 4'd1; // 扫描行0
  parameter SCAN_ROW1 = 4'd2; // 扫描行1
  parameter SCAN_ROW2 = 4'd3; // 扫描行2
  parameter SCAN_ROW3 = 4'd4; // 扫描行3
  parameter YES_KEY = 4'd5; // 有按键按下
  
  // 状态机
  reg[3:0] current_state;
  reg[3:0] next_state;

  // 结果
  reg[3:0] row_coord; // 行坐标
  reg[3:0] col_coord; // 列坐标

  // 每拍进行一次状态转移
  always @(posedge clk) begin
    if (rst == `Enable) begin
      current_state <= NO_KEY;
      rows <= 0'd0;
      value <= 0'd0;
    end else begin
      current_state <= next_state;
    end
  end

  // 决策下一状态
  always @(*) begin
    case (current_state)
    NO_KEY: begin
      // 列线全部被上拉到1，说明没有按键被按下
      if (cols == 4'b1111) begin
        next_state = NO_KEY;
      end else begin
        // 否则开始逐行扫描
        next_state = SCAN_ROW0;
      end
    end
    SCAN_ROW0: begin
      // 给出的该行扫描信号没有拉低列线，说明被按的按钮不在该行
      // 下面同理
      if (cols == 4'b1111) begin
        next_state = SCAN_ROW1;
      end else begin
        next_state = YES_KEY;
      end
    end
    SCAN_ROW1: begin
      if (cols == 4'b1111) begin
        next_state = SCAN_ROW2;
      end else begin
        next_state = YES_KEY;
      end
    end
    SCAN_ROW2: begin
      if (cols == 4'b1111) begin
        next_state = SCAN_ROW3;
      end else begin
        next_state = YES_KEY;
      end
    end
    SCAN_ROW3: begin
      if (cols == 4'b1111) begin
        // 始终无法拉低列线，说明没有键被按下
        next_state = NO_KEY;
      end else begin
        next_state = YES_KEY;
      end
    end
    YES_KEY: begin
      if (cols == 4'b1111) begin
        next_state = NO_KEY;
      end else begin
        next_state = YES_KEY;
      end
    end
    endcase
  end

  // 准备次态需要的信号
  always @(posedge clk) begin
    case (next_state)
    NO_KEY: begin
      rows <= 4'b1111;
    end
    SCAN_ROW0: begin
      rows <= 4'b1110;
    end
    SCAN_ROW1: begin
      rows <= 4'b1101;
    end
    SCAN_ROW2: begin
      rows <= 4'b1011;
    end
    SCAN_ROW3: begin
      rows <= 4'b0111;
    end
    YES_KEY: begin
      // 锁存按键坐标
      row_coord <= rows;
      col_coord <= cols;
    end
    endcase
  end

  // 将坐标转换为键值
  always @(posedge clk) begin
    case ({row_coord, col_coord})
    8'b1110_1110: value <= 4'h1;
    8'b1110_1101: value <= 4'h2;
    8'b1110_1011: value <= 4'h3;
    8'b1110_0111: value <= 4'hA;
    
    8'b1101_1110: value <= 4'h4;
    8'b1101_1101: value <= 4'h5;
    8'b1101_1011: value <= 4'h6;
    8'b1101_0111: value <= 4'hB;

    8'b1011_1110: value <= 4'h7;
    8'b1011_1101: value <= 4'h8;
    8'b1011_1011: value <= 4'h9;
    8'b1011_0111: value <= 4'hC;

    8'b0111_1110: value <= 4'hE;
    8'b0111_1101: value <= 4'h0;
    8'b0111_1011: value <= 4'hF;
    8'b0111_0111: value <= 4'hD;
    endcase
  end

endmodule