module PI_reg (clock, period_end,
					REF_IN_N_int32, MES_IN_N_int32,
					Kp_IN_N_float32, Ki_IN_N_float32,
					PI_OUT_N_int32
					);

input clock, period_end;
input [31:0] REF_IN_N_int32, MES_IN_N_int32, Kp_IN_N_float32, Ki_IN_N_float32;

output reg [31:0] PI_OUT_N_int32;

//wires declaration

wire clear_main, start_pireg_wire;
wire C1_EN, C2_EN, C3_EN, C4_EN, C5_EN, C6_EN, C7_EN, C8_EN, C9_EN, C10_EN, C11_EN, C12_EN;


wire [31:0] ERROR_int32;

wire [31:0] ERROR_float32;

wire [31:0] Up_float32;

wire ERROR_msb;

assign ERROR_msb = ERROR_float32 [31];

wire zero_detected;

wire [31:0] Ui_float32;

reg [31:0] Ui_float32_prev;
wire [31:0] Ui_float32_prev_0;
wire [31:0] Ui_float32_prev_1;

wire [31:0] Ui_float32_added;

wire [31:0] Ui_hilim_float32;
wire [31:0] Ui_lolim_float32;
assign Ui_hilim_float32 = 32'b01000101000000000000000000000000;
assign Ui_lolim_float32 = 32'b11000101000000000000000000000000;

wire Ui_aLb, Ui_aGb;

wire [31:0] Ui_lolim_passed;
wire [31:0] Ui_saturated;

wire [31:0] UpUi_float32;

wire [31:0] PI_out_presat;

wire [31:0] PI_out;

wire reset_sysm;

assign reset_sysm = 0;


wire cnt_en_counter;

assign cnt_en_counter = (C1_EN || C2_EN || C3_EN || C4_EN || C5_EN || C6_EN || C7_EN || C8_EN || C9_EN || C10_EN || C11_EN || C12_EN);

wire [4:0] cnt;

assign start_pireg_wire = period_end;


//STAGE 1 - calculating ERROR (int32)
//C1_EN domain

int32_subs	int32_subs_inst (
	.aclr ( clear_main ),
	.clken ( C1_EN ),
	.clock ( clock ),
	.dataa ( REF_IN_N_int32 ),
	.datab ( MES_IN_N_int32 ),
	.result ( ERROR_int32 )
	);

//STAGE 2 - converting ERROR to float32
//C2_EN domain

int_to_float	int_to_float_inst_0 (
	.aclr ( clear_main ),
	.clk_en ( C2_EN ),
	.clock ( clock ),
	.dataa ( ERROR_int32 ),
	.result ( ERROR_float32 )
	);	//Error
	
//STAGE 3 - zero error detector & Error{mult}Kp
//C3_EN domain

zero_err_det zero_err_det_inst
(
	.CLOCK( clock ) ,	// input  CLOCK_sig
	.ENABLE(C3_EN),
	.ERR_MSB_IN( ERROR_msb ) ,	// input  ERR_MSB_IN_sig
	.ZERO( zero_detected ) 	// output  ZERO_sig
);


float_multiplier	float_multiplier_inst_0 (
	.aclr ( clear_main ),
	.clk_en ( C3_EN ),
	.clock ( clock ),
	.dataa ( ERROR_float32 ),
	.datab ( Kp_IN_N_float32 ),
	.result ( Up_float32 )
	);
	
//STAGE 4 - Err*Ki
//C4_EN domain

float_multiplier	float_multiplier_inst_1 (
	.aclr ( clear_main ),
	.clk_en ( C4_EN ),
	.clock ( clock ),
	.dataa ( ERROR_float32 ), //changed 05.02.2014
	.datab ( Ki_IN_N_float32 ),
	.result ( Ui_float32 )
	);
	
//STAGE 5 - Ui accumulation adder
//C5_EN domain

float_adder	float_adder_inst (
	.aclr ( clear_main ),
	.clk_en ( C5_EN ),
	.clock ( clock ),
	.dataa ( Ui_float32 ),
	.datab ( Ui_float32_prev ),
	.result ( Ui_float32_added )
	);
	
//STAGE 6 - 2 channel Ui latch
//C6_EN domain

always @ (posedge clock)
begin

	if (zero_detected) Ui_float32_prev <= 0;
	else if (C6_EN) Ui_float32_prev <= Ui_float32_added; // ADDED "else" 18.02.2014

end

//STAGE 7 & 8 - Ui saturation
//C7_EN & C8_EN domain


Ui_float_compare	Ui_float_compare_inst_aLb (
	.aclr ( clear_main ),
	.clk_en ( C7_EN ),
	.clock ( clock ),
	.dataa ( Ui_float32_prev ),
	.datab ( Ui_lolim_float32 ),
	.agb (  ),
	.alb ( Ui_aLb )
	);
	
mux_axis_sel	Ui_alb_mux (
	.data0x ( Ui_float32_prev ),
	.data1x ( Ui_lolim_float32 ),
	.sel ( Ui_aLb ),
	.result ( Ui_lolim_passed )
	);

Ui_float_compare	Ui_float_compare_inst_aGb (
	.aclr ( clear_main ),
	.clk_en ( C8_EN ),
	.clock ( clock ),
	.dataa ( Ui_lolim_passed ),
	.datab ( Ui_hilim_float32 ),
	.agb ( Ui_aGb ),
	.alb (  )
	);

mux_axis_sel	Ui_agb_mux (
	.data0x ( Ui_lolim_passed ),
	.data1x ( Ui_hilim_float32 ),
	.sel ( Ui_aGb ),
	.result ( Ui_saturated )
	);
	
//STAGE 9 - Up{+}Ui
//C9_EN domain

float_adder	float_adder_Up_plus_Ui (
	.aclr ( clear_main ),
	.clk_en ( C9_EN ),
	.clock ( clock ),
	.dataa ( Up_float32 ),
	.datab ( Ui_saturated ),
	.result ( UpUi_float32 )
	);
	
//STAGE 10 - Up{+}Ui to int32
//C10_EN domain

float_to_int	float_to_int_inst (
	.aclr ( clear_main ),
	.clk_en ( C10_EN ),
	.clock ( clock ),
	.dataa ( UpUi_float32 ),
	.result ( PI_out_presat )
	);

//STAGE 11 - Saturate PI_OUT
//C11_EN domain

PIDout_sat PIDout_sat_inst
(
	.clock( clock ) ,
	.enable( C11_EN ) ,
	.PIDout_presat( PI_out_presat ) ,
	.PIDout( PI_out ) 	
);

defparam PIDout_sat_inst.Upper_limit = 2048;
defparam PIDout_sat_inst.Lower_limit = -2048;

//STAGE 12 -  channel latch
//C12_EN domain


always @ (posedge clock)
begin

	if (C12_EN) PI_OUT_N_int32 <= PI_out;

end


//state machines and COUNTER here

counter_5_bit	counter_5_bit_inst (
	.clock ( clock ),
	.cnt_en ( cnt_en_counter ),
	.sclr ( cnt [4] ),
	.q ( cnt )
	);

syst_ctrl_statemachine syst_ctrl_statemachine_inst
(
	.reset( reset_sysm ) ,	// input  reset_sig
	.clock( clock ) ,	// input  clock_sig
	.C1(cnt [4]) ,	// input  C1_sig
	.C2(cnt [4]) ,	// input  C2_sig
	.C3(cnt [4]) ,	// input  C3_sig
	.C4(cnt [4]) ,	// input  C4_sig
	.C5(cnt [4]) ,	// input  C5_sig
	.C6(cnt [4]) ,	// input  C6_sig
	.C7(cnt [4]) ,	// input  C7_sig
	.C8(cnt [4]) ,	// input  C8_sig
	.C9(cnt [4]) ,	// input  C9_sig
	.C10(cnt [4]) ,	// input  C10_sig
	.C11(cnt [4]) ,	// input  C11_sig
	.C12(cnt [4]) ,	// input  C12_sig
	.START( start_pireg_wire ) ,	// input  START_sig
	.C1_EN( C1_EN ) ,	// output  C1_EN_sig
	.C2_EN( C2_EN ) ,	// output  C2_EN_sig
	.C3_EN( C3_EN ) ,	// output  C3_EN_sig
	.C4_EN( C4_EN ) ,	// output  C4_EN_sig
	.C5_EN( C5_EN ) ,	// output  C5_EN_sig
	.C6_EN( C6_EN ) ,	// output  C6_EN_sig
	.C7_EN( C7_EN ) ,	// output  C7_EN_sig
	.C8_EN( C8_EN ) ,	// output  C8_EN_sig
	.C9_EN( C9_EN ) ,	// output  C9_EN_sig
	.C10_EN( C10_EN ) ,	// output  C10_EN_sig
	.C11_EN( C11_EN ) ,	// output  C11_EN_sig
	.C12_EN( C12_EN ) ,	// output  C12_EN_sig
	.CLR( clear_main ) 	// output  CLR_sig
);

/*defparam syst_ctrl_statemachine_inst.state1 = 0;
defparam syst_ctrl_statemachine_inst.state2 = 1;
defparam syst_ctrl_statemachine_inst.state3 = 2;
defparam syst_ctrl_statemachine_inst.state4 = 3;
defparam syst_ctrl_statemachine_inst.state5 = 4;
defparam syst_ctrl_statemachine_inst.state6 = 5;
defparam syst_ctrl_statemachine_inst.state7 = 6;
defparam syst_ctrl_statemachine_inst.state8 = 7;
defparam syst_ctrl_statemachine_inst.state9 = 8;
defparam syst_ctrl_statemachine_inst.state10 = 9;
defparam syst_ctrl_statemachine_inst.state11 = 10;
defparam syst_ctrl_statemachine_inst.state12 = 11;
defparam syst_ctrl_statemachine_inst.state13 = 12;
defparam syst_ctrl_statemachine_inst.state14 = 13;*/


endmodule
