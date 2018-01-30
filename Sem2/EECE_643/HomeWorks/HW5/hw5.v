// STUDENT
// HW 5
// EECE 643
// Spring 2016

//////////////////////////////////////
// Do not modify the module interface except for possibly changing an
// interface signal from wire to register.
//
// You may ignore the parameters if needed. Your submissions will not be
// tested with values different from the defaults provided.
//
// You may use the packing/upacking code provided or create your own
// equivalent code.
//
// Inputs:
// x     - The vector of input values arranged {xM,...,x4,x3,x2,x1,x0}. These
//         may not remain stable during the computation (i.e., x may change
//         between the start and finish signals).
// clk   - Input clock.
// start - Active high control signal that indicates the values provided on
//         x should be accepted for processing. The value of x should be saved
//         on the clock cycle in which both high and ready are asserted. start
//         should be ignored if ready is deasserted.
// reset - Active high synchronous signal that causes system to reset.
//
// Outputs:
// y     - The vector of output values arranged {yM,...,y4,y3,y2,y1,y0}. They
//         may take on any value while done is deasserted, but must have the
//         correct result whenever done is asserted.
// ready - Active high control signal indicating the module is ready to accept
//         a new input. Ready should remain asserted whenever the module is
//         capable of accepting new input and should remain deasserted during
//         any period in which the module cannot accept new input. ready must
//         become active for at least one cycle between computations.
// done  - Active high control signal indicating the computation is complete
//         and the result, y, is valid. done should remain asserted for only
//         one cycle.
//////////////////////////////////////
module hw5 #(parameter DATA_WIDTH=32, MATRIX_SIZE=5) (input [MATRIX_SIZE*DATA_WIDTH-1:0] x, input clk, start, reset, output [MATRIX_SIZE*DATA_WIDTH-1:0] y, output reg ready, output reg done);

	wire [DATA_WIDTH-1:0] x_val [MATRIX_SIZE-1:0];  // x_val(MATRIX_SIZE-1) down to x_val(0) are the DATA_WIDTH-bit values
	reg [2*DATA_WIDTH-1:0] y_val [MATRIX_SIZE-1:0]; // Resulting y values

	// Pack output y and unpack input x
	genvar i;
	generate
		for( i=MATRIX_SIZE-1; i>=0; i=i-1 ) begin : packing_loop
			assign x_val[i] = x[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH];
			assign y[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i] = y_val[i][DATA_WIDTH-1:0];
		end
	endgenerate

endmodule
