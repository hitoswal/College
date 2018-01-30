`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:06:58 03/02/2016 
// Design Name: 
// Module Name:    BCDto7segandmux 
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
module BCDto7seg(
    input [3:0] BCDin,
	 output reg [6:0] seg_Data
    );
	 
//reg [6:0] seg_Data;
always @ (BCDin)
begin
case (BCDin)
	4'b0000: seg_Data = 7'b1111110; //0
	4'b0001: seg_Data = 7'b0110000; //1
	4'b0010: seg_Data = 7'b1101101; //2
	4'b0011: seg_Data = 7'b1111001; //3
	4'b0100: seg_Data = 7'b0110011; //4
	4'b0101: seg_Data = 7'b1011011; //5
	4'b0110: seg_Data = 7'b1011111; //6
	4'b0111: seg_Data = 7'b1110000; //7
	4'b1000: seg_Data = 7'b1111111; //8
	4'b1001: seg_Data = 7'b1111011; //9
	default: seg_Data = 7'b0000000;
endcase
end
endmodule
