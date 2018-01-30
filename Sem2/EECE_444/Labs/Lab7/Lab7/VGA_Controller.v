module VGA_Controller(
    input clk,
	 input reset,
    input [2:0] control0,
	 input [2:0] control1,
	 input [2:0] control2,
	 input mode,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output h_sync,
    output v_sync
    );

wire Clk25MHz, video_on;
wire [15:0] pixel_x, pixel_y;

Slow_Clock Clock25MHz (
    .reset(~reset), 
    .clkin(clk), 
    .clkout(Clk25MHz)
    );

VGA_Sync VGA_Synchronization (
    .clk(Clk25MHz), 
    .reset(~reset), 
    .pixel_x(pixel_x), 
    .pixel_y(pixel_y), 
    .video_on(video_on), 
    .h_sync(h_sync), 
    .v_sync(v_sync)
    );

Pixel_Gen_Ckt Pixel_Generation_Circuit (
    .clk(Clk25MHz),
	 .reset(~reset),
    .pixel_x(pixel_x), 
    .pixel_y(pixel_y), 
    .control0(control0),
	 .control1(control1),
	 .control2(control2),
	 .mode(mode),
    .video_on(video_on), 
    .red(red), 
    .green(green), 
    .blue(blue)
    );

endmodule
