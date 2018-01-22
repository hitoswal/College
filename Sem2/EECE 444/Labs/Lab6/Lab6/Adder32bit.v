/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 
module Adder32bit(
    input [31:0] A,
    input [31:0] B,
    input Cin,
//	 input Sign,
    output [31:0] S,
    output Z
    );
genvar i;
wire [32:0] Ctemp;

generate
for (i = 0; i <= 32-4; i = i + 4)	
begin : add32bit 
Carry_LookAheadAdder Adder32bitloop (
    .A(A[i+3:i]), 
    .B(B[i+3:i]), 
    .Bsign(Cin), 
    .Cin(Ctemp[i]), 
    .S(S[i+3:i]), 
    .Cout(Ctemp[i+4]), 
    .V(), 
    .N(), 
    .Z()
    );
end
endgenerate
assign Ctemp[0] = Cin;
assign Z = (S == 0) ? 1'b1 : 1'b0; 

endmodule
