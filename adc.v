`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 河北大学
// Engineer: 柳晓阳
// 
// Create Date: 2025/07/24 20:46:53
// Design Name: ADC采集与测试系统
// Module Name: adc
// Project Name: 全国大学生电子设计竞赛
// Target Devices: Xilinx ZYNQ-7010
// Tool Versions: Vivado 2018.3
// Description: 实现高精度ADC数据采集，为后续FFT频谱分析提供数据基础。
//              包含采样时钟生成、数据同步、采样率控制等功能。
// 
// Dependencies: 0
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 1. 输入时钟为50MHz系统时钟
// 2. 支持最高65MSPS采样率
// 3. 输出数据位宽12bit
// 
//////////////////////////////////////////////////////////////////////////////////
module adc(
    input ad_clk,
    input Rst,
    input [11:0] ad1_in,
    output reg [11:0] ad_ch1
);
always @(posedge ad_clk or negedge Rst) begin
    if(!Rst)begin
        ad_ch1<=12'b0;
    end
    else begin
        ad_ch1<=ad1_in;
    end

end
endmodule
