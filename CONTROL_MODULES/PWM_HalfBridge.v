module PWM_HalfBridge (clock, PWM_DUTY, PWM_OUT_HI, PWM_OUT_LO);

input clock;

input [31:0] PWM_DUTY;
output PWM_OUT_HI, PWM_OUT_LO;

reg [31:0] duty, counter;
reg pwm_out, pwm_hi_reg, pwm_lo_reg;

assign PWM_OUT_HI = ~pwm_hi_reg;
assign PWM_OUT_LO = pwm_lo_reg;

always @ (posedge clock)
begin
	counter <= counter + 1;
	
	if (counter <= duty) pwm_out <= 1;
	else pwm_out <= 0;
	
	if (counter > 2047)
		begin
			counter <= 0;
			if 		(PWM_DUTY < 2048)	duty <= PWM_DUTY;
			else if	(PWM_DUTY > 2048) duty <= PWM_DUTY - 2048;
			else 								duty <= PWM_DUTY;
		end
	
	if 		(PWM_DUTY < 2048)
										begin
											pwm_hi_reg <= pwm_out;
											pwm_lo_reg <= 0;
										end
	else if	(PWM_DUTY == 2048)
										begin
											pwm_hi_reg <= 1;
											pwm_lo_reg <= 0;
										end
	else if	(PWM_DUTY > 2048) begin
											pwm_hi_reg <= 1;
											pwm_lo_reg <= pwm_out;
										end
	
	
	
end
endmodule
