`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:29:37 03/10/2016
// Design Name:   ALU8bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/ALU8bit_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU8bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU8bit_tb;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;
	reg [2:0] ctl;

	// Outputs
	wire [7:0] Output;
	wire N;
	wire Z;
	wire V;
	wire C;

	// Instantiate the Unit Under Test (UUT)
	ALU8b uut (
		.A(A), 
		.B(B), 
		.ctl(ctl), 
		.Output(Output), 
		.N(N), 
		.Z(Z), 
		.V(V), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		ctl = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		#100;
		ctl = 3'b0;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b1;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b10;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b100;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b101;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b110;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = 5;
		#100;
		#100;
		ctl = 3'b111;
		A = 30;
		B = 25;
		#100;
		A = 45;
		B = 55;
		#100;
		A = 128;
		B = -5;
		#100;

	end
      
endmodule

