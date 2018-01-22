`timescale 1ns / 1ps

module Adder(
	 input clk,
	 input reset,
	 input EA,
    input [2:0] Sig,
	 output reg LED,
    output reg [13:0] TotalTime
    );

reg [14:0] Time = 0;
reg [4:0 ]q = 0, r = 0, s = 0;

always @ (posedge clk, negedge reset)
begin
	if (reset == 0)
	Time <= 0;
else
	begin
	if (EA == 0)
		begin
		if (Sig == 3'b01)
			if (Time >= 9999 - 50)
				Time <= 9999;
			else
				begin
				Time <= Time + 14'd50;
				end
			
		else if (Sig == 3'b10)
			if (Time >= 9999 - 150)
				Time <= 9999;
			else
				begin
				Time <= Time + 14'd150;
				end
			
		else if (Sig == 3'b11)
			if (Time >= 9999 - 250)
				Time <= 9999;
			else
				begin
				Time <= Time + 14'd250;
				end
			
		else if (Sig == 3'b100)
			if (Time >= 9999 - 500)
				Time <= 9999;
			else
				begin
				Time <= Time + 14'd500;
				end
			
		else
			Time <= Time;
		end
	else
		begin
		if (Time == 0)
			Time <= 0;
		else
			begin
			q <= q+1; 
			if (q == 10)
				begin
				if (Time >= 9999)
				Time <= 9999;
				Time <= Time - 14'b1;
				q <= 0;
				end
			end
		end
		
	if ((Time <=10) && (Time >0))
		begin
		s <= s+1;
		if (s == 10)
			begin
			LED <= ~LED;
			s <= 0;
			end
		end
	
	else if (Time ==0)
		begin
		r <= r+1;
		if (r == 5)
			begin
			LED <= ~LED;
			r <= 0;
			end
		end
	
	else
		LED <= 0;
	
	TotalTime <= Time;
	end
end
endmodule


