//aribitration.v
//读数据总线仲裁器
//选择正确的外设/ram输出至真正的数据总线上
//by wxy in 2021/01/05

module arbitration(
    input wire clk,

    input wire[`WordRange] ram_data,
    input wire[`WordRange] seven_display_data,
    input wire[`WordRange] keyboard_data,
    input wire[`WordRange] counter_data,
    input wire[`WordRange] pwm_data,
    input wire[`WordRange] uart_data,
    input wire[`WordRange] watch_dog_data,
    input wire[`WordRange] led_light_data,
    input wire[`WordRange] switch_data,
    input wire[`WordRange] buzzer_data,

    input wire[9:0] device_eable,

    output reg[`WordRange] data_out
);


always @(posedge clk)begin
    case (device_eable)
        10'd0:begin
            data_out <= `ZeroWord;
        end 
        10'd1:begin
            data_out <= ram_data;
        end
        10'd2:begin
            data_out <= seven_display_data;
        end
        10'd4:begin
            data_out <= keyboard_data;
        end
        10'd8:begin
            data_out <= counter_data;
        end
        10'd16:begin
            data_out <= pwm_data;
        end
        10'd32:begin
            data_out <= uart_data;
        end
        10'd64:begin
            data_out <= watch_dog_data;
        end
        10'd128:begin
            data_out <= led_light_data;
        end
        10'd256:begin
            data_out <= switch_data;
        end
        10'd512:begin
            data_out <= buzzer_data;
        end
        default: begin
            data_out <= `ZeroWord;
        end
    endcase
end
endmodule