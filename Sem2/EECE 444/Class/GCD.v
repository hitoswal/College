`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:11:15 05/06/2016 
// Design Name: 
// Module Name:    GCD 
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
module GCD_datapath( 
		input [3:0] x,
		input [3:0] y,
		input x_sel,
		input y_sel,
		output [3:0] GCD
    );
reg[3:0] x_reg, y_reg, GCD_reg;
wire[3:0] xminy, yminx, x_mux, y_mux;
wire xlessy, xequy;

assign x_mux = (x_sel == 0)? x : xmixy;
assign y_mux = (y_sel == 0)? y : ymixx;
assign xminy = x-y;
assign yminx = y-x;
assign xlessy = (x < y) ? 1 : 0;
assign xequy = (x == y) ? 1 : 0;

endmodule
