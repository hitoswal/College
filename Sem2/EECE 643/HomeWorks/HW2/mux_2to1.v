module mux_2to1 #(parameter WIDTH = 8) (input [WIDTH-1:0] d1, d0, input sel, output reg [WIDTH-1:0] d_out);
	always @ (d1, d0, sel)
		if( sel )
			d_out = d1;
		else
			d_out = d0;
endmodule
