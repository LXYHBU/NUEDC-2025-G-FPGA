`timescale 1ns / 1ps

module iir_biquad_32bit (
    input  wire        clk,      // 建议接入 4MHz 采样时钟
    input  wire        rst_n,
    
    // 数据通路
    input  wire [11:0] ad_in,    // 12-bit ADC 原始输入
    output wire [13:0] da_out,   // 14-bit DAC 滤波输出
    
    // 可重构系数接口 (32位有符号数，Q4.28 定点数格式)
    // 范围: -8.0 到 +7.999... 精度: 1/2^28
    input  wire signed [31:0] b0,
    input  wire signed [31:0] b1,
    input  wire signed [31:0] b2,
    input  wire signed [31:0] a1,
    input  wire signed [31:0] a2
);

    // 1. ADC 无符号偏移码 -> 有符号补码 (去除直流偏置)
    // 例如：12'h800 变为 0; 12'hFFF 变为 +2047; 12'h000 变为 -2048
    wire signed [12:0] x_in = {~ad_in[11], ad_in[10:0]};

    // 2. 状态寄存器 (X 和 Y 的历史值)
    reg signed [12:0] x_d1, x_d2;
    reg signed [16:0] y_d1, y_d2; // Y的历史值留一定余量防溢出

    // 3. 乘法器阵列 (13/17 bit * 32 bit = 45/49 bit)
    wire signed [44:0] mult_b0 = x_in * b0;
    wire signed [44:0] mult_b1 = x_d1 * b1;
    wire signed [44:0] mult_b2 = x_d2 * b2;
    wire signed [48:0] mult_a1 = y_d1 * a1;
    wire signed [48:0] mult_a2 = y_d2 * a2;

    // 4. 加法树累加器 (扩展到 50 位防止溢出)
    // 对应公式: y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]
    wire signed [49:0] acc = mult_b0 + mult_b1 + mult_b2 - mult_a1 - mult_a2;

    // 5. Q28 格式恢复 (算术右移 28 位)
    wire signed [16:0] y_n = acc >>> 28;

    // 移位寄存器更新
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_d1 <= 0; x_d2 <= 0;
            y_d1 <= 0; y_d2 <= 0;
        end else begin
            x_d1 <= x_in;
            x_d2 <= x_d1;
            y_d1 <= y_n;
            y_d2 <= y_d1;
        end
    end

    // 6. 有符号补码 -> DAC 无符号偏移码 (加回 DAC 的 14位 中心点 8192)
    wire signed [17:0] y_offset = y_n + 18'sd8192;
    
    // 7. 防溢出饱和限幅保护 (极度关键，防止滤波发散震荡)
    assign da_out = (y_offset > 18'sd16383) ? 14'd16383 :
                    (y_offset < 18'sd0)     ? 14'd0     : y_offset[13:0];

endmodule