module VGA_Sync(
    input clk,
	 input reset,
    output reg [15:0] pixel_x,
    output reg [15:0] pixel_y,
    output reg video_on,
    output reg h_sync,
    output reg v_sync
    );

 
localparam H_Tdsip	= 640;
localparam H_Tpw	= 96;
localparam H_Tfp	= 16;
localparam H_Tbp	= 48;
localparam H_TS	= 800;
localparam V_Tdisp	= 480;
localparam V_Tpw	= 2;
localparam V_Tfp	= 10;
localparam V_Tbp	= 29;
localparam V_TS	= 521;

reg horiz_sync, vert_sync, video_on_v, video_on_h;
reg[15:0] h_count, v_count;


	 
always @ (posedge clk)
begin
	if(h_count == H_TS - 1) 
		h_count <= 0;
	else
		h_count <= h_count + 16'b1;

	if((h_count < H_Tpw) && (h_count >= 0))
		horiz_sync <= 0;
	else
		horiz_sync <= 1;
		
		
	if (v_count > V_TS)
		v_count <= 0;
	else if(h_count == H_TS - 1) 
		v_count <= v_count + 16'b1;

	if ((v_count < V_Tpw) && (v_count >= 0))
		vert_sync <= 0;
	else
		vert_sync <= 1;
		
	if (h_count > H_Tpw + H_Tbp && h_count < H_Tpw + H_Tbp + H_Tdsip )
	begin	
		video_on_h <= 1;
		pixel_x <= h_count - 16'd144;
	end
	else
		video_on_h <= 0;
		

	if (v_count > V_Tpw + V_Tbp && v_count < V_Tpw + V_Tbp + V_Tdisp)
	begin
		video_on_v <= 1;
		pixel_y <= v_count - 16'd30;
	end
	else
		video_on_v <= 0;

end

always@(posedge clk)
begin
	h_sync <= horiz_sync;
	v_sync <= vert_sync;
	video_on <= video_on_v & video_on_h;
end

endmodule
