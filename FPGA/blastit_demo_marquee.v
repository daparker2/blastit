// Top level module for blastit. Contains a DLL-driven marquee.

module blastit_main
(
	//
	// 50Mhz clock signal
	//
	input wire CLOCK_50,

	//
	// Daylight operation indicator
	//
	input wire DAYLIGHT,
	
	//
	// UART RX
	//
	input wire UART_RX,
	
	//
	// Seven segment selector output
	//
	output wire[7:0] C_SSEG,
	
	//
	// Seven segment selector address input
	//
	output wire[15:0] C,
	
	//
	// Diode array address output
	//
	output wire[7:0] D,
	
	//
	// Diode array address input
	//
	output wire[9:0] G,
	
	//
	// UART TX
	// 
	output wire UART_TX,
	
	//
	// (Possibly unused) status LEDs
	//
	output wire[3:0] LED,
	
	//
	// Warning indicator
	//
	output wire WARN
);
	//
	// Parameters
	//

	localparam T = 20; // Clock period
	localparam LED_DISPLAY_PERIOD = 24'd5000,
	           LED_PERIOD_BITS = 24;
	
	// Warning & status LEDs params
	localparam WARN_PWM_BITS = 8;
	
	// SSEG array params			  
	localparam SSEG_BITS=4,
				  SSEG_N=16,
				  SSEG_PWM_BITS=8,
				  SSEG_TICK_BITS=8;
				  
	// LED matrix params
	localparam LEDS_N=10,
				  LEDS_M=8,
				  LEDS_N_BITS = 4,
				  LEDS_M_BITS = 4,
				  LEDS_PWM_BITS = 8,
				  LEDS_COUNTER_BITS = 8;
	
	//
	// I/Os
	//
	
	genvar status_led_i, c_i, c_cseg_i, g_i, d_i;
	wire clk;         // Goes to MCU
	wire led_tick; // Goes to status LEDs
				  
	// Warning & status PWM inputs
	wire warn_pwm_reset, warn_pwm_en;
	wire [WARN_PWM_BITS-1:0] warn_pwm_brightness; // Goes to MCU
	wire [3:0] status_led_en;    // Goes to MCU
	wire [1:0] warn_pwm_control; // Goes tO MCU
	reg [3:0] led_i_reg, led_i_next;
	
	// SSEG array inputs
	wire sseg_reset, sseg_tc_reset;
	wire [SSEG_PWM_BITS-1:0] sseg_sel; // Goes to MCU
	wire [SSEG_BITS-1:0] sseg_addr; // Goes to MCU
	wire sseg_en, sseg_sign, sseg_dp;
	wire [3:0] sseg_val;
	wire [1:0] sseg_reset_control; // Goes to MCU
	wire [7:0] sseg_wr_val;        // Goes to MCU
	
	// SSEG array outputs
	wire [7:0] sseg;
	wire sseg_done_tick;
	wire [SSEG_N - 1:0] sseg_oe;
	wire [SSEG_TICK_BITS-1:0] sseg_counter; // Goes to MCU
	wire sseg_counter_of;                   // Goes tO MCU
	
	// LED matrix inputs
	wire leds_reset, leds_counter_reset;
	wire [LEDS_COUNTER_BITS-1:0] leds_brightness;            // Goes to MCU
	wire [LEDS_N_BITS + LEDS_M_BITS - 1:0] leds_sel_addr;    // Goes to MCU
	wire leds_sel, leds_en;
	wire [1:0] leds_reset_control;                           // Goes to MCU
	wire [2 + LEDS_N_BITS + LEDS_M_BITS - 1:0] leds_wr_val;  // Goes to MCU
	
	// LED matrix outputs
	wire [LEDS_N-1:0] leds_n_en;
	wire [LEDS_M-1:0] leds_m_en;
	wire leds_done_tick;
	wire [LEDS_COUNTER_BITS-1:0] leds_counter; // Goes to MCU
	wire leds_counter_of;                      // Goes to MCU	
	
	//
	// Entity blocks
	//
	
	// LED multiplexing
	mod_m_counter #(.M_BITS(24)) tick_counter(.clk(clk), .reset(0), .m(LED_DISPLAY_PERIOD), .max_tick(led_tick), .q());
	
	// Warning brightness PWM
	pwm #(.N(WARN_PWM_BITS), .M(1)) warn_pwm(.clk(clk), .reset(warn_pwm_reset), .in(warn_pwm_en), .w(warn_pwm_brightness), .out(WARN));
	
	// SSEG array
	sseg_array #(.SSEG_BITS(SSEG_BITS), .SSEG_N(SSEG_N), .PWM_BITS(SSEG_PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS))
		sseg_array(.clk(clk), .reset(sseg_boost), .wr(sseg_wr), .brightness(sseg_boost),
					  .sel(sseg_sel_addr), .led_period(LED_DISPLAY_PERIOD), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
					  .val(sseg_val), .sseg(sseg), .oe(sseg_oe), .done_tick(sseg_done_tick));
	tick_counter #(.N(SSEG_TICK_BITS)) sseg_tc(.clk(clk), .reset(sseg_tc_reset), .tick(sseg_done_tick), .counter(sseg_counter), .of(sseg_counter_of));																
	
	// LED matrix
	led_matrix #(.LEDS_N(LEDS_N), .LEDS_M(LEDS_M), .N_BITS(LEDS_N_BITS), .M_BITS(LEDS_M_BITS), .PWM_BITS(LEDS_PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS))
		led_boost(.clk(clk), .reset(leds_reset), .brightness(leds_brightness), .sel_addr(leds_sel_addr),
					 .sel(leds_sel), .led_period(LED_DISPLAY_PERIOD), .en(leds_en), .n_en(leds_n_en), .m_en(leds_m_en), .done_tick(leds_done_tick));
	tick_counter #(.N(LEDS_COUNTER_BITS)) 
		leds_tc(.clk(clk), .reset(leds_counter_reset), .tick(leds_done_tick), .counter(leds_counter), .of(leds_counter_of));
	
	// Status LEDs
	mod_m_counter #(.M_BITS(LED_PERIOD_BITS)) status_led_counter(.clk(clk), .reset(0), .m(LED_DISPLAY_PERIOD), .max_tick(led_tick), .q());

	//
	// FSM logic
	//
	
	always @(posedge clk)
		begin
			led_i_reg <= led_i_next;
		end
		
	always @*
		begin
			led_i_next = led_i_reg;
			if (led_tick)
				begin
					led_i_next = led_i_reg + 1'b1;
					if (led_i_next == 4'd4)
						led_i_next = 0;
				end
		end
	
	//
	// I/O block assignments
	//
	
	assign clk = CLOCK_50;
	
	// Warning & status PWM block
	assign warn_pwm_control = { warn_pwm_reset, warn_pwm_en };
	
	// SSEG block
	assign sseg_reset_control = { sseg_reset, sseg_tc_reset };
	assign sseg_wr_val = { sseg_wr, sseg_en, sseg_sign, sseg_dp, sseg_val };
	
	// LEDS block
	assign leds_reset_control = { leds_reset, leds_counter_reset };
	assign leds_wr_val = { leds_sel, leds_en, leds_sel_addr };
	
	//
	// Output assignments
	//
				 						
	generate
		for (status_led_i = 0; status_led_i < 4; status_led_i = status_led_i + 1) begin:gen_status_led
			assign LED[status_led_i] = status_led_en[status_led_i] == 1'b1 ? 1'b0 : 1'bz;
		end
	
		for (c_i = 0; c_i < SSEG_N; c_i = c_i + 1) begin:gen_c
			assign C[c_i] = (sseg_oe[c_i] == 1'b1) ? 1'b1 : 1'bz;
		end
		
		for (c_cseg_i = 0; c_cseg_i < 8; c_cseg_i = c_cseg_i + 1) begin:gen_c_cseg
			assign C[c_cseg_i] = (sseg[c_i] == 1'b0) ? 1'b0 : 1'bz;
		end
		
		for (g_i = 0; g_i < LEDS_N; g_i = g_i + 1) begin:gen_g
			assign G[g_i] = (leds_n_en[g_i] == 1'b1) ? 1'b0 : 1'bz;
		end
		
		for (d_i = 0; d_i < LEDS_M; d_i = d_i + 1) begin:gen_d
			assign D[d_i] = (leds_m_en[d_i] == 1'b1) ? 1'b1 : 1'bz;
		end
	endgenerate
	
endmodule