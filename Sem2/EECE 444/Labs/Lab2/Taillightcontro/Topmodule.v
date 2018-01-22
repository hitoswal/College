`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:54 02/16/2016 
// Design Name: 
// Module Name:    Topmodule 
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
module Topmodule(
    input clk,
    input Reset,
    input Left,
    input Right,
    input Hazard,
    input Break,
    output reg LA,
    output reg LB,
    output reg LC,
    output reg RA,
    output reg RB,
    output reg RC,
	 output clock
    );
	 
reg [2:0] state, next_state;
wire Clk;

parameter AllOff = 3'b000;
parameter SLA = 3'b001;
parameter SLB = 3'b010;
parameter SLC = 3'b011;
parameter SRA = 3'b100;
parameter SRB = 3'b101;
parameter SRC = 3'b110;
parameter AllOn = 3'b111;

//Instantiate the module
clkdiv instance_name (
    .clk(clk), 
    .clr(~Reset), 
    .clk3(Clk)
    );

//assign clock = Clk;

always @ (Left, Right, Break, Hazard, state)
begin
case (state) 

AllOff : if (Break == 1) next_state = AllOn;
			else if (Hazard == 1) next_state = AllOn;
			else if (Left == 1) next_state = SLA;
			else if (Right == 1) next_state = SRA;
			else next_state = AllOff;

SLA : if (Left == 1) next_state = SLB;
	  else next_state = AllOff;

SLB : if (Left == 1) next_state = SLC;
	  else next_state = AllOff;

SLC : next_state = AllOff;

SRA : if (Right == 1) next_state = SRB;
	  else next_state = AllOff;
 
SRB : if (Right == 1) next_state = SRC;
	  else next_state = AllOff;

SRC : next_state = AllOff;
		

AllOn : if (Break == 1) next_state = AllOn;
		  else if (Hazard == 1) next_state = AllOff;
		  else next_state = AllOff;
			
default : next_state = AllOff;

endcase
end

always @ (posedge Clk)

if (Reset == 0) state <= AllOff;
else state <= next_state;

always @ (state)

if (state == AllOn)
begin
	RA = 1;
	RB = 1;
	RC = 1;
	LA = 1;
	LB = 1;
	LC = 1;
end
else if(state == SLA) 
begin
	RA = 0;
	RB = 0;
	RC = 0;
	LA = 1;
	LB = 0;
	LC = 0;
end
else if(state == SLB) 
begin
	RA = 0;
	RB = 0;
	RC = 0;
	LA = 1;
	LB = 1;
	LC = 0;
end
else if(state == SLC) 
begin
	RA = 0;
	RB = 0;
	RC = 0;
	LA = 1;
	LB = 1;
	LC = 1;
end
else if(state == SRA) 
begin
	RA = 1;
	RB = 0;
	RC = 0;
	LA = 0;
	LB = 0;
	LC = 0;
end
else if(state == SRB) 
begin
	RA = 1;
	RB = 1;
	RC = 0;
	LA = 0;
	LB = 0;
	LC = 0;
end

else if(state == SRC) 
begin
	RA = 1;
	RB = 1;
	RC = 1;
	LA = 0;
	LB = 0;
	LC = 0;
end

else 
begin
	RA = 0;
	RB = 0;
	RC = 0;
	LA = 0;
	LB = 0;
	LC = 0;
end


endmodule

module clkdiv(
	input clk,
	input clr,
	output clk3
	);
reg [24:0] q;

always @ (posedge clk or posedge clr)
	begin
		if (clr == 1)
			q <= 0;
			else
			q <= q+1;
	end
assign clk3 = q[24];

endmodule	

			
