module output_2ch_latch (CLOCK, ENABLE, AXIS_SEL, DATA_INPUT, PIDOUT_X, PIDOUT_Y);

input CLOCK;
input AXIS_SEL;
input ENABLE;

input [31:0] DATA_INPUT;

output [31:0] PIDOUT_X;
output [31:0] PIDOUT_Y;

reg [31:0] tmp_x;
reg [31:0] tmp_y;

always @(posedge CLOCK)
begin

	if(ENABLE)
	begin
		
		if(AXIS_SEL) tmp_y <= DATA_INPUT;
		else tmp_x <= DATA_INPUT;
		
	end

end

assign PIDOUT_X = tmp_x;
assign PIDOUT_Y = tmp_y;

endmodule
