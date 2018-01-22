`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:54:30 03/06/2015
// Design Name:   top
// Module Name:   C:/Users/hmustafa/Xilinx/LAB5/mipstest.v
// Project Name:  LAB5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mipstest;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] writedata;
	wire [31:0] dataadr;
	wire memwrite;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.reset(reset), 
		.writedata(writedata), 
		.dataadr(dataadr), 
		.memwrite(memwrite)
	);

	initial begin
		// Initialize Inputs
		clk <= 0;
		reset <= 1;
	   #22;
		reset <= 0;
	end
	
   // generate clock to sequence tests
	
	always #5 clk = ~clk; 
 // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 84 & writedata === 7) begin
		  //if(dataadr === 84 & writedata === -33022) begin
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule

