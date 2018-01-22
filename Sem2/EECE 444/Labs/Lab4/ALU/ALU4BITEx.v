`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:25 03/23/2016 
// Design Name: 
// Module Name:    ALU4BITEx 
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
module ALU4BITEx(
    input [3:0] ctl,
    input [3:0] A,
    input [3:0] B,
	 input Cin,
	 output [3:0] Output,
    output N,
    output Z,
    output V,
    output C    
    );

wire [3:0] Bin, Aout, Lout, Andout, Orout, XOROut, ShiftOut; 
wire Ntemp, Ztemp, Ctemp, Vtemp;

Carry_LookAheadAdder Add4bit (
    .A(A), 
    .B(B), 
    .Bsign(ctl[2]),
	 .Cin(Cin), 
    .S(Aout),
	 .Cout(Ctemp),
	 .V(Vtemp),
	 .N(Ntemp),
	 .Z(Ztemp)
    );
	 
And4bit AndGate (
    .A(A), 
    .B(Bin), 
    .Out(Andout)
    );

Or4bit OrGate (
    .A(A), 
    .B(Bin), 
    .Out(Orout)
    );
	 
assign Bin = (ctl[2] == 0) ? B : ~B;
assign Output = (ctl[2:1] == 2'd0) ? Lout : (ctl[2:1] == 2'd1) ? Aout : (ctl[2:1] == 2'd2) ? XOROut : ShiftOut;
assign N = (ctl[2:1] == 2'd1) ? Ntemp : 1'b0;
assign Z = (ctl[2:1] == 2'd1) ? Ztemp : 1'b0;
assign C = (ctl[2:1] == 2'd1) ? Ctemp : 1'b0;
assign V = (ctl[2:1] == 2'd1) ? Vtemp : 1'b0;
assign Lout = (ctl[0] == 0) ? Andout : Orout;

endmodule