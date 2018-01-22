`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:16:14 03/08/2016
// Design Name:   Carry_LookAheadAdder8bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/Carry_LookAheadAdder8bit_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Carry_LookAheadAdder8bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Carry_LookAheadAdder8bit_tb;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;
	reg Cin;

	// Outputs
	wire [7:0] S;
	wire Cout;
	wire V;

	// Instantiate the Unit Under Test (UUT)
	Carry_LookAheadAdder8bit uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
		.S(S), 
		.Cout(Cout),
		.V(V)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
      #100;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		Cin = 1;
		#100;
		$finish(0);  
		// Add stimulus here

	end
      
endmodule

