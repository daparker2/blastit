module tick_counter_testbench;
	localparam T = 20; // Clock period
	localparam N = 4;  // Counter resolution
	
	integer i;
	reg clk, reset;
	reg tick;
	wire [N-1:0] counter;
	wire of;
	
	tick_counter #(.N(N)) uut(.clk(clk), .reset(reset), .tick(tick), .counter(counter), .of(of));
	
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
			tick = 0;
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
		
	task do_tick;
		input reg [N-1:0] count;
		begin
			$display("do_tick: %d counts", count);
			for (i = 0; i < count - 1; i = i + 1)
				begin
					@(negedge clk);
					tick = 1;
					#(T);
					tick = 0;
				end
		end
	endtask
	
	always @*
		$display("do_tick: counter: %d of: %b", counter, of);
		
	// test process
	initial
		begin
			@(negedge reset);
			@(negedge clk);
			
			do_tick(1);
			do_tick(2);
			do_tick(3);
			do_tick(6);
			
			$display("force overflow");
			do_tick(15);
			
			$stop;
		end
	
endmodule