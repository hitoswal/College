`timescale 1ns / 1ps
module NRZtoNRZI(
    input clk,
	 input reset,
	 input In,
    output reg Out
    );

parameter S0 = 0;
parameter S1 = 1;

reg P_state, N_state;

always @ (posedge clk, negedge reset)
	if (reset == 0)
		P_state <= S0;
	else
		P_state <= N_state;
	
always @ (In, P_state)
	case (P_state)
		S0	:	if (In == 0)
					N_state <= S0;
				else
					N_state <= S1;
					
		S1	:	if (In == 0)
					N_state <= S1;
				else
					N_state <= S0;
		
		default : N_state <= S0;
	endcase
	
always @ (P_state)
	case (P_state)
		S0	: Out <= 0;
		S1	: Out <= 1;
		default : Out <= 0;
	endcase
endmodule
