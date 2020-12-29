`include "../../../sources/cpu/public.v"

// 程序计数器PC测试
module alu_tb();
  // 产生时钟
  reg CLOCK_50MHZ; // T = 20ns
  initial begin
    CLOCK_50MHZ = 1'b0;
    forever #10 CLOCK_50MHZ = ~CLOCK_50MHZ;
  end
  
  // 被测信号
  // ======= 输入 =======
  reg[`WordRange] data1;
  reg[`WordRange] data2;
  reg[`ALUOpRange] op;
  // ======= 输出 =======
  wire[`WordRange] res;
  wire zf; // zero-flag，结果为0时为1
  wire cf; // carry-flag，无符号进位时为1
  wire sf; // sign-flag，为负数时为1
  wire of; // overflow-flag，有符号溢出时为1

  // 例化被测模块
  alu u_alu(
    .data1(data1),
    .data2(data2),
    .op(op),
    .res(res),
    .zf(zf),
    .cf(cf),
    .sf(sf),
    .of(of)
  );

  // 描述测试过程
  initial begin
    #100 begin // nop
      op <= `ALUOP_NOP;
    end
    #100 begin // 无符号加
      data1 <= 32'd1;
      data2 <= 32'd4294967294;
      op <= `ALUOP_ADDU; // 4294967295
    end
    #100 begin // 有符号加
      data1 <= 32'd1;
      data2 <= 32'd4294967294; // -2
      op <= `ALUOP_ADD; // -1（4294967295）
    end
    #100 begin // 无符号减
      data1 <= 32'd1;
      data2 <= 32'd4294967294;
      op <= `ALUOP_SUBU; // 3
    end
    #100 begin // 有符号减
      data1 <= 32'd1;
      data2 <= 32'd4294967294; // -2
      op <= `ALUOP_SUB; // 3
    end
    #100 begin // 按位与
      data1 <= 32'h12345678;
      data2 <= 32'h87654321;
      op <= `ALUOP_AND; // 0224 4220 H
    end
    #100 begin // 按位或
      data1 <= 32'h12345678;
      data2 <= 32'h87654321;
      op <= `ALUOP_OR; // 9775 5779 H
    end
    #100 begin // 按位异或
      data1 <= 32'h12345678;
      data2 <= 32'h87654321;
      op <= `ALUOP_XOR; // 9551 1559 H
    end
    #100 begin // 按位或非
      data1 <= 32'h12345678; 
      data2 <= 32'h87654321;
      op <= `ALUOP_NOR; // 688A A886 H
    end
    #100 begin // 逻辑左移
      data1 <= 32'd5;
      data2 <= 32'd35;
      op <= `ALUOP_SLL; // 0000 0460 H
    end
    #100 begin // 逻辑右移
      data1 <= 32'd5;
      data2 <= 32'd35;
      op <= `ALUOP_SRL; // 0000 0001 H
    end
    #100 begin // 算术右移
      data1 <= 32'd5;
      data2 <= 32'hF000_0024;
      op <= `ALUOP_SRA; // FF80 0001 H
    end
    #100 begin // 有符号less-than
      data1 <= 32'd1;
      data2 <= 32'd4294967294; // -2
      op <= `ALUOP_SLT; // FALSE
    end
    #100 begin // 无符号less-than
      data1 <= 32'd1;
      data2 <= 32'd4294967294;
      op <= `ALUOP_SLTU; // TRUE
    end
    // 结束
    #100 $stop;
  end

endmodule