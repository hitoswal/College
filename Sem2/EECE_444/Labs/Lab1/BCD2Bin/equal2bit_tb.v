`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:27:48 02/06/2016
// Design Name:   equal2bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab1/BCD2Bin/equal2bit_tb.v
// Project Name:  BCD2Bin
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: equal2bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module equal2bit_tb;

	// Inputs
	reg [1:0] a;
	reg [1:0] b;

	// Outputs
	wire eq;
	reg exp_eq;
	// Instantiate the Unit Under Test (UUT)
	equal2bit uut (
		.a(a), 
		.b(b), 
		.eq(eq)
	);

	initial begin
		// Initialize Inputs
		a = 2'b0;
		b = 2'b0;
		exp_eq = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		exp_eq = equal(2'b00,2'b00);
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, eq, exp_eq);
		#50;
		exp_eq = equal(2'b00,2'b11);
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, eq, exp_eq);
		#50;
		exp_eq = equal(2'b11,2'b00);
		$monitor("a = %b, b = %b, Ans = %b, Exp Ans = %b", a, b, eq, exp_eq);
		#50;
	end
    function equal(input[1:0] x, y);
		begin
			a = x;
			b = y;
			if( x == y )
				equal = 1;
			else
				equal = 0;
		end
	endfunction  
endmodule

