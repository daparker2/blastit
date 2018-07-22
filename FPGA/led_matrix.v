// NxM LED matrix, individually addressible
module led_matrix
#(
			    // LED strip parameters
	parameter LEDS_N=4,                    // Number of LED input enables
				 LEDS_M=2,                    // Number of LED output enables
				 N_BITS = 2,                  // N index storage bits
				 M_BITS = 2,                  // M index storage bits
	
				 // PWM parameters
				 PWM_BITS=12          // PWM precision
)
(
	input wire clk, reset,                // Global clock and reset signals
	input wire [PWM_BITS-1:0] brightness, // Display brightness
	input wire [N_BITS + M_BITS - 1:0] sel_addr,  // address select
	input wire sel, en,                   // I/O select and enable set
	output wire [LEDS_N-1:0] n_en,        // Input driver enable
	output wire [LEDS_M-1:0] m_en,        // Output driver enable
	output reg done_tick                  // All I/Os scanned tick
);

	reg [(LEDS_N*LEDS_M)-1:0] en_reg;
	reg [N_BITS-1:0] n_i_reg, n_i_next;
	reg [M_BITS-1:0] m_i_reg, m_i_next;
	wire [LEDS_N-1:0] cur_n;
	wire [LEDS_M-1:0] cur_m;
	wire [N_BITS + M_BITS - 1:0] addr_i;

	pwm #(.N(PWM_BITS), .M(LEDS_N)) pwm_n(.clk(clk), .reset(reset), .in(cur_n), .w(brightness), .out(n_en)); 
	pwm #(.N(PWM_BITS), .M(LEDS_M)) pwm_m(.clk(clk), .reset(reset), .in(cur_m), .w(brightness), .out(m_en)); 
	
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
			end
		else
			begin
				n_i_reg <= n_i_next;
				m_i_reg <= m_i_next;
			end
	
	// FSM sequence
	always @*
		begin
			done_tick = 0;
			if (n_i_reg == 0 && m_i_reg == 0)
				done_tick = 1;
			
			n_i_next = n_i_reg + 1;
			m_i_next = m_i_reg;
			if (n_i_next == LEDS_N)
				begin
					n_i_next = 0;
					m_i_next = m_i_reg + 1;
					if (m_i_next == LEDS_M)
						m_i_next = 0;
				end
		end
	
	assign addr_i = n_i_next + m_i_next * LEDS_N;
	assign cur_n = en_reg[addr_i] << n_i_reg;
	assign cur_m = en_reg[addr_i] << m_i_reg;
			
endmodule