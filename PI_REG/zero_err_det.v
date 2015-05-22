module zero_err_det (CLOCK, ENABLE, ERR_MSB_IN,ZERO);

input CLOCK, ERR_MSB_IN, ENABLE;

output reg ZERO;

reg prev;
reg curr;

always @(posedge CLOCK)
begin
	
	if (ENABLE)
	begin
		prev <= curr;
		curr <= ERR_MSB_IN;
		if (curr != prev)
			begin
				ZERO <= 1;
			end
		else 
			begin
				ZERO <= 0;
			end
	end
end

endmodule
