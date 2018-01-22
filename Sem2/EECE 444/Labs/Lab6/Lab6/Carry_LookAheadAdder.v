/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 
module Carry_LookAheadAdder(
    input [3:0] A,
    input [3:0] B,
    input Bsign,
	 input Cin,
    output [3:0] S,
    output Cout,
	 output V,
	 output N,
	 output Z
    );

wire [4:0] Ctemp, C, P, G;
wire [3:0] Bin;
genvar i;

assign C[0] = Cin;
assign Cout = C[4];
assign V = C[4] ^ C[3];
assign N = S[3];
assign Z = (S == 0) ? 1'b1 : 1'b0;
generate	for(i = 0; i < 4; i = i+1) 
begin :adder
	assign Bin[i] = B[i] ^ Bsign;
	FullAdder Add (
    .A(A[i]), 
    .B(Bin[i]), 
    .Cin(C[i]), 
    .S(S[i])
    );
	assign P[i] = A[i] & Bin[i];
	assign G[i] = A[i] | Bin[i];
	assign C[i+1] = P[i] | (G[i] & C[i]);

end
endgenerate
endmodule
