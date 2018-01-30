

module mipstest;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] writedata;
	wire [31:0] dataadr;
	wire memwrite;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.reset(reset), 
		.writedata(writedata), 
		.adr(dataadr), 
		.memwrite(memwrite)
	);

	initial begin
		// Initialize Inputs
		clk <= 0;
		reset <= 1;
	   #22;
		reset <= 0;
	end
	
   // generate clock to sequence tests
	
	always #5 clk = ~clk; 
 // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 84 & writedata === 7) begin
		    $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule

