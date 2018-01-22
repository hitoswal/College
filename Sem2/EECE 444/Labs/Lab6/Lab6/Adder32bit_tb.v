/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 

module Adder32bit_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg Cin;
//	reg Sign;

	// Outputs
	wire [31:0] S;
	wire Z;

	// Instantiate the Unit Under Test (UUT)
	Adder32bit uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
//		.Sign(Sign), 
		.S(S), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;
//		Sign = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Cin = 0;
//		Sign = 0;
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
		$finish(0);

	end
      
endmodule

