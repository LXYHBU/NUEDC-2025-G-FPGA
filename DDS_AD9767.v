module DDS_AD9767(
    CLK125M,
    Reset_n,
    DataA,
    Rx_Data_0,
    Rx_Data_1,
    Rx_Data_2,
    Rx_Data_3,
    Rx_Data_4,
    Rx_Data_5,
    Rx_Data_6,
    Rx_Data_7,
    Rx_Data_8,
    Rx_Data_9,
	uart_rx_axis_tvalid,
    state,
	Develop_two_flag
);//ver1.1
    input CLK125M;
    input Reset_n;
    output [13:0]DataA;
    input [7:0]Rx_Data_0;
    input [7:0]Rx_Data_1;
    input [7:0]Rx_Data_2;
    input [7:0]Rx_Data_3;
    input [7:0]Rx_Data_4;
    input [7:0]Rx_Data_5;
    input [7:0]Rx_Data_6;
    input [7:0]Rx_Data_7;
    input [7:0]Rx_Data_8;
    input [7:0]Rx_Data_9;
	input uart_rx_axis_tvalid;
    input [2:0]state;
	output reg Develop_two_flag;
    
    reg     [31:0]FwordA;//Ƶ�ʿ�����

    wire    [1:0]Mode_SelA=2'b0;//���Ҳ�

    reg     [4:0]CHA_Fword_Sel;//Ƶ��

    wire    [11:0]PwordA=12'b0;//��λƫ��0

    reg     [13:0]Amp_scale; //���ȿ���
    parameter Basic_two    =3'd0;//������2
    parameter Basic_three  =3'd1;//������3
    parameter Basic_four   =3'd2;//������4
    parameter Develop_one  =3'd3;//������1
    parameter Develop_two  =3'd4;//������2
   
    DDS_Module DDS_ModuleA(
        .Clk(CLK125M),
        .Reset_n(Reset_n),
        .Mode_Sel(Mode_SelA),
        .Fword(FwordA),
        .Pword(PwordA),
        .Data(DataA),
        .Amp_scale(Amp_scale)
    );
//ɨƵ
reg [9:0]fre_cnt;//Ŀǰ491�������������ܷ���
always @(posedge CLK125M or negedge Reset_n) begin
	if(!Reset_n)
		fre_cnt<=0;
	else if(uart_rx_axis_tvalid&&(state==Develop_one))begin
		if(fre_cnt>490)
			fre_cnt<=490;
		else fre_cnt<=fre_cnt+1;
	end
end

    
always @(posedge CLK125M or negedge Reset_n) begin//״̬��
    if(!Reset_n)begin
        FwordA <= 32'd3436;// 100Hz 
        Amp_scale<=7167;//不小ￄ1�7??3V
		Develop_two_flag<=0;
    end
    else begin
        case(state)
        Basic_two:begin
            Amp_scale<=7167;// ����3V
            case(Rx_Data_0)   
            8'h0:FwordA <= 32'd3436;    // 100Hz 
            8'h1:FwordA <= 32'd6872;    // 200Hz 
            8'h2:FwordA <= 32'd10308;   // 300Hz
            8'h3:FwordA <= 32'd13744;   // 400Hz
            8'h4:FwordA <= 32'd17180;   // 500Hz
            8'h5:FwordA <= 32'd20616;   // 600Hz
            8'h6:FwordA <= 32'd24052;   // 700Hz
            8'h7:FwordA <= 32'd27488;   // 800Hz
            8'h8:FwordA <= 32'd30924;   // 900Hz
            8'h9:FwordA <= 32'd34360;   // 1000Hz
            8'h10:FwordA <= 32'd37796;  // 1100Hz
            8'h11:FwordA <= 32'd41232;  // 1200Hz
            8'h12:FwordA <= 32'd44668;  // 1300Hz
            8'h13:FwordA <= 32'd48104;  // 1400Hz
            8'h14:FwordA <= 32'd51540;  // 1500Hz
            8'h15:FwordA <= 32'd54976;  // 1600Hz
            8'h16:FwordA <= 32'd58412;  // 1700Hz
            8'h17:FwordA <= 32'd61848;  // 1800Hz
            8'h18:FwordA <= 32'd65284;  // 1900Hz
            8'h19:FwordA <= 32'd68720;  // 2000Hz
            8'h20:FwordA <= 32'd72156;  // 2100Hz
            8'h21:FwordA <= 32'd75592;  // 2200Hz
            8'h22:FwordA <= 32'd79028;  // 2300Hz
            8'h23:FwordA <= 32'd82464;  // 2400Hz
            8'h24:FwordA <= 32'd85900;  // 2500Hz
            8'h25:FwordA <= 32'd89336;  // 2600Hz
            8'h26:FwordA <= 32'd92772;  // 2700Hz
            8'h27:FwordA <= 32'd96208;  // 2800Hz
            8'h28:FwordA <= 32'd99644;  // 2900Hz
            8'h29:FwordA <= 32'd103080; // 3000Hz
            8'h30:FwordA <= 32'd34359738;////////////1MHZ
            8'h31:FwordA <=32'd68719476;/////////////2MHZ
            default:FwordA <= 32'd3436;//100HZ
            endcase
        end
        Basic_three:begin
            FwordA <= 32'd34360;
            Amp_scale<=14'd1563;
        end
        Basic_four:begin

		case({Rx_Data_1,Rx_Data_0})
			{8'h01,8'h00}: begin
								FwordA <= 32'd3436;//					100Hz
								Amp_scale = 415;     // 0.20274517V
							end
			{8'h01,8'h01}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  457;     // 0.223019687V
							end
			{8'h01,8'h02}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  499;     // 0.243294204V
							end
			{8'h01,8'h03}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  541;     // 0.26356872V
							end
			{8'h01,8'h04}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  583;     // 0.283843237V
							end
			{8'h01,8'h05}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  625;     // 0.304117754V
							end
			{8'h01,8'h06}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale = 667;     // 0.324392271V
							end
			{8'h01,8'h07}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  709;     // 0.344666788V
							end
			{8'h01,8'h08}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  751;     // 0.364941305V
							end
			{8'h01,8'h09}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  793;     // 0.385215822V
							end
			{8'h01,8'h0a}:begin
							FwordA <= 32'd3436;//Ƶ��
							Amp_scale =  835;     // 0.405490339V
							end
			{8'h01,8'h0b}: begin
								FwordA <= 32'd6872;    // 						200Hz 
								Amp_scale =  432;     // 0.210788137V
							end
			{8'h01,8'h0c}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =   474;     // 0.231866951V
							end
			{8'h01,8'h0d}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  516;     // 0.252945764V
							end
			{8'h01,8'h0e}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  558;     // 0.274024578V
							end
			{8'h01,8'h0f}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  600;     // 0.295103392V
							end
			{8'h01,8'h10}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  642;     // 0.316182205V
							end
			{8'h01,8'h11}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale = 684;     // 0.337261019V
							end
			{8'h01,8'h12}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  726;     // 0.358339833V
							end
			{8'h01,8'h13}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  768;     // 0.379418646V
							end
			{8'h01,8'h14}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  810;     // 0.40049746V
							end
			{8'h01,8'h15}:begin
							FwordA <= 32'd6872;//Ƶ��
							Amp_scale =  852;     // 0.421576274V
							end
			{8'h01,8'h16}: begin
								FwordA <= 32'd10308;   // 							300Hz
								Amp_scale =  458;     // 0.223603596V
							end
			{8'h01,8'h17}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  499;     // 0.245963955V
							end
			{8'h01,8'h18}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  540;     // 0.268324315V
							end
			{8'h01,8'h19}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  581;     // 0.290684674V
							end
			{8'h01,8'h1a}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale = 622;     // 0.313045034V
							end
			{8'h01,8'h1b}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale = 663;     // 0.335405393V
							end
			{8'h01,8'h1c}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =733;     // 0.357765753V
							end
			{8'h01,8'h1d}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  778;     // 0.380126112V
							end
			{8'h01,8'h1e}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  786;     // 0.402486472V
							end
			{8'h01,8'h1f}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale =  827;     // 0.424846832V
							end
			{8'h01,8'h20}:begin
							FwordA <= 32'd10308;//Ƶ��
							Amp_scale = 868;     // 0.447207191V
							end
			{8'h01,8'h21}: begin
								FwordA <=  32'd13744;   // 					400Hz
								Amp_scale =  493;     // 0.240511809V
							end
			{8'h01,8'h22}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale =  542;     // 0.26456299V
							end
			{8'h01,8'h23}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale = 591;     // 0.288614171V
							end
			{8'h01,8'h24}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale = 640;     // 0.312665352V
							end
			{8'h01,8'h25}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale = 689;     // 0.336716533V
							end
			{8'h01,8'h26}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale = 738;     // 0.360767714V
							end
			{8'h01,8'h27}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale =787;     // 0.384818895V
							end
			{8'h01,8'h28}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale =  836;     // 0.408870076V
							end
			{8'h01,8'h29}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale =  885;     // 0.432921256V
							end
			{8'h01,8'h2a}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale =  934;     // 0.456972437V
							end
			{8'h01,8'h2b}:begin
							FwordA <= 32'd13744;//Ƶ��
							Amp_scale = 983;     // 0.481023618V
							end
			{8'h01,8'h2c}: begin
								FwordA <=  32'd17180;   //							 500Hz
								Amp_scale =   534;     // 0.260817402V
							end
			{8'h01,8'h2d}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 587;     // 0.286899142V
							end
			{8'h01,8'h2e}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 640;     // 0.312980882V
							end
			{8'h01,8'h2f}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 693;     // 0.339062622V
							end
			{8'h01,8'h30}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 746;     // 0.365144362V
							end
			{8'h01,8'h31}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 799;     // 0.391226103V
							end
			{8'h01,8'h32}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale =852;     // 0.417307843V
							end
			{8'h01,8'h33}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale =   905;     // 0.443389583V
							end
			{8'h01,8'h34}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale =  958;     // 0.469471323V
							end
			{8'h01,8'h35}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 1011;    // 0.495553063V
							end
			{8'h01,8'h36}:begin
							FwordA <= 32'd17180;//Ƶ��
							Amp_scale = 1064;    // 0.521634803V
							end
			{8'h01,8'h37}: begin
								FwordA <=  32'd20616;   //   						600Hz
								Amp_scale =  581;     // 0.283905403V
							end
			{8'h01,8'h38}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale =  639;     // 0.312295943V
							end
			{8'h01,8'h39}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 697;     // 0.340686483V
							end
			{8'h01,8'h3a}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 755;     // 0.369077024V
							end
			{8'h01,8'h3b}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 813;     // 0.397467564V
							end
			{8'h01,8'h3c}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 871;     // 0.425858104V
							end
			{8'h01,8'h3d}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale =929;     // 0.454248644V
							end
			{8'h01,8'h3e}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 987;     // 0.482639185V
							end
			{8'h01,8'h3f}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale =  1045;    // 0.511029725V
							end
			{8'h01,8'h40}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 1103;    // 0.539420265V
							end
			{8'h01,8'h41}:begin
							FwordA <= 32'd20616;//Ƶ��
							Amp_scale = 1161;    // 0.567810805V
							end
			{8'h01,8'h42}: begin
								FwordA <=  32'd24052;   //                                       700Hz
								Amp_scale =   633;     // 0.309291105V
							end
			{8'h01,8'h43}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale =  697;     // 0.340220215V
							end
			{8'h01,8'h44}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 761;     // 0.371149326V
							end
			{8'h01,8'h45}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 825;     // 0.402078436V
							end
			{8'h01,8'h46}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 889;     // 0.433007547V
							end
			{8'h01,8'h47}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 953;     // 0.463936657V
							end
			{8'h01,8'h48}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale =1017;    // 0.494865768V
							end
			{8'h01,8'h49}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale =1081;    // 0.525794878V
							end
			{8'h01,8'h4a}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale =  1145;    // 0.556723989V
							end
			{8'h01,8'h4b}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 1209;    // 0.587653099V
							end
			{8'h01,8'h4c}:begin
							FwordA <= 32'd24052;//Ƶ��
							Amp_scale = 1273;    // 0.61858221V
							end
			{8'h01,8'h4d}: begin
								FwordA <=   32'd27488;   //				 800Hz
								Amp_scale =   689;     // 0.336598337V
							end
			{8'h01,8'h4e}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 758;     // 0.370258171V
							end
			{8'h01,8'h4f}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 827;     // 0.403918005V
							end
			{8'h01,8'h50}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale =  896;     // 0.437577838V
							end
			{8'h01,8'h51}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 965;     // 0.471237672V
							end
			{8'h01,8'h52}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 1034;    // 0.504897506V
							end
			{8'h01,8'h53}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale =1103;    // 0.53855734V
							end
			{8'h01,8'h54}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale =1172;    // 0.572217173V
							end
			{8'h01,8'h55}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale =  1241;    // 0.605877007V
							end
			{8'h01,8'h56}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 1310;    // 0.639536841V
							end
			{8'h01,8'h57}:begin
							FwordA <= 32'd27488;//Ƶ��
							Amp_scale = 1379;    // 0.673196674V
							end
			{8'h01,8'h58}: begin
								FwordA <=   32'd30924;   // 		900Hz
								Amp_scale =   749;     // 0.365550519V
							end
			{8'h01,8'h59}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale = 823;     // 0.402105571V
							end
			{8'h01,8'h5a}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale =  897;     // 0.438660623V
							end
			{8'h01,8'h5b}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale =  971;     // 0.475215675V
							end
			{8'h01,8'h5c}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale = 1045;    // 0.511770727V
							end
			{8'h01,8'h5d}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale = 1119;    // 0.548325779V
							end
			{8'h01,8'h5e}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale =1193;    // 0.584880831V
							end
			{8'h01,8'h5f}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale =1267;    // 0.621435882V
							end
			{8'h01,8'h60}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale =  1341;    // 0.657990934V
							end
			{8'h01,8'h61}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale = 1415;    // 0.694545986V
							end
			{8'h01,8'h62}:begin
							FwordA <= 32'd30924;//Ƶ��
							Amp_scale = 1489;    // 0.731101038V
							end
			{8'h01,8'h63}: begin
								FwordA <=  32'd34360;   // 			1000Hz
								Amp_scale =  812;     // 0.395945518V
							end
			{8'h01,8'h64}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 892;     // 0.43554007V
							end
			{8'h01,8'h65}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 972;     // 0.475134621V
							end
			{8'h01,8'h66}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 1052;    // 0.514729173V
							end
			{8'h01,8'h67}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 1132;    // 0.554323725V
							end
			{8'h01,8'h68}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 1212;    // 0.593918277V
							end
			{8'h01,8'h69}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale =1292;    // 0.633512829V
							end
			{8'h01,8'h6a}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale =1372;    // 0.67310738V
							end
			{8'h01,8'h6b}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale =  1452;    // 0.712701932V
							end
			{8'h01,8'h6c}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 1532;    // 0.752296484V
							end
			{8'h01,8'h6d}:begin
							FwordA <= 32'd34360;//Ƶ��
							Amp_scale = 1612;    // 0.791891036V
							end
			{8'h01,8'h6e}: begin
								FwordA <=  32'd37796;  // 		1100Hz
								Amp_scale =   876;     // 0.427642833V
							end
			{8'h01,8'h6f}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale =963;     // 0.470407116V
							end
			{8'h01,8'h70}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale = 1050;    // 0.513171399V
							end
			{8'h01,8'h71}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale =  1137;    // 0.555935683V
							end
			{8'h01,8'h72}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale = 1224;    // 0.598699966V
							end
			{8'h01,8'h73}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale = 1311;    // 0.641464249V
							end
			{8'h01,8'h74}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale =1398;    // 0.684228532V
							end
			{8'h01,8'h75}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale =1485;    // 0.726992816V
							end
			{8'h01,8'h76}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale =  1572;    // 0.769757099V
							end
			{8'h01,8'h77}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale = 1659;    // 0.812521382V
							end
			{8'h01,8'h78}:begin
							FwordA <= 32'd37796;//Ƶ��
							Amp_scale = 1746;    // 0.855285665V
							end
		{8'h01,8'h79}: begin
								FwordA <=   32'd41232;  // 		1200Hz
								Amp_scale =  943;     // 0.460553585V
							end
			{8'h01,8'h7a}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale =1037;    // 0.506608944V
							end
			{8'h01,8'h7b}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale = 1131;    // 0.552664302V
							end
			{8'h01,8'h7c}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale =  1225;    // 0.598719661V
							end
			{8'h01,8'h7d}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale = 1319;    // 0.64477502V
							end
			{8'h01,8'h7e}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale =1413;    // 0.690830378V
							end
			{8'h01,8'h7f}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale =1507;    // 0.736885737V
							end
			{8'h01,8'h80}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale =1601;    // 0.782941095V
							end
			{8'h01,8'h81}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale = 1695;    // 0.828996454V
							end
			{8'h01,8'h82}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale = 1789;    // 0.875051812V
							end
			{8'h01,8'h83}:begin
							FwordA <= 32'd41232;//Ƶ��
							Amp_scale = 1883;    // 0.921107171V
							end
		{8'h01,8'h84}: begin
								FwordA <=   32'd44668;  // 			1300Hz
								Amp_scale = 1014;    // 0.494584302V
							end
			{8'h01,8'h85}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale =1114;    // 0.544042732V
							end
			{8'h01,8'h86}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 1214;    // 0.593501162V
							end
			{8'h01,8'h87}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 1314;    // 0.642959592V
							end
			{8'h01,8'h88}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 1414;    // 0.692418023V
							end
			{8'h01,8'h89}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale =1514;    // 0.741876453V
							end
			{8'h01,8'h8a}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale =1614;    // 0.791334883V
							end
			{8'h01,8'h8b}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale =1714;    // 0.840793313V
							end
			{8'h01,8'h8c}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 1814;    // 0.890251743V
							end
			{8'h01,8'h8d}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 1914;    // 0.939710174V
							end
			{8'h01,8'h8e}:begin
							FwordA <= 32'd44668;//Ƶ��
							Amp_scale = 2014;    // 0.989168604V
							end
		{8'h01,8'h8f}: begin
								FwordA <=   32'd48104;  // 		1400Hz
								Amp_scale = 1085;    // 0.529717131V
							end
			{8'h01,8'h90}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale =1193;    // 0.582688844V
							end
			{8'h01,8'h91}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 1301;    // 0.635660557V
							end
			{8'h01,8'h92}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 1409;    // 0.68863227V
							end
			{8'h01,8'h93}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 1517;    // 0.741603983V
							end
			{8'h01,8'h94}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale =1625;    // 0.794575697V
							end
			{8'h01,8'h95}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale =1733;    // 0.84754741V
							end
			{8'h01,8'h96}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale =1841;    // 0.900519123V
							end
			{8'h01,8'h97}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 1949;    // 0.953490836V
							end
			{8'h01,8'h98}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 2057;    // 1.006462549V
							end
			{8'h01,8'h99}:begin
							FwordA <= 32'd48104;//Ƶ��
							Amp_scale = 2165;    // 1.059434262V
							end
		{8'h01,8'h9a}: begin
								FwordA <=    32'd51540;  // 			1500Hz
								Amp_scale = 1160;    // 0.565930956V
							end
			{8'h01,8'h9b}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =1275;    // 0.622524052V
							end
			{8'h01,8'h9c}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =1390;    // 0.679117148V
							end
			{8'h01,8'h9d}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale = 1505;    // 0.735710243V
							end
			{8'h01,8'h9e}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale = 1620;    // 0.792303339V
							end
			{8'h01,8'h9f}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =1735;    // 0.848896435V
							end
			{8'h01,8'ha0}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =1850;    // 0.90548953V
							end
			{8'h01,8'ha1}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =1965;    // 0.962082626V
							end
			{8'h01,8'ha2}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale = 2080;    // 1.018675722V
							end
			{8'h01,8'ha3}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale =2195;    // 1.075268817V
							end
			{8'h01,8'ha4}:begin
							FwordA <= 32'd51540;//Ƶ��
							Amp_scale = 2310;    // 1.131861913V
							end
		{8'h01,8'ha5}: begin
								FwordA <=    32'd54976;  // 				1600Hz
								Amp_scale = 1235;    // 0.603172688V
							end
			{8'h01,8'ha6}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1359;    // 0.663489957V
							end
			{8'h01,8'ha7}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1483;    // 0.723807226V
							end
			{8'h01,8'ha8}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 1607;    // 0.784124495V
							end
			{8'h01,8'ha9}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 1731;    // 0.844441764V
							end
			{8'h01,8'haa}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1855;    // 0.904759033V
							end
			{8'h01,8'hab}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1979;    // 0.965076301V
							end
			{8'h01,8'hac}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =2103;    // 1.02539357V
							end
			{8'h01,8'had}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 2227;    // 1.085710839V
							end
			{8'h01,8'hae}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =2351;    // 1.146028108V
							end
			{8'h01,8'haf}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 2475;    // 1.206345377V
							end
		{8'h01,8'hb0}: begin
								FwordA <=     32'd58412;  // 			1700Hz
								Amp_scale = 1314;    // 0.641519117V
							end
			{8'h01,8'hb1}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1446;    // 0.705671029V
							end
			{8'h01,8'hb2}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1578;    // 0.769822941V
							end
			{8'h01,8'hb3}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 1710;    // 0.833974852V
							end
			{8'h01,8'hb4}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1842;    // 0.898126764V
							end
			{8'h01,8'hb5}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =1974;    // 0.962278676V
							end
			{8'h01,8'hb6}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =2106;    // 1.026430588V
							end
			{8'h01,8'hb7}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =2238;    // 1.090582499V
							end
			{8'h01,8'hb8}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 2370;    // 1.154734411V
							end
			{8'h01,8'hb9}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale =2502;    // 1.218886323V
							end
			{8'h01,8'hba}:begin
							FwordA <= 32'd54976;//Ƶ��
							Amp_scale = 2634;    // 1.283038235V
							end
		{8'h01,8'hbb}: begin
								FwordA <=     32'd61848;  //			 1800Hz
								Amp_scale = 1394;    // 0.680874243V
							end
			{8'h01,8'hbc}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =1536;    // 0.748961667V
							end
			{8'h01,8'hbd}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =1678;    // 0.817049091V
							end
			{8'h01,8'hbe}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =1820;    // 0.885136515V
							end
			{8'h01,8'hbf}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =1962;    // 0.95322394V
							end
			{8'h01,8'hc0}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =2104;    // 1.021311364V
							end
			{8'h01,8'hc1}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =2246;    // 1.089398788V
							end
			{8'h01,8'hc2}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =2388;    // 1.157486212V
							end
			{8'h01,8'hc3}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale = 2530;    // 1.225573637V
							end
			{8'h01,8'hc4}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale = 2672;    // 1.293661061V
							end
			{8'h01,8'hc5}:begin
							FwordA <= 32'd61848;//Ƶ��
							Amp_scale =2814;    // 1.361748485V
							end
		{8'h01,8'hc6}: begin
								FwordA <=      32'd65284;  // 				1900Hz
								Amp_scale = 1477;    // 0.721292556V
							end
			{8'h01,8'hc7}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =1625;    // 0.793421812V
							end
			{8'h01,8'hc8}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =1773;    // 0.865551068V
							end
			{8'h01,8'hc9}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =1921;    // 0.937680323V
							end
			{8'h01,8'hca}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =2069;    // 1.009809579V
							end
			{8'h01,8'hcb}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =2217;    // 1.081938834V
							end
			{8'h01,8'hcc}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =2365;    // 1.15406809V
							end
			{8'h01,8'hcd}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =2513;    // 1.226197346V
							end
			{8'h01,8'hce}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale = 2661;    // 1.298326601V
							end
			{8'h01,8'hcf}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale = 2809;    // 1.370455857V
							end
			{8'h01,8'hd0}:begin
							FwordA <= 32'd65284;//Ƶ��
							Amp_scale =2957;    // 1.442585113V
							end
		{8'h01,8'hd1}: begin
								FwordA <=       32'd68720;  //				 2000Hz
								Amp_scale = 1562;    // 0.762834694V
							end
			{8'h01,8'hd2}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =1717;    // 0.839118163V
							end
			{8'h01,8'hd3}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =1872;    // 0.915401632V
							end
			{8'h01,8'hd4}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =2027;    // 0.991685102V
							end
			{8'h01,8'hd5}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =2182;    // 1.067968571V
							end
			{8'h01,8'hd6}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =2337;    // 1.144252041V
							end
			{8'h01,8'hd7}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =2492;    // 1.22053551V
							end
			{8'h01,8'hd8}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =2647;    // 1.296818979V
							end
			{8'h01,8'hd9}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale = 2802;    // 1.373102449V
							end
			{8'h01,8'hda}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale = 2957;    // 1.449385918V
							end
			{8'h01,8'hdb}:begin
							FwordA <= 32'd68720;//Ƶ��
							Amp_scale =3112;    // 1.525669387V
							end
		{8'h01,8'hdc}: begin
								FwordA <=       32'd72156;  // 				2100Hz
								Amp_scale = 1649;    // 0.805412371V
							end
			{8'h01,8'hdd}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale = 1811;    // 0.885953608V
							end
			{8'h01,8'hde}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =1973;    // 0.966494845V
							end
			{8'h01,8'hdf}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =2135;    // 1.047036082V
							end
			{8'h01,8'he0}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =2297;    // 1.12757732V
							end
			{8'h01,8'he1}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =2459;    // 1.208118557V
							end
			{8'h01,8'he2}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =2639;    // 1.288659794V
							end
			{8'h01,8'he3}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =2804;    // 1.369201031V
							end
			{8'h01,8'he4}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale = 2969;    // 1.449742268V
							end
			{8'h01,8'he5}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale = 3134;    // 1.530283505V
							end
			{8'h01,8'he6}:begin
							FwordA <= 32'd72156;//Ƶ��
							Amp_scale =3298;    // 1.610824742V
							end
		{8'h01,8'he7}: begin
								FwordA <=       32'd75592;  // 			2200Hz
								Amp_scale = 1739;    // 0.849112677V
							end
			{8'h01,8'he8}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =1909;    // 0.934023945V
							end
			{8'h01,8'he9}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2079;    // 1.018935213V
							end
			{8'h01,8'hea}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2249;    // 1.10384648V
							end
			{8'h01,8'heb}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2419;    // 1.188757748V
							end
			{8'h01,8'hec}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2589;    // 1.273669016V
							end
			{8'h01,8'hed}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2759;    // 1.358580284V
							end
			{8'h01,8'hee}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =2935;    // 1.443491551V
							end
			{8'h01,8'hef}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale = 3130;    // 1.528402819V
							end
			{8'h01,8'hf0}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale = 3304;    // 1.613314087V
							end
			{8'h01,8'hf1}:begin
							FwordA <= 32'd75592;//Ƶ��
							Amp_scale =3477;    // 1.698225355V
							end
		{8'h01,8'hf2}: begin
								FwordA <=       32'd79028;  // 				2300Hz
								Amp_scale =1825;    // 0.893974611V
							end
			{8'h01,8'hf3}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =2010;    // 0.983372072V
							end
			{8'h01,8'hf4}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale = 2188;    // 1.072769533V
							end
			{8'h01,8'hf5}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =2366;    // 1.162166994V
							end
			{8'h01,8'hf6}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =2544;    // 1.251564456V
							end
			{8'h01,8'hf7}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =2722;    // 1.340961917V
							end
			{8'h01,8'hf8}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =2900;    // 1.430359378V
							end
			{8'h01,8'hf9}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale =3078;    // 1.519756839V
							end
			{8'h01,8'hfa}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale = 3256;    // 1.6091543V
							end
			{8'h02,8'h4f}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale = 3434;    // 1.698551761V
							end
			{8'h02,8'h4e}:begin
							FwordA <= 32'd79028;//Ƶ��
							Amp_scale = 3661;    // 1.787949222V
							end
		{8'h02,8'h4d}: begin
								FwordA <=       32'd82464;  // 			2400Hz
								Amp_scale = 1927;    // 0.939937964V
							end
			{8'h02,8'h4c}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =2117;    // 1.033931761V
							end
			{8'h02,8'h4b}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale = 2309;    // 1.127925557V
							end
			{8'h02,8'h00}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =2502;    // 1.221919353V
							end
			{8'h02,8'h01}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale = 2694;    // 1.31591315V
							end
			{8'h02,8'h02}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =2887;    // 1.409906946V
							end
			{8'h02,8'h03}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =3097;    // 1.503900743V
							end
			{8'h02,8'h04}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =3272;    // 1.597894539V
							end
			{8'h02,8'h05}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale = 3465;    // 1.691888335V
							end
			{8'h02,8'h06}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =3657;    // 1.785882132V
							end
			{8'h02,8'h07}:begin
							FwordA <= 32'd82464;//Ƶ��
							Amp_scale =3849;    // 1.879875928V
							end
			{8'h02,8'h08}: begin
								FwordA <=       32'd85900;  // 					2500Hz
								Amp_scale = 2024;    // 0.987069391V
							end
			{8'h02,8'h09}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =2216;    // 1.08577633V
							end
			{8'h02,8'h0a}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale = 2408;    // 1.184483269V
							end
			{8'h02,8'h0b}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =2600;    // 1.283190208V
							end
			{8'h02,8'h0c}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale = 2792;    // 1.381897147V
							end
			{8'h02,8'h0d}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =2984;    // 1.480604086V
							end
			{8'h02,8'h0e}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =3176;    // 1.579311026V
							end
			{8'h02,8'h0f}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =3368;    // 1.678017965V
							end
			{8'h02,8'h10}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale = 3560;    // 1.776724904V
							end
			{8'h02,8'h11}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =3752;    // 1.875431843V
							end
			{8'h02,8'h12}:begin
							FwordA <= 32'd85900;//Ƶ��
							Amp_scale =3944;    // 1.974138782V
							end
			{8'h02,8'h13}: begin
								FwordA <=32'd89336;  // 			2600Hz
								Amp_scale = 2124;    // 1.035411058V
							end
			{8'h02,8'h14}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =2322;    // 1.138952164V
							end
			{8'h02,8'h15}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale = 2520;    // 1.24249327V
							end
			{8'h02,8'h16}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =2718;    // 1.346034376V
							end
			{8'h02,8'h17}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =2916;    // 1.449575481V
							end
			{8'h02,8'h18}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =3114;    // 1.553116587V
							end
			{8'h02,8'h19}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =3312;    // 1.656657693V
							end
			{8'h02,8'h1a}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =3510;    // 1.760198799V
							end
			{8'h02,8'h1b}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale = 3708;    // 1.863739905V
							end
			{8'h02,8'h1c}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =3906;    // 1.967281011V
							end
			{8'h02,8'h1d}:begin
							FwordA <= 32'd89336;//Ƶ��
							Amp_scale =4104;    // 2.070822116V
							end
			{8'h02,8'h1e}: begin
								FwordA <= 32'd92772;  // 				2700Hz
								Amp_scale = 2226;    // 1.08495172V
							end
			{8'h02,8'h1f}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =2429;    // 1.193446892V
							end
			{8'h02,8'h20}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale = 2632;    // 1.301942064V
							end
			{8'h02,8'h21}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =2835;    // 1.410437236V
							end
			{8'h02,8'h22}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =3038;    // 1.518932408V
							end
			{8'h02,8'h23}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =3241;    // 1.627427579V
							end
			{8'h02,8'h24}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =3444;    // 1.735922751V
							end
			{8'h02,8'h25}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =3647;    // 1.844417923V
							end
			{8'h02,8'h26}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale = 3850;    // 1.952913095V
							end
			{8'h02,8'h27}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =4053;    // 2.061408267V
							end
			{8'h02,8'h28}:begin
							FwordA <= 32'd92772;//Ƶ��
							Amp_scale =4256;    // 2.169903439V
							end
			{8'h02,8'h29}: begin
								FwordA <=32'd96208;  // 				2800Hz
								Amp_scale = 2331;    // 1.135718342V
							end
			{8'h02,8'h2a}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =2559;    // 1.249290176V
							end
			{8'h02,8'h2b}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =  2791;    // 1.36286201V
							end
			{8'h02,8'h2c}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =3023;    // 1.476433844V
							end
			{8'h02,8'h2d}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =3256;    // 1.590005679V
							end
			{8'h02,8'h2e}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =3489;    // 1.703577513V
							end
			{8'h02,8'h2f}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =3721;    // 1.817149347V
							end
			{8'h02,8'h30}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =3954;    // 1.930721181V
							end
			{8'h02,8'h31}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale = 4187;    // 2.044293015V
							end
			{8'h02,8'h32}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =4419;    // 2.15786485V
							end
			{8'h02,8'h33}:begin
							FwordA <= 32'd96208;//Ƶ��
							Amp_scale =4652;    // 2.271436684V
							end
			{8'h02,8'h34}: begin
								FwordA <=       32'd99644;  // 				2900Hz
								Amp_scale = 2432;    // 1.187648456V
							end
			{8'h02,8'h35}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =2675;    // 1.306413302V
							end
			{8'h02,8'h36}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =  2919;    // 1.425178147V
							end
			{8'h02,8'h37}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =3161;    // 1.543942993V
							end
			{8'h02,8'h38}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =3405;    // 1.662707838V
							end
			{8'h02,8'h39}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =3648;    // 1.781472684V
							end
			{8'h02,8'h3a}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =3891;    // 1.90023753V
							end
			{8'h02,8'h3b}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =4134;    // 2.019002375V
							end
			{8'h02,8'h3c}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =  4378;    // 2.137767221V
							end
			{8'h02,8'h3d}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =4621;    // 2.256532067V
							end
			{8'h02,8'h3e}:begin
							FwordA <= 32'd99644;//Ƶ��
							Amp_scale =4864;    // 2.375296912V
							end
			{8'h02,8'h40}: begin
								FwordA <=       32'd103080; // 			3000Hz
								Amp_scale = 2541;    // 1.240848741V
							end
			{8'h02,8'h41}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =2795;    // 1.364933615V
							end
			{8'h02,8'h42}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =  3049;    // 1.489018489V
							end
			{8'h02,8'h43}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =3303;    // 1.613103363V
							end
			{8'h02,8'h44}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =3557;    // 1.737188237V
							end
			{8'h02,8'h45}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =3812;    // 1.861273111V
							end
			{8'h02,8'h46}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =4066;    // 1.985357985V
							end
			{8'h02,8'h47}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =4320;    // 2.109442859V
							end
			{8'h02,8'h48}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =  4574;    // 2.233527733V
							end
			{8'h02,8'h49}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =4828;    // 2.357612607V
							end
			{8'h02,8'h4a}:begin
							FwordA <= 32'd103080;//Ƶ��
							Amp_scale =5082;    // 2.481697481V
							end
		endcase

        end
        Develop_one:begin
			Amp_scale<=14'd4106;
			case (fre_cnt)
				    10'd0:   FwordA <= 32'd34360;    // 1000Hz
					10'd1:   FwordA <= 32'd37796;    // 1100Hz
					10'd2:   FwordA <= 32'd41232;    // 1200Hz
					10'd3:   FwordA <= 32'd44668;    // 1300Hz
					10'd4:   FwordA <= 32'd48104;    // 1400Hz
					10'd5:   FwordA <= 32'd51540;    // 1500Hz
					10'd6:   FwordA <= 32'd54976;    // 1600Hz
					10'd7:   FwordA <= 32'd58412;    // 1700Hz
					10'd8:   FwordA <= 32'd61848;    // 1800Hz
					10'd9:   FwordA <= 32'd65284;    // 1900Hz
					10'd10:  FwordA <= 32'd68719;    // 2000Hz
					10'd11:  FwordA <= 32'd72155;    // 2100Hz
					10'd12:  FwordA <= 32'd75591;    // 2200Hz
					10'd13:  FwordA <= 32'd79027;    // 2300Hz
					10'd14:  FwordA <= 32'd82463;    // 2400Hz
					10'd15:  FwordA <= 32'd85899;    // 2500Hz
					10'd16:  FwordA <= 32'd89335;    // 2600Hz
					10'd17:  FwordA <= 32'd92771;    // 2700Hz
					10'd18:  FwordA <= 32'd96207;    // 2800Hz
					10'd19:  FwordA <= 32'd99643;    // 2900Hz
					10'd20:  FwordA <= 32'd103079;   // 3000Hz
					10'd21:  FwordA <= 32'd106515;   // 3100Hz
					10'd22:  FwordA <= 32'd109951;   // 3200Hz
					10'd23:  FwordA <= 32'd113387;   // 3300Hz
					10'd24:  FwordA <= 32'd116823;   // 3400Hz
					10'd25:  FwordA <= 32'd120259;   // 3500Hz
					10'd26:  FwordA <= 32'd123695;   // 3600Hz
					10'd27:  FwordA <= 32'd127131;   // 3700Hz
					10'd28:  FwordA <= 32'd130567;   // 3800Hz
					10'd29:  FwordA <= 32'd134003;   // 3900Hz
					10'd30:  FwordA <= 32'd137439;   // 4000Hz
					10'd31:  FwordA <= 32'd140875;   // 4100Hz
					10'd32:  FwordA <= 32'd144311;   // 4200Hz
					10'd33:  FwordA <= 32'd147747;   // 4300Hz
					10'd34:  FwordA <= 32'd151183;   // 4400Hz
					10'd35:  FwordA <= 32'd154619;   // 4500Hz
					10'd36:  FwordA <= 32'd158055;   // 4600Hz
					10'd37:  FwordA <= 32'd161491;   // 4700Hz
					10'd38:  FwordA <= 32'd164927;   // 4800Hz
					10'd39:  FwordA <= 32'd168363;   // 4900Hz
					10'd40:  FwordA <= 32'd171799;   // 5000Hz
					    // 5.1KHz ~ 6.0KHz
					10'd41:  FwordA <= 32'd175235;   // 5100Hz
					10'd42:  FwordA <= 32'd178671;   // 5200Hz
					10'd43:  FwordA <= 32'd182107;   // 5300Hz
					10'd44:  FwordA <= 32'd185543;   // 5400Hz
					10'd45:  FwordA <= 32'd188979;   // 5500Hz
					10'd46:  FwordA <= 32'd192415;   // 5600Hz
					10'd47:  FwordA <= 32'd195851;   // 5700Hz
					10'd48:  FwordA <= 32'd199287;   // 5800Hz
					10'd49:  FwordA <= 32'd202723;   // 5900Hz
					10'd50:  FwordA <= 32'd206159;   // 6000Hz
					
					// 6.1KHz ~ 7.0KHz
					10'd51:  FwordA <= 32'd209595;   // 6100Hz
					10'd52:  FwordA <= 32'd213031;   // 6200Hz
					10'd53:  FwordA <= 32'd216467;   // 6300Hz
					10'd54:  FwordA <= 32'd219903;   // 6400Hz
					10'd55:  FwordA <= 32'd223339;   // 6500Hz
					10'd56:  FwordA <= 32'd226775;   // 6600Hz
					10'd57:  FwordA <= 32'd230211;   // 6700Hz
					10'd58:  FwordA <= 32'd233647;   // 6800Hz
					10'd59:  FwordA <= 32'd237083;   // 6900Hz
					10'd60:  FwordA <= 32'd240519;   // 7000Hz
					
					// 7.1KHz ~ 8.0KHz
					10'd61:  FwordA <= 32'd243955;   // 7100Hz
					10'd62:  FwordA <= 32'd247391;   // 7200Hz
					10'd63:  FwordA <= 32'd250827;   // 7300Hz
					10'd64:  FwordA <= 32'd254263;   // 7400Hz
					10'd65:  FwordA <= 32'd257699;   // 7500Hz
					10'd66:  FwordA <= 32'd261135;   // 7600Hz
					10'd67:  FwordA <= 32'd264571;   // 7700Hz
					10'd68:  FwordA <= 32'd268007;   // 7800Hz
					10'd69:  FwordA <= 32'd271443;   // 7900Hz
					10'd70:  FwordA <= 32'd274879;   // 8000Hz
					
					// 8.1KHz ~ 9.0KHz
					10'd71:  FwordA <= 32'd278315;   // 8100Hz
					10'd72:  FwordA <= 32'd281751;   // 8200Hz
					10'd73:  FwordA <= 32'd285187;   // 8300Hz
					10'd74:  FwordA <= 32'd288623;   // 8400Hz
					10'd75:  FwordA <= 32'd292059;   // 8500Hz
					10'd76:  FwordA <= 32'd295495;   // 8600Hz
					10'd77:  FwordA <= 32'd298931;   // 8700Hz
					10'd78:  FwordA <= 32'd302367;   // 8800Hz
					10'd79:  FwordA <= 32'd305803;   // 8900Hz
					10'd80:  FwordA <= 32'd309239;   // 9000Hz
					
					// 9.1KHz ~ 10.0KHz
					10'd81:  FwordA <= 32'd312675;   // 9100Hz
					10'd82:  FwordA <= 32'd316111;   // 9200Hz
					10'd83:  FwordA <= 32'd319547;   // 9300Hz
					10'd84:  FwordA <= 32'd322983;   // 9400Hz
					10'd85:  FwordA <= 32'd326419;   // 9500Hz
					10'd86:  FwordA <= 32'd329855;   // 9600Hz
					10'd87:  FwordA <= 32'd333291;   // 9700Hz
					10'd88:  FwordA <= 32'd336727;   // 9800Hz
					10'd89:  FwordA <= 32'd340163;   // 9900Hz
					10'd90:  FwordA <= 32'd343599;   // 10000Hz
					// 10.1KHz ~ 11.0KHz
					10'd91:  FwordA <= 32'd347035;   // 10100Hz
					10'd92:  FwordA <= 32'd350471;   // 10200Hz
					10'd93:  FwordA <= 32'd353907;   // 10300Hz
					10'd94:  FwordA <= 32'd357343;   // 10400Hz
					10'd95:  FwordA <= 32'd360779;   // 10500Hz
					10'd96:  FwordA <= 32'd364215;   // 10600Hz
					10'd97:  FwordA <= 32'd367651;   // 10700Hz
					10'd98:  FwordA <= 32'd371087;   // 10800Hz
					10'd99:  FwordA <= 32'd374523;   // 10900Hz
					10'd100: FwordA <= 32'd377959;   // 11000Hz

					// 11.1KHz ~ 12.0KHz
					10'd101: FwordA <= 32'd381395;   // 11100Hz
					10'd102: FwordA <= 32'd384831;   // 11200Hz
					10'd103: FwordA <= 32'd388267;   // 11300Hz
					10'd104: FwordA <= 32'd391703;   // 11400Hz
					10'd105: FwordA <= 32'd395139;   // 11500Hz
					10'd106: FwordA <= 32'd398575;   // 11600Hz
					10'd107: FwordA <= 32'd402011;   // 11700Hz
					10'd108: FwordA <= 32'd405447;   // 11800Hz
					10'd109: FwordA <= 32'd408883;   // 11900Hz
					10'd110: FwordA <= 32'd412319;   // 12000Hz

					// 12.1KHz ~ 13.0KHz
					10'd111: FwordA <= 32'd415755;   // 12100Hz
					10'd112: FwordA <= 32'd419191;   // 12200Hz
					10'd113: FwordA <= 32'd422627;   // 12300Hz
					10'd114: FwordA <= 32'd426063;   // 12400Hz
					10'd115: FwordA <= 32'd429499;   // 12500Hz
					10'd116: FwordA <= 32'd432935;   // 12600Hz
					10'd117: FwordA <= 32'd436371;   // 12700Hz
					10'd118: FwordA <= 32'd439807;   // 12800Hz
					10'd119: FwordA <= 32'd443243;   // 12900Hz
					10'd120: FwordA <= 32'd446679;   // 13000Hz

					// 13.1KHz ~ 14.0KHz
					10'd121: FwordA <= 32'd450115;   // 13100Hz
					10'd122: FwordA <= 32'd453551;   // 13200Hz
					10'd123: FwordA <= 32'd456987;   // 13300Hz
					10'd124: FwordA <= 32'd460423;   // 13400Hz
					10'd125: FwordA <= 32'd463859;   // 13500Hz
					10'd126: FwordA <= 32'd467295;   // 13600Hz
					10'd127: FwordA <= 32'd470731;   // 13700Hz
					10'd128: FwordA <= 32'd474167;   // 13800Hz
					10'd129: FwordA <= 32'd477603;   // 13900Hz
					10'd130: FwordA <= 32'd481039;   // 14000Hz

					// 14.1KHz ~ 15.0KHz
					10'd131: FwordA <= 32'd484475;   // 14100Hz
					10'd132: FwordA <= 32'd487911;   // 14200Hz
					10'd133: FwordA <= 32'd491347;   // 14300Hz
					10'd134: FwordA <= 32'd494783;   // 14400Hz
					10'd135: FwordA <= 32'd498219;   // 14500Hz
					10'd136: FwordA <= 32'd501655;   // 14600Hz
					10'd137: FwordA <= 32'd505091;   // 14700Hz
					10'd138: FwordA <= 32'd508527;   // 14800Hz
					10'd139: FwordA <= 32'd511963;   // 14900Hz
					10'd140: FwordA <= 32'd515399;   // 15000Hz
					// 15.1KHz ~ 16.0KHz
					10'd141: FwordA <= 32'd518835;   // 15100Hz
					10'd142: FwordA <= 32'd522271;   // 15200Hz
					10'd143: FwordA <= 32'd525707;   // 15300Hz
					10'd144: FwordA <= 32'd529143;   // 15400Hz
					10'd145: FwordA <= 32'd532579;   // 15500Hz
					10'd146: FwordA <= 32'd536015;   // 15600Hz
					10'd147: FwordA <= 32'd539451;   // 15700Hz
					10'd148: FwordA <= 32'd542887;   // 15800Hz
					10'd149: FwordA <= 32'd546323;   // 15900Hz
					10'd150: FwordA <= 32'd549759;   // 16000Hz

					// 16.1KHz ~ 17.0KHz
					10'd151: FwordA <= 32'd553195;   // 16100Hz
					10'd152: FwordA <= 32'd556631;   // 16200Hz
					10'd153: FwordA <= 32'd560067;   // 16300Hz
					10'd154: FwordA <= 32'd563503;   // 16400Hz
					10'd155: FwordA <= 32'd566939;   // 16500Hz
					10'd156: FwordA <= 32'd570375;   // 16600Hz
					10'd157: FwordA <= 32'd573811;   // 16700Hz
					10'd158: FwordA <= 32'd577247;   // 16800Hz
					10'd159: FwordA <= 32'd580683;   // 16900Hz
					10'd160: FwordA <= 32'd584119;   // 17000Hz

					// 17.1KHz ~ 18.0KHz
					10'd161: FwordA <= 32'd587555;   // 17100Hz
					10'd162: FwordA <= 32'd590991;   // 17200Hz
					10'd163: FwordA <= 32'd594427;   // 17300Hz
					10'd164: FwordA <= 32'd597863;   // 17400Hz
					10'd165: FwordA <= 32'd601299;   // 17500Hz
					10'd166: FwordA <= 32'd604735;   // 17600Hz
					10'd167: FwordA <= 32'd608171;   // 17700Hz
					10'd168: FwordA <= 32'd611607;   // 17800Hz
					10'd169: FwordA <= 32'd615043;   // 17900Hz
					10'd170: FwordA <= 32'd618479;   // 18000Hz

					// 18.1KHz ~ 19.0KHz
					10'd171: FwordA <= 32'd621915;   // 18100Hz
					10'd172: FwordA <= 32'd625351;   // 18200Hz
					10'd173: FwordA <= 32'd628787;   // 18300Hz
					10'd174: FwordA <= 32'd632223;   // 18400Hz
					10'd175: FwordA <= 32'd635659;   // 18500Hz
					10'd176: FwordA <= 32'd639095;   // 18600Hz
					10'd177: FwordA <= 32'd642531;   // 18700Hz
					10'd178: FwordA <= 32'd645967;   // 18800Hz
					10'd179: FwordA <= 32'd649403;   // 18900Hz
					10'd180: FwordA <= 32'd652839;   // 19000Hz

					// 19.1KHz ~ 20.0KHz
					10'd181: FwordA <= 32'd656275;   // 19100Hz
					10'd182: FwordA <= 32'd659711;   // 19200Hz
					10'd183: FwordA <= 32'd663147;   // 19300Hz
					10'd184: FwordA <= 32'd666583;   // 19400Hz
					10'd185: FwordA <= 32'd670019;   // 19500Hz
					10'd186: FwordA <= 32'd673455;   // 19600Hz
					10'd187: FwordA <= 32'd676891;   // 19700Hz
					10'd188: FwordA <= 32'd680327;   // 19800Hz
					10'd189: FwordA <= 32'd683763;   // 19900Hz
					10'd190: FwordA <= 32'd687199;   // 20000Hz
					// 20.1KHz ~ 21.0KHz
					10'd191: FwordA <= 32'd690635;   // 20100Hz
					10'd192: FwordA <= 32'd694071;   // 20200Hz
					10'd193: FwordA <= 32'd697507;   // 20300Hz
					10'd194: FwordA <= 32'd700943;   // 20400Hz
					10'd195: FwordA <= 32'd704379;   // 20500Hz
					10'd196: FwordA <= 32'd707815;   // 20600Hz
					10'd197: FwordA <= 32'd711251;   // 20700Hz
					10'd198: FwordA <= 32'd714687;   // 20800Hz
					10'd199: FwordA <= 32'd718123;   // 20900Hz
					10'd200: FwordA <= 32'd721559;   // 21000Hz

					// 21.1KHz ~ 22.0KHz
					10'd201: FwordA <= 32'd724995;   // 21100Hz
					10'd202: FwordA <= 32'd728431;   // 21200Hz
					10'd203: FwordA <= 32'd731867;   // 21300Hz
					10'd204: FwordA <= 32'd735303;   // 21400Hz
					10'd205: FwordA <= 32'd738739;   // 21500Hz
					10'd206: FwordA <= 32'd742175;   // 21600Hz
					10'd207: FwordA <= 32'd745611;   // 21700Hz
					10'd208: FwordA <= 32'd749047;   // 21800Hz
					10'd209: FwordA <= 32'd752483;   // 21900Hz
					10'd210: FwordA <= 32'd755919;   // 22000Hz

					// 22.1KHz ~ 23.0KHz
					10'd211: FwordA <= 32'd759355;   // 22100Hz
					10'd212: FwordA <= 32'd762791;   // 22200Hz
					10'd213: FwordA <= 32'd766227;   // 22300Hz
					10'd214: FwordA <= 32'd769663;   // 22400Hz
					10'd215: FwordA <= 32'd773099;   // 22500Hz
					10'd216: FwordA <= 32'd776535;   // 22600Hz
					10'd217: FwordA <= 32'd779971;   // 22700Hz
					10'd218: FwordA <= 32'd783407;   // 22800Hz
					10'd219: FwordA <= 32'd786843;   // 22900Hz
					10'd220: FwordA <= 32'd790279;   // 23000Hz

					// 23.1KHz ~ 24.0KHz
					10'd221: FwordA <= 32'd793715;   // 23100Hz
					10'd222: FwordA <= 32'd797151;   // 23200Hz
					10'd223: FwordA <= 32'd800587;   // 23300Hz
					10'd224: FwordA <= 32'd804023;   // 23400Hz
					10'd225: FwordA <= 32'd807459;   // 23500Hz
					10'd226: FwordA <= 32'd810895;   // 23600Hz
					10'd227: FwordA <= 32'd814331;   // 23700Hz
					10'd228: FwordA <= 32'd817767;   // 23800Hz
					10'd229: FwordA <= 32'd821203;   // 23900Hz
					10'd230: FwordA <= 32'd824639;   // 24000Hz

					// 24.1KHz ~ 25.0KHz
					10'd231: FwordA <= 32'd828075;   // 24100Hz
					10'd232: FwordA <= 32'd831511;   // 24200Hz
					10'd233: FwordA <= 32'd834947;   // 24300Hz
					10'd234: FwordA <= 32'd838383;   // 24400Hz
					10'd235: FwordA <= 32'd841819;   // 24500Hz
					10'd236: FwordA <= 32'd845255;   // 24600Hz
					10'd237: FwordA <= 32'd848691;   // 24700Hz
					10'd238: FwordA <= 32'd852127;   // 24800Hz
					10'd239: FwordA <= 32'd855563;   // 24900Hz
					10'd240: FwordA <= 32'd858999;   // 25000Hz
					// 25.1KHz ~ 26.0KHz
					10'd241: FwordA <= 32'd862435;   // 25100Hz
					10'd242: FwordA <= 32'd865871;   // 25200Hz
					10'd243: FwordA <= 32'd869307;   // 25300Hz
					10'd244: FwordA <= 32'd872743;   // 25400Hz
					10'd245: FwordA <= 32'd876179;   // 25500Hz
					10'd246: FwordA <= 32'd879615;   // 25600Hz
					10'd247: FwordA <= 32'd883051;   // 25700Hz
					10'd248: FwordA <= 32'd886487;   // 25800Hz
					10'd249: FwordA <= 32'd889923;   // 25900Hz
					10'd250: FwordA <= 32'd893359;   // 26000Hz

					// 26.1KHz ~ 27.0KHz
					10'd251: FwordA <= 32'd896795;   // 26100Hz
					10'd252: FwordA <= 32'd900231;   // 26200Hz
					10'd253: FwordA <= 32'd903667;   // 26300Hz
					10'd254: FwordA <= 32'd907103;   // 26400Hz
					10'd255: FwordA <= 32'd910539;   // 26500Hz
					10'd256: FwordA <= 32'd913975;   // 26600Hz
					10'd257: FwordA <= 32'd917411;   // 26700Hz
					10'd258: FwordA <= 32'd920847;   // 26800Hz
					10'd259: FwordA <= 32'd924283;   // 26900Hz
					10'd260: FwordA <= 32'd927719;   // 27000Hz

					// 27.1KHz ~ 28.0KHz
					10'd261: FwordA <= 32'd931155;   // 27100Hz
					10'd262: FwordA <= 32'd934591;   // 27200Hz
					10'd263: FwordA <= 32'd938027;   // 27300Hz
					10'd264: FwordA <= 32'd941463;   // 27400Hz
					10'd265: FwordA <= 32'd944899;   // 27500Hz
					10'd266: FwordA <= 32'd948335;   // 27600Hz
					10'd267: FwordA <= 32'd951771;   // 27700Hz
					10'd268: FwordA <= 32'd955207;   // 27800Hz
					10'd269: FwordA <= 32'd958643;   // 27900Hz
					10'd270: FwordA <= 32'd962079;   // 28000Hz

					// 28.1KHz ~ 29.0KHz
					10'd271: FwordA <= 32'd965515;   // 28100Hz
					10'd272: FwordA <= 32'd968951;   // 28200Hz
					10'd273: FwordA <= 32'd972387;   // 28300Hz
					10'd274: FwordA <= 32'd975823;   // 28400Hz
					10'd275: FwordA <= 32'd979259;   // 28500Hz
					10'd276: FwordA <= 32'd982695;   // 28600Hz
					10'd277: FwordA <= 32'd986131;   // 28700Hz
					10'd278: FwordA <= 32'd989567;   // 28800Hz
					10'd279: FwordA <= 32'd993003;   // 28900Hz
					10'd280: FwordA <= 32'd996439;   // 29000Hz

					// 29.1KHz ~ 30.0KHz
					10'd281: FwordA <= 32'd999875;   // 29100Hz
					10'd282: FwordA <= 32'd1003311;  // 29200Hz
					10'd283: FwordA <= 32'd1006747;  // 29300Hz
					10'd284: FwordA <= 32'd1010183;  // 29400Hz
					10'd285: FwordA <= 32'd1013619;  // 29500Hz
					10'd286: FwordA <= 32'd1017055;  // 29600Hz
					10'd287: FwordA <= 32'd1020491;  // 29700Hz
					10'd288: FwordA <= 32'd1023927;  // 29800Hz
					10'd289: FwordA <= 32'd1027363;  // 29900Hz
					10'd290: FwordA <= 32'd1030799;  // 30000Hz
					// 30.1KHz ~ 31.0KHz
					10'd291: FwordA <= 32'd1034235;  // 30100Hz
					10'd292: FwordA <= 32'd1037671;  // 30200Hz
					10'd293: FwordA <= 32'd1041107;  // 30300Hz
					10'd294: FwordA <= 32'd1044543;  // 30400Hz
					10'd295: FwordA <= 32'd1047979;  // 30500Hz
					10'd296: FwordA <= 32'd1051415;  // 30600Hz
					10'd297: FwordA <= 32'd1054851;  // 30700Hz
					10'd298: FwordA <= 32'd1058287;  // 30800Hz
					10'd299: FwordA <= 32'd1061723;  // 30900Hz
					10'd300: FwordA <= 32'd1065159;  // 31000Hz

					// 31.1KHz ~ 32.0KHz
					10'd301: FwordA <= 32'd1068595;  // 31100Hz
					10'd302: FwordA <= 32'd1072031;  // 31200Hz
					10'd303: FwordA <= 32'd1075467;  // 31300Hz
					10'd304: FwordA <= 32'd1078903;  // 31400Hz
					10'd305: FwordA <= 32'd1082339;  // 31500Hz
					10'd306: FwordA <= 32'd1085775;  // 31600Hz
					10'd307: FwordA <= 32'd1089211;  // 31700Hz
					10'd308: FwordA <= 32'd1092647;  // 31800Hz
					10'd309: FwordA <= 32'd1096083;  // 31900Hz
					10'd310: FwordA <= 32'd1099519;  // 32000Hz

					// 32.1KHz ~ 33.0KHz
					10'd311: FwordA <= 32'd1102955;  // 32100Hz
					10'd312: FwordA <= 32'd1106391;  // 32200Hz
					10'd313: FwordA <= 32'd1109827;  // 32300Hz
					10'd314: FwordA <= 32'd1113263;  // 32400Hz
					10'd315: FwordA <= 32'd1116699;  // 32500Hz
					10'd316: FwordA <= 32'd1120135;  // 32600Hz
					10'd317: FwordA <= 32'd1123571;  // 32700Hz
					10'd318: FwordA <= 32'd1127007;  // 32800Hz
					10'd319: FwordA <= 32'd1130443;  // 32900Hz
					10'd320: FwordA <= 32'd1133879;  // 33000Hz

					// 33.1KHz ~ 34.0KHz
					10'd321: FwordA <= 32'd1137315;  // 33100Hz
					10'd322: FwordA <= 32'd1140751;  // 33200Hz
					10'd323: FwordA <= 32'd1144187;  // 33300Hz
					10'd324: FwordA <= 32'd1147623;  // 33400Hz
					10'd325: FwordA <= 32'd1151059;  // 33500Hz
					10'd326: FwordA <= 32'd1154495;  // 33600Hz
					10'd327: FwordA <= 32'd1157931;  // 33700Hz
					10'd328: FwordA <= 32'd1161367;  // 33800Hz
					10'd329: FwordA <= 32'd1164803;  // 33900Hz
					10'd330: FwordA <= 32'd1168239;  // 34000Hz

					// 34.1KHz ~ 35.0KHz
					10'd331: FwordA <= 32'd1171675;  // 34100Hz
					10'd332: FwordA <= 32'd1175111;  // 34200Hz
					10'd333: FwordA <= 32'd1178547;  // 34300Hz
					10'd334: FwordA <= 32'd1181983;  // 34400Hz
					10'd335: FwordA <= 32'd1185419;  // 34500Hz
					10'd336: FwordA <= 32'd1188855;  // 34600Hz
					10'd337: FwordA <= 32'd1192291;  // 34700Hz
					10'd338: FwordA <= 32'd1195727;  // 34800Hz
					10'd339: FwordA <= 32'd1199163;  // 34900Hz
					10'd340: FwordA <= 32'd1202599;  // 35000Hz
					// 35.1KHz ~ 36.0KHz
					10'd341: FwordA <= 32'd1206035;  // 35100Hz
					10'd342: FwordA <= 32'd1209471;  // 35200Hz
					10'd343: FwordA <= 32'd1212907;  // 35300Hz
					10'd344: FwordA <= 32'd1216343;  // 35400Hz
					10'd345: FwordA <= 32'd1219779;  // 35500Hz
					10'd346: FwordA <= 32'd1223215;  // 35600Hz
					10'd347: FwordA <= 32'd1226651;  // 35700Hz
					10'd348: FwordA <= 32'd1230087;  // 35800Hz
					10'd349: FwordA <= 32'd1233523;  // 35900Hz
					10'd350: FwordA <= 32'd1236959;  // 36000Hz

					// 36.1KHz ~ 37.0KHz
					10'd351: FwordA <= 32'd1240395;  // 36100Hz
					10'd352: FwordA <= 32'd1243831;  // 36200Hz
					10'd353: FwordA <= 32'd1247267;  // 36300Hz
					10'd354: FwordA <= 32'd1250703;  // 36400Hz
					10'd355: FwordA <= 32'd1254139;  // 36500Hz
					10'd356: FwordA <= 32'd1257575;  // 36600Hz
					10'd357: FwordA <= 32'd1261011;  // 36700Hz
					10'd358: FwordA <= 32'd1264447;  // 36800Hz
					10'd359: FwordA <= 32'd1267883;  // 36900Hz
					10'd360: FwordA <= 32'd1271319;  // 37000Hz

					// 37.1KHz ~ 38.0KHz
					10'd361: FwordA <= 32'd1274755;  // 37100Hz
					10'd362: FwordA <= 32'd1278191;  // 37200Hz
					10'd363: FwordA <= 32'd1281627;  // 37300Hz
					10'd364: FwordA <= 32'd1285063;  // 37400Hz
					10'd365: FwordA <= 32'd1288499;  // 37500Hz
					10'd366: FwordA <= 32'd1291935;  // 37600Hz
					10'd367: FwordA <= 32'd1295371;  // 37700Hz
					10'd368: FwordA <= 32'd1298807;  // 37800Hz
					10'd369: FwordA <= 32'd1302243;  // 37900Hz
					10'd370: FwordA <= 32'd1305679;  // 38000Hz

					// 38.1KHz ~ 39.0KHz
					10'd371: FwordA <= 32'd1309115;  // 38100Hz
					10'd372: FwordA <= 32'd1312551;  // 38200Hz
					10'd373: FwordA <= 32'd1315987;  // 38300Hz
					10'd374: FwordA <= 32'd1319423;  // 38400Hz
					10'd375: FwordA <= 32'd1322859;  // 38500Hz
					10'd376: FwordA <= 32'd1326295;  // 38600Hz
					10'd377: FwordA <= 32'd1329731;  // 38700Hz
					10'd378: FwordA <= 32'd1333167;  // 38800Hz
					10'd379: FwordA <= 32'd1336603;  // 38900Hz
					10'd380: FwordA <= 32'd1340039;  // 39000Hz

					// 39.1KHz ~ 40.0KHz
					10'd381: FwordA <= 32'd1343475;  // 39100Hz
					10'd382: FwordA <= 32'd1346911;  // 39200Hz
					10'd383: FwordA <= 32'd1350347;  // 39300Hz
					10'd384: FwordA <= 32'd1353783;  // 39400Hz
					10'd385: FwordA <= 32'd1357219;  // 39500Hz
					10'd386: FwordA <= 32'd1360655;  // 39600Hz
					10'd387: FwordA <= 32'd1364091;  // 39700Hz
					10'd388: FwordA <= 32'd1367527;  // 39800Hz
					10'd389: FwordA <= 32'd1370963;  // 39900Hz
					10'd390: FwordA <= 32'd1374399;  // 40000Hz
					// 40.1KHz ~ 41.0KHz
					10'd391: FwordA <= 32'd1377835;  // 40100Hz
					10'd392: FwordA <= 32'd1381271;  // 40200Hz
					10'd393: FwordA <= 32'd1384707;  // 40300Hz
					10'd394: FwordA <= 32'd1388143;  // 40400Hz
					10'd395: FwordA <= 32'd1391579;  // 40500Hz
					10'd396: FwordA <= 32'd1395015;  // 40600Hz
					10'd397: FwordA <= 32'd1398451;  // 40700Hz
					10'd398: FwordA <= 32'd1401887;  // 40800Hz
					10'd399: FwordA <= 32'd1405323;  // 40900Hz
					10'd400: FwordA <= 32'd1408759;  // 41000Hz

					// 41.1KHz ~ 42.0KHz
					10'd401: FwordA <= 32'd1412195;  // 41100Hz
					10'd402: FwordA <= 32'd1415631;  // 41200Hz
					10'd403: FwordA <= 32'd1419067;  // 41300Hz
					10'd404: FwordA <= 32'd1422503;  // 41400Hz
					10'd405: FwordA <= 32'd1425939;  // 41500Hz
					10'd406: FwordA <= 32'd1429375;  // 41600Hz
					10'd407: FwordA <= 32'd1432811;  // 41700Hz
					10'd408: FwordA <= 32'd1436247;  // 41800Hz
					10'd409: FwordA <= 32'd1439683;  // 41900Hz
					10'd410: FwordA <= 32'd1443119;  // 42000Hz

					// 42.1KHz ~ 43.0KHz
					10'd411: FwordA <= 32'd1446555;  // 42100Hz
					10'd412: FwordA <= 32'd1449991;  // 42200Hz
					10'd413: FwordA <= 32'd1453427;  // 42300Hz
					10'd414: FwordA <= 32'd1456863;  // 42400Hz
					10'd415: FwordA <= 32'd1460299;  // 42500Hz
					10'd416: FwordA <= 32'd1463735;  // 42600Hz
					10'd417: FwordA <= 32'd1467171;  // 42700Hz
					10'd418: FwordA <= 32'd1470607;  // 42800Hz
					10'd419: FwordA <= 32'd1474043;  // 42900Hz
					10'd420: FwordA <= 32'd1477479;  // 43000Hz

					// 43.1KHz ~ 44.0KHz
					10'd421: FwordA <= 32'd1480915;  // 43100Hz
					10'd422: FwordA <= 32'd1484351;  // 43200Hz
					10'd423: FwordA <= 32'd1487787;  // 43300Hz
					10'd424: FwordA <= 32'd1491223;  // 43400Hz
					10'd425: FwordA <= 32'd1494659;  // 43500Hz
					10'd426: FwordA <= 32'd1498095;  // 43600Hz
					10'd427: FwordA <= 32'd1501531;  // 43700Hz
					10'd428: FwordA <= 32'd1504967;  // 43800Hz
					10'd429: FwordA <= 32'd1508403;  // 43900Hz
					10'd430: FwordA <= 32'd1511839;  // 44000Hz

					// 44.1KHz ~ 45.0KHz
					10'd431: FwordA <= 32'd1515275;  // 44100Hz
					10'd432: FwordA <= 32'd1518711;  // 44200Hz
					10'd433: FwordA <= 32'd1522147;  // 44300Hz
					10'd434: FwordA <= 32'd1525583;  // 44400Hz
					10'd435: FwordA <= 32'd1529019;  // 44500Hz
					10'd436: FwordA <= 32'd1532455;  // 44600Hz
					10'd437: FwordA <= 32'd1535891;  // 44700Hz
					10'd438: FwordA <= 32'd1539327;  // 44800Hz
					10'd439: FwordA <= 32'd1542763;  // 44900Hz
					10'd440: FwordA <= 32'd1546199;  // 45000Hz
					// 45.1KHz ~ 46.0KHz
					10'd441: FwordA <= 32'd1549635;  // 45100Hz
					10'd442: FwordA <= 32'd1553071;  // 45200Hz
					10'd443: FwordA <= 32'd1556507;  // 45300Hz
					10'd444: FwordA <= 32'd1559943;  // 45400Hz
					10'd445: FwordA <= 32'd1563379;  // 45500Hz
					10'd446: FwordA <= 32'd1566815;  // 45600Hz
					10'd447: FwordA <= 32'd1570251;  // 45700Hz
					10'd448: FwordA <= 32'd1573687;  // 45800Hz
					10'd449: FwordA <= 32'd1577123;  // 45900Hz
					10'd450: FwordA <= 32'd1580559;  // 46000Hz

					// 46.1KHz ~ 47.0KHz
					10'd451: FwordA <= 32'd1583995;  // 46100Hz
					10'd452: FwordA <= 32'd1587431;  // 46200Hz
					10'd453: FwordA <= 32'd1590867;  // 46300Hz
					10'd454: FwordA <= 32'd1594303;  // 46400Hz
					10'd455: FwordA <= 32'd1597739;  // 46500Hz
					10'd456: FwordA <= 32'd1601175;  // 46600Hz
					10'd457: FwordA <= 32'd1604611;  // 46700Hz
					10'd458: FwordA <= 32'd1608047;  // 46800Hz
					10'd459: FwordA <= 32'd1611483;  // 46900Hz
					10'd460: FwordA <= 32'd1614919;  // 47000Hz

					// 47.1KHz ~ 48.0KHz
					10'd461: FwordA <= 32'd1618355;  // 47100Hz
					10'd462: FwordA <= 32'd1621791;  // 47200Hz
					10'd463: FwordA <= 32'd1625227;  // 47300Hz
					10'd464: FwordA <= 32'd1628663;  // 47400Hz
					10'd465: FwordA <= 32'd1632099;  // 47500Hz
					10'd466: FwordA <= 32'd1635535;  // 47600Hz
					10'd467: FwordA <= 32'd1638971;  // 47700Hz
					10'd468: FwordA <= 32'd1642407;  // 47800Hz
					10'd469: FwordA <= 32'd1645843;  // 47900Hz
					10'd470: FwordA <= 32'd1649279;  // 48000Hz

					// 48.1KHz ~ 49.0KHz
					10'd471: FwordA <= 32'd1652715;  // 48100Hz
					10'd472: FwordA <= 32'd1656151;  // 48200Hz
					10'd473: FwordA <= 32'd1659587;  // 48300Hz
					10'd474: FwordA <= 32'd1663023;  // 48400Hz
					10'd475: FwordA <= 32'd1666459;  // 48500Hz
					10'd476: FwordA <= 32'd1669895;  // 48600Hz
					10'd477: FwordA <= 32'd1673331;  // 48700Hz
					10'd478: FwordA <= 32'd1676767;  // 48800Hz
					10'd479: FwordA <= 32'd1680203;  // 48900Hz
					10'd480: FwordA <= 32'd1683639;  // 49000Hz

					// 49.1KHz ~ 50.0KHz
					10'd481: FwordA <= 32'd1687075;  // 49100Hz
					10'd482: FwordA <= 32'd1690511;  // 49200Hz
					10'd483: FwordA <= 32'd1693947;  // 49300Hz
					10'd484: FwordA <= 32'd1697383;  // 49400Hz
					10'd485: FwordA <= 32'd1700819;  // 49500Hz
					10'd486: FwordA <= 32'd1704255;  // 49600Hz
					10'd487: FwordA <= 32'd1707691;  // 49700Hz
					10'd488: FwordA <= 32'd1711127;  // 49800Hz
					10'd489: FwordA <= 32'd1714563;  // 49900Hz
					10'd490: FwordA <= 32'd1717999;  // 50000Hz
				default: FwordA <= 32'd1717999;   // 1Khz
			endcase
        end
        Develop_two:begin
			Develop_two_flag<=1;
        end
        endcase
    end
    
end
endmodule
