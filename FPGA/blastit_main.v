// Top level module for blastit. Contains I/Os definitions.

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
	output wire[19:0] C,
	
	//
	// Boost array address output
	//
	output wire[5:0] D,
	
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

	localparam LED_PERIOD_BITS = 24;
				  
	// Timer params
	localparam TC_M_BITS=32, 
	           TC_N_BITS=24;
	
	// UART parameters
	localparam UART_FIFO_R = 8,
	           UART_FIFO_W = 8,
				  UART_DVSR_BIT = 16,
				  UART_DBIT = 8,
				  UART_RX_TICK_BITS = 10,
				  UART_TX_TICK_BITS = 10;
	
	// BCD converter params
	localparam BCD_N = 4,
	           BCD_BIN_N = 15,
				  BCD_TICK_BITS = 8;	
				  
	// Warning & status LEDs params
	localparam WARN_PWM_BITS = 8;
	
	// SSEG array params			  
	localparam SSEG_BITS=5,
				  SSEG_N=20,
				  SSEG_PWM_BITS=8,
				  SSEG_TICK_BITS=8;
				  
	// LED matrix params
	localparam LEDS_N=10,
				  LEDS_M=3,
				  LEDS_N_BITS = 4,
				  LEDS_M_BITS = 4,
				  LEDS_PWM_BITS = 8,
				  LEDS_COUNTER_BITS = 8,
				  LEDS_SEL_BITS = 3,
				  LEDS_BANKS = 2;
	
	// Reset controller counter resolution
	localparam RC1_TIMER_BITS = 24;
	
	//
	// I/Os
	//
	
	genvar status_led_i, c_i, c_cseg_i, g_i, d_i;
	wire clk; // Goes to MCU
	// Goes to status LEDs
	wire led_tick;
	wire [LED_PERIOD_BITS-1:0] led_period; // Goes to MCU
				  
	// Timer counter inputs
	wire tc1_reset, tc2_reset, tc3_reset, tc4_reset;
	wire [3:0] tc_reset_control;
	wire [TC_M_BITS-1:0] tc1_m, tc2_m, tc3_m, tc4_m; // Goes to MCU
	wire [3:0] tc_en; // Goes to MCU
	
	// Timer counter outputs
	wire [TC_N_BITS-1:0] tc1_counter, tc2_counter, tc3_counter, tc4_counter;
	wire tc1_of, tc2_of, tc3_of, tc4_of;
	wire [TC_N_BITS:0] tc1_status, tc2_status, tc3_status, tc4_status; // Goes to MCU
	
	// UART inputs
	wire uart1_reset, uart1_rx_tc_reset, uart1_tx_tc_reset;
	wire uart1_rd_uart, uart1_wr_uart;
	wire [3:0] uart1_dbit;
	wire [1:0] uart1_pbit;
	wire [7:0] uart1_sb_tick;
	wire [7:0] uart1_os_tick;
	wire [15:0] uart1_dvsr;
	wire [7:0] uart1_w_data;        // Goes to MCU
	wire [2:0] uart1_reset_control; // Goes to MCU
	wire [1:0] uart1_wr_control;    // Goes to MCU
	wire [21:0] uart1_baud_control; // Goes to MCU
	
	// UART outputs
	wire uart1_tx_full, uart1_rx_empty;
	wire uart1_rx_full, uart1_tx_empty;
	wire [7:0] uart1_r_data;                       // Goes tO MCU
	wire uart1_tx_done_tick, uart1_rx_done_tick;
	wire uart1_e_parity, uart1_e_frame, uart1_e_rxof, uart1_e_txof;
	wire [UART_RX_TICK_BITS-1:0] uart1_rx_counter; // Goes to MCU
	wire [UART_TX_TICK_BITS-1:0] uart1_tx_counter; // Goes to MCU
	wire uart1_rx_counter_of, uart1_tx_counter_of;
	wire [9:0] uart1_status_control;               // Goes to MCU
	
	// BCD converter inputs
	wire bcd1_reset, bcd1_tc_reset;
	wire bcd1_start;
	wire [BCD_BIN_N-1:0] bcd1_bin; // Goes to MCU
	wire [2:0] bcd1_control;       // Goes to MCU
	
	// BCD converter outputs
	wire bcd1_ready, bcd1_done_tick;
	wire [(4*BCD_N)-1:0]  bcd1_bcd;        // Goes to MCU
	wire [BCD_TICK_BITS-1:0] bcd1_counter; // Goes to MCU
	wire bcd1_counter_of;
	wire [1:0] bcd1_status;                // Goes to MCU
	
	// Warning & status PWM inputs
	wire warn_pwm_reset;
	wire warn_pwm_en;
	wire [WARN_PWM_BITS-1:0] warn_pwm_brightness; // Goes to MCU
	wire [3:0] status_led_en;                     // Goes to MCU
	wire [1:0] warn_pwm_control;                  // Goes tO MCU
	reg [3:0] led_i_reg, led_i_next;
	
	// SSEG array inputs
	wire sseg_reset, sseg_tc_reset;
	wire [SSEG_PWM_BITS-1:0] sseg_brightness; // Goes to MCU
	wire sseg_wr;
	wire [SSEG_BITS-1:0] sseg_sel;
	wire sseg_en, sseg_sign, sseg_dp;
	wire [3:0] sseg_val;
	wire [1:0] sseg_reset_control;            // Goes to MCU
	wire [8 + SSEG_BITS - 1:0] sseg_wr_val;   // Goes to MCU
	
	// SSEG array outputs
	wire [7:0] sseg;
	wire sseg_done_tick;
	wire [SSEG_N - 1:0] sseg_oe;
	wire [SSEG_TICK_BITS-1:0] sseg_counter; // Goes to MCU
	wire sseg_counter_of;                   // Goes tO MCU
	
	// LED matrix inputs
	wire leds1_reset, leds1_counter_reset, leds2_reset, leds2_counter_reset;
	wire [LEDS_COUNTER_BITS-1:0] leds1_brightness, leds2_brightness;           // Goes to MCU
	wire [LEDS_N_BITS + LEDS_M_BITS - 1:0] leds1_sel_addr, leds2_sel_addr;
	wire leds1_sel, leds1_en, leds2_sel, leds2_en;
	wire [1:0] leds1_reset_control, leds2_reset_control;                       // Goes to MCU
	wire [2 + LEDS_N_BITS + LEDS_M_BITS - 1:0] leds1_wr_val, leds2_wr_val;     // Goes to MCU
	
	// LED matrix outputs
	wire [LEDS_N-1:0] leds1_n_en, leds2_n_en, leds_n_en;
	wire [LEDS_M-1:0] leds1_m_en, leds2_m_en;
	wire leds1_done_tick, leds2_done_tick;
	wire [LEDS_COUNTER_BITS-1:0] leds1_counter, leds2_counter; // Goes to MCU
	wire leds1_counter_of, leds2_counter_of;                   // Goes to MCU	
	
	// LED matrix selector
	reg [LEDS_SEL_BITS-1:0] led_idx_reg, led_idx_next;
	
	// Timed reset controller inputs
	wire [RC1_TIMER_BITS-1:0] rc1_m;
	wire rc1_start;
	wire [RC1_TIMER_BITS:0] rc1_control; // Goes to MCU
	
	// Timed reset controller outputs
	wire rc1_reset, rc1_ready;           // Goes to MCU
	
	//
	// Entity blocks
	//
	
	// LED multiplexing
	mod_m_counter #(.M_BITS(LED_PERIOD_BITS)) tick_counter(.clk(clk), .reset(rc1_reset), .m(led_period), .max_tick(led_tick), .q());
	
	// Timer counter
	timer_counter #(.N_BITS(TC_N_BITS), .M_BITS(TC_M_BITS)) 
	              tc1(.clk(clk), .reset(tc1_reset), .m(tc1_m), .counter(tc1_counter), .of(tc1_of)),
	              tc2(.clk(clk), .reset(tc2_reset), .m(tc2_m), .counter(tc2_counter), .of(tc2_of)),
	              tc3(.clk(clk), .reset(tc3_reset), .m(tc3_m), .counter(tc3_counter), .of(tc3_of)),
	              tc4(.clk(clk), .reset(tc4_reset), .m(tc4_m), .counter(tc4_counter), .of(tc4_of));
	
	// UART
	uart #(.FIFO_R(UART_FIFO_R), .FIFO_W(UART_FIFO_W), .DVSR_BIT(UART_DVSR_BIT), .DBIT(UART_DBIT)) 
	     uart1(.clk(clk), .reset(uart1_reset), .dbit(uart1_dbit), .pbit(uart1_pbit), .sb_tick(uart1_sb_tick),
		        .os_tick(uart1_os_tick), .dvsr(uart1_dvsr), .rd_uart(uart1_rd_uart), .wr_uart(uart1_wr_uart), 
				  .rx(UART_RX), .w_data(uart1_w_data), .tx_full(uart1_tx_full), .rx_empty(uart1_rx_empty),
				  .tx(UART_TX), .r_data(uart1_r_data), .tx_done_tick(uart1_tx_done_tick), .rx_done_tick(uart1_rx_done_tick), 
				  .e_parity(uart1_e_parity), .e_frame(uart1_e_frame), .e_rxof(uart1_e_rxof), .e_txof(uart1_e_txof),
				  .rx_full(uart1_rx_full), .tx_empty(uart1_tx_empty));
	tick_counter #(.N(UART_RX_TICK_BITS)) uart1_rx_tc(.clk(clk), .reset(uart1_rx_tc_reset), .tick(uart1_rx_done_tick), .counter(uart1_rx_counter), .of(uart1_rx_counter_of));
	tick_counter #(.N(UART_TX_TICK_BITS)) uart1_tx_tc(.clk(clk), .reset(uart1_tx_tc_reset), .tick(uart1_tx_done_tick), .counter(uart1_tx_counter), .of(uart1_tx_counter_of));
	
	// BCD converter
	bin2bcd #(.BCD_N(BCD_N), .BIN_N(BCD_BIN_N-1)) bcd1(.clk(clk), .reset(bcd1_reset), .start(bcd1_start), .sign(bcd1_bin[BCD_BIN_N-1]),
                                                      .bin(bcd1_bin[BCD_BIN_N-2:0]), .ready(bcd1_ready), .done_tick(bcd1_done_tick), .bcd(bcd1_bcd));
	tick_counter #(.N(BCD_TICK_BITS)) bcd1_tc(.clk(clk), .reset(bcd1_tc_reset), .tick(bcd1_done_tick), .counter(bcd1_counter), .of(bcd1_counter_of));

	// Warning brightness PWM
	pwm #(.N(WARN_PWM_BITS), .M(1)) warn_pwm(.clk(clk), .reset(warn_pwm_reset), .in(warn_pwm_en), .w(warn_pwm_brightness), .out(WARN));
	
	// SSEG array	
	sseg_array #(.SSEG_BITS(SSEG_BITS), .SSEG_N(SSEG_N), .PWM_BITS(SSEG_PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS))
			ssegarr(.clk(clk), .reset(sseg_reset), .wr(sseg_wr), .brightness(sseg_brightness),
					  .sel(sseg_sel), .led_period(led_period), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
					  .val(sseg_val), .o_sseg(sseg), .oe(sseg_oe), .done_tick(sseg_done_tick));
	tick_counter #(.N(SSEG_TICK_BITS)) sseg_tc(.clk(clk), .reset(sseg_tc_reset), .tick(sseg_done_tick), .counter(sseg_counter), .of(sseg_counter_of));																
	
	// LED matrix
	
	// body	
	led_matrix #(.LEDS_N(LEDS_N), .LEDS_M(LEDS_M), .N_BITS(LEDS_N_BITS), .M_BITS(LEDS_M_BITS), .PWM_BITS(LEDS_PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS))
		leds1(.clk(clk), .reset(leds1_reset), .brightness(leds1_brightness), .sel_addr(leds1_sel_addr),
			  .sel(leds1_sel), .led_period(led_period), .en(leds1_en), .n_en(leds1_n_en), .m_en(leds1_m_en), .done_tick(leds1_done_tick));
	tick_counter #(.N(LEDS_COUNTER_BITS)) 
		leds1_tc(.clk(clk), .reset(leds1_counter_reset), .tick(leds1_done_tick), .counter(leds1_counter), .of(leds1_counter_of));
		
	led_matrix #(.LEDS_N(LEDS_N), .LEDS_M(LEDS_M), .N_BITS(LEDS_N_BITS), .M_BITS(LEDS_M_BITS), .PWM_BITS(LEDS_PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS))
		leds2(.clk(clk), .reset(leds2_reset), .brightness(leds2_brightness), .sel_addr(leds2_sel_addr),
			  .sel(leds2_sel), .led_period(led_period), .en(leds2_en), .n_en(leds2_n_en), .m_en(leds2_m_en), .done_tick(leds2_done_tick));
	tick_counter #(.N(LEDS_COUNTER_BITS)) 
		leds2_tc(.clk(clk), .reset(leds2_counter_reset), .tick(leds2_done_tick), .counter(leds2_counter), .of(leds2_counter_of));
	
	// Timed reset controller
	reset_controller #(.M_BITS(RC1_TIMER_BITS)) rc1(.clk(clk), .reset(1'b0), .start(rc1_start), .m(rc1_m), .en(rc1_reset), .ready(rc1_ready));
	
	// Microcontroller
	controller mcu1(.clock_50_clk(clk), 
	                .reset_reset_n(~rc1_reset), 
						 .daylight_export(DAYLIGHT), 
						 .tc1_m_export(tc1_m),
						 .tc2_m_export(tc2_m), 
						 .tc3_m_export(tc3_m), 
						 .tc4_m_export(tc4_m), 
						 .tc_reset_control_export(tc_reset_control),
						 .tc1_status_export(tc1_status), 
						 .tc2_status_export(tc2_status),
						 .tc3_status_export(tc3_status), 
						 .tc4_status_export(tc4_status),
						 .uart1_w_data_export(uart1_w_data), 
						 .uart1_reset_control_export(uart1_reset_control), 
						 .uart1_wr_control_export(uart1_wr_control), 
						 .uart1_baud_control_export(uart1_baud_control), 
						 .uart1_dvsr_export(uart1_dvsr),
						 .uart1_r_data_export(uart1_r_data),
						 .uart1_rx_counter_export(uart1_rx_counter),
						 .uart1_tx_counter_export(uart1_tx_counter),
						 .uart1_status_control_export(uart1_status_control),
						 .bcd1_bin_export(bcd1_bin),
						 .bcd1_control_export(bcd1_control),
						 .bcd1_bcd_export(bcd1_bcd), 
						 .bcd1_counter_export(bcd1_counter),	
						 .bcd1_status_export(bcd1_status),
						 .warn_pwm_brightness_export(warn_pwm_brightness),
						 .status_led_en_export(status_led_en), 
						 .warn_pwm_control_export(warn_pwm_control),
						 .sseg_brightness_export(sseg_brightness),
						 .sseg_reset_control_export(sseg_reset_control),
						 .sseg_wr_val_export(sseg_wr_val),
						 .sseg_counter_export(sseg_counter),
						 .sseg_counter_of_export(sseg_counter_of),
						 .leds1_brightness_export(leds1_brightness),
						 .leds1_wr_val_export(leds1_wr_val),
						 .leds1_counter_export(leds1_counter),
						 .leds1_reset_control_export(leds1_reset_control),
						 .leds1_counter_of_export(leds1_counter_of),
						 .leds2_brightness_export(leds2_brightness),
						 .leds2_wr_val_export(leds2_wr_val),
						 .leds2_counter_export(leds2_counter),
						 .leds2_reset_control_export(leds2_reset_control),
						 .leds2_counter_of_export(leds2_counter_of),
						 .rc1_control_export(rc1_control),
						 .rc1_ready_export(rc1_ready),
						 .led_period_export(led_period)
					);
					
	//
	// FSM logic
	//
	
	always @(posedge clk)
		begin
			led_i_reg <= led_i_next;
			led_idx_reg <= led_idx_next;
		end
		
	always @*
		begin
			led_i_next = led_i_reg;
			led_idx_next = led_idx_reg;
			if (led_tick)
				begin
					led_i_next = led_i_reg + 1'b1;
					if (led_i_next == 4'd4)
						led_i_next = 0;
				end
				
			if (leds1_done_tick && led_idx_next == 0)
				led_idx_next = 1;
			if (leds2_done_tick && led_idx_next == 1)
				led_idx_next = 0;
		end
	
	//
	// I/O block assignments
	//
	
	assign clk = CLOCK_50;
	
	// Timer counter block
	assign tc_reset_control = { tc4_reset, tc3_reset, tc2_reset, tc1_reset };
	assign tc1_status = { tc1_of, tc1_counter };
	assign tc2_status = { tc2_of, tc2_counter };
	assign tc3_status = { tc3_of, tc3_counter };
	assign tc4_status = { tc4_of, tc4_counter };
	
	// UART block
	assign uart1_reset_control = { uart1_reset, uart1_rx_tc_reset, uart1_tx_tc_reset };
	assign uart1_wr_control = { uart1_rd_uart, uart1_wr_uart };
	assign uart1_baud_control = { uart1_dbit, uart1_pbit, uart1_sb_tick, uart1_os_tick };
	assign uart1_status_control = { uart1_tx_empty, uart1_rx_full, uart1_tx_full, uart1_rx_empty, uart1_e_parity, uart1_e_frame, uart1_e_rxof, uart1_e_txof, uart1_rx_counter_of, uart1_tx_counter_of };

	// BCD converter block
	assign bcd1_control = { bcd1_reset, bcd1_tc_reset, bcd1_start };
	assign bcd1_status = { bcd1_ready, bcd1_counter_of };
	
	// Warning & status PWM block
	assign warn_pwm_control = { warn_pwm_reset, warn_pwm_en };
	
	// SSEG block
	assign sseg_reset_control = { sseg_reset, sseg_tc_reset };
	assign sseg_wr_val = { sseg_wr, sseg_sel, sseg_en, sseg_sign, sseg_dp, sseg_val };
	
	// LEDS block
	assign leds1_reset_control = { leds1_reset, leds1_counter_reset };
	assign leds1_wr_val = { leds1_sel, leds1_en, leds1_sel_addr };
	
	assign leds2_reset_control = { leds2_reset, leds2_counter_reset };
	assign leds2_wr_val = { leds2_sel, leds2_en, leds2_sel_addr };
	
	// Reset controller block
	assign rc1_control = { rc1_start, rc1_m };
	
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
			assign C_SSEG[c_cseg_i] = (sseg[c_cseg_i] == 1'b1) ? 1'b0 : 1'bz;
		end
		
		for (g_i = 0; g_i < LEDS_N; g_i = g_i + 1) begin:gen_g
			assign G[g_i] = (leds_n_en[g_i] == 1'b1) ? 1'b0 : 1'bz;
		end
		
		for (d_i = 0; d_i < LEDS_M; d_i = d_i + 1) begin:gen_d1
			assign D[d_i] = (leds1_m_en[d_i] == 1'b1) ? 1'b1 : 1'bz;
		end
		
		for (d_i = 0; d_i < LEDS_M; d_i = d_i + 1) begin:gen_d2
			assign D[3 + d_i] = (leds2_m_en[d_i] == 1'b1) ? 1'b1 : 1'bz;
		end
	endgenerate
						
	// Hackfix for dual LED bars sharing one matrix
	assign leds_n_en = led_idx_next == 0 ? leds1_n_en : leds2_n_en;
			
endmodule