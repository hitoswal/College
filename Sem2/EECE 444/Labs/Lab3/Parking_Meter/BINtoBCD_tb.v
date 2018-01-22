`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:09:46 03/01/2016
// Design Name:   BinarytoBCD
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab3/Parking_Meter/BINtoBCD_tb.v
// Project Name:  Parking_Meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BinarytoBCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BINtoBCD_tb;

	// Inputs
	reg [13:0] Bin;

	// Outputs
	wire [15:0] BCDout;

	// Instantiate the Unit Under Test (UUT)
	BinarytoBCD uut (
		.Bin(Bin), 
		.BCDout(BCDout)
	);

	initial begin
		// Initialize Inputs
		Bin = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		Bin = 1135;
		#100;
		Bin = 500;
		#100;
		Bin = 555;
        
		// Add stimulus here

	end
      
endmodule

