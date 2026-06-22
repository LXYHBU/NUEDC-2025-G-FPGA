module DDS_Module(
    Clk,
    Reset_n,
    Mode_Sel,      // 波形选择
    Fword,         // 频率控制字
    Pword,         // 相位控制字
    Amp_scale,       // 峰峰值选择
    Data           // 输出数字量
);
    input Clk;
    input Reset_n;
    input [1:0]Mode_Sel;
    input [31:0]Fword;
    input [11:0]Pword;
    input [13:0]Amp_scale;  // 峰峰值档位选择（0~30）
    output reg [13:0]Data;
    
    // --------------------------
    // 1. 适配4V参考电压的峰峰值缩放系数（原8.4V系数×2.1）
    // --------------------------
    
    // --------------------------
    // 2. 频率/相位累加器（保持不变）
    // --------------------------
    reg [31:0]Fword_r;
    always@(posedge Clk)
        Fword_r <= Fword;
    
    reg [11:0]Pword_r;
    always@(posedge Clk)
        Pword_r <= Pword; 
    
    reg [31:0]Freq_ACC;
    always@(posedge Clk or negedge Reset_n)
        if(!Reset_n)
            Freq_ACC <= 0;
        else
            Freq_ACC <= Fword_r + Freq_ACC;
 
    // --------------------------
    // 3. 波形数据表地址（保持不变）
    // --------------------------
    wire [11:0]Rom_Addr;
    assign Rom_Addr = Freq_ACC[31:20] + Pword_r;
    
    wire [13:0]Data_sine, Data_square, Data_triangular;
    rom_sine rom_sine(
        .clka(Clk),
        .addra(Rom_Addr),
        .douta(Data_sine)
    );
    
    rom_square rom_square(
        .clka(Clk),
        .addra(Rom_Addr),
        .douta(Data_square)
    ); 
     
    rom_triangular rom_triangular(
        .clka(Clk),
        .addra(Rom_Addr),
        .douta(Data_triangular)
    );  
    
    // --------------------------
    // 4. 正弦波幅度缩放（保持符号正确）
    // --------------------------
    reg [13:0]Data_sine_scaled;
    reg signed [13:0]offset;        // 有符号偏移（-8192~+8191）
    reg signed [26:0]scaled_offset;  // 缩放后偏移（保留符号）
    always@(*) begin
        // 计算相对于中心8192的偏移
        offset = $signed(Data_sine) - 14'sd8192;
        
        // 按校准后的Amp_scale缩放（适配4V参考电压）
        scaled_offset = offset * $signed(Amp_scale);
        scaled_offset = scaled_offset >>> 13;  // 算术右移保留符号
        
        // 还原为中心8192的输出格式
        Data_sine_scaled = 14'sd8192 + scaled_offset[13:0];
        
        // 边界保护
        if(Data_sine_scaled > 16383)
            Data_sine_scaled = 16383;
        else if(Data_sine_scaled < 0)
            Data_sine_scaled = 0;
    end
    
    // --------------------------
    // 5. 波形选择（保持不变）
    // --------------------------
    always@(*) begin
        case(Mode_Sel)
            0: Data = Data_sine_scaled;  // 正弦波（精细校准后）
            1: Data = Data_square;       // 方波（需单独校准，建议同步放大）
            2: Data = Data_triangular;   // 三角波（需单独校准，建议同步放大）
            3: Data = 14'd8192;          // 直流0V
            default: Data = 14'd8192;
        endcase
    end
    
endmodule