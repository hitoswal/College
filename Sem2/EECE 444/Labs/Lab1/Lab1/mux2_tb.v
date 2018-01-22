`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:12:25 02/05/2016
// Design Name:   mux2
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab1/Lab1/mux2_tb.v
// Project Name:  Lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mux2_tb;

	// Inputs
	reg in0;
	reg in1;
	reg select;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	mux2 uut (
		.in0(in0), 
		.in1(in1), 
		.select(select), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in0 = 0;
		in1 = 0;
		select = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		in0 = 1;
		in1 = 0;
		select = 0;
		$monitor("%g in0 = %b, in1 = %b, Select = %b, Output = %b", $time, in0, in1, select, out);
		
		#100;
		in0 = 1;
		in1 = 0;
		select = 1;
		$monitor("%g in0 = %b, in1 = %b, Select = %b, Output = %b", $time, in0, in1, select, out);
		$finish;
	end
      
endmodule

