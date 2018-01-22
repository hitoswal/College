module Slow_Clock_tb;

	// Inputs
	reg reset;
	reg clkin;

	// Outputs
	wire clkout;

	// Instantiate the Unit Under Test (UUT)
	Slow_Clock uut (
		.reset(reset), 
		.clkin(clkin), 
		.clkout(clkout)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		clkin = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        
		// Add stimulus here

	end
 always @ (clkin) #10 clkin <= ~clkin ;     
endmodule

