// timer.v
// https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 定时器
module timer (

  input rst, // 复位
  input clk, // 时钟

  input cs, // 片选
  input rd, // 读模式
  input wr, // 写模式
  input [2:0] port, // 内部寄存器端口选择，方式寄存器：0/2，初始值寄存器：4/6

  input [15:0] data, // 输入数据

  output reg[15:0] out1, // CNT1输出
  output reg[15:0] out2, // CNT2输出

  output reg cout1, // COUT1，低电平有效
  output reg cout2 // COUT2，低电平有效

);

  // 方式寄存器
  reg[15:0] config1;
  reg[15:0] config2;
  // 状态寄存器
  reg[15:0] status1;
  reg[15:0] status2;
  // 初始值寄存器
  reg[15:0] init1;
  reg[15:0] init2;
  // 当前值寄存器
  reg[15:0] current1;
  reg[15:0] current2;

  // 重置逻辑以及对内部寄存器的访问
  always @(posedge clk) begin
    if (rst == `Enable) begin
      config1 <= 16'd0;   config2 <= 16'd0;
      status1 <= 16'd0;   status2 <= 16'd0;
      init1 <= 16'd0;     init2 <= 16'd0;
      current1 <= 16'd0;  current2 <= 16'd0;
      out1 <= 16'd0;      out2 <= 16'd0;
      cout1 <= `Enable;   cout2 <= `Enable;
    end else begin
      if (cs == `Enable) begin
        if (wr == `Enable) begin
          // 处理对只写寄存器的访问
          if (port == 3'h0) begin
            config1 <= data;
            // 方式寄存器设置后还没有写计数初始值时，状态寄存器有效位置0
            status1 <= status1 & 16'h7FFF;
          end
          if (port == 3'h2) begin
            config2 <= data;
            status2 <= status2 & 16'h7FFF;
          end
          if (port == 3'h4) begin
            init1 <= data;
            // 写好计数初始值后，状态寄存器有效位置1
            status1 <= status1 | 16'h8000;
          end
          if (port == 3'h6) begin
            init2 <= data;
            status2 <= status2 | 16'h8000;
          end
        end else if (rd == `Enable) begin
          // 处理对只读寄存器的访问
          if (port == 3'h0) begin
            out1 <= status1;
          end
          if (port == 3'h2) begin
            out2 <= status2;
          end
          if (port == 3'h4) begin
            out1 <= current1;
          end
          if (port == 3'h6) begin
            out1 <= current2;
          end
        end
      end
    end
  end

  // 按照时钟对CNT1进行步进
  always @(posedge clk) begin
    current1 <= current1 - 16'd1;
    // 处理边界逻辑
    if (config1[0] == `Disable) begin
      // 定时模式  
      if (current1 == 16'd1) begin
        // 设置状态寄存器有效位为0，定时到位为1
        status1 <= status1 & 16'h7FFF | 16'h0001;
        cout1 <= `Disable;
      end
    end else begin
      // 计数模式
      if (current1 == 16'd0) begin
        // 设置状态寄存器有效位为0，计数到位为1
        status1 <= status1 & 16'h7FFF | 16'h0002;
        cout1 <= `Disable;
      end
    end
  end

  // 按照时钟对CNT2进行步进
  always @(posedge clk) begin
    current2 <= current2 - 16'd1;
    // 处理边界逻辑
    if (config2[0] == `Disable) begin
      // 定时模式  
      if (current2 == 16'd1) begin
        // 设置状态寄存器有效位为0，定时到位为1
        status2 <= status2 & 16'h7FFF | 16'h0001;
        cout1 <= `Disable;
      end
    end else begin
      // 计数模式
      if (current2 == 16'd0) begin
        // 设置状态寄存器有效位为0，计数到位为1
        status2 <= status2 & 16'h7FFF | 16'h0002;
        cout1 <= `Disable;
      end
    end
  end

  // 进一步处理计数到后的重复逻辑
  always @(cout1) begin
    if (cout1 == `Disable) begin
      if (config1[1] == `Enable) begin // 重复模式
        current1 <= init1;
        cout1 <= `Enable;
      end else begin // 非重复模式
        // TODO
      end
    end
  end

  always @(cout2) begin
    if (cout2 == `Disable) begin
      if (config2[1] == `Enable) begin // 重复模式
        current2 <= init2;
        cout2 <= `Enable;
      end else begin // 非重复模式
        // TODO
      end
    end
  end

endmodule