`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:19:23 03/08/2016
// Design Name:   Carry_LookAheadAdder
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/Carry_LookAheadAdder_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Carry_LookAheadAdder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Carry_LookAheadAdder_tb;

	// Inputs
	reg [3:0] A;
	reg [3:0] B;
	reg Cin;

	// Outputs
	wire [3:0] S;
	wire Cout;

	// Instantiate the Unit Under Test (UUT)
	Carry_LookAheadAdder uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
		.S(S), 
		.Cout(Cout)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
		A = 10;
		B = 5;
		#100;
		A = 15;
		B = 5;
		#100;
		A = 2;
		B = 4;
		Cin = 1;
		#100;
		$finish(0);
        
		// Add stimulus here

	end
      
endmodule

