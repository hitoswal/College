`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:48:52 02/05/2016
// Design Name:   greater2bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab1/BCD2Bin/test.v
// Project Name:  BCD2Bin
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: greater2bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg [1:0] a;
	reg [1:0] b;

	// Outputs
	wire gt;

	// Instantiate the Unit Under Test (UUT)
	greater2bit uut (
		.a(a), 
		.b(b), 
		.gt(gt)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

