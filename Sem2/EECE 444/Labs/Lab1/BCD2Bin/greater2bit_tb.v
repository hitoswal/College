`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:01:26 02/05/2016
// Design Name:   greater2bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab1/BCD2Bin/greater2bit_tb.v
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

module greater2bit_tb;

	// Inputs
	reg [1:0]a;
	reg [1:0]b;
	
	//Outputs
	wire gt;
	reg exp_gt;
	// Instantiate the Unit Under Test (UUT)
	greater2bit uut (
		.a(a), 
		.b(b), 
		.gt(gt)
	);

	initial begin
		// Initialize Inputs
		a = 2'b0;
		b = 2'b0;
		exp_gt = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		exp_gt = greater(2'b00,2'b00);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(2'b00,2'b11);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(2'b11,2'b00);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
	end 
	function greater(input[1:0] x, y);
		begin
			a = x;
			b = y;
			if( x > y )
				greater = 1;
			else
				greater = 0;
		end
	endfunction   
endmodule

