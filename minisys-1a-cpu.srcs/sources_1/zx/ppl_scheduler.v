// ppl_scheduler.v
// 2020-11 @ https://github.com/seu-cs-class2/minisys-1a-cpu

`include "public.v"

// 流水线调度器
module ppl_scheduler (

  input rst,

  // 阻塞请求
  input pause_req_id,
  input pause_req_ex,

  // 阻塞响应
  output reg pause_res_pc,
  output reg pause_res_if,
  output reg pause_res_id,
  output reg pause_res_ex,
  output reg pause_res_mem,
  output reg pause_res_wb 

);

  always @(*) begin
    if (rst == `Enable) begin
      pause_res_pc <= `Disable;
      pause_res_if <= `Disable;
      pause_res_id <= `Disable;
      pause_res_ex <= `Disable;
      pause_res_mem <= `Disable;
      pause_res_wb <= `Disable;
    end else if (pause_req_id == `Enable || pause_req_ex == `Enable) begin
      pause_res_pc <= `Enable;
      pause_res_if <= `Enable;
      pause_res_id <= `Enable;
      pause_res_ex <= `Enable;
      pause_res_mem <= `Enable;
      pause_res_wb <= `Enable;
    end else begin
      pause_res_pc <= `Disable;
      pause_res_if <= `Disable;
      pause_res_id <= `Disable;
      pause_res_ex <= `Disable;
      pause_res_mem <= `Disable;
      pause_res_wb <= `Disable;
    end
  end

endmodule