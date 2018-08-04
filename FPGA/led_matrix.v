// NxM LED matrix, individually addressible
module led_matrix
#(
			    // LED strip parameters
	parameter LEDS_N=4,                    // Number of LED input enables
				 LEDS_M=2,                    // Number of LED output enables
				 N_BITS = 2,                  // N index storage bits
				 M_BITS = 2,                  // M index storage bits
	
				 // PWM parameters
				 PWM_BITS=12,                 // PWM precision
				 LED_PERIOD_BITS=24           // LED tick counter precision`
)
(
	input wire clk, reset,                        // Global clock and reset signals
	input wire [PWM_BITS-1:0] brightness,         // Display brightness
	input wire [N_BITS + M_BITS - 1:0] sel_addr,  // address select
	input wire sel, en,                           // I/O select and enable set
	input wire [LED_PERIOD_BITS-1:0] led_period,    // LED display period in clocks
	output wire [LEDS_N-1:0] n_en,                // Input driver enable
	output wire [LEDS_M-1:0] m_en,                // Output driver enable
	output reg done_tick                          // All I/Os scanned tick
);

	reg [(LEDS_N*LEDS_M)-1:0] en_reg;
	reg [N_BITS + M_BITS - 1:0] addr_i_reg, addr_i_next;
	reg [N_BITS-1:0] n_i_reg, n_i_next;
	reg [M_BITS-1:0] m_i_reg, m_i_next;
	wire [LEDS_N-1:0] cur_n;
	wire [LEDS_M-1:0] cur_m;
	wire led_tick;

	pwm #(.N(PWM_BITS), .M(LEDS_N + LEDS_M)) pwm_n(.clk(clk), .reset(reset), .in({ cur_n, cur_m }), .w(brightness), .out({ n_en, m_en })); 
	mod_m_counter #(.M_BITS(LED_PERIOD_BITS)) tick_counter(.clk(clk), .reset(reset), .m(led_period), .max_tick(led_tick), .q());
	
	// Register file write operation
	always @(posedge clk)
		if (sel)
			en_reg[sel_addr] = en;
	
	// FF sequence
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				n_i_reg <= 0;
				m_i_reg <= 0;
				addr_i_reg <= 0;
			end
		else
			begin
				n_i_reg <= n_i_next;
				m_i_reg <= m_i_next;
				addr_i_reg <= addr_i_next;
			end
	
	// FSM sequence
	always @*
		begin
			done_tick = 1'b0;
			n_i_next = n_i_reg;
			m_i_next = m_i_reg;
			addr_i_next = addr_i_reg;
			if (led_tick)
				begin
					n_i_next = n_i_reg + 1'b1;
					addr_i_next = addr_i_reg + 1'b1;
					if (n_i_next == LEDS_N)
						begin
							n_i_next = 1'b0;
							m_i_next = m_i_reg + 1'b1;
							if (m_i_next == LEDS_M)
								begin
									m_i_next = 1'b0;
									addr_i_next = 1'b0;
									done_tick = 1'b1;
								end
						end
						
				end
		end
	
	assign cur_n = en_reg[addr_i_reg] << n_i_reg;
	assign cur_m = en_reg[addr_i_reg] << m_i_reg;
			
endmodule