// N bit timer counter with overflow
module timer_counter
#(
	parameter M_BITS=8, // Mod-M bit precision
	          N_BITS=4  // Counter bit precision
)
(
	input wire clk, reset,
	input wire [M_BITS-1:0] m,        // Counter max
	output wire [N_BITS-1:0] counter, // Counter
	output wire of                    // Overflow
);
	wire max_tick;

	mod_m_counter #(.M_BITS(M_BITS)) counter_m(.clk(clk), .reset(reset), .m(m), .max_tick(max_tick), .q());
	tick_counter #(.N(N_BITS)) counter_n(.clk(clk), .reset(reset), .tick(max_tick), .counter(counter), .of(of));
endmodule
