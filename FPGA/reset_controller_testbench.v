module reset_controller_testbench;
	localparam T = 20; // Clock resolution
	localparam M = 8;  // Counter resolution
	
	integer i;
	reg clk, reset;
	reg start;
	reg [M-1:0] m;
	wire en, ready;
	
	reset_controller #(.M_BITS(M)) uut(.clk(clk), .reset(reset), .start(start), .m(m), .en(en), .ready(ready));
	
	// set up the clock
	always
		begin
			clk = 1'b1;
			#(T / 2);
			clk = 1'b0;
			#(T / 2);
		end
		
	task do_reset;
		input reg [M-1:0] count;
		begin
			$display("do_reset: %d counts", count);
			@(negedge clk);
			m = count;
			start = 1;
			#(T);
			start = 0;
		end
	endtask
	
	initial
		begin
			@(negedge clk);
			reset = 1;
			m = 0;
			#(T / 2);
			reset = 0;
		end
		
	// test process
	initial
		begin
			@(negedge reset);
			@(negedge clk);
			
			for (i = 0; i < 256; i = i + 1)
				begin
					do_reset(i);
					@(negedge clk);
					#(T * (i + 2));
				end
			
			$stop;
		end
	
endmodule