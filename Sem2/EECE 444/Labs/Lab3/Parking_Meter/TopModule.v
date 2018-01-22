`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:13 03/01/2016 
// Design Name: 
// Module Name:    Controlanddatablock 
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
module TopModule(
    input clk,
	 input reset,
	 input SW1,
    input SW2,
    input SW3,
    input SW4,
    output [6:0] seg,
	 output [7:0] Ctrl,
    output LED
    );
wire in1, in2, in3, in4, clk1hz, clk4hz;
wire [15:0] BCDOut;
wire [6:0] seg0, seg1, seg2, seg3;

Clocks1Hz Clock10Hz (
    .Clkin(clk), 
    .reset(reset), 
    .Clkout(clk1hz)
    );

//Clocks4Hz Clock4Hz (
//    .Clkin(clk), 
//    .reset(reset), 
//    .Clkout(clk4hz)
//    );	 

Debounce Switch1 (
    .In(SW1), 
    .Clk(clk), 
    .reset(reset), 
    .Out(in1)
    );

Debounce Switch2 (
    .In(SW2), 
    .Clk(clk), 
    .reset(reset), 
    .Out(in2)
    );

Debounce Switch3 (
    .In(SW3), 
    .Clk(clk), 
    .reset(reset), 
    .Out(in3)
    );

Debounce Switch4 (
    .In(SW4), 
    .Clk(clk), 
    .reset(reset), 
    .Out(in4)
    );

ControlBlock ctlblk (
    .clk(clk1hz), 
    .reset(reset), 
    .DSW1(in1), 
    .DSW2(in2), 
    .DSW3(in3), 
    .DSW4(in4), 
	 .LED(LED),
    .BCDOut(BCDOut)
    );
	 

	 
SegmentMux Segmux (
    .clk(clk), 
	 .BCDin(BCDOut),
    .Ctl(Ctrl), 
    .seg(seg)
    );
	 
endmodule
