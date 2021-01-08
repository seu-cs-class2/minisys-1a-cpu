// keyboard.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 4×4矩阵键盘
// 键盘驱动
// 键盘物理地址范围：0xFFFFFC10~0xFFFFFC1F
// 唯一寄存器地址: 0xFFFFFC10（用来存储当前按下的值）
module keyboard (

  input rst, // 复位
  input clk, // 时钟
  // 防抖的灵敏度取决于clk的频率（采样频率），可考虑对clk进行倍频

  //从总线来的数据 所有外设驱动都应有以下信号
  input wire[`WordRange] addr,
  input wire en, // 使能
  input wire[3:0] byte_sel,
  input wire[`WordRange] data_in, // 数据输入（来自cpu）
  input wire we, //写使能

  //发送给仲裁器 所有外设都应有此输出
  output reg[`WordRange] data_out,// 内部端口寄存器 存储按下的值 若无键按下则全f


  input[3:0] cols, // 列线（输入线）  外设输入
  output reg[3:0] rows // 行线（输出线） 发给外设

);

  // 状态与参数
  parameter COUNT = 20000; //防抖处理  在列线有反应的情况下 计数20000个时钟周期后再看列线的结果

  parameter NO_KEY = 4'd0; // 初态，没有键按下
  parameter MIGHT_HAVE_KEY = 4'd1; //可能有键位按下，此时应该等待2000个时钟周期后开始扫描行线，每来一个时钟周期，计数就加1
  parameter SCAN_ROW0 = 4'd2; // 扫描行0
  parameter SCAN_ROW1 = 4'd3; // 扫描行1
  parameter SCAN_ROW2 = 4'd4; // 扫描行2
  parameter SCAN_ROW3 = 4'd5; // 扫描行3
  parameter YES_KEY = 4'd6; // 有按键按下
  
  // 状态机
  reg[3:0] state;
  // 计数器
  reg[15:0] count;
  // 内部寄存器
  reg[31:0] data;

  // 每拍进行一次状态转移,状态转移则state+1，若回转到初态则直接置0
  always @(posedge clk) begin
    if (rst == `Enable) begin
      state <= NO_KEY;
      rows <= 4'b0000;
      count <= 16'd0;
      data <= 32'hffffffff;
    end else begin
      case (state)
        NO_KEY:begin
          rows <= 4'b0000; //行线全部输出低电平
          count <= 16'd0;
          if(cols != 4'b1111)begin  //这时候如果行线不全为1说明可能有键位输入 状态跳转
            state <= MIGHT_HAVE_KEY;
          end
        end 
        MIGHT_HAVE_KEY:begin
          if(count != COUNT)begin  //计数 
            count <= count + 16'd1;  
          end else if(cols == 4'b1111) begin  //如果这时候行线全为1 说明抖动了 回到初始状态
            state <= NO_KEY;
            count <= 16'd0;
          end else begin  //如果仍然不全为1 说明真的有键位输入 开始扫描行
            rows <= 4'b1110;
            state <= SCAN_ROW0;
          end
        end
        SCAN_ROW0:begin
          if(cols == 4'b1111)begin //说明不在这一行
            rows <= 4'b1101;
            state <= SCAN_ROW1;
          end else begin //说明在这一行
            state <= NO_KEY;
            if(cols == 4'b1110)begin
              data <= 32'd13;
            end else if(cols == 4'b1101) begin
              data <= 32'd12;
            end else if(cols == 4'b1011) begin
              data <= 32'd11;
            end else if(cols == 4'b0111) begin
              data <= 32'd10;
            end
          end   
        end
        SCAN_ROW1:begin
          if(cols == 4'b1111)begin //说明不在这一行
            rows <= 4'b1011;
            state <= SCAN_ROW2;
          end else begin //说明在这一行
            state <= NO_KEY;
            if(cols == 4'b1110)begin
              data <= 32'd15;
            end else if(cols == 4'b1101) begin
              data <= 32'd9;
            end else if(cols == 4'b1011) begin
              data <= 32'd6;
            end else if(cols == 4'b0111) begin
              data <= 32'd3;
            end
          end           
        end
        SCAN_ROW2:begin
          if(cols == 4'b1111)begin //说明不在这一行
            rows <= 4'b0111;
            state <= SCAN_ROW3;
          end else begin //说明在这一行
            state <= NO_KEY;
            if(cols == 4'b1110)begin
              data <= 32'd0;
            end else if(cols == 4'b1101) begin
              data <= 32'd8;
            end else if(cols == 4'b1011) begin
              data <= 32'd5;
            end else if(cols == 4'b0111) begin
              data <= 32'd2;
            end
          end          
        end
        SCAN_ROW3:begin
          if(cols == 4'b1111)begin //说明不在这一行
            rows <= 4'b0000;
            state <= NO_KEY;
          end else begin //说明在这一行
            state <= NO_KEY;
            if(cols == 4'b1110)begin
              data <= 32'd14;
            end else if(cols == 4'b1101) begin
              data <= 32'd7;
            end else if(cols == 4'b1011) begin
              data <= 32'd4;
            end else if(cols == 4'b0111) begin
              data <= 32'd1;
            end
          end           
        end
        YES_KEY:begin
          if( {rows,cols} == 8'b11101110)begin
            data <= 32'd13;
          end else if( {rows,cols} == 8'b11101101)begin
            data <= 32'd12;
          end else if( {rows,cols} == 8'b11101011)begin
            data <= 32'd11;
          end else if( {rows,cols} == 8'b11100111)begin
            data <= 32'd10;
          end else if( {rows,cols} == 8'b11011110)begin
            data <= 32'd15;
          end else if( {rows,cols} == 8'b11011101)begin
            data <= 32'd9;
          end else if( {rows,cols} == 8'b11011011)begin
            data <= 32'd6;
          end else if( {rows,cols} == 8'b11010111)begin
            data <= 32'd3;
          end else if( {rows,cols} == 8'b10111110)begin
            data <= 32'd0;
          end else if( {rows,cols} == 8'b10111101)begin
            data <= 32'd8;
          end else if( {rows,cols} == 8'b10111011)begin
            data <= 32'd5;
          end else if( {rows,cols} == 8'b10110111)begin
            data <= 32'd2;
          end else if( {rows,cols} == 8'b01111110)begin
            data <= 32'd14;
          end else if( {rows,cols} == 8'b01111101)begin
            data <= 32'd7;
          end else if( {rows,cols} == 8'b01111011)begin
            data <= 32'd4;
          end else if( {rows,cols} == 8'b01110111)begin
            data <= 32'd1;
          end else begin
            data <= 32'hffffffff;
          end
          state <= NO_KEY;
        end
        default: begin
          state <= NO_KEY;
        end
      endcase
    end
  end

  always @(*)begin
    if(rst == `Enable) begin
      data_out <= `ZeroWord;
    end else if (addr == 32'hfffffc10 && en == `Enable && we ==`Disable) begin
      data_out <= data;
    end else begin
      data_out <= `ZeroWord;
    end
  end

endmodule