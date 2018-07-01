`timescale 1 ns / 10 ps

module fifo_testbench;

	localparam WORD_LEN = 8, ADDR_W=8, NUM_WORDS = 2**ADDR_W-1;
	localparam T = 20;

	integer i;
	reg clk, reset, rd, wr;
	reg [WORD_LEN-1:0] w_data;
	wire empty, full;
	wire [WORD_LEN-1:0] r_data;
	
	fifo #(WORD_LEN, ADDR_W) uut (clk, reset, rd, wr, w_data, empty, full, r_data);
	
	task fifo_wr;
		input integer max;
		input integer delay;
		begin
			for (i = 1; i <= max; i = i + 1)
				begin
					w_data = i;
					wr = 1'b1;
					@(negedge clk);
					#(T/2);
					#(delay);
					wr = 1'b0;
				end
			
			for (i = 1; i <= max; i = i + 1)
				begin
					rd = 1'b1;
					@(negedge clk);
					#(T/2);
					#(delay);
					rd = 1'b0;
				end
		end
	endtask
	
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
		rd = 1'b0;
		wr = 1'b0;
		w_data = 0;
		@(negedge reset);
		@(negedge clk);
		
		fifo_wr(1, 0);
		fifo_wr(4, 0);
		fifo_wr(4, 200);
		fifo_wr(NUM_WORDS, 0);
		fifo_wr(NUM_WORDS, 50);
		
		@(negedge clk);
		$stop;
	end
	
endmodule