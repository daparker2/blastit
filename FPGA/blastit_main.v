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
	input wire DAYLIGHT, // Goes to MCU
	
	//
	// UART RX
	//
	input wire UART_RX,
	
	//
	// Seven segment selector output
	//
	inout wire[7:0] C_SSEG,
	
	//
	// Seven segment selector address input
	//
	inout wire[15:0] C,
	
	//
	// Diode array address output
	//
	inout wire[9:0] D,
	
	//
	// Diode array address input
	//
	inout wire[9:0] G,
	
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

	// Timer params
	localparam TC_M_BITS=32, 
	           TC_N_BITS=16;
	
	// UART parameters
	localparam UART_FIFO_R = 8,
	           UART_FIFO_W = 3,
				  UART_DVSR_BIT = 8,
				  UART_DBIT = 8,
				  UART_RX_TICK_BITS = UART_FIFO_R,
				  UART_TX_TICK_BITS = UART_FIFO_W;
	
	// BCD converter params
	localparam BCD_N = 4,
	           BCD_BIN_N = 14,
				  BCD_TICK_BITS = 8;	
				  
	// Warning & status LEDs params
	localparam WARN_PWM_BITS = 8;
	
	// SSEG array params			  
	localparam SSEG_BITS=2,
				  SSEG_N=4,
				  SSEG_PWM_BITS=8,
				  SSEG_TICK_BITS=8;
				  
	// LED matrix params
	localparam LEDS_N=5,
				  LEDS_M=5,
				  LEDS_N_BITS = 2,
				  LEDS_M_BITS = 2,
				  LEDS_PWM_BITS = 8,
				  LEDS_COUNTER_BITS = 8;
	
	//
	// I/Os
	//
	
	wire clk; // Goes to MCU
				  
	// Timer counter inputs
	wire tc1_reset;               // Goes to MCU
	wire [TC_M_BITS-1:0] tc1_m;   // Goes to MCU
	
	// Timer counter outputs
	wire [TC_N_BITS-1:0] tc1_counter;
	wire tc1_of;
	wire [TC_N_BITS:0] tc_status; // Goes to MCU
	
	// UART inputs
	wire uart1_reset, uart1_rx_tc_reset, uart1_tx_tc_reset;
	wire uart1_rd_uart, uart1_wr_uart;
	wire [3:0] uart1_dbit;
	wire [1:0] uart1_pbit;
	wire [7:0] uart1_sb_tick;
	wire [7:0] uart1_os_tick;
	wire [7:0] uart1_dvsr;
	wire [7:0] uart1_w_data;        // Goes to MCU
	wire [2:0] uart1_reset_control; // Goes to MCU
	wire [1:0] uart1_wr_control;    // Goes to MCU
	wire [29:0] uart1_baud_control; // Goes to MCU
	
	// UART outputs
	wire uart1_tx_full, uart1_rx_empty;
	wire [7:0] uart1_r_data;             // Goes tO MCU
	wire uart1_tx_done_tick, uart1_rx_done_tick;
	wire uart1_e_parity, uart1_e_frame, uart1_e_rxof, uart1_e_txof;
	wire [UART_RX_TICK_BITS-1:0] uart1_rx_counter; // Goes to MCU
	wire [UART_TX_TICK_BITS-1:0] uart1_tx_counter; // Goes to MCU
	wire uart1_rx_counter_of, uart1_tx_counter_of;
	wire [7:0] uart1_status_control;    // Goes to MCU
	
	// BCD converter inputs
	wire bcd1_reset, bcd1_tc_reset, bcd1_start;
	wire [BCD_BIN_N:0] bcd1_bin; // Goes to MCU
	wire [2:0] bcd1_control;     // Goes to MCU
	
	// BCD converter outputs
	wire bcd1_ready, bcd1_done_tick;
	wire [(4*BCD_N)-1:0]  bcd1_bcd;        // Goes to MCU
	wire [BCD_TICK_BITS-1:0] bcd1_counter; // Goes to MCU
	wire bcd1_counter_of;
	wire [1:0] bcd1_status; // Goes to MCU
	
	// Warning & status PWM inputs
	wire warn_pwm_reset, warn_pwm_en;
	wire [WARN_PWM_BITS-1:0] warn_pwm_brightness; // Goes to MCU
	wire [3:0] status_led_en;    // Goes to MCU
	wire [1:0] warn_pwm_control; // Goes tO MCU
	
	// SSEG array inputs
	wire sseg_reset_boost, sseg_reset_afr, sseg_reset_oil, sseg_reset_coolant, sseg_tc_reset;
	wire sseg_wr_boost, sseg_wr_afr, sseg_wr_oil, sseg_wr_coolant;
	wire [SSEG_PWM_BITS-1:0] sseg_brightness_boost, sseg_brightness_afr, sseg_brightness_oil, sseg_brightness_coolant; // Goes to MCU
	wire [SSEG_BITS-1:0] sseg_sel_addr; // Goes to MCu
	wire sseg_en, sseg_sign, sseg_dp;
	wire [3:0] sseg_val;
	wire [4:0] sseg_reset_control; // Goes to MCU
	wire [3:0] sseg_wr_control;    // Goes to MCU
	wire [6:0] sseg_wr_val;        // Goes to MCU
	
	// SSEG array outputs
	wire [7:0] sseg_boost, sseg_afr, sseg_oil, sseg_coolant;
	wire [SSEG_N - 1:0] sseg_oe_boost, sseg_oe_afr, sseg_oe_oil, sseg_oe_coolant;
	wire sseg_done_tick_boost, sseg_done_tick_afr, sseg_done_tick_oil, sseg_done_tick_coolant;
	wire [15:0] sseg_oe;
	wire [SSEG_TICK_BITS-1:0] sseg_counter; // Goes to MCU
	wire sseg_counter_of;                   // Goes tO MCU
	
	// LED matrix inputs
	wire leds_boost_reset, leds_afr_reset, leds_boost_counter_reset, leds_afr_counter_reset;
	wire [LEDS_COUNTER_BITS-1:0] leds_boost_brightness, leds_afr_brightness;       // Goes to MCU
	wire [LEDS_N_BITS + LEDS_M_BITS - 1:0] leds_boost_sel_addr, leds_afr_sel_addr; // Goes to MCU
	wire leds_boost_sel, leds_afr_sel, leds_boost_en, leds_afr_en;
	wire [3:0] leds_reset_control;                   // Goes to MCU
	wire [1:0] leds_boost_control, leds_afr_control; // Goes to MCU
	
	// LED matrix outputs
	wire [LEDS_N-1:0] leds_boost_n_en, leds_afr_n_en;
	wire [LEDS_M-1:0] leds_boost_m_en, leds_afr_m_en;
	wire leds_boost_done_tick, leds_afr_done_tick;
	wire [9:0] leds_m;
	wire [9:0] leds_n;
	wire [LEDS_COUNTER_BITS-1:0] leds_boost_counter, leds_afr_counter;
	wire leds_boost_counter_of, leds_afr_counter_of;
	wire [LEDS_COUNTER_BITS:0] leds_boost_counter_status, leds_afr_counter_status; // Goes to MCU
	
	//
	// Entity blocks
	//
	
	// Timer counter
	timer_counter #(.N_BITS(TC_N_BITS), .M_BITS(TC_M_BITS)) 
	              tc1(.clk(clk), .reset(tc1_reset), .m(tc1_m), .counter(tc1_counter), .of(tc1_of));
	
	// UART
	uart #(.FIFO_R(UART_FIFO_R), .FIFO_W(UART_FIFO_W), .DVSR_BIT(UART_DVSR_BIT), .DBIT(UART_DBIT)) 
	     uart1(.clk(clk), .reset(uart1_reset), .dbit(uart1_dbit), .pbit(uart1_pbit), .sb_tick(uart1_sb_tick),
		        .os_tick(uart1_os_tick), .dvsr(uart1_dvsr), .rd_uart(uart1_rd_uart), .wr_uart(uart1_wr_uart), 
				  .rx(UART_RX), .w_data(uart1_w_data), .tx_full(uart1_tx_full), .rx_empty(uart1_rx_empty),
				  .tx(UART_TX), .r_data(uart1_r_data), .tx_done_tick(uart1_tx_done_tick), .rx_done_tick(uart1_rx_done_tick), 
				  .e_parity(uart1_e_parity), .e_frame(uart1_e_frame), .e_rxof(uart1_e_rxof), .e_txof(uart1_e_txof));			  
	tick_counter #(.N(UART_RX_TICK_BITS)) uart1_rx_tc(.clk(clk), .reset(uart1_rx_tc_reset), .tick(uart1_rx_done_tick), .counter(uart1_rx_counter), .of(uart1_rx_counter_of));
	tick_counter #(.N(UART_TX_TICK_BITS)) uart1_tx_tc(.clk(clk), .reset(uart1_tx_tc_reset), .tick(uart1_tx_done_tick), .counter(uart1_tx_counter), .of(uart1_tx_counter_of));
	
	// BCD converter
	bin2bcd #(.BCD_N(BCD_N), .BIN_N(BCD_BIN_N)) bcd1(.clk(clk), .reset(bcd1_reset), .start(bcd1_start), .sign(bcd1_bin[BCD_BIN_N-1]),
                                                    .bin(bcd1_bin[BCD_BIN_N-2:0]), .ready(bcd1_ready), .done_tick(bcd1_done_tick), .bcd(bcd1_bcd));
	tick_counter #(.N(BCD_TICK_BITS)) bcd1_tc(.clk(clk), .reset(bcd1_tc_reset), .tick(bcd1_done_tick), .counter(bcd1_counter), .of(bcd1_counter_of));

	// Warning brightness PWM
	pwm #(.N(WARN_PWM_BITS), .M(1)) warn_pwm(.clk(clk), .reset(warn_pwm_reset), .in(warn_pwm_en), .w(warn_pwm_brightness), .out(WARN));
	
	// SSEG array
	sseg_array #(.SSEG_BITS(SSEG_BITS), .SSEG_N(SSEG_N), .PWM_BITS(SSEG_PWM_BITS)) sseg_boost_array(.clk(clk), .reset(sseg_reset_boost), .wr(sseg_wr_boost), .brightness(sseg_brightness_boost),
																																	.sel(sseg_sel_addr), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
																																	.val(sseg_val), .sseg(sseg_boost), .oe(sseg_oe_boost), .done_tick(sseg_done_tick_boost)),
																											 sseg_afr_array(.clk(clk), .reset(sseg_reset_afr), .wr(sseg_wr_afr), .brightness(sseg_brightness_afr),
																																 .sel(sseg_sel_addr), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
																																 .val(sseg_val), .sseg(sseg_afr), .oe(sseg_oe_afr), .done_tick(sseg_done_tick_afr)),
																											 sseg_oil_array(.clk(clk), .reset(sseg_reset_oil), .wr(sseg_wr_oil), .brightness(sseg_brightness_oil),
																																 .sel(sseg_sel_addr), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
																											         		 .val(sseg_val), .sseg(sseg_oil), .oe(sseg_oe_oil), .done_tick(sseg_done_tick_oil)),
																											 sseg_coolant_array(.clk(clk), .reset(sseg_reset_coolant), .wr(sseg_wr_coolant), .brightness(sseg_brightness_coolant),
																																	  .sel(sseg_sel_addr), .en(sseg_en), .sign(sseg_sign), .dp(sseg_dp),
																											         			  .val(sseg_val), .sseg(sseg_coolant), .oe(sseg_oe_coolant), .done_tick(sseg_done_tick_coolant));
	tick_counter #(.N(BCD_TICK_BITS)) sseg_tc(.clk(clk), .reset(sseg_tc_reset), .tick(sseg_done_tick_boost | sseg_done_tick_afr | sseg_done_tick_oil | sseg_done_tick_coolant), .counter(sseg_counter), .of(sseg_counter_of));																
	
	// LED matrix
	led_matrix #(.LEDS_N(LEDS_N), .LEDS_M(LEDS_M), .N_BITS(LEDS_N_BITS), .M_BITS(LEDS_M_BITS), .PWM_BITS(LEDS_PWM_BITS)) led_boost(.clk(clk), .reset(leds_boost_reset), .brightness(leds_boost_brightness), .sel_addr(leds_boost_sel_addr),
																																											 .sel(leds_boost_sel), .en(leds_boost_en), .n_en(leds_boost_n_en), .m_en(leds_boost_m_en), .done_tick(leds_boost_done_tick)),
																																								led_afr(.clk(clk), .reset(leds_afr_reset), .brightness(leds_afr_brightness), .sel_addr(leds_afr_sel_addr),
																																								        .sel(leds_afr_sel), .en(leds_afr_en), .n_en(leds_afr_n_en), .m_en(leds_afr_m_en), .done_tick(leds_afr_done_tick));
	tick_counter #(.N(LEDS_COUNTER_BITS)) leds_boost_tc(.clk(clk), .reset(leds_boost_counter_reset), .tick(leds_boost_done_tick), .counter(leds_boost_counter), .of(leds_boost_counter_of)),
												     leds_afr_tc(.clk(clk), .reset(leds_afr_counter_reset), .tick(leds_afr_done_tick), .counter(leds_afr_counter), .of(leds_afr_counter_of));
																																											 

	
	//
	// I/O block assignments
	//
	
	assign clk = CLOCK_50;
	assign sseg_oe = { sseg_oe_coolant, sseg_oe_oil, sseg_oe_afr, sseg_oe_boost };
	assign leds_m  = { leds_afr_n_en, leds_boost_n_en };
	assign leds_n = { leds_afr_m_en, leds_boost_m_en };
	
	// Timer counter block
	assign tc_status = { tc1_of, tc1_counter};
	
	// UART block
	assign uart1_reset_control = { uart1_reset, uart1_rx_tc_reset, uart1_rx_tc_reset };
	assign uart1_wr_control = { uart1_rd_uart, uart1_wr_uart };
	assign uart1_baud_control = { uart1_dbit, uart1_pbit, uart1_sb_tick, uart1_os_tick, uart1_dvsr };
	assign uart1_status_control = {uart1_tx_full, uart1_rx_empty, uart1_e_parity, uart1_e_frame, uart1_e_rxof, uart1_e_txof, uart1_rx_counter_of, uart1_tx_counter_of };
	
	// BCD converter block
	assign bcd1_control = { bcd1_reset, bcd1_tc_reset, bcd1_start };
	assign bcd1_status = { bcd1_ready, bcd1_counter_of };
	
	// Warning & status PWM block
	assign warn_pwm_control = { warn_pwm_reset, warn_pwm_en };
	
	// SSEG block
	assign sseg_reset_control = { sseg_reset_boost, sseg_reset_afr, sseg_reset_oil, sseg_reset_coolant, sseg_tc_reset };
	assign sseg_wr_control = { sseg_wr_boost, sseg_wr_afr, sseg_wr_oil, sseg_wr_coolant };
	assign sseg_wr_val = { sseg_en, sseg_sign, sseg_dp, sseg_val };
	
	// LEDS block
	assign leds_reset_control = { leds_boost_reset, leds_afr_reset, leds_boost_counter_reset, leds_afr_counter_reset };
	assign leds_boost_control = { leds_boost_sel, leds_boost_en };
	assign leds_afr_control = { leds_afr_sel, leds_afr_en };
	assign leds_boost_counter_status = { leds_boost_counter_of, leds_boost_counter };
	assign leds_afr_counter_status = { leds_afr_counter_of, leds_afr_counter };
	
	//
	// Output assignments
	//
	
	assign LED = ~status_led_en;
	assign C_SSEG = (sseg_oe <= (1 << 3)) ? sseg_boost :
	                (sseg_oe <= (1 << 7)) ? sseg_afr :
						 (sseg_oe <= (1 << 11)) ? sseg_oil :
						 (sseg_oe <= (1 << 15)) ? sseg_coolant :
						 8'b0;
	assign C = sseg_oe;
	assign D = leds_m;
	assign G = leds_n;
									
endmodule