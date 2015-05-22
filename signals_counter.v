module signals_counter (	
									input clock, reset, 
									input REF, MES,
									output [31:0] DIFF,
									output sign
								);
										
reg r_d, r_d_1, m_d, m_d_1;
reg state, state1;
reg REF_posedge, MES_posedge;
reg [31:0] counter_RtoM, counter_MtoR;
reg [31:0] DIFF_RtoM, DIFF_MtoR;

assign DIFF = (DIFF_RtoM>DIFF_MtoR)?DIFF_MtoR:DIFF_RtoM;
assign sign = (DIFF_RtoM>DIFF_MtoR)?1:0;
								
always @(posedge clock)
begin

	if (reset)
		begin
			r_d				<= 0;
			r_d_1				<= 0;
			m_d				<= 0;
			m_d_1				<= 0;	
			state 			<= 0;
			state1 			<= 0;
			counter_RtoM	<= 0;
			counter_MtoR	<= 0;
			REF_posedge		<= 0;
			MES_posedge		<= 0;
		end
	else
		begin
			
			r_d <= REF;
			r_d_1 <= r_d;
			
			m_d <= MES;
			m_d_1 <= m_d;
			
			if ((r_d == 1) && (r_d_1 == 0))	REF_posedge <= 1;
			else										REF_posedge <= 0;
		
			if ((m_d == 1) && (m_d_1 == 0))	MES_posedge <= 1;
			else										MES_posedge <= 0;
			
			case (state)
				0:	begin
						if (REF_posedge)
							begin
								state <= 1;
								counter_RtoM <= 0;
							end
					end
				1:	begin
						if (MES_posedge)
							begin
								state <= 0;
								DIFF_RtoM <= counter_RtoM;
							end
						else counter_RtoM <= counter_RtoM + 1;
					end
			endcase
			
			case (state1)
				0:	begin
						if (MES_posedge)
							begin
								state1 <= 1;
								counter_MtoR <= 0;
							end
					end
				1:	begin
						if (REF_posedge)
							begin
								state1 <= 0;
								DIFF_MtoR <= counter_MtoR;
							end
						else counter_MtoR <= counter_MtoR + 1;
					end
			endcase
		
		end
		
end

endmodule

									