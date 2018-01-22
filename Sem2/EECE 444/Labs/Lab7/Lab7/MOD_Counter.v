module MOD_Counter
		#(parameter Count = 800)
		( 
			input clk,
			input reset,
			input Enable,
			output reg [15:0] Counter_out
		);

always @ (posedge clk, posedge reset)
	if (reset == 1)
		Counter_out <= 0;
	else if ( Counter_out == Count )
		Counter_out <= 0;
	else if ( Enable == 1 )
		Counter_out <= Counter_out + 16'b1;
	else
		Counter_out <= Counter_out;
endmodule
