module MOVEMENT_GEN (clock, button, MOVE_X, MOVE_Y);

input clock, button;

reg [2:0] state;

output reg signed [31:0] MOVE_X, MOVE_Y;

always @ (posedge clock)
begin
	
	if (button) state <= state + 1;
	
	
	if 		(state == 0) begin
									MOVE_X <= 0;
									MOVE_Y <= 0;
								end
	else if	(state == 1) begin
									MOVE_X <= -512;
									MOVE_Y <= 512;
								end
	else if	(state == 2) begin
									MOVE_X <= -1024;
									MOVE_Y <= 1024;
								end
	else
								begin
									MOVE_X <= 0;
									MOVE_Y <= 0;
									state <= 0;
								end								
end

endmodule
