`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:21 03/01/2016 
// Design Name: 
// Module Name:    BinarytoBCD 
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
module BinarytoBCD(
    input [7:0] Bin,
    output [11:0] BCDout
    );

reg [7:0] B;
reg [11:0] BCD;

integer i;

always @ (Bin)
begin

B = Bin;
BCD = 12'b0;

for(i = 0; i <= 7; i = i+1) 
begin
if (BCD[3:0] > 4'b0100)
	BCD[3:0] = BCD[3:0] + 4'b0011;

if (BCD[7:4] > 4'b0100)
	BCD[7:4] = BCD[7:4] + 4'b0011;

if (BCD[11:8] > 4'b0100)
	BCD[11:8] = BCD[11:8] + 4'b0011;

BCD = {BCD[10:0], B[7]};
B = {B[6:0], 1'b0};
end
end

assign BCDout = BCD;

endmodule
