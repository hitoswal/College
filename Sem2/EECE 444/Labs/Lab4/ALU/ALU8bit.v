`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:36:55 03/09/2016 
// Design Name: 
// Module Name:    ALU8bit 
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
module ALU8bit(
	 input clk,
    input [7:0] A,
    input [7:0] B,
	 input ctl,
    output [6:0] Disp,
	 output [7:0] Dispctl,
	 output N,
    output Z,
    output V,
    output C
    );
	 
wire Ctemp, Z1, Z2;
wire [7:0] Outtemp, Output, Comp2sout;
wire [11:0] BCD;
reg [2:0] ctlout;
wire [3:0] neg;
reg[24:0] counter = 0;

always @ (posedge clk) 
begin
if (ctl == 1)
	if (counter == 20000000)
	begin
		ctlout = ctlout + 3'b1;
		counter = 24'b0;
	end
	else
		counter = counter + 24'b1;
end
	 
ALU4bit Lower4bit (
    .ctl(ctlout), 
    .A(A[3:0]), 
    .B(B[3:0]), 
    .Cin(ctlout[2]), 
    .Output(Outtemp[3:0]), 
    .N(), 
    .Z(Z1), 
    .V(), 
    .C(Ctemp)
    );

ALU4bit Higher4bit (
    .ctl(ctlout), 
    .A(A[7:4]), 
    .B(B[7:4]), 
    .Cin(Ctemp), 
    .Output(Outtemp[7:4]), 
    .N(N), 
    .Z(Z2), 
    .V(V), 
    .C(C)
    );

BinarytoBCD BCDout (
    .Bin(Output), 
    .BCDout(BCD)
    );

SegmentMux seg7 (
    .clk(clk), 
    .BCDin({1'b0,ctlout,neg,BCD}), 
    .Ctl(Dispctl), 
    .seg(Disp)
    );	 

assign Z = Z1 & Z2;
assign Output = (ctlout == 3'b111) ? {7'b0, Outtemp[7]} : Comp2sout;
assign Comp2sout = (N == 1) ? ((~Outtemp)+ 8'b1) : Outtemp;
assign neg = (N == 1) ? 4'b1010 : 4'b1111;
endmodule
