`timescale 1 ns / 10 ps

module mod_m_counter_testbench;

localparam T = 20,
           M_BITS = 8;

reg clk, reset;
reg [M_BITS-1:0] m;
wire max_tick;
wire [M_BITS-1:0] q;

mod_m_counter #(.M_BITS(M_BITS)) uut(.clk(clk), .reset(reset), .m(m), .max_tick(max_tick), .q(q));

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
	
// test process
initial
	begin
		@(negedge reset);
		@(negedge clk);
		
		m = 16;
		#2000;
		@(negedge clk);
		
		m = 163;
		#2000;
		@(negedge clk);
		
		#2000;		
		$stop;
	end
	
endmodule