`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:01 03/01/2016 
// Design Name: 
// Module Name:    ControlBlock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ControlBlock(
    input clk,
	 input reset,
	 input DSW1,
    input DSW2,
    input DSW3,
    input DSW4,
	 output LED,
	 output [15:0] BCDOut	 
    );

parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;
parameter s5 = 3'b101;

reg [2:0] state, nextstate;
wire [13:0] Time;
reg [2:0] Sig;
reg EA;

always @(state, DSW1, DSW2, DSW3, DSW4)
case (state)
s1: 	if (DSW1 == 1) nextstate = s2;
		else if (DSW2 == 1) nextstate = s3;
		else if (DSW3 == 1) nextstate = s4;
		else if (DSW4 == 1) nextstate = s5;
		else nextstate = s1;

default: nextstate = s1;

endcase

always @ (posedge clk, negedge reset)
if (reset == 0)
	state <= s1;
else 
	state <= nextstate;

always @ (state)
if (state == s1) 
	begin
	EA = 1;
	Sig = 3'b00;
	end

else if (state == s2) 
	begin
	Sig = 3'b01;
	EA = 0;
	end

else if (state == s3) 
	begin
	Sig = 3'b10;
	EA = 0;
	end

else if (state == s4) 
	begin
	Sig = 3'b11;
	EA = 0;
	end

else if (state == s5) 
	begin
	Sig = 3'b100;
	EA = 0;
	end

else
	begin
	Sig = 3'b00;
	EA = 0;
	end

Adder Data (
    .clk(clk),
	 .reset(reset),
	 .EA(EA),
    .Sig(Sig),
	 .LED(LED),
    .TotalTime(Time)
    );
	 
BinarytoBCD BINtoBCD (
    .Bin(Time), 
    .BCDout(BCDOut)
    );

endmodule
