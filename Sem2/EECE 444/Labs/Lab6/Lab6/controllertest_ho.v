/*Name: Hitesh Vijay Oswal and Kausthub Chaudhari*/ 
module controllertest_ho;

	// Inputs
	reg clk;
	reg reset;
	reg [5:0] op;
	reg [5:0] funct;
	reg zero;

	// Outputs
	wire pcen;
	wire memwrite;
	wire irwrite;
	wire regwrite;
	wire alusrca;
	wire iord;
	wire memtoreg;
	wire regdst;
	wire [1:0] alusrcb;
	wire [1:0] pcsrc;
	wire [2:0] alucontrol;

	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.clk(clk), 
		.reset(reset), 
		.op(op), 
		.funct(funct), 
		.zero(zero), 
		.pcen(pcen), 
		.memwrite(memwrite), 
		.irwrite(irwrite), 
		.regwrite(regwrite), 
		.alusrca(alusrca), 
		.iord(iord), 
		.memtoreg(memtoreg), 
		.regdst(regdst), 
		.alusrcb(alusrcb), 
		.pcsrc(pcsrc), 
		.alucontrol(alucontrol)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		op = 0;
		funct = 0;
		zero = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset = 1;
		#10;
		reset = 0;
		//add
		op = 6'b000000;
		funct = 6'b100000;
		zero = 0;
		#50;
		//sub
      reset = 1;
		#10;
		reset = 0;
		op = 6'b000000;
		funct = 6'b100010;
		zero = 0;
		#50;
		//and
      reset = 1;
		#10;
		reset = 0;		
		op = 6'b000000;
		funct = 6'b100100;
		zero = 0;
		#50;
		//or
      reset = 1;
		#10;
		reset = 0;
		op = 6'b000000;
		funct = 6'b100101;
		zero = 0;
		#50;
		//slt
      reset = 1;
		#10;
		reset = 0;
		op = 6'b000000;
		funct = 6'b101010;
		zero = 0;
		#50;
		//lw
      reset = 1;
		#10;
		reset = 0;		
		op = 6'b100011;
		funct = 6'bxxxxxx;
		zero = 0;
		#50;
		//sw
      reset = 1;
		#10;
		reset = 0;
		op = 6'b101011;
		funct = 6'bxxxxxx;
		zero = 0;
		#50;
		//beq
      reset = 1;
		#10;
		reset = 0;
		op = 6'b000100;
		funct = 6'bxxxxxx;
		zero = 1;
		#50;
		//addi
      reset = 1;
		#10;
		reset = 0;
		op = 6'b001000;
		funct = 6'bxxxxxx;
		zero = 0;
		#50;
		//j
      reset = 1;
		#10;
		reset = 0;
		op = 6'b000010;
		funct = 6'bxxxxxx;
		zero = 0;
		#50;
		$finish(0);
	end
   always #5 clk = ~clk;   
endmodule

