`timescale 1ns / 1ps

module divider (
    input  wire        clk_in,      // 输入时钟
    input  wire        rst_n,       // 复位信号，低电平有效
    input  wire [15:0] div_ratio,   // 分频系数（>=1）
    input  wire [15:0] duty_cycle,  // 占空比（0~div_ratio，值越大高电平越长）
    output reg         clk_out      // 分频后时钟输出
);

// 内部计数器
reg [15:0] cnt;

// 分频逻辑
always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        // 复位状态：计数器清零，输出时钟置低
        cnt     <= 16'd0;
        clk_out <= 1'b0;
    end else begin
        // 处理分频系数为0的特殊情况（按分频比1处理，即不分频）
        // 避免直接使用clk_in赋值，通过计数器实现
        if (div_ratio == 16'd0) begin
            // 分频比为0时，按1分频处理（输出与输入时钟同频）
            cnt <= 16'd0;
            clk_out <= ~clk_out;  // 等价于1分频（每1个周期翻转一次）
        end else begin
            // 计数器达到最大值时复位
            if (cnt >= div_ratio - 16'd1) begin
                cnt <= 16'd0;
            end else begin
                cnt <= cnt + 16'd1;
            end
            
            // 根据占空比控制输出电平
            clk_out <= (cnt < duty_cycle) ? 1'b1 : 1'b0;
        end
    end
end

endmodule