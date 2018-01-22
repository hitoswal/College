`timescale 1ns / 1ps
module SegmentMux(
	 input clk,
    input [19:0] BCDin,
    output reg [7:0] Ctl,
    output reg [6:0] seg
    );
reg[24:0] counter = 0;
reg [3:0] data=0;
reg [3:0] disp = 1;
reg [2:0] Control = 0;

always @ (Control, BCDin)
begin
case (Control)
4'd0: data = BCDin[3:0];
4'd1: data = BCDin[7:4];
4'd2: data = BCDin[11:8];
4'd3: data = BCDin[15:12];
4'd4: data = BCDin[19:16];
default: data = 4'b1111;
endcase
end

always @ (disp)
begin
case (disp)
3'd1: Ctl = 8'b11111110;
3'd2: Ctl = 8'b11111101;
3'd3: Ctl = 8'b11111011;
3'd4: Ctl = 8'b11110111;
3'd5: Ctl = 8'b11101111;
default: Ctl = 8'b11111111;
endcase
end

always@(negedge clk)
begin
if (disp == 1)
	if (counter == 160000)
		begin
		disp = 2;
		end
	else
		begin
		counter = counter + 24'b1;
		Control = 4'd0;
		end
else if (disp == 2)
	if (counter == 320000)
		begin
		disp = 3;
		end
	else
		begin
		counter = counter + 24'b1;
		Control = 4'd1;
		end
else if (disp == 3)
	if (counter == 480000)
		begin
		disp = 4;
		end
	else
		begin
		counter = counter + 24'b1;
		Control = 4'd2;
		end
else if (disp == 4)
	if (counter == 640000)
		begin
		disp = 5;
		end
	else
		begin
		counter = counter + 24'b1;
		Control = 4'd3;
		end
else if (disp == 5)
	if (counter == 800000)
		begin
		disp = 1;
		counter = 0;
		end
	else
		begin
		counter = counter + 24'b1;
		Control = 4'd4;
		end
else 
	disp = 1;
end
	

always @ (*)
begin
case (data)
	4'b0000: seg = ~7'b1111110; //0
	4'b0001: seg = ~7'b0110000; //1
	4'b0010: seg = ~7'b1101101; //2
	4'b0011: seg = ~7'b1111001; //3
	4'b0100: seg = ~7'b0110011; //4
	4'b0101: seg = ~7'b1011011; //5
	4'b0110: seg = ~7'b1011111; //6
	4'b0111: seg = ~7'b1110000; //7
	4'b1000: seg = ~7'b1111111; //8
	4'b1001: seg = ~7'b1111011; //9
	4'b1010: seg = ~7'b0000001; //-
	default: seg = ~7'b0000000;
endcase
end

endmodule