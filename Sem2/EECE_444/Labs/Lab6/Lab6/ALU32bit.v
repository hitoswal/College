/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 
module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] Fun,
    output [31:0] Out,
    output Z
    );

wire [31:0] Bin, Andout, Orout, Aout, Lout, Outtemp;
wire Ztemp;
	 
Adder32bit Add_Sub32bit (
    .A(A), 
    .B(B), 
    .Cin(Fun[2]), 
//    .Sign(Fun[2]), 
    .S(Aout), 
    .Z(Ztemp)
    );
	 
assign Andout = A & Bin;

assign Orout = A | Bin;

assign Bin = (Fun[2] == 0) ? B : ~B;
assign Outtemp = (Fun[1] == 0) ? Lout : Aout;
assign Z = (Fun[1] == 0) ? 1'b0 : Ztemp;
assign Lout = (Fun[0] == 0) ? Andout : Orout;
assign Out = (Fun == 3'b111) ? {31'b0, Outtemp[31]} : Outtemp;

endmodule
