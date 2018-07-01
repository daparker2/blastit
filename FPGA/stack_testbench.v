`timescale 1 ns / 10 ps

module stack_testbench;

	localparam WORD_LEN = 8, WORD_SIZE = 4, NUM_WORDS=16;
	localparam T = 20;

	reg clk, reset, rd, wr;
	reg [WORD_LEN-1:0] w_data;
	wire of, uf;
	wire [WORD_LEN-1:0] r_data;
	integer i;
	
	stack #(WORD_LEN, WORD_SIZE) uut (clk, reset, rd, wr, w_data, r_data, of, uf);
	
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
		w_data = 8'h1;
		rd = 1'b0;
		@(negedge reset);
		@(negedge clk);
		
		for (i = 2; i <= NUM_WORDS; i = i + 1)
			begin
				w_data = i;
				wr = 1'b1;
				@(negedge clk);
				@(posedge clk);
				wr = 1'b0;
				#200;
			end
		
		wr = 1'b0;
		@(negedge clk);
		
		for (i = 2; i <= NUM_WORDS; i = i + 1)
			begin
				rd = 1'b1;
				@(negedge clk);
				@(posedge clk);
				rd = 1'b0;
				#200;
			end
		
		@(negedge clk);
		$stop;
	end
	
endmodule