module trigger_block_1 (
								clock_tb1,
								ref_chain,
								mes_chain,
								xor_chain,
								refand_chain
								);

input clock_tb1, ref_chain, mes_chain;
output xor_chain, refand_chain;

reg dqtb1ref, dqtb2ref, dqtb3ref;
reg dqtb1mes, dqtb2mes, dqtb3mes;

wire npand_ref, npand_mes;

assign npand_ref = (dqtb2ref) & (~dqtb3ref);
assign npand_mes = (dqtb2mes) & (~dqtb3mes);

assign xor_chain = npand_ref^npand_mes;
assign refand_chain = npand_ref;

always @(posedge clock_tb1)
begin

		dqtb1ref <= ref_chain;
		dqtb2ref <= dqtb1ref;
		dqtb3ref <= dqtb2ref;
		
		dqtb1mes <= mes_chain;
		dqtb2mes <= dqtb1mes;
		dqtb3mes <= dqtb2mes;
		
end

endmodule



////////////////////////*****************************************\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



module trigger_block_2  (
								clock_tb2,
								xor_chain2,
								refand_chain2,
								enable_chain,
								updown_chain	
								);
								
input clock_tb2, xor_chain2, refand_chain2;
output enable_chain, updown_chain;
								
reg dqtb1xor, dqtb2xor;
reg dqtb1npand, dqtb2npand;

assign enable_chain = dqtb2xor;
assign updown_chain = dqtb2npand;

always @(posedge clock_tb2)
begin
	
	dqtb1xor <= xor_chain2;
	dqtb2xor <= dqtb1xor;
	
	dqtb1npand <= refand_chain2;
	dqtb2npand <= dqtb1npand;
	
end

endmodule



////////////////////////*****************************************\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



module pulse_counter (
							clk,
							reset,
							enable,
							updown_port,
							data_out
							);

input clk, reset, updown_port, enable;

output reg signed [31:0] data_out;

reg signed [31:0] tmp;


always @ (posedge clk)
begin
	if(reset) 
		begin
			tmp <= 0;
			data_out <= 0;
		end
	else
		begin
			if(enable)
			begin
				if (updown_port) tmp <= tmp + 1;
				else tmp <= tmp - 1;
			end
			data_out <= tmp;
		end
end

//assign data_out = tmp;

endmodule



////////////////////////*****************************************\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



module LASINT_SIG_PROCESSING (
										input clock, LI_REF, LI_MES, reset_c,
										output [31:0] DATA32_POS
										);
										
wire xor_wire, npand_wire, ena_wire, updown_wire;
										
trigger_block_1 L_SIG_inst1 (

.clock_tb1		(clock),
.ref_chain		(LI_REF),
.mes_chain		(LI_MES),
.xor_chain		(xor_wire),
.refand_chain	(npand_wire)

);

trigger_block_2 L_SIG_inst2 (

.clock_tb2			(clock),
.xor_chain2			(xor_wire),
.refand_chain2		(npand_wire),
.enable_chain		(ena_wire),
.updown_chain		(updown_wire)
	
);

pulse_counter L_SIG_inst3 (

.clk				(clock),
.reset			(reset_c),
.enable			(ena_wire),
.updown_port	(updown_wire),
.data_out		(DATA32_POS)

);
endmodule
