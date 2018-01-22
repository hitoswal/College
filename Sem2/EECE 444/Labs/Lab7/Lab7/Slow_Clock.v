
module Slow_Clock(
    input reset,
	 input clkin,
    output reg clkout
    );

reg [2:0] q;

always @ (posedge clkin, posedge reset)
if (reset == 1)
		q <= 0;
else
		begin
		q <= q+ 3'b1; 
		if (q == 3)
		begin
			clkout <= 1;
			q <= 0;
		end
		else
			clkout <= 0;
		end

endmodule
