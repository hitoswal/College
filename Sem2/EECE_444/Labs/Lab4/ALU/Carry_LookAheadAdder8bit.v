`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:23 03/08/2016 
// Design Name: 
// Module Name:    Carry_LookAheadAdder8bit 
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
module Carry_LookAheadAdder8bit(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
	 output V
    );

wire [8:0] Ctemp;
wire [4:0] Vtemp;
genvar i;

assign Ctemp[0] = Cin;
assign Cout = Ctemp[8];
assign V = Vtemp[4];
generate	for(i = 0; i < 5; i = i+4) 
begin :adder 
	Carry_LookAheadAdder Add8bit (
    .A(A[i+3:i]), 
    .B(B[i+3:i]), 
    .Bsign(Cin),
	 .Cin(Ctemp[i]), 
    .S(S[i+3:i]),
	 .Cout(Ctemp[i+4]),
	 .V(Vtemp[i])
    );

end
endgenerate
endmodule

