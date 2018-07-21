module sseg_array
#(
	parameter SSEG_BITS=2,         // SSEG storage bits
	          SSEG_N=3,            // SSEG module count
				 
				 // PWM parameters
				 PWM_BITS=12          // PWM precision
)
(
	input wire clk, reset,                // Global clock and reset signals
	input wire wr,                        // Write enable
	input wire [PWM_BITS-1:0] brightness, // Display brightness
	input wire [SSEG_BITS-1:0] sel,       // Selected module
	input wire en, sign, dp,              // BCD enable, sign or decimal point enable
	input wire [3:0] val,                 // BCD value
	output wire [7:0] sseg,               // Current output
	output wire [2**SSEG_BITS-1:0] oe,    // Output enable for current clock cycle
	output reg done_tick                  // All outputs displayed tick
);

	reg [7:0] sseg_arr_reg [2**SSEG_BITS-1:0];                     // Encoded value storage register with enable and blink prefix
	reg [SSEG_BITS-1:0] oe_i_reg, oe_i_next;                       // Output enable register index
	reg done_reg;                                                  // Done register
	wire [7:0] val_enc;                                            // Encoded sseg value
	wire [7:0] cur_sseg;
	wire [2**SSEG_BITS-1:0] cur_oe;
	
	pwm #(.N(PWM_BITS), .M(2**SSEG_BITS-1)) pwm1(.clk(clk), .reset(reset), .in(cur_oe), .w(brightness), .out(oe)); 
	pwm #(.N(PWM_BITS), .M(8)) pwm2(.clk(clk), .reset(reset), .in(cur_sseg), .w(brightness), .out(sseg));
	sseg encoder(.num(val), .en(en), .sign(sign), .dp(dp), .hex(val_enc));
		
	// register file write operation
	always @(posedge clk)
		if (wr)
			sseg_arr_reg[sel] <= val_enc;
			
	// FF operation
	always @(posedge clk, posedge reset)
		if (reset)
			oe_i_reg <= 0;
		else
			oe_i_reg <= oe_i_next;
				
	// Counter operation
	always @*
		begin
			done_tick = 0;
			if (oe_i_reg == 0)
				done_tick = 1;
				
			oe_i_next = oe_i_reg + 1'b1; // Should just flip over
			if (oe_i_next == SSEG_N)
				oe_i_next = 0;
		end
		
	assign cur_sseg = sseg_arr_reg[oe_i_next];
	assign cur_oe = (1 << oe_i_reg);

endmodule
