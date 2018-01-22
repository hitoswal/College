`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:14:23 03/03/2016
// Design Name:   DataPath
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab3/Parking_Meter/Datapath_tb.v
// Project Name:  Parking_Meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DataPath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Datapath_tb;

	// Inputs
	reg [2:0] Sig;
	reg EA;
	reg clk;

	// Outputs
	wire [13:0] Timeout;

	// Instantiate the Unit Under Test (UUT)
	DataPath uut (
		.Sig(Sig), 
		.EA(EA), 
		.clk(clk), 
		.Timeout(Timeout)
	);

	initial begin
		// Initialize Inputs
		Sig = 0;
		EA = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      Sig = 3'b01;
		#2;
		Sig = 3'b00;
		EA = 1;
		#50;
		EA = 0;
		Sig = 3'b10;
		#2;
		Sig = 3'b00;
		EA = 1;
		#50;
		// Add stimulus here

	end
always @ (clk) #1 clk <= ~clk;       
endmodule

