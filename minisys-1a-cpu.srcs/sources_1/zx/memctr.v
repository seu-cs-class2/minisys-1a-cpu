//memctr.v
//控制cpu访问ram与外设用，同时充当总线仲裁器
//集成在cpu内部，作为cpu主要外部访问接口
//by wxy in 2021/01/04

//不再使用  采用总线方法之后不需要memctr
`include "public.v"

module memctr(
    input wire rst,
    input wire[`WordRange] cpu_addr_in, //访存阶段发送过来的地址
    input wire cpu_eable_in, //访存阶段发送来的有效信号
    input wire cpu_we_in, //访存阶段发送过来的写有效信号（eable有效时）
    input wire[`WordRange] cpu_data_in, //访存阶段发送过来的写入数据

    output reg[`WordRange] cpu_data_out, //外设或ram发送给cpu的数据

    output reg[`WordRange] ram_io_addr_out, //发送给外设或ram的地址（使用地址总线发送）
    output reg[`WordRange] ram_io_data_out, //发送给外设或ram的写入数据（使用数据总线发送）
    output reg ram_io_we_out, //发送给外设或ram的写有效信号（使用控制总线发送）

    output reg ram_eable, //是否选中ram
    output reg keyboard_eable,
    output reg seven_dispaly_eable,
    output reg buzzer_eable,
    output reg counter_eable,
    output reg pwm_eable,
    output reg uart_eable,
    output reg watch_dog_eable,
    output reg led_eable,
    output reg switch_eable,
    //后续在这里添加cpu给外设设备的输出

    input wire[`WordRange] ram_data_in,
    input wire[`WordRange] keyboard_data_in,
    input wire[`WordRange] counter_data_in,
    input wire[`WordRange] pwm_data_in,
    input wire[`WordRange] uart_data_in,
    input wire[`WordRange] watch_dog_data_in,
    input wire[`WordRange] switch_data_in
    //后续在这里添加外设给cpu的输入(有个问题，比如说led灯这类的外设，需不需要有数据输入呢？)
);



always @(*) begin
    if(rst == `Enable)begin
        ram_io_addr_out <= `ZeroWord;
        ram_io_data_out <= `ZeroWord;
        ram_io_we_out <= `Disable;
        
        ram_eable <= `Disable;
        keyboard_eable <= `Disable;
        led_eable <= `Disable;
        switch_eable <= `Disable;
        seven_dispaly_eable <= `Disable;
        buzzer_eable <= `Disable;
        counter_eable <= `Disable;
        pwm_eable <= `Disable;
        uart_eable <= `Disable;
        watch_dog_eable <= `Disable;

        cpu_data_out <= `ZeroWord;
    end else begin
        ram_io_addr_out <= cpu_addr_in;
        ram_io_data_out <= cpu_data_in;
        ram_io_we_out <= cpu_we_in;

        ram_eable <= `Disable;
        keyboard_eable <= `Disable;
        led_eable <= `Disable;
        switch_eable <= `Disable;
        seven_dispaly_eable <= `Disable;
        buzzer_eable <= `Disable;
        counter_eable <= `Disable;
        pwm_eable <= `Disable;
        uart_eable <= `Disable;
        watch_dog_eable <= `Disable;
        //后续在这里添加外设控制信号的初始化

        cpu_data_out <= `ZeroWord

        if(cpu_addr_in[31:16] == 16'h0000)begin  //cpu发送来的地址信号的高16位全为0，说明访问的是ram，此时让ram的控制信号有效
            ram_eable <= `Enable;
            cpu_data_out <= ram_data_in; //这么做合适吗？需不需要判断是否为读
        end
        if(cpu_addr_in[31:10] == 22'b1111111111111111111111)begin //cpu发送来的地址信号高22位全为1，说明访问外设，此时需要开始译码外设地址，分别给控制信号
            case (cpu_addr_in[9:4]) //低十位中的高六位用来译码io单元，低四位作为一个io设备的内部地址
                `IO_SEVEN_DISPLAY:begin
                    seven_dispaly_eable <= `Enable;
                end 
                `IO_KEYBORAD:begin
                    keyboard_eable <= `Enable;
                    cpu_data_out <= keyboard_data_in;
                end
                `IO_COUNTER:begin
                    counter_eable <= `Enable;
                    cpu_data_out <= counter_data_in;
                end
                `IO_PWM:begin
                    pwm_eable <= `Enable;
                    cpu_data_out <= pwm_data_in;
                end
                `IO_UART:begin
                    uart_eable <= `Enable;
                    cpu_data_out <= uart_data_in;
                end
                `IO_WATCH_DOG:begin
                    watch_dog_eable <= `Enable;
                    cpu_data_out <= watch_dog_data_in;
                end
                `IO_LED_LIGHT:begin
                    led_eable <= `Enable;
                end
                `IO_SWITCH:begin
                    switch_eable <= `Enable;
                    cpu_data_out <= switch_data_in;
                end
                `IO_BUZZER:begin
                    buzzer_eable <= `Enable;
                end
            endcase    
        end   
    end
end
endmodule