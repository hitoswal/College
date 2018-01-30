//-------------------------------------------------------
// mipsmulti.v
// Last Modified by: Hadil Mustafa 3/28/15
//
// Multicycle MIPS processor
//------------------------------------------------
//editied by
/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 

module mips(input    		clk, reset,
            output [31:0] 	adr, writedata,
            output           memwrite,
            input  [31:0] 	readdata);

  wire        zero, pcen, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst;
  wire [1:0]  alusrcb, pcsrc;
  wire [2:0]  alucontrol;
  wire [5:0]  op, funct;

  controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol);
  datapath dp(clk, reset, 
              pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst,
              alusrcb, pcsrc, alucontrol,
              op, funct, zero,
              adr, writedata, readdata);
endmodule

module controller(input         clk, reset,
                  input  [5:0]  op, funct,
                  input         zero,
                  output        pcen, memwrite, irwrite, regwrite,
                  output        alusrca, iord, memtoreg, regdst,
                  output  [1:0] alusrcb, pcsrc,
                  output  [2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch, pcwrite;

  // Main Decoder and ALU Decoder subunits.
  maindec md(clk, reset, op,
             pcwrite, memwrite, irwrite, regwrite,
             alusrca, branch, iord, memtoreg, regdst, 
             alusrcb, pcsrc, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcen = ((branch & zero) | pcwrite);
 
endmodule

module maindec(input         clk, reset, 
               input   [5:0] op, 
               output        pcwrite, memwrite, irwrite, regwrite,
               output        alusrca, branch, iord, memtoreg, regdst,
               output  [1:0] alusrcb, pcsrc,
               output  [1:0] aluop);

  parameter   Fetch   = 4'b0000; // State 0
  parameter   Decode  = 4'b0001; // State 1
  parameter   MemAdr  = 4'b0010;	// State 2
  parameter   MemRd   = 4'b0011;	// State 3
  parameter   MemWB   = 4'b0100;	// State 4
  parameter   MemWr   = 4'b0101;	// State 5
  parameter   RtypeEx = 4'b0110;	// State 6
  parameter   RtypeWB = 4'b0111;	// State 7
  parameter   BeqEx   = 4'b1000;	// State 8
  parameter   AddiEx  = 4'b1001;	// State 9
  parameter   AddiWB  = 4'b1010;	// state 10
  parameter   JEx     = 4'b1011;	// State 11

  parameter   LW      = 6'b100011;	// Opcode for lw
  parameter   SW      = 6'b101011;	// Opcode for sw
  parameter   Rtype   = 6'b000000;	// Opcode for R-type
  parameter   BEQ     = 6'b000100;	// Opcode for beq
  parameter   ADDI    = 6'b001000;	// Opcode for addi
  parameter   J       = 6'b000010;	// Opcode for j

  reg [3:0]  state, nextstate;
  reg [14:0] controls;

  // state register
  always @(posedge clk or posedge reset)			
    if(reset) state <= Fetch;
    else state <= nextstate;

  // ADD CODE HERE
  // Finish entering the next state logic below.  
  // the first two states, FETCH and DECODE, are completed for you.

  // next state logic
  always @ (*)
    case(state)
      Fetch:   nextstate <= Decode;
      Decode:  case(op)
                 LW:      nextstate <= MemAdr;
                 SW:      nextstate <= MemAdr;
                 Rtype:   nextstate <= RtypeEx;
                 BEQ:     nextstate <= BeqEx;
                 ADDI:    nextstate <= AddiEx;
                 J:       nextstate <= JEx;
                 default: nextstate <= 4'bx; // should never happen
               endcase
      MemAdr:	case(op) 
					  LW:      nextstate <= MemRd;
                 SW:      nextstate <= MemWr;
                 default: nextstate <= 4'bx; // should never happen
               endcase
      MemRd: 	nextstate <= MemWB;
      MemWB: 	nextstate <= Fetch;
      MemWr: 	nextstate <= Fetch;
      RtypeEx: nextstate <= RtypeWB;
      RtypeWB: nextstate <= Fetch;
      BeqEx:   nextstate <= Fetch;
      AddiEx:  nextstate <= AddiWB;
      AddiWB:  nextstate <= Fetch;
      JEx:     nextstate <= Fetch;
      default: nextstate <= 4'bx; // should never happen
    endcase
  // output logic
  assign {pcwrite, memwrite, irwrite, regwrite, 
          alusrca, branch, iord, memtoreg, regdst,
          alusrcb, pcsrc, aluop} = controls;

  // ADD CODE HERE
  // Finish entering the output logic below.  We've entered the
  // output logic for the first two states, S0 and S1, for you.
  always @(*) 
    case(state)
      Fetch:   controls <= 15'h5010;
      Decode:  controls <= 15'h0030;
		MemAdr:	controls <= 15'h0420;
		MemRd:	controls <= 15'h0100;
		MemWB:	controls <= 15'h0880;
		MemWr:	controls <= 15'h2100;
		RtypeEx:	controls <= 15'h0402;
		RtypeWB:	controls <= 15'h0840;
		BeqEx:	controls <= 15'h0605;
		AddiEx:	controls <= 15'h0420;
		AddiWB:	controls <= 15'h0800;
		JEx:		controls <= 15'h4008;
      default: controls <= 15'hxxxx; // should never happen
    endcase
endmodule

module aludec(input  [5:0] funct,
              input  [1:0] aluop,
              output reg [2:0] alucontrol);

  // ADD CODE HERE
  // Complete the design for the ALU Decoder.
  // Your design goes here.  Remember that this is a combinational 
  // module. 

  // Remember that you may also reuse any code from previous labs.
	parameter addOp = 2'b00;  	// 
	parameter subOp = 2'b01;  	// 
	parameter funcOp = 2'b10;	//

	parameter funcAdd = 6'b100000;	//
	parameter funcSub = 6'b100010;	//
	parameter funcAnd = 6'b100100;	//
	parameter funcOr 	= 6'b100101;	//
	parameter funcSlt = 6'b101010;	//
	reg [5:0] code;
	
	always @ (aluop,funct) 
		case(aluop)
			addOp:	alucontrol = 3'b010; 
			subOp:	alucontrol = 3'b110; 
			funcOp:	case(funct)
							funcAdd: alucontrol = 3'b010;
							funcSub: alucontrol = 3'b110;
							funcAnd: alucontrol = 3'b000;
							funcOr:  alucontrol = 3'b001;
							funcSlt: alucontrol = 3'b111;
							default: alucontrol = 3'bx ;
						endcase
			default: alucontrol = 3'bx;
		endcase
	endmodule




// Complete the datapath module below for Lab 7.
// You do not need to complete this module for Lab 6

// The datapath unit is a structural verilog module.  That is,
// it is composed of instances of its sub-modules.  For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated.
// The datapath module is for lab 7. 

module datapath(input         clk, reset,
                input         pcen, irwrite, regwrite,
                input         alusrca, iord, memtoreg, regdst,
                input  [1:0]  alusrcb, pcsrc, 
                input  [2:0]  alucontrol,
                output [5:0]  op, funct,
                output        zero,
                output [31:0] adr, writedata, 
                input  [31:0] readdata);

  // Below are the internal signals of the datapath module.

  wire [4:0]  writereg;
  wire [31:0] pcnext, pc;
  wire [31:0] instr, data, srca, srcb;
  wire [31:0] a, b;
  wire [31:0] aluresult, aluout;
  wire [31:0] signimm;   // the sign-extended immediate
  wire [31:0] signimmsh; // the sign-extended immediate shifted left by 2
  wire [31:0] wd3, rd1, rd2;
  wire [4:0] wa3;
  wire [27:0] slout;

  // op and funct fields to controller
  assign op = instr[31:26];
  assign funct = instr[5:0];
  assign writedata = b;

  // Your datapath hardware goes below.  Instantiate each of the submodules
  // that you need.  Remember that alu's, mux's and various other 
  // versions of parameterizable modules are available in mipsparts.v
  // from Lab 5. You'll likely want to include this verilog file in your
  // simulation.

  // I've included parameterizable 3:1 and 4:1 muxes below for your use.

  // Remember to give your instantiated modules applicable names
  // such as pcreg (PC register), wdmux (Write Data Mux), etc.
  // so it's easier to understand.

  // ADD CODE HERE
  regfile RegFile (
    .clk(clk), 
    .we3(regwrite), 
    .ra1(instr[25:21]), 
    .ra2(instr[20:16]), 
    .wa3(wa3), 
    .wd3(wd3), 
    .rd1(rd1), 
    .rd2(rd2)
    );
	 
	alu ALU (
    .A(srca), 
    .B(srcb), 
    .Fun(alucontrol), 
    .Out(aluresult), 
    .Z(zero)
    );
	 
	mux4 #(32) SrcBMux (
    .d0(b), 
    .d1(32'd4), 
    .d2(signimm), 
    .d3(signimmsh), 
    .s(alusrcb), 
    .y(srcb)
    );
	 
	mux3 #(32) PCMux (
    .d0(aluresult), 
    .d1(aluout), 
    .d2({pc[31:28], slout[27:0]}),
    .s(pcsrc), 
    .y(pcnext)
    );
	 
	signext SignExt (
    .a(instr[15:0]), 
    .y(signimm)
    );
	 
	sl2 #(32) slSrcB (
    .a(signimm), 
    .y(signimmsh)
    );
	 
	sl2#(28) slpcsrc (
    .a({2'b0, instr[25:0]}), 
    .y(slout)
    );
	 
	mux2 #(32) SrcAMux (
    .d0(pc), 
    .d1(a), 
    .s(alusrca), 
    .y(srca)
    );
	 
	mux2 #(32) RegWrData (
    .d0(aluout), 
    .d1(data), 
    .s(memtoreg), 
    .y(wd3)
    );
	 
	mux2  #(5) RegWrAdr(
    .d0(instr[20:16]), 
    .d1(instr[15:11]), 
    .s(regdst), 
    .y(wa3)
    );
	 
	mux2 #(32) PCAdr (
    .d0(pc), 
    .d1(aluout), 
    .s(iord), 
    .y(adr)
    );
	 
	flopr #(32) Aluoutput (
    .clk(clk), 
    .reset(reset), 
    .d(aluresult), 
    .q(aluout)
    );
	 
	flopr #(32) Aout (
    .clk(clk), 
    .reset(reset), 
    .d(rd1), 
    .q(a)
    );
	 
	flopr #(32) Bout (
    .clk(clk), 
    .reset(reset), 
    .d(rd2), 
    .q(b)
    );
	 
	flopr #(32) data_r (
    .clk(clk), 
    .reset(reset), 
    .d(readdata), 
    .q(data)
    );
	 
	flopenr #(32) Instr (
    .clk(clk), 
    .reset(reset), 
    .en(irwrite), 
    .d(readdata), 
    .q(instr)
    );
	 
	flopenr #(32) PCFF (
    .clk(clk), 
    .reset(reset), 
    .en(pcen), 
    .d(pcnext), 
    .q(pc)
    );


  // datapath
  
endmodule


module mux3 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, d2,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input   [WIDTH-1:0] d0, d1, d2, d3,
              input   [1:0]       s, 
              output reg  [WIDTH-1:0] y);

   always@(*)
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule

