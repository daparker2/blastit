module timer_counter_testbench;
	localparam T = 20;        // Clock period
	localparam M = 4, N = 4;  // Counter resolution

	reg clk, reset;
	reg [M-1:0] m;
	wire [N-1:0] counter;
	wire of;
	
	timer_counter #(.M_BITS(M), .N_BITS(N)) uut(.clk(clk), .reset(reset), .m(m), .counter(counter), .of(of));
	
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
			m = 0;
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
		
	task set_counter;
		input reg[M-1:0] m_i;
		begin
			@(negedge clk);
			m = m_i;
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
	endtask
	
	// test process
	initial
		begin
			@(negedge reset);
			@(negedge clk);
			
			@(negedge clk);
			set_counter(10);
			#(1000);	
				
			@(negedge clk);
			set_counter(100);
			#(1000);
			
			$stop;
		end
endmodule