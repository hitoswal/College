`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:24:23 03/10/2016
// Design Name:   Adder32bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/Adder32bit_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Adder32bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Adder32bit_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg Cin;
//	reg Sign;

	// Outputs
	wire [31:0] S;
	wire Z;

	// Instantiate the Unit Under Test (UUT)
	Adder32bit uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
//		.Sign(Sign), 
		.S(S), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;
//		Sign = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Cin = 0;
//		Sign = 0;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		$finish(0);

	end
      
endmodule

