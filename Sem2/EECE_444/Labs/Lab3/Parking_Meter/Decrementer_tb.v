`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:52:01 03/01/2016
// Design Name:   Decrementer
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab3/Parking_Meter/Decrementer_tb.v
// Project Name:  Parking_Meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Decrementer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Decrementer_tb;

	// Inputs
	reg EA;
	reg [13:0] Time;
	reg clk;

	// Outputs
	wire [13:0] Timeout;

	// Instantiate the Unit Under Test (UUT)
	Decrementer uut (
		.Timein(Time),
		.EA(EA), 
		.clk(clk), 
		.Timeout(Timeout)
	);

	initial begin
		// Initialize Inputs
		EA = 0;

		Time = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		EA = 1;
		Time = 500;
		#100;
		Time = Timeout;
		
		// Add stimulus here

	end
  always @ (clk) #1 clk <= ~clk;    
endmodule

