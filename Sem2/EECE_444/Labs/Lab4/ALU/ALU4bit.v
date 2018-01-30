`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:47:12 03/08/2016 
// Design Name: 
// Module Name:    ALU4bit 
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
module ALU4bit(
    input [2:0] ctl,
    input [3:0] A,
    input [3:0] B,
	 input Cin,
	 output [3:0] Output,
    output N,
    output Z,
    output V,
    output C    
    );

wire [3:0] Bin, Aout, Lout, Andout, Orout; 
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
assign Output = (ctl[1] == 0) ? Lout : Aout;
assign N = (ctl[1] == 0) ? 1'b0 : Ntemp;
assign Z = (ctl[1] == 0) ? 1'b0 : Ztemp;
assign C = (ctl[1] == 0) ? 1'b0 : Ctemp;
assign V = (ctl[1] == 0) ? 1'b0 : Vtemp;
assign Lout = (ctl[0] == 0) ? Andout : Orout;

endmodule
