`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:53 02/06/2016 
// Design Name: 
// Module Name:    greater4bit 
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
module greater4bit(
    input [3:0] a,
    input [3:0] b,
    output gt
    );

wire xgt, ygt, xeq, yeq;

	 	// Instantiate the module
equal2bit higheq (
    .a(a[3:2]), 
    .b(b[3:2]), 
    .eq(xeq)
    );
	 
// Instantiate the module
greater2bit lowgt (
    .a(a[1:0]), 
    .b(b[1:0]), 
    .gt(ygt)
    );

// Instantiate the module
greater2bit highgt (
    .a(a[3:2]), 
    .b(b[3:2]), 
    .gt(xgt)
    );
assign gt = xgt | (xeq & ygt);
endmodule
