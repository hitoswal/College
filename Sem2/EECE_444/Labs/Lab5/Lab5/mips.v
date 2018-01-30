//--------------------------------------------------------------
// mips.sv
// Updated by Hadil Mustafa 3/1/2015 
// Single-cycle MIPS processor
//--------------------------------------------------------------

// files needed for simulation:
//  mipsttest.v
//  mipstop.v
//  mipsmem.v
//  mips.v
//  mipsparts.v

// single-cycle MIPS processor

module mips(input      	clk, reset,
            output		[31:0] pc,
            input			[31:0] instr,
            output		memwrite,
            output		[31:0] aluout, writedata,
            input			[31:0] readdata);

  wire        memtoreg, branch,
               pcsrc, zero,
               alusrc, regdst, regwrite, jump, ext;
  wire [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump, ext,
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump, ext,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule

module controller(input  	[5:0] op, funct,
                  input 			zero,
                  output	      memtoreg, memwrite,
                  output	      pcsrc, alusrc,
                  output	      regdst, regwrite,
                  output	      jump, ext,
                  output	[2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch, op_fun, n_zero;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, ext, n_zero,
             aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = (n_zero == 1) ? branch & ~zero : branch & zero;
endmodule

module maindec(input  		 [5:0] op,
               output		       memtoreg, memwrite,
               output		       branch, alusrc,
               output		       regdst, regwrite,
               output		       jump, ext, n_zero,
               output		 [1:0] aluop);

  reg [10:0] controls;

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, ext, n_zero, aluop} = controls; // assigning the signals is easier using concatenation of all outputs. 
	
	// insert your code here to define the controls singnal using table 1 in the assignment
//////////////////////////////////////////////////////////////////////////////////////////
	parameter rtype = 6'b000000;  // 
	parameter lw = 6'b100011;  // 
	parameter sw = 6'b101011;  // 
	parameter beq = 6'b000100;	// 
	parameter addi = 6'b001000;	// 
	parameter ju = 6'b000010;	// 
	parameter ori = 6'b001101;	// 
	parameter bne = 6'b000101;	// 
		
	always @ (op) 
	begin
		case(op)
			rtype :begin 
					controls = 11'b1100000xx10;end
		
			lw :begin 
					controls = 11'b10100100x00;end 
				
			sw :begin 
					controls = 11'b0x101x0xx00;end 
				
			beq :begin 
					controls = 11'b0x010x00001;end
				
			addi :begin 
					controls = 11'b10100000x00;end
				
			ju :begin 
					controls = 11'b0xxx0x1xxxx;end
				
			ori :begin 
					controls = 11'b10100001x11;end
				
			bne :begin 
					controls = 11'b0x010x0x101;end

			default:begin controls = 11'bx; end
			
		endcase
	end	
		


//////////////////////////////////////////////////////////////////////////////////////////
  
  
endmodule

module aludec(input   		[5:0] funct,
				  input   		[1:0] aluop,
				  output reg  	[2:0] alucontrol);

	
	
	// use table 2 to define the alucontrol signal here
//////////////////////////////////////////////////////////////////////////////////////////

	parameter addOp = 2'b00;  	// 
	parameter subOp = 2'b01;  	// 
	parameter funcOp = 2'b10;	//
	parameter oriop = 2'b11;	//

	parameter funcAdd = 6'b100000;	//
	parameter funcSub = 6'b100010;	//
	parameter funcAnd = 6'b100100;	//
	parameter funcOr = 6'b100101;		//
	parameter funcSlt = 6'b101010;	//
	parameter opcodori = 6'b001101;	//
	reg [5:0] code;
	
	always @ (aluop,funct) 
	begin
		case(aluop)
			addOp :begin 
					alucontrol = 3'b010; end 
				
			subOp :begin 
					alucontrol = 3'b110;end 
				
			funcOp :begin 
					case(funct)
					funcAdd: begin alucontrol = 3'b010; end
					funcSub: begin alucontrol = 3'b110; end
					funcAnd: begin alucontrol = 3'b000; end
					funcOr: begin alucontrol = 3'b001; end
					funcSlt: begin alucontrol = 3'b111; end
					opcodori: begin alucontrol = 3'b001; end
					default:begin alucontrol = 3'bx ; end
					endcase
					end
					
			oriop :begin 
					alucontrol = 3'b001;end 

			default:begin alucontrol = 3'bx; end
			
		endcase
	end	


//////////////////////////////////////////////////////////////////////////////////////////
  
endmodule

module datapath(input          clk, reset,
                input          memtoreg, pcsrc,
                input          alusrc, regdst,
                input          regwrite, jump, extsig,
                input   [2:0]  alucontrol,
                output         zero,
                output  [31:0] pc,
                input   [31:0] instr,
                output  [31:0] aluout, writedata,
                input   [31:0] readdata);

  wire [4:0]  writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [31:0] signimm, signimmsh, extval, zeroimm;
  wire [31:0] srca, srcb;
  wire [31:0] result;

  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(extval, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, 
                    jump, pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 result, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata,
                     memtoreg, result);
  signext     se(instr[15:0], signimm);
  zeroext     ze(instr[15:0], zeroimm);
  mux2 #(32)  ext(signimm, zeroimm, extsig,
                      extval);
  // ALU logic
  mux2 #(32)  srcbmux(writedata, extval, alusrc,
                      srcb);
  alu         alu(.A(srca), .B(srcb), .Fun(alucontrol),
                  .Out(aluout), .Z(zero));
endmodule

