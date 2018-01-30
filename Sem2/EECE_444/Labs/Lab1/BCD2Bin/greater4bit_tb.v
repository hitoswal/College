`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:06:30 02/08/2016
// Design Name:   greater4bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab1/BCD2Bin/greater4bit_tb.v
// Project Name:  BCD2Bin
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: greater4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module greater4bit_tb;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire gt;
	reg exp_gt;
	// Instantiate the Unit Under Test (UUT)
	greater4bit uut (
		.a(a), 
		.b(b), 
		.gt(gt)
	);

	initial begin
		// Initialize Inputs
		a = 4'b0;
		b = 4'b0;
		exp_gt = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		exp_gt = greater(4'b0000,4'b0000);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0000,4'b1111);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b1111,4'b0000);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0001,4'b0100);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0100,4'b0100);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0100,4'b0101);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0100,4'b1000);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		exp_gt = greater(4'b0010,4'b0001);
		#50;
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, gt, exp_gt);
		#10;
		$finish(0);
	end 
	function greater(input[3:0] x, y);
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