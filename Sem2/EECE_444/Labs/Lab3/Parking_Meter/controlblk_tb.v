`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:43:28 03/01/2016
// Design Name:   ControlBlock
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab3/Parking_Meter/controlblk_tb.v
// Project Name:  Parking_Meter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ControlBlock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module controlblk_tb;

	// Inputs
	reg clk;
	reg reset;
	reg DSW1;
	reg DSW2;
	reg DSW3;
	reg DSW4;

	// Outputs
	wire [15:0] BCDOut;

	// Instantiate the Unit Under Test (UUT)
	ControlBlock uut (
		.clk(clk), 
		.reset(reset), 
		.DSW1(DSW1), 
		.DSW2(DSW2), 
		.DSW3(DSW3), 
		.DSW4(DSW4), 
		.BCDOut(BCDOut)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#10;
		
		DSW1 = 1;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;
		#2;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;
		#100;
		DSW1 = 0;
		DSW2 = 1;
		DSW3 = 0;
		DSW4 = 0;
		#2;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;
		#100;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 1;
		DSW4 = 0;
		#2;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;
		#100;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 1;
		#2;
		DSW1 = 0;
		DSW2 = 0;
		DSW3 = 0;
		DSW4 = 0;
		// Add stimulus here

	end
	always @ (clk) #1 clk <= ~clk;
      
endmodule

