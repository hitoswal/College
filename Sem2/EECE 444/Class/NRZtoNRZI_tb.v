`timescale 1ns / 1ps
module NRZtoNRZI_tb;

	// Inputs
	reg clk;
	reg reset;
	reg In;

	// Outputs
	wire Out;

	// Instantiate the Unit Under Test (UUT)
	NRZtoNRZI uut (
		.clk(clk), 
		.reset(reset), 
		.In(In), 
		.Out(Out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		In = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		In = 0;
		#25;
      In = 1;
		#20;
		In = 1;
		#20;
		In = 1;
		#20;
		In = 0;
		#20;
		In = 0;
		#20;
		In = 1;
		#20;
		In = 0;
		#20;
		$finish(0);
		// Add stimulus here

	end
always @ (clk) #10 clk <= ~clk;      
endmodule

