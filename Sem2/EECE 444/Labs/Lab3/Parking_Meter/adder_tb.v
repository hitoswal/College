`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:33:07 03/04/2016
// Design Name:   Adder
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab3/Parking_Meter/Adder_tb.v
// Project Name:  Parking_Meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Adder_tb;

	// Inputs
	reg clk;
	reg reset;
	reg EA;
	reg [2:0] Sig;

	// Outputs
	wire LED;
	wire [13:0] TotalTime;

	// Instantiate the Unit Under Test (UUT)
	Adder uut (
		.clk(clk), 
		.reset(reset), 
		.EA(EA), 
		.Sig(Sig), 
		.LED(LED), 
		.TotalTime(TotalTime)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		EA = 0;
		Sig = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		Sig = 3'b01;
		EA = 0;
		#2;
		Sig = 0;
		EA = 1;
		#100
      Sig = 3'b10;
		EA = 0;
		#2;
		Sig = 0;
		EA = 1;
		#100;
		Sig = 3'b11;
		EA = 0;
		#2;
		Sig = 0;
		EA = 1;
		#100;
		Sig = 3'b100;
		EA = 0;
		#2;
		Sig = 0;
		EA = 1;
			
	end
always @ (clk) #1 clk <= ~clk;  
        
		// Add stimulus here

      
endmodule

