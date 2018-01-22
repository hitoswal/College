`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:50:31 03/08/2016
// Design Name:   ALU4bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/ALU4bit_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU4bit_tb;

	// Inputs
	reg [2:0] ctl;
	reg [3:0] A;
	reg [3:0] B;

	// Outputs
	wire [3:0] Output;
	wire N;
	wire Z;
	wire V;
	wire C;

	// Instantiate the Unit Under Test (UUT)
	ALU4bit uut (
		.ctl(ctl), 
		.A(A), 
		.B(B), 
		.Cin(ctl[2]), 
		.Output(Output), 
		.N(N), 
		.Z(Z), 
		.V(V), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		ctl = 0;
		A = 0;
		B = 0;
		

		// Wait 100 ns for global reset to finish
		#100;
		
		A = 5;
		B = 10;
		ctl = 3'b0;
		
		#100;
		ctl = 3'b1;
		#100;
		ctl = 3'b10;
		
		#100;
		ctl = 3'b100;
		#100;
		ctl = 3'b101;
		#100;
		ctl = 3'b110;
		#100;
		ctl = 3'b111;
		#100;
		$finish(0);
		
        
		// Add stimulus here

	end
      
endmodule

