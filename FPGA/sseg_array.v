module sseg_array
#(
	parameter SSEG_BITS=2,         // SSEG storage bits
	          SSEG_N=3,            // SSEG module count
				 
				 // Blinker parameters
				 C_ON_DIV_SSEG_N=2,   // Number of clocks the blinker stays on when b_en / SSEG_N
				 C_OFF_DIV_SSEG_N=3,  // Number of clocks the blinker stays off when b_en / SSEG_N
				 C_BITS=3             // Number of bits of precision of the blinker
)
(
	input wire clk, reset,               // Global clock and reset signals
	input wire en, wr,                   // Display enable signal for PWM and write enable
	input wire [SSEG_BITS-1:0] sel,      // Selected module
	input wire [3:0] val,                // Selected value (BCD)
	input wire sseg_en, sign, dp, blink, // Sign enable
	output wire [7:0] sseg,              // Current output
	output wire [SSEG_BITS-1:0] oe       // Output enable for current clock cycle
);

	reg [9:0] sseg_arr_reg [2**SSEG_BITS-1:0];      // Encoded value storage register with enable and blink prefix
	reg [7:0] sseg_reg, sseg_next;                  // Output value
	reg [SSEG_BITS-1:0] oe_i_reg, oe_i_next;        // Output enable register index
	reg [2**SSEG_BITS-1:0] oe_reg, oe_next;         // Output enable register value
	wire [7:0] val_enc;                             // Encoded sseg value
	wire b_en;                                      // Encoded sseg value blink state
	
	blinker_counter #(.C_ON(C_ON_DIV_SSEG_N), .C_OFF(C_OFF_DIV_SSEG_N), .C_BITS(C_BITS)) bc(.clk(clk), .reset(reset), .blink(~reset), .b_en(b_en));
	sseg encoder(.num(val), .dp(dp), .sign(sign), .hex(val_enc));
		
	// register file write operation
	always @(posedge clk)
		if (wr)
			sseg_arr_reg[sel] <= {sseg_en, blink, val_enc};
			
	// FF operation
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				sseg_reg <= 0;
				oe_i_reg <= 0;
				oe_reg <= 0;
			end
		else
			begin
				sseg_reg <= sseg_next;
				oe_i_reg <= oe_i_next;
				oe_reg <= oe_next;
			end
			
	// Counter operation
	always @*
		begin
			oe_i_next = oe_i_reg + 1'b1; // Should just flip over
			if (oe_i_next == SSEG_N)
				oe_i_next = 0;
			
			if (!en || !sseg_arr_reg[oe_i_next][9] || (sseg_arr_reg[oe_i_next][8] && !b_en))
				begin
					 sseg_next = 0;
					 oe_next = 0;
				end
			else
				begin
					sseg_next = sseg_arr_reg[oe_i_next][8:0];
					oe_next = 1'b1 << oe_i_next;
				end
		end
			
	assign sseg = sseg_reg;
	assign oe = oe_reg;

endmodule
