module ALU8b(
//	 input clk,
    input [7:0] A,
    input [7:0] B,
	 input [2:0] ctl,
    output [7:0] Output,
//	 output [7:0] Dispctl,
	 output N,
    output Z,
    output V,
    output C
    );
	 
wire Ctemp, Z1, Z2;
wire [7:0] Outtemp;
//wire [11:0] BCD;
//reg [2:0] ctlout;
//wire [3:0] neg;
//reg[24:0] counter = 0;

//always @ (posedge clk) 
//begin
//if (ctl == 1)
//	if (counter == 20000000)
//	begin
//		ctlout = ctlout + 3'b1;
//		counter = 24'b0;
//	end
//	else
//		counter = counter + 24'b1;
//end
	 
ALU4bit Lower4bit (
    .ctl(ctl), 
    .A(A[3:0]), 
    .B(B[3:0]), 
    .Cin(ctl[2]), 
    .Output(Outtemp[3:0]), 
    .N(), 
    .Z(Z1), 
    .V(), 
    .C(Ctemp)
    );

ALU4bit Higher4bit (
    .ctl(ctl), 
    .A(A[7:4]), 
    .B(B[7:4]), 
    .Cin(Ctemp), 
    .Output(Outtemp[7:4]), 
    .N(N), 
    .Z(Z2), 
    .V(V), 
    .C(C)
    );

//BinarytoBCD BCDout (
//    .Bin(Output), 
//    .BCDout(BCD)
//    );
//
//SegmentMux seg7 (
//    .clk(clk), 
//    .BCDin({1'b0,ctlout,neg,BCD}), 
//    .Ctl(Dispctl), 
//    .seg(Disp)
//    );	 

assign Z = Z1 & Z2;
assign Output = (ctl == 3'b111) ? {7'b0, Outtemp[7]} : Outtemp;
//assign Comp2sout = (N == 1) ? ((~Outtemp)+ 8'b1) : Outtemp;
//assign neg = (N == 1) ? 4'b1010 : 4'b1111;
endmodule
