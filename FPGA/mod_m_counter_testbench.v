`timescale 1 ns / 10 ps

module mod_m_counter_testbench;

localparam T = 20;

reg clk, reset;
wire max_tick;
wire [3:0] q;

mod_m_counter uut(clk, reset, max_tick, q);

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
		
		#2000;		
		$stop;
	end
	
endmodule