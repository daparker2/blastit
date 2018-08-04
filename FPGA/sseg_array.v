module sseg_array
#(
	parameter SSEG_BITS=2,         // SSEG storage bits
	          SSEG_N=3,            // SSEG module count
				 
				 // PWM parameters
				 PWM_BITS=12,         // PWM precision
				 LED_PERIOD_BITS=24   // LED tick counter precision`
)
(
	input wire clk, reset,                       // Global clock and reset signals
	input wire wr,                               // Write enable
	input wire [PWM_BITS-1:0] brightness,        // Display brightness
	input wire [SSEG_BITS-1:0] sel,              // Selected module
	input wire [LED_PERIOD_BITS-1:0] led_period, // LED display period in clocks
	input wire en, sign, dp,                     // BCD enable, sign or decimal point enable
	input wire [3:0] val,                        // BCD value
	output wire [7:0] o_sseg,                    // Current output
	output wire [SSEG_N-1:0] oe,                 // Output enable for current clock cycle
	output reg done_tick                         // All outputs displayed tick
);
	localparam SSEG_LEDS_N = 8;

	reg [SSEG_LEDS_N-1:0] sseg_arr_reg [SSEG_N-1:0];               // Encoded value storage register with enable and blink prefix
	reg [SSEG_BITS-1:0] oe_i_reg, oe_i_next;                       // Output enable register index
	reg done_reg;                                                  // Done register
	wire [SSEG_LEDS_N-1:0] val_enc;                                // Encoded sseg value
	wire [SSEG_LEDS_N-1:0] cur_sseg;
	wire [SSEG_N-1:0] cur_oe;
	wire led_tick;
	
	pwm #(.N(PWM_BITS), .M(SSEG_N + SSEG_LEDS_N)) pwm1(.clk(clk), .reset(reset), .in({ cur_oe, cur_sseg }), .w(brightness), .out({ oe, o_sseg })); 
	sseg encoder(.num(val), .en(en), .sign(sign), .dp(dp), .hex(val_enc));
	mod_m_counter #(.M_BITS(LED_PERIOD_BITS)) tick_counter(.clk(clk), .reset(reset), .m(led_period), .max_tick(led_tick), .q());
		
	// register file write operation
	always @(posedge clk)
		if (wr)
			begin
				$display("val: val=%b sel=%b -> %b", {en, sign, dp, val }, sel, val_enc);
				sseg_arr_reg[sel] <= val_enc;
			end
			
	// FF operation
	always @(posedge clk, posedge reset)
		if (reset)
			oe_i_reg <= 0;
		else
			oe_i_reg <= oe_i_next;
				
	// Counter operation
	always @*
		begin
			oe_i_next = oe_i_reg;
			done_tick = 0;
			if (led_tick)
				begin
					oe_i_next = oe_i_reg + 1'b1; // Should just flip over
					if (oe_i_next == SSEG_N)
						begin
							oe_i_next = 0;
							done_tick = 1'b1;
						end
				end
		end
		
	assign cur_sseg = sseg_arr_reg[oe_i_reg];
	assign cur_oe = (sseg_arr_reg[oe_i_reg] > 0) ? (1 << oe_i_reg) : 0;

endmodule
