module LI_align (	input  clock, reset, 
						input	 SIGN,
						input  [31:0] POS, DIFF,
						output reg [31:0] RES_POS
						);
						
reg [31:0] diff_reg;

always @(posedge clock)
begin
	if (reset)
		begin
			
		end
	else
		begin
			if (DIFF > 50) diff_reg <= 100;
			else diff_reg <= DIFF<<1;
			
			RES_POS <= SIGN?(POS*100+diff_reg):(POS*100-diff_reg);		
			
		end
end

endmodule
