`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:22:04 03/10/2016
// Design Name:   ALU32bit
// Module Name:   F:/College/Sem2/EECE 444/Labs/Lab4/ALU/ALU32bit_Selftesting_tb.v
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

module ALU32bit_Selftesting_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] Fun;

	// Outputs
	wire [31:0] Out;
	wire Z;
	reg [31:0] expOut;
	reg expZ;
	
//	genvar i;
	
	integer               data_file    ; // file handler
	integer               scan_file    ; // file handler
	integer error_count;
	integer i;
	reg [102:0] captured_data;
	`define NULL 0 

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
			A = 0;
			B = 0; 
			Fun = 0;
			error_count = 0;
			
			#100;
			$display("**************************************");
			$display("** Starting simulation");
			$display("**************************************");
			data_file = $fopen("testalu.txt", "r");
			if (data_file == `NULL) begin
				$display("data_file handle was NULL");
				$finish(0);
			end
		
			for (i = 0; i < 23; i = i+1)
			begin
				#100;
				DataCompare();
//				#10;
				$monitor("[T=%d] Function = %h, A = %h, B = %h, Out = %h, Z = %h, Expected Out = %h, Z = %h", $time, Fun, A, B, Out, Z, expOut, expZ);
			end		
		end
		
		
		       
task DataCompare ();
begin
	
	scan_file = $fscanf(data_file, "%h\n", captured_data); 
	if ($feof(data_file)) 
	begin
		$display("[T=%d] Simulation complete", $time);
		$display("**************************************");
		$display("** %d total errors", error_count);
		$display("**************************************");
		$stop;
	end
	else
	begin
		Fun = captured_data[102:100];
		A = captured_data[99:68];
		B = captured_data[67:36];
		expOut = captured_data[35:4];
		expZ = captured_data[0];
		#1;
	end
	
	
	
	if ((Out == expOut) && (Z == expZ))
		$display("Data Correct");
	else
	begin
		$display("Data Incorrect");
		error_count = error_count + 1;
	end

end
endtask
      
endmodule

