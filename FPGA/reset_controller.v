// 1 input, 1 output reset controller which assets the output high based on the counter bits
module reset_controller
#(
	parameter M_BITS=8
)
(
	input wire clk, reset,
	input wire start,
	input wire [M_BITS-1:0] m,
	output wire en, ready
);

	reg [1:0] state_reg, state_next;
	reg [M_BITS-1:0] m_reg, m_next;
	wire reset_tick;
		
	localparam START = 2'd0,
	           RESET = 2'b1;
		
	mod_m_counter #(.M_BITS(M_BITS)) tick_counter(.clk(clk), .reset(ready), .m(m_reg), .max_tick(reset_tick), .q());
	
	always @(posedge clk)
		if (reset)
			begin
				state_reg <= 0;
				m_reg <= 0;
			end
		else
			begin
				state_reg <= state_next;
				m_reg <= m_next;
			end
		
	always @*
		begin
			state_next = state_reg;
			m_next = m_reg;
			if (start && m > 0)
				begin
					m_next = m;
					state_next = RESET;
				end
			if (reset_tick)
				begin
					m_next = 0;
					state_next = START;
				end
		end
	
	assign en = state_reg == RESET;
	assign ready = ~en;
	
	always @*
		$display("ready: %d m: %d max_tick: %d state_reg: %d", ready, m, reset_tick, state_reg);
	
endmodule