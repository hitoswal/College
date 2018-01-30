`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:11:42 02/06/2016 
// Design Name: 
// Module Name:    equal2bit 
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
module equal2bit(
    input [1:0] a,
    input [1:0] b,
    output eq
    );

//assign eq = (((~a[0])&(~a[1])&(~b[0])&(~b[1])) | ((~a[0])&a[1]&(~b[0])&b[1]) | (a[0]&a[1]&b[0]&b[1]) | (a[0]&(~a[1])&b[0]&(~b[1])));
assign eq = ((a[0] ~^ b[0]) & (a[1] ~^ b[1]));
endmodule
