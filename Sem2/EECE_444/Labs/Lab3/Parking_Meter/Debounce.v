`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:02 03/01/2016 
// Design Name: 
// Module Name:    Debounce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Debounce(
    input In, Clk, reset,
    output reg Out
    );
parameter s0 = 0;
parameter s1 = 1;

reg State, NextState;
reg Q;

always @ (In, State)

case (State)
s0: if (In == 0)
		NextState = s0;
	 else
		NextState = s1;
		
s1: if (In == 0) 
		NextState = s0;
	 else
		NextState = s1;

default: NextState = s0;

endcase

always @ (posedge Clk, negedge reset)
if (reset == 0)
	State <= s0;
else
	State <= NextState;

always @ (State)
	if (State == s0)
	Out = 0;
	else
	Out = 1;	
endmodule
