//aribitration.v
//读数据总线仲裁器
//选择正确的外设/ram输出至真正的数据总线上
//by wxy in 2021/01/05
`include "public.v"

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

    input wire[`WordRange] addr,

    output reg[`WordRange] data_out
);


always @(posedge clk)begin
    if(addr[31:16] == 16'h0000)begin
        data_out = ram_data;
    end else if(addr[31:10] == {20'hfffff,2'b11})begin
        case (addr[9:4])
            `IO_SEVEN_DISPLAY: begin
                data_out = seven_display_data;
            end
            `IO_BUZZER: begin
                data_out = buzzer_data;
            end
            `IO_PWM: begin
                data_out = pwm_data;
            end
            `IO_LED_LIGHT: begin
                data_out = led_light_data;
            end
            `IO_SWITCH: begin
                data_out = switch_data;
            end
            `IO_UART: begin
                data_out = uart_data;
            end
            `IO_WATCH_DOG: begin
                data_out = watch_dog_data;
            end
            `IO_COUNTER: begin
                data_out = counter_data;
            end
            `IO_KEYBORAD: begin
                data_out = keyboard_data;
            end
            default: begin
                data_out = `ZeroWord;
            end
        endcase
    end else begin
        data_out = `ZeroWord;
    end
end
endmodule