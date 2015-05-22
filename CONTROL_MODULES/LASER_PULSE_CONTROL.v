module LASER_PULSE_CONTROL (	
										input clock, stop, LSR_ON,
										input [31:0] PULSE_LENGTH, PWM_DUTY,
																				
										output PULSE_OUT,
										output reg LASER_VOLTAGE_PWM_OUT
									);

reg [31:0] counter_per, pulse_len;
reg [11:0] counter_pwm, duty;
reg pulse;

assign PULSE_OUT = pulse & LSR_ON & (~stop);

always @(posedge clock)
begin
	
	// This counter generates laser pulsse frequency
	
	counter_per <= counter_per + 1'b1;
	
	if (counter_per < pulse_len) pulse <= 1'b1;
	else pulse <= 1'b0;
	
	if (counter_per > 32'hF4240)
		begin
			counter_per <= 32'h0;
			pulse_len <= PULSE_LENGTH;
		end
		
		
	// This counter generates PWM for laser voltage control
		
	counter_pwm <= counter_pwm + 1'b1;
	
	if (counter_pwm < duty) LASER_VOLTAGE_PWM_OUT <= 1'b1;
	else LASER_VOLTAGE_PWM_OUT <= 1'b0;
	
	if (counter_pwm == 4095)
		begin
			counter_pwm <= 0;
			duty <= PWM_DUTY [11:0];
		end
	
end

endmodule
