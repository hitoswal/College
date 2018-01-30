module signext(input  [15:0] a,
               output [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule
//////////////////////////////////////////////////////////////////////////////////////
module regfile(input 	    clk, 
               input       we3, 
               input [4:0]  ra1, ra2, wa3, 
               input [31:0] wd3, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////////////
module FullAdder(
    input A,
    input B,
    input Cin,
    output S
    );

assign S = A ^ B ^ Cin;

endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
module mux2 #(parameter WIDTH = 8)
             (input  			[WIDTH-1:0] d0, d1, 
              input            s, 
              output				 [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule
//////////////////////////////////////////////////////////////////////////////////////
module mux4 #(parameter WIDTH = 8)
             (input  			[WIDTH-1:0] d0, d1, d2, d3 
              input            [1:0] s, 
              output				 [WIDTH-1:0] y);
	case(s)
	2b'00: assign y = d0; 
	2b'00: assign y = d1; 
	2b'00: assign y = d2; 
	2b'00: assign y = d3; 
	endcase
endmodule
//////////////////////////////////////////////////////////////////////////////////////
module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign y = {a[29:0], 2'b00};
endmodule
//////////////////////////////////////////////////////////////////////////////////////
module flopr #(parameter WIDTH = 8)
              (input            clk, reset,
               input  [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule