`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:02:20 02/16/2016
// Design Name:   Topmodule
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab2/Taillightcontro/TopModule_tb.v
// Project Name:  Taillightcontro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Topmodule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TopModule_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg Left;
	reg Right;
	reg Hazard;
	reg Break;

	// Outputs
	wire LA;
	wire LB;
	wire LC;
	wire RA;
	wire RB;
	wire RC;

	

	// Instantiate the Unit Under Test (UUT)
	Topmodule uut (
		.clk(Clk), 
		.Reset(Reset), 
		.Left(Left), 
		.Right(Right), 
		.Hazard(Hazard), 
		.Break(Break), 
		.LA(LA), 
		.LB(LB), 
		.LC(LC), 
		.RA(RA), 
		.RB(RB), 
		.RC(RC)
	);
	
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 1;
		Left = 0;
		Right = 0;
		Hazard = 0;
		Break = 0;
	
		// Wait 100 ns for global reset to finish
		#100;
		
		// Reset for 2 clock cycles
		Reset = 0;
		repeat(2) @(posedge Clk);
		Reset = 1;

		repeat(2) @(posedge Clk);

		Left = 1;
		Right = 0;
		Hazard = 0;
		Break = 0;
		repeat(10) @(posedge Clk);
		Left = 0;
		Right = 1;
		Hazard = 0;
		Break = 0;
		repeat(10) @(posedge Clk);
		Left = 0;
		Right = 0;
		Hazard = 1;
		Break = 0;
		repeat(10) @(posedge Clk);
		Left = 0;
		Right = 0;
		Hazard = 0;
		Break = 1;
		repeat(10) @(posedge Clk);

	end
	
	// Generate the system clock
	always @ (Clk) #1 Clk <= ~Clk;
	
endmodule

