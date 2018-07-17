module front_panel_controller
#(
	parameter T=20,          // Clock period in MS
				 LEDS_BITS = 8, // LED strip address count
				 
	
				 // Boost/AFR readout size 
				 BOOST_REF = 139,              // Boost reference
				 BOOST_MAX = 100,              // Boost max * 10
	          BOOST_D_W = 5,
				 BOOST_G_W = 10,
				 AFR_D_W = 5,
				 AFR_G_W = 10
)
(
	input wire clk, reset,
	input wire[8:0] disp_w,	                                            // Display brightness
	input wire disp_en,                                                 // Display enable
	input wire [9:0] boost_val, afr_val, oil_val, coolant_val,
	input wire boost_sign,                                              // Is boost input negative
	input wire wrn, boost_wrn, afr_wrn,
	
	output wire[7:0] sseg,                                              // Digital readout 7-seg interface
	output wire[15:0] c,                                                // Digital readout 7-seg enable
	output wire[BOOST_D_W-1:0] boost_d,                                 // Digital readout boost/AFR bar select
	output wire[BOOST_G_W-1:0]	boost_g,
	output wire[AFR_D_W-1:0] afr_d, 
	output wire[AFR_G_W-1:0] afr_g,                                     
	output wire warning                                                 // Warning enable
);

	localparam COUNTER_W = 30,               // Counter bit width
	           MILLIS_W = 14,                // Millisecond timer bit width
				  
				  // Digital readout array settings
				  READOUT_N_BITS=2,      // Digital readout storage bits
				  READOUT_W_BITS=2,       // Digital readout counter bits
				  READOUT_N=4,            // Digital readout module count
				  READOUT_W=4,            // Count of SSEG displays per module
				  READOUT_BIN_N=10,       // Bit precision of floating binary number, note that one module is always reserved for the sign
				  READOUT_DECM_N=2;       // Bit precision of decimal mantissa

	localparam [COUNTER_W-1:0] WRN_ON_MILLIS = millis2clocks(200),
	                           WRN_OFF_MILLIS = millis2clocks(300),
										READOUT_WRN_ON_MILLIS = millis2clocks(12),
	                           READOUT_WRN_OFF_MILLIS = millis2clocks(18),
										BOOST_AFR_WRN_ON_MILLIS = millis2clocks(20),
										BOOST_AFR_WRN_OFF_MILLIS = millis2clocks(25);
										
	reg [3:0] state_reg, state_next;             // Readout encoder state
   reg [READOUT_N_BITS-1:0] sel_reg, sel_next;
	reg [READOUT_BIN_N-1:0] val_reg, val_next;
	reg [READOUT_DECM_N-1:0] m_reg, m_next;
	reg sign_reg, sign_next;
	reg blink_reg, blink_next;
	reg wr_reg, wr_next;
	wire [9:0] boost_bar_val;
	wire readout_ready, readout_done_tick;      // Digital readout ready/done tick
	wire en;                                    // Global enable/PWM setting

	// Brightness PWM
	pwm #(.N(9), .M(1)) brightness_pwm(.clk(clk), .reset(reset), .in(disp_en), .w(disp_w), .out(en));
	
	// Blinker counter warning output
	blinker_counter #(.C_ON(WRN_ON_MILLIS), .C_OFF(WRN_OFF_MILLIS), .C_BITS(COUNTER_W)) 
	  warning_blinker(.clk(clk), .reset(reset), .blink(wrn), .b_en(warning));
	  
	// Digital readout
	digital_readout_array #(.READOUT_N_BITS(READOUT_N_BITS), .READOUT_W_BITS(READOUT_W_BITS), .READOUT_N(READOUT_N), 
	                        .READOUT_W(READOUT_W), .READOUT_BIN_N(READOUT_BIN_N), .READOUT_DECM_N(READOUT_DECM_N),
									.C_ON_DIV_SSEG_N(READOUT_WRN_ON_MILLIS), .C_OFF_DIV_SSEG_N(READOUT_WRN_OFF_MILLIS), .C_BITS(COUNTER_W))
						readout(.clk(clk), .reset(reset), .en(en), .wr(wr_reg), 
								  .sel(sel_reg), .val(val_reg), .mantissa(m_reg),
								  .sign(sign_reg), .blink(blink_reg),
								  .sseg(sseg), .ready(readout_ready), .done_tick(readout_done_tick), .oe(c));
								  
	// Boost and AFR bar
	led_bar #(.LEDS_N(BOOST_D_W*BOOST_G_W), .LEDS_I(BOOST_D_W), .LEDS_O(BOOST_G_W), .LEDS_BITS(LEDS_BITS),
             .VAL_L('d110), .VAL_U('d180), .VAL_Z('d147), .VAL_BITS(READOUT_BIN_N),
				 .C_ON(BOOST_AFR_WRN_ON_MILLIS), .C_OFF(BOOST_AFR_WRN_OFF_MILLIS), .C_BITS(COUNTER_W))
	boost_bar(.clk(clk), .reset(reset), .en(en), .value(boost_bar_val), .blink(boost_wrn), .in_en(boost_d), .out_en(boost_g));
	
	led_bar #(.LEDS_N(AFR_D_W*AFR_G_W), .LEDS_I(AFR_D_W), .LEDS_O(AFR_G_W), .LEDS_BITS(LEDS_BITS),
             .VAL_L('d000), .VAL_U(BOOST_REF), .VAL_Z(BOOST_REF + BOOST_MAX), .VAL_BITS(READOUT_BIN_N),
				 .C_ON(BOOST_AFR_WRN_ON_MILLIS), .C_OFF(BOOST_AFR_WRN_OFF_MILLIS), .C_BITS(COUNTER_W))
	afr_bar(.clk(clk), .reset(reset), .en(en), .value(afr_val), .blink(afr_wrn), .in_en(afr_d), .out_en(afr_g));
	
	localparam [3:0] boost   = 3'd0,
						  afr     = 3'd1,
						  oil     = 3'd2,
						  coolant = 3'd3;
						
	// FF control		
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				state_reg <= 0;
				sel_reg <= 0;
				val_reg <= 0;
				m_reg <= 0;
				sign_reg <= 0;
				blink_reg <= 0;
				wr_reg <= 0;
			end
		else
			begin
				state_reg <= state_next;
				sel_reg <= sel_next;
				val_reg <= val_next;
				m_reg <= m_next;
				sign_reg <= sign_next;
				blink_reg <= blink_next;
				wr_reg <= wr_next;
			end
			
	// FSMD logic
	always @*
		begin
			state_next = state_reg;
			sel_next = sel_reg;
			val_next = val_reg;
			m_next = m_reg;
			sign_next = sign_reg;
			blink_next = blink_reg;
			wr_next = wr_reg;
			case (state_reg)
				boost:
					begin
						wr_next = 1'b0;
						if (readout_ready)
							begin
								// Set the boost value
								sel_next = boost;
								val_next = boost_val;
								m_next = 1'b1;
								sign_next = boost_sign;
								blink_next = boost_wrn;
								wr_next = 1'b1;
								state_next = afr;
							end
					end
				afr:
					begin
						wr_next = 1'b0;
						if (readout_ready)
							begin
								// Set the boost value
								sel_next = afr;
								val_next = afr_val;
								m_next = 1'b1;
								sign_next = 0;
								blink_next = afr_wrn;
								wr_next = 1'b1;
								state_next = oil;
							end
					end
				oil:
					begin
						wr_next = 1'b0;
						if (readout_ready)
							begin
								// Set the boost value
								sel_next = oil;
								val_next = oil_val;
								m_next = 0;
								sign_next = 0;
								blink_next = 0;
								wr_next = 1'b1;
								state_next = coolant;
							end
					end
				coolant:
					begin
						wr_next = 1'b0;
						if (readout_ready)
							begin
								// Set the boost value
								sel_next = coolant;
								val_next = coolant_val;
								m_next = 0;
								sign_next = 0;
								blink_next = 0;
								wr_next = 1'b1;
								state_next = boost;
							end
					end
			endcase
		end
						  
	function [COUNTER_W-1:0] millis2clocks;
		input wire [MILLIS_W-1:0] value;
		begin 
			millis2clocks = value * 1000000 / T;
		end
	endfunction
	
	// Assign boost bar reference
	assign boost_bar_val = boost_sign ? (BOOST_REF - boost_val) : (BOOST_REF + boost_val);
endmodule