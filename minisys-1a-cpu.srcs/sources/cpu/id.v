// id.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 指令译码模块
// 对指令进行译码，输出包括：
// 源操作数1、源操作数2、写入的目的寄存器的运算类型（逻辑、移位、算术）
module id (

  input rst, // 复位
  input wire[`WordRange] pc_in, // 输入的PC值，译码阶段指令地址
  input wire[`WordRange] ins_in, // 输入的指令，即取出的指令

  input wire[`WordRange] reg1_data_in, // 输入的寄存器数据1
  input wire[`WordRange] reg2_data_in, // 输入的寄存器数据2

  output reg reg1_re_out, // 寄存器读使能1
  output reg reg2_re_out, // 寄存器读使能2
  output reg[`RegRangeLog2] reg1_addr_out, // 寄存器读地址1
  output reg[`RegRangeLog2] reg2_addr_out, // 寄存器读地址2

  output reg[`ALUOpRange] aluop_out, // 输出的ALUOp

  output reg[`WordRange] data1_out, // 输出的数据1
  output reg[`WordRange] data2_out, // 输出的数据2
  
  output reg wreg_e_out, // 写寄存器使能输出
  output reg[`RegRangeLog2] wreg_addr_out, // 写寄存器地址输出

  // 下面部分用于采用数据前推（转移）法解决相隔0条（ID-EX）和相隔1条（ID-MEM）阶段的RAW数据相关
  // EX阶段运算结果（即上条指令）
  input wire ex_wreg_e_in,
  input wire[`WordRange] ex_wreg_data_in,
  input wire[`RegRangeLog2] ex_wreg_addr_in,
  // MEM阶段运算结果（上两条指令）
  input wire mem_wreg_e_in,
  input wire[`WordRange] mem_wreg_data_in,
  input wire[`RegRangeLog2] mem_wreg_addr_in,

  output reg pause_req, // 要求进行流水暂停信号

  input wire in_delayslot_in, // 当前要进入（译码阶段）指令是否是延迟槽内指令（必须执行）
  output reg in_delayslot_out,  // 当前要出（译码阶段）指令是否是延迟槽内指令（必须执行）
  output reg next_in_delayslot_out, // 下条指令是否处是延迟槽内指令（即当前指令是否要跳转）
  output reg branch_e_out,  // 分支生效信号
  output reg[`WordRange] branch_addr_out, // 分支跳转地址
  output reg[`WordRange] link_addr_out, // 转移指令需要保存的地址
  
  output wire[`WordRange] ins_out   // 向流水线后续传递的指令 在添加存储指令时需要用到

);

  // 指令的各个可能组成
  wire[5:0] op = ins_in[`OpRange];
  wire[4:0] rs = ins_in[`RsRange];
  wire[4:0] rt = ins_in[`RtRange];
  wire[4:0] rd = ins_in[`RdRange];
  wire[4:0] shamt = ins_in[`ShamtRange];
  wire[5:0] func = ins_in[`FuncRange];
  wire[15:0] immediate = ins_in[`ImmedRange];
  wire[15:0] offset = ins_in[`OffsetRange];
  wire[25:0] address = ins_in[`AddressRange];

  reg[`WordRange] immed; // 指令中的立即数的扩展结果

  // PC+4和PC+8
  wire[`WordRange] pc_plus_4;
  assign pc_plus_4 = pc_in + 32'd4;
  wire[`WordRange] pc_plus_8;
  assign pc_plus_8 = pc_in + 32'd8;

  assign ins_out = ins_in;  // 直接向下传递

  // 指令译码
  always @(*) begin
    // rst时关掉所有使能，清空立即数
    if (rst == `Enable) begin
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
    // 具体译码逻辑
    end else begin
      // 先赋默认值，以免有些指令不需要修改其中一些值时出现错误
      aluop_out <= `ALUOP_NOP;
      wreg_e_out <= `Disable;
      reg1_re_out <= `Disable;
      reg2_re_out <= `Disable;
      immed <= `ZeroWord;
      link_addr_out <= `ZeroWord;
      next_in_delayslot_out <= `Disable;
      branch_e_out <= `Disable;
      // 根据op翻译
      // R类指令（寄存器操作类型，除了eret指令之外，op全为000000）
      if (op == `OP_RTYPE) begin
        case (func)
          `FUNC_OR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_AND: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;  
          end
          `FUNC_XOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_NOR: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_NOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRLV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SRAV: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRA;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLL: begin
            if (rt == 0 && rd == 0 && shamt == 0) begin // 说明是NOP
              aluop_out <= `ALUOP_NOP;
              wreg_e_out <= `Disable;
              reg1_re_out <= `Disable;
              reg2_re_out <= `Disable;
              immed <= `ZeroWord;
              link_addr_out <= `ZeroWord;
            end else begin
              wreg_e_out <= `Enable;
              wreg_addr_out <= rd;
              aluop_out <= `ALUOP_SLL;
              reg1_re_out <= `Disable;
              reg2_re_out <= `Enable;
              reg2_addr_out <= rt;
              immed <= {27'h0, shamt};
            end             
          end
          `FUNC_SRL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SRL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          `FUNC_SRA: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            immed <= {27'h0, shamt};
          end
          // 注意HI/LO不在32个寄存器组中，使能不要给错
          `FUNC_MFHI: begin   // MFHI 读HI至rd
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFHI;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MFLO: begin   // MFLO 读LO至rd
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_MFLO;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTHI: begin   // MTHI 写rs至HI
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_MTHI;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `FUNC_MTLO: begin
            wreg_e_out <= `Disable; // 此处虽然写HI和LO但是寄存器写使能为disable
            aluop_out <= `EXOP_MTLO;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `FUNC_SLT: begin   // 比大小
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLT;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SLTU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SLTU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_ADD: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_ADD;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_ADDU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_ADDU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SUB: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SUB;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_SUBU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_SUBU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_DIV: begin
            wreg_e_out <= `Disable;
            aluop_out <= `ALUOP_DIV;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_DIVU: begin
            wreg_e_out <= `Disable;
            aluop_out <= `ALUOP_DIVU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_MULT: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_MULT;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_MULTU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `ALUOP_MULTU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `FUNC_JR: begin   // rs->pc
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_JR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            branch_e_out <= `Enable;
            branch_addr_out <= data1_out;
            next_in_delayslot_out <= `Enable;
          end
          `FUNC_JALR: begin   // rd->PC+4; PC->rs(rd=$31,rs=$1)
            wreg_e_out <= `Enable;
            wreg_addr_out <= rd;
            aluop_out <= `EXOP_JALR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            branch_e_out <= `Enable;
            branch_addr_out <= data1_out;
            link_addr_out <= pc_plus_8;
            next_in_delayslot_out <= `Enable;
          end
        endcase
      end else begin
        // I类或J类
        case (op)
          `OP_ORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_ANDI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_AND;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_XORI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_XOR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {16'h0, ins_in[`ImmedRange]};
          end
          `OP_LUI: begin
            // 借助rs=$0的特性，可等价如下实现
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_OR;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {ins_in[`ImmedRange], 16'h0};
          end
          `OP_SLTI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_SLT;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {{16{ins_in[15]}}, ins_in[15:0]}; // sign-ext
          end
          `OP_SLTIU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_SLTU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {{16{ins_in[15]}}, ins_in[15:0]}; // sign-ext
          end
          `OP_ADDI: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_ADD;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {{16{ins_in[15]}}, ins_in[15:0]}; // sign-ext
          end
          `OP_ADDIU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `ALUOP_ADDU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            immed <= {{16{ins_in[15]}}, ins_in[15:0]}; // sign-ext
          end
          `OP_J: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_J;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
            branch_e_out <= `Enable;
            branch_addr_out <= {4'b0000, address[25:0], 2'b00};
            next_in_delayslot_out <= `Enable;
          end
          `OP_JAL: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= 5'd31; // $ra
            aluop_out <= `EXOP_JAL;
            reg1_re_out <= `Disable;
            reg2_re_out <= `Disable;
            branch_e_out <= `Enable;
            branch_addr_out <= {4'b0000, address[25:0], 2'b00};
            next_in_delayslot_out <= `Enable;
          end
          `OP_BEQ: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_BEQ;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            if (data1_out == data2_out) begin
              branch_e_out <= `Enable;
              branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
              next_in_delayslot_out <= `Enable;
            end
          end
          `OP_BGTZ: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_BGTZ;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            if (data1_out[31] == 1'b0 && data1_out != `ZeroWord) begin
              branch_e_out <= `Enable;
              branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
              next_in_delayslot_out <= `Enable;
            end
          end
          `OP_BLEZ: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_BLEZ;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            if (data1_out[31] == 1'b1 || data1_out == `ZeroWord) begin
              branch_e_out <= `Enable;
              branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
              next_in_delayslot_out <= `Enable;
            end
          end
          `OP_BNE: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_BNE;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
            if (data1_out != data2_out) begin
              branch_e_out <= `Enable;
              branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
              next_in_delayslot_out <= `Enable;
            end
          end
          `OP_BGEZ: begin
            if(rt == 5'b00001)begin
              wreg_e_out <= `Disable;
              aluop_out <= `EXOP_BGEZ;
              reg1_re_out <= `Enable;
              reg1_addr_out <= rs;
              reg2_re_out <= `Disable;
              if (data1_out[31] == 1'b0) begin
                branch_e_out <= `Enable;
                branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
                next_in_delayslot_out <= `Enable;
              end
            end else if(rt == 5'b10001) begin  //bgezal
              wreg_e_out <= `Enable;
              wreg_addr_out <= `RegCountLog2'd31;
              aluop_out <= `EXOP_BGEZAL;
              reg1_re_out <= `Enable;
              reg1_addr_out <= rs;
              reg2_re_out <= `Disable;
              link_addr_out <= pc_plus_8;
              if (data1_out[31] == 1'b0) begin
                branch_e_out <= `Enable;
                branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
                next_in_delayslot_out <= `Enable;
              end
            end else if(rt == 5'b10000) begin //bltzal
              wreg_e_out <= `Enable;
              wreg_addr_out <= `RegCountLog2'd31;
              aluop_out <= `EXOP_BLTZAL;
              reg1_re_out <= `Enable;
              reg1_addr_out <= rs;
              reg2_re_out <= `Disable;
              link_addr_out <= pc_plus_8;
              if (data1_out[31] == 1'b1) begin
                branch_e_out <= `Enable;
                branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
                next_in_delayslot_out <= `Enable;
              end
            end  
          end
          `OP_BLTZ: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_BLTZ;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
            if (data1_out[31] == 1'b1) begin
              branch_e_out <= `Enable;
              branch_addr_out <= pc_plus_4 + {{14{offset[15]}}, offset[15:0], 2'b00};
              next_in_delayslot_out <= `Enable;
            end
          end
          // 访存相关指令
          `OP_LB: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `EXOP_LB;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `OP_LBU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `EXOP_LBU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `OP_LH: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `EXOP_LH;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `OP_LHU: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `EXOP_LHU;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `OP_SB: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_SB;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `OP_SH: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_SH;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `OP_LW: begin
            wreg_e_out <= `Enable;
            wreg_addr_out <= rt;
            aluop_out <= `EXOP_LW;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Disable;
          end
          `OP_SW: begin
            wreg_e_out <= `Disable;
            aluop_out <= `EXOP_SW;
            reg1_re_out <= `Enable;
            reg1_addr_out <= rs;
            reg2_re_out <= `Enable;
            reg2_addr_out <= rt;
          end
          `OP_CP0:begin
            if(rs == 5'b00000) begin //是mfc0
              wreg_e_out <= `Enable;
              wreg_addr_out <= rt;
              aluop_out <= `EXOP_MFC0;
              reg1_re_out <= `Disable;
              reg2_re_out <= `Disable;
            end
            if(rs == 5'b00100) begin //是mtc0
              wreg_e_out <= `Disable;
              aluop_out <= `EXOP_MTC0;
              reg1_re_out <= `Enable;
              reg1_addr_out <= rt;
              reg2_re_out <= `Disable;
            end
          end
          default: begin 
          end
        endcase
      end
    end
  end

  always @(*) begin
    if (rst == `Enable) begin
      in_delayslot_out <= `Disable;     
    end else begin
      in_delayslot_out <= in_delayslot_in;
    end
  end

  // 下面开始确定送到ALU的数据具体来自于哪里
  // 这取决于来源：是寄存器，还是立即数
  always @(*) begin
    // rst时固定出0x0
    if (rst == `Enable) begin
      data1_out <= `ZeroWord;
    // 解决相隔0条（ID-EX）的流水数据相关
    // 如果前面的EX要写的就是后面的ID要读的，则穿透（转发）
    end else if (ex_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == ex_wreg_addr_in) begin
      data1_out <= ex_wreg_data_in;
    // 解决相隔1条（ID-MEM）的流水数据相关
    // 如果前面的MEM要写的就是后面的ID要读的，则穿透（转发）
    end else if (mem_wreg_e_in == `Enable && reg1_re_out == `Enable && reg1_addr_out == mem_wreg_addr_in) begin
      data1_out <= mem_wreg_data_in;  
    // 如果指令译码的结果需要读reg1，就说明操作数1来自寄存器（rs）
    end else if (reg1_re_out == `Enable) begin
      data1_out <= reg1_data_in;
    // 如果指令译码的结果不需要读reg1，就说明操作1是立即数
    end else if (reg1_re_out == `Disable) begin
      data1_out <= immed;
    // 兜底
    end else begin
      data1_out <= `ZeroWord;
    end
  end

  // 逻辑同上
  always @(*) begin
    if (rst == `Enable) begin
      data2_out <= `ZeroWord;
    end else if (ex_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == ex_wreg_addr_in) begin
      data2_out <= ex_wreg_data_in;
    end else if (mem_wreg_e_in == `Enable && reg2_re_out == `Enable && reg2_addr_out == mem_wreg_addr_in) begin
      data2_out <= mem_wreg_data_in;  
    end else if (reg2_re_out == `Enable) begin //（rt）
      data2_out <= reg2_data_in;
    end else if (reg2_re_out == `Disable) begin
      data2_out <= immed;
    end else begin
      data2_out <= `ZeroWord;
    end
  end

endmodule