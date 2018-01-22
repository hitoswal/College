`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:39:27 03/10/2016
// Design Name:   ALU32bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/ALU32bit_tb.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU32bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU32bit_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] Fun;

	// Outputs
	wire [31:0] Out;
	wire Z;

	// Instantiate the Unit Under Test (UUT)
	ALU32bit uut (
		.A(A), 
		.B(B), 
		.Fun(Fun), 
		.Out(Out), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Fun = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Fun = 3'b0;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b1;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b10;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b100;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b101;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b110;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		Fun = 3'b111;
		A = 32'h00000000;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'hFFFFFFFF;
		#100;
		A = 32'h00000001;
		B = 32'h0000FFFF;
		#100;
		A = 32'h00000000;
		B = 32'h00000000;
		#100;
        
		// Add stimulus here

	end
      
endmodule

