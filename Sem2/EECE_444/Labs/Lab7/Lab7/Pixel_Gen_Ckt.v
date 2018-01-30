module Pixel_Gen_Ckt(
    input clk,
	 input reset,
    input [15:0] pixel_x,
    input [15:0] pixel_y,
	 input [2:0] control0,
	 input [2:0] control1,
	 input [2:0] control2,
	 input mode,
    input video_on,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
    );
localparam x_start = 0;
localparam x_end = 640;
localparam y_start = 0;
localparam y_end = 480;
reg[11:0] rgb;

assign {red, green, blue} = rgb;

always @(posedge clk, posedge reset)
	if (reset == 1)
		rgb <= 12'h000;
	else
		if(video_on == 1)
				case (mode)
					1'b0:	if (pixel_x >= x_start && pixel_x < x_end / 3 && pixel_y >= y_start && pixel_y < y_end-1)
								case (control0)
									3'b000: rgb <= 12'h000;
									3'b001: rgb <= 12'h00F;
									3'b010: rgb <= 12'h0F0;
									3'b011: rgb <= 12'h0FF;
									3'b100: rgb <= 12'hF00;
									3'b101: rgb <= 12'hF0F;
									3'b110: rgb <= 12'hFF0;
									3'b111: rgb <= 12'hFFF;
									default: rgb <= 12'h000;
								endcase
							else if (pixel_x >= x_end/3 && pixel_x < (2*x_end)/3 && pixel_y >= y_start && pixel_y < y_end-1)
								case (control1)
									3'b000: rgb <= 12'h000;
									3'b001: rgb <= 12'h00F;
									3'b010: rgb <= 12'h0F0;
									3'b011: rgb <= 12'h0FF;
									3'b100: rgb <= 12'hF00;
									3'b101: rgb <= 12'hF0F;
									3'b110: rgb <= 12'hFF0;
									3'b111: rgb <= 12'hFFF;
									default: rgb <= 12'h000;
								endcase
							else if (pixel_x >= (2*x_end)/3 && pixel_x < x_end-1 && pixel_y >= y_start && pixel_y < y_end-1)
								case (control2)
									3'b000: rgb <= 12'h000;
									3'b001: rgb <= 12'h00F;
									3'b010: rgb <= 12'h0F0;
									3'b011: rgb <= 12'h0FF;
									3'b100: rgb <= 12'hF00;
									3'b101: rgb <= 12'hF0F;
									3'b110: rgb <= 12'hFF0;
									3'b111: rgb <= 12'hFFF;
									default: rgb <= 12'h000;
								endcase
							else
								rgb <= 12'h000;
				1'b1:	if (pixel_x >= x_start && pixel_x < x_end-1 && pixel_y >= y_start && pixel_y < y_end-1)
							case (control0)
								3'b000: rgb <= 12'h000;
								3'b001: rgb <= 12'h00F;
								3'b010: rgb <= 12'h0F0;
								3'b011: rgb <= 12'h0FF;
								3'b100: rgb <= 12'hF00;
								3'b101: rgb <= 12'hF0F;
								3'b110: rgb <= 12'hFF0;
								3'b111: rgb <= 12'hFFF;
								default: rgb <= 12'h000;
							endcase
						else
							rgb <= 12'h000;
				endcase
endmodule
