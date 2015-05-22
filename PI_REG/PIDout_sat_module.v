module PIDout_sat (clock, enable, PIDout_presat, PIDout);

parameter Upper_limit = 2048;
parameter Lower_limit = -2048;

input clock;
input enable;

input signed [31:0] PIDout_presat;

output signed [31:0] PIDout;

reg signed [31:0] PIDout;


always @(posedge clock)
begin

	if(enable)
		begin
		
			if(PIDout_presat < Lower_limit) PIDout <= (Lower_limit + 2048);
			else if (PIDout_presat > Upper_limit) PIDout <= (Upper_limit + 2048);
			else PIDout <= (PIDout_presat + 2048);
		
		
		end
	else
		begin
			
		end

end
endmodule
