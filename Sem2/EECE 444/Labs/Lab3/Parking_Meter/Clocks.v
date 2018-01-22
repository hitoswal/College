`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:06 03/02/2016 
// Design Name: 
// Module Name:    Clocks 
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
module Clocks1Hz(
    input Clkin, reset,
    output reg Clkout
    );
	
reg [26:0] q;

always @ (posedge Clkin, negedge reset)
if (reset == 0)
		q <= 0;
else
		begin
		q <= q+1; 
		if (q == 10000000)
		begin
			Clkout <= 1;
			q <= 0;
		end
		else
		Clkout <= 0;
		end

endmodule

