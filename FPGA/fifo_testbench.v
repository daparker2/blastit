`timescale 1 ns / 10 ps

module fifo_testbench;

	localparam WORD_LEN = 8, ADDR_W=8, NUM_WORDS = 2**ADDR_W-1;
	localparam T = 20;

	integer i;
	reg clk, reset, rd, wr;
	reg [WORD_LEN-1:0] w_data;
	wire empty, full;
	wire [WORD_LEN-1:0] r_data;
	wire of, uf;
	
	fifo #(.B(WORD_LEN), .W(ADDR_W)) uut (.clk(clk), .reset(reset), .rd(rd), .wr(wr), .w_data(w_data), .empty(empty), .full(full), .r_data(r_data), .of(of), .uf(uf));
	
	task fifo_write;
		input reg [WORD_LEN-1:0] w;
		begin
			w_data = w;
			wr = 1'b1;
			#(T);
			wr = 1'b0;
			#(T);
			$display("    wrote %x (empty=%d full=%d of=%d uf=%d)", w_data, empty, full, of, uf);
		end
	endtask
	
	task fifo_read;
		reg [WORD_LEN-1:0] r;
		begin
			r = r_data;
			rd = 1'b1;
			#(T);
			rd = 1'b0;
			#(T);
			$display("    read %x (empty=%d full=%d of=%d uf=%d)", r, empty, full, of, uf);
		end
	endtask
	
	task fifo_readwrite;
		input reg [WORD_LEN-1:0] w;
		reg [WORD_LEN-1:0] r;
		begin
			w_data = w;
			r = r_data;
			wr = 1'b1;
			rd = 1'b1;
			#(T);
			wr = 1'b0;
			rd = 1'b0;
			#(T);
			$display("    wrote %x, read %x (empty=%d full=%d of=%d uf=%d)", w_data, r, empty, full, of, uf);
		end
	endtask
		
	task fifo_test;
		input integer wr_max;
		input integer rd_max;
		input integer delay;
		input integer wr;
		begin
			$display("=== fifo test wr_max=%d rd_max=%d delay=%d wr=%d of=%d uf=%d", wr_max, rd_max, delay, wr, of, uf);
		
			if (0 != wr)
				begin
					if (wr_max == rd_max)
						begin						
							for (i = 1; i <= wr_max; i = i + 1)
								fifo_readwrite(i);
						end
					else if (wr_max < rd_max)
						begin
							for (i = 1; i <= wr_max; i = i + 1)
								fifo_readwrite(i);
								
							for (i = 1; i <= rd_max - wr_max; i = i + 1)
								fifo_read();
						end
					else if (wr_max > rd_max)
						begin
							for (i = 1; i <= wr_max - rd_max; i = i + 1)
								fifo_write(i);
								
							for (i = 1; i <= rd_max; i = i + 1)
								fifo_readwrite(i + wr_max - rd_max);
						end
				end
			else
				begin
					for (i = 1; i <= wr_max; i = i + 1)
						fifo_write(i);
					
					for (i = 1; i <= rd_max; i = i + 1)
						fifo_read();
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
		
		fifo_test(1, 1, 0, 0);
		fifo_test(1, 1, 0, 1);
		fifo_test(4, 2, 10, 0);
		fifo_test(4, 4, 200, 0);
		fifo_test(4, 2, 10, 1);
		fifo_test(4, 4, 200, 1);
		fifo_test(NUM_WORDS, NUM_WORDS, 0, 0);
		fifo_test(NUM_WORDS - 1, NUM_WORDS, 10, 0);
		fifo_test(NUM_WORDS, NUM_WORDS + 1, 200, 0);
		fifo_test(NUM_WORDS, NUM_WORDS, 0, 1);
		fifo_test(NUM_WORDS, NUM_WORDS + 1, 10, 1);
		fifo_test(NUM_WORDS, NUM_WORDS - 1, 200, 1);
		
		@(negedge clk);
		$stop;
	end
	
endmodule