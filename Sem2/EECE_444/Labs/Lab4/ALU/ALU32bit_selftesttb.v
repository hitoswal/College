`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:03:54 03/11/2016
// Design Name:   ALU32bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/ALU32bit_selftesttb.v
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

module ALU32bit_selftesttb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] Fun;

	// Outputs
	wire [31:0] Out;
	wire Z;
	
	reg[102:0] Data[0:21];
	reg[31:0] ExpOut;
	reg[3:0] ExpZ;
	
	integer i;
	integer errorcount = 0;

	// Instantiate the Unit Under Test (UUT)
	ALU32bit uut (
		.A(A), 
		.B(B), 
		.Fun(Fun), 
		.Out(Out), 
		.Z(Z)
	);

	initial 
	begin
		// Initialize Inputs
		$display("**************************************");
		$display("** Starting simulation");
		$display("**************************************");
		A = 0;
		B = 0;
		Fun = 0;
		$readmemh("testalu.txt", Data);
		// Wait 100 ns for global reset to finish
		#100;
		for (i = 0; i < 21; i = i+1)
		begin
			{Fun, A, B, ExpOut, ExpZ} = Data[i];
			#5;
			$monitor("[T=%d] Function = %h, A = %h, B = %h, Out = %h, Z = %h, Expected Out = %h, Z = %h", $time, Fun, A, B, Out, Z, ExpOut, ExpZ);
			if ((compare(ExpOut, Out)) && (compare(ExpZ, Z)))
				$display("Data Correct");
			else
			begin
				$display("Data Inorrect");
				errorcount = errorcount + 1;
			end
		end
		$display("[T=%d] Simulation complete", $time);
		$display("**************************************");
		$display("** %d total errors", errorcount);
		$display("**************************************");
		$stop;
	end

function compare (input exp, act);
begin
	if (exp == act)
		compare = 1;
	else
		compare = 0;
end
endfunction 
 
endmodule

