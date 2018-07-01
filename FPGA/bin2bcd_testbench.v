`timescale 1 ns / 10 ps

module bin2bcd_testbench;

	localparam N = 4;
	localparam T = 20;
	
	integer i;
	reg clk, reset, start;
	reg [12:0] bin;
	wire ready, done_tick;
	wire [3:0] bcd3, bcd2, bcd1, bcd0;
	
	bin2bcd uut(clk, reset, start, bin, ready, done_tick, { bcd3, bcd2, bcd1, bcd0 });
	
	// set up the clock
	always
	begin
		clk = 1'b1;
		#(T / 2);
		clk = 1'b0;
		#(T / 2);
	end
	
	// reset the UUT
	initial
	begin
		reset = 1'b1;
		#(T / 2);
		reset = 1'b0;
	end
	
	initial
	begin
		start = 1'b0;
		@(negedge reset);
		@(negedge clk);
		
		for (i = 0; i <= 1; i = i + 1)
			begin
				start = 1'b1;
				bin = i;
				@(negedge clk);
				#(T);
				start = 1'b0;
				@(negedge done_tick);
				#1000;
			end
		
		$stop;
	end
endmodule