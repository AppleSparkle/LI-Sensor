module Ui_2channel_latch (CLOCK, ACLEAR, ENABLE, AXIS_SEL, DATA_INPUT, DATA_OUTPUT_0, DATA_OUTPUT_1);

input CLOCK, AXIS_SEL, ENABLE, ACLEAR;

input [31:0] DATA_INPUT;

output reg [31:0] DATA_OUTPUT_0;
output reg [31:0] DATA_OUTPUT_1;

reg [31:0] tmp_data_0;
reg [31:0] tmp_data_1;

always @(posedge CLOCK or posedge ACLEAR)
begin
	
	if(ACLEAR)
		begin
	
			if(AXIS_SEL)
				begin
					tmp_data_1 <= 0;
					DATA_OUTPUT_1 <= 0;
				end
			else
				begin
					tmp_data_0 <= 0;
					DATA_OUTPUT_0 <= 0;
				end
	
		end
	else if(ENABLE)
		begin
		
			if(AXIS_SEL)
				begin
			
					tmp_data_1 <= DATA_INPUT;
					DATA_OUTPUT_1 <= tmp_data_1;
				
				end
			else
				begin
			
					tmp_data_0 <= DATA_INPUT;
					DATA_OUTPUT_0 <= tmp_data_0;
				
				end
		
		end


end




endmodule
