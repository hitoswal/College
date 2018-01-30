module hw5_tb ();
	// These are here for your reference and as an example.
	// I will not test your submissions with any other values
	// of MATRIX_SIZE and DATA_WIDTH.
	localparam MATRIX_SIZE = 5;
	localparam DATA_WIDTH = 32;
	localparam TIMING_START_TEST = 8;
	localparam NUM_TEST_CASES = 17;

	// DUT input and output
	reg [MATRIX_SIZE*DATA_WIDTH-1:0] x;
	wire [MATRIX_SIZE*DATA_WIDTH-1:0] y;
	reg clk, start, reset;
	wire done, ready;

	// Testbench counters and state
	integer stim_num, result_num; // Track which test for input or verification
	integer error_count;          // Total number of errors
	reg prev_done;               // Previous values for DUT signals
	reg prev_start;
	reg prev_ready;
	integer i;                    // Loop variable
	reg measure_timing;
	reg first_measurement;
	integer measurement_count;
	integer sum_clock_counts;
	integer clock_count;
	integer num_start, num_done;

	// Stimulus and result values
	reg signed [MATRIX_SIZE*DATA_WIDTH-1:0] stimulus [0:NUM_TEST_CASES-1];
	reg signed [MATRIX_SIZE*DATA_WIDTH-1:0] results [0:NUM_TEST_CASES-1];

	/////////////////////////
	// Tasks and functions
	/////////////////////////

	// Trigger start signal to capture inputs
	task start_test;
	begin
		start = 1;
		@(negedge clk);
		start = 0;
	end
	endtask

	// Wait for next available input opportunity
	task end_test;
	begin
		wait (ready == 1'b1);
		@(negedge clk);
	end
	endtask

	task run_test;
	begin
		start_test();
		end_test();
	end
	endtask

	// Verify the DUT outputs against provided results
	task verify_results;
	begin
		if( y !== results[result_num] ) begin
			error_count = error_count + 1;
			$display("[T=%t] ERROR: Incorrect result for test %d.\n\tExpected: %b\n\tReceived:%b", $time, result_num+1, results[result_num], y);
		end
	end
	endtask

	// Instantiate the DUT
	hw5 #(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH)) uut (.x(x), .clk(clk), .reset(reset), .start(start), .y(y), .done(done), .ready(ready));

	/////////////////////////////////////////////////////
	// Setup and stimulus generation block
	/////////////////////////////////////////////////////
	initial begin
		x = 0;
		clk = 0;
		start = 0;
		reset = 1;
		stim_num = 0;

		// Load the stimulus values from files
		$readmemh("stimulus.dat", stimulus);

		// Reset DUT
		repeat(4) @(negedge clk);
		reset = 0;

		// Setup first test
		end_test();

		// Proceed through stimulus cases until all are processed
		for( stim_num = 0; stim_num < NUM_TEST_CASES; stim_num = stim_num + 1 ) begin
			x <= stimulus[stim_num];
			$display("[T=%t] INFO: Running test number %d.", $time, stim_num+1);

			// Check that the input values can change mid-operation
			if( stim_num == 6 ) begin
				$display("[T=%t] INFO: Input changing mid-operation test started.", $time);
				start_test();
				@(negedge clk);
				x = ~x;
				end_test();
			end
			else begin
				run_test();
			end

			// Check that the system can remain idle between operations
			if( stim_num == 4 ) begin
				$display("[T=%t] INFO: System held idle for several clock cycles test started.", $time);
				repeat(6) @(negedge clk);
			end

		end
	end

	////////////////////////////////
	// Output verification block
	////////////////////////////////
	initial begin
		result_num = 0;
		error_count = 0;
		measure_timing = 0;
		first_measurement = 1;
		measurement_count = 0;
		sum_clock_counts = 0;
		clock_count = 0;
		num_start = 0;
		num_done = 0;

		// Load the result values from files
		$readmemh("results.dat", results);

		// Wait for reset to complete
		wait (reset == 1'b0);

		// Proceed through test cases and check module outputs
		for( result_num = 0; result_num < NUM_TEST_CASES; result_num = result_num + 1 ) begin
			wait (done == 1'b1);
			@(negedge clk);
			verify_results();
			wait (done == 1'b0);

			// Start timing measurements on indicated test
			if( result_num >= TIMING_START_TEST ) begin
				measure_timing = 1;
			end
		end

		repeat(30) @(posedge clk);

		// Check that the number of requests match the number of results
		if( num_done != num_start ) begin
			$display("[T=%t] ERROR: A different number of operations was started than completed. %d operations started and %d completed.", $time, num_start, num_done);
			error_count <= error_count + 1;
		end

		// Final summary messages
		$display("[T=%t] SUMMARY: Simulation finished with %d total errors.", $time, error_count);
		$display("SUMMARY: Average clock cycles per operation equals %f.", $itor(sum_clock_counts)/$itor(measurement_count));
		$finish;
	end

	////////////////////////////////
	// Timing measurement block
	////////////////////////////////
	always @ (negedge clk) begin
		if( (measure_timing == 1) && (done == 1) ) begin
			if( first_measurement == 1 ) begin
				first_measurement <= 0;
			end
			else begin
				measurement_count <= measurement_count + 1;
				sum_clock_counts <= sum_clock_counts + clock_count + 1;
			end
			clock_count <= 0;
		end
		else begin
			clock_count <= clock_count + 1;
		end
	end

	////////////////////////////////
	// Check that done signal is high for only one cycle
	////////////////////////////////
	always @ (negedge clk) begin
		if( done && prev_done ) begin
			error_count <= error_count + 1;
			$display("[T=%t] ERROR: done signal held asserted for multiple clock cycles.", $time);
		end
		prev_done <= done;
	end

	////////////////////////////////
	// Check that ready goes low one cycle after start is asserted
	////////////////////////////////
	always @ (posedge clk) begin
		prev_start <= start;
	end
	always @ (negedge clk) begin
		if( prev_start && ready ) begin
			error_count <= error_count + 1;
			$display("[T=%t] ERROR: ready signal held asserted after start asserted.", $time);
		end
		prev_ready <= ready;
	end

	////////////////////////////////
	// Check that ready goes low only after start is asserted
	////////////////////////////////
	always @ (negedge clk) begin
		if( prev_ready && ~ready && ~prev_start ) begin
			error_count <= error_count + 1;
			$display("[T=%t] ERROR: ready signal deasserted without start being asserted.", $time);
		end
	end

	////////////////////////////////
	// Keep track of how many start and done signals have occured
	////////////////////////////////
	always @ (posedge clk) begin
		prev_start <= start;
		if( (start == 1) && (prev_start == 0) ) begin
			num_start <= num_start + 1;
		end
	end
	always @ (negedge clk) begin
		prev_done <= done;
		if( (done == 1) && (prev_done == 0) ) begin
			num_done <= num_done + 1;
		end
	end

	// Generate the clock
	always @ (clk)
		#5 clk <= ~clk;

endmodule
