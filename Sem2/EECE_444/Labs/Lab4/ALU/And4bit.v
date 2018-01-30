`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:50 03/10/2016 
// Design Name: 
// Module Name:    And4bit 
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
module And4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Out
    );

assign Out = A & B;

endmodule
