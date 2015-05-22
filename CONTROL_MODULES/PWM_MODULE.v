module pwm (	clock,
					pwm_duty,
					out_hi_1,
					out_hi_2,
					out_low_1,
					out_low_2,
					period_end
				);
				
input clock;

input [31:0] pwm_duty;

reg [31:0] duty_reg;

output out_hi_1, out_hi_2, out_low_1, out_low_2;

reg pwm_out;

output reg period_end;

reg [31:0] counter = 0;

assign out_hi_1 = pwm_out;
assign out_hi_2 = ~pwm_out;
assign out_low_1 = ~pwm_out;
assign out_low_2 = pwm_out;

always @ (posedge clock)
begin

	counter <= counter + 1;
	
	if (counter <= duty_reg)
		begin
			pwm_out <= 1;
			period_end <= 0;
		end
	else
		begin
			pwm_out <= 0;
			period_end <= 0;
		end
	
	if (counter > 4095)
		begin
			counter <= 0;
			duty_reg <= pwm_duty;
			period_end <= 1;
		end
		
end
				
				
endmodule



module EOP_alignment	(	clock,
								period_end,
								p_end_ext_5_clk
							);
													
input clock, period_end;
output p_end_ext_5_clk;

reg dff1, dff2, dff3, dff4, dff5;

assign p_end_ext_5_clk = (dff1 | dff2 | dff3 | dff4 | dff5);

always @ (posedge clock)
begin

	dff1 <= period_end;
	dff2 <= dff1;
	dff3 <= dff2;
	dff4 <= dff3;
	dff5 <= dff4;
	
end

endmodule


module clock_sync	(
clock_wr, 
clock_rd, 
data_in, 
data_out
);

input clock_wr, clock_rd;
input [31:0] data_in;

output reg [31:0] data_out;

reg [31:0] data_st1, data_st2;

always @ (posedge clock_wr)
begin

	data_st1 <= data_in;
	
end

always @ (posedge clock_rd)
begin
	
	data_st2 <= data_st1;
	data_out <= data_st2;
end

endmodule

///***************************************************************///
///***************************************************************///
///***************************************************************///

module PWM_MODULE (
							input clock_200,
							input clock_in,
							input [31:0] PWM_DUTY_VAL,
							output PWM_HI_1,
							output PWM_HI_2,
							output PWM_LO_1,
							output PWM_LO_2,
							output EOP_5_cycles
						);

wire [31:0] duty_wire;
wire eop_wire;
						
clock_sync clock_sync_inst	(

.clock_wr	(clock_in)		, 
.clock_rd	(clock_200)		, 
.data_in		(PWM_DUTY_VAL)	, 
.data_out	(duty_wire)

);


EOP_alignment EOP_alignment_inst (

.clock				(clock_200)		,
.period_end			(eop_wire)		,
.p_end_ext_5_clk	(EOP_5_cycles)

);

 pwm pwm_inst (
 
.clock		(clock_200)		,
.pwm_duty	(duty_wire)		,
.out_hi_1	(PWM_HI_1)		,
.out_hi_2	(PWM_HI_2)		,
.out_low_1	(PWM_LO_1)		,
.out_low_2	(PWM_LO_2)		,
.period_end	(eop_wire)

);

endmodule
