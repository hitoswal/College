module VGA_Sync_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] pixel_x;
	wire [15:0] pixel_y;
	wire video_on;
	wire h_sync;
	wire v_sync;

	// Instantiate the Unit Under Test (UUT)
	VGA_Sync uut (
		.clk(clk), 
		.reset(reset), 
		.pixel_x(pixel_x), 
		.pixel_y(pixel_y), 
		.video_on(video_on), 
		.h_sync(h_sync), 
		.v_sync(v_sync)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        
		// Add stimulus here

	end
always @ (clk) #10 clk <= ~clk ;     
endmodule

