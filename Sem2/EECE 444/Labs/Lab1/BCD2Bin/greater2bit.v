`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:45:07 02/05/2016 
// Design Name: 
// Module Name:    greater2bit 
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
module greater2bit(
    input [1:0]a,
    input [1:0]b,
    output gt
    );

		assign gt = ((((~b[0])&(~b[1]))&a[0]) | ((~b[1])&a[1]) | ((a[0]&a[1])&(~b[0])));
	
endmodule
