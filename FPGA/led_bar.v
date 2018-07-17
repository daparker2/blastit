module led_bar
#(
			    // LED strip parameters
	parameter LEDS_N=8,       // Number of LEDs in the strip
				 LEDS_I=4,       // Number of LED input enables
				 LEDS_O=2,       // Number of LED output enables
				 LEDS_BITS=4,    // Count of I/O bits
	
				 // Value parameters
	          VAL_L=0,        // Lower bound number
				 VAL_U=7,        // Upper bound number
				 VAL_Z=3,        // Zero value, which LED the number is offset from
				 VAL_BITS=3,     // Number of bits of precision of binary values
				 
				 // Blinker parameters
				 C_ON=2,         // Number of clocks the blinker stays on when b_en is high
				 C_OFF=3,        // Number of clocks the blinker stays off when b_en is high
				 C_BITS=3        // Number of bits of precision of the blinker
)
(
	input wire clk, reset,             // Global clock and reset signals
	input wire en,                     // Display enable signal for PWM
	input wire [VAL_BITS-1:0] value,   // Input value
	input wire blink,                  // Blink enable signal
	output wire [LEDS_I-1:0] in_en,    // Input driver enable
	output wire [LEDS_O-1:0] out_en    // Output driver enable
);

	reg [LEDS_I-1:0] in_en_reg, in_en_next;           // Input enable register
	reg [LEDS_O-1:0] out_en_reg, out_en_next;         // Output enable register
	reg [VAL_BITS-1:0] val_reg, val_next;             // Current value being driven
	reg [VAL_BITS-1:0] cur_reg, cur_next;             // Current value per I/O pair being examined
	reg [LEDS_BITS-1:0] i_reg, i_next, o_reg, o_next; // Current I/O being examined
	wire val_en;                                      // Current value I/O enable
	wire b_en;

	blinker_counter #(.C_ON(C_ON), .C_OFF(C_OFF), .C_BITS(C_BITS)) bc(.clk(clk), .reset(reset), .blink(blink), .b_en(b_en));
	
	// FF sequence
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				in_en_reg <= 0;
				out_en_reg <= 0;
				val_reg <= 0;
				cur_reg <= 0;
				i_reg <= 0;
				o_reg <= 0;
			end
		else
			begin
				in_en_reg <= in_en_next;
				out_en_reg <= out_en_next;
				val_reg <= val_next;
				cur_reg <= cur_next;
				i_reg <= i_next;
				o_reg <= o_next;
			end

	// Set and clamp value
	always @*
		begin
			val_next = value;
			if (val_next < VAL_L)
				val_next = VAL_L;
			if (val_next > VAL_U)
				val_next = VAL_U;
		end
			
	// Determine the I/O pair and value being tested and set the enable state
	always @*
		begin
			cur_next = cur_reg + 1'b1;
			if (cur_next == VAL_U)
				cur_next = VAL_L;
		
			i_next = i_reg + 1'b1;
			o_next = o_reg;
			if (i_next == LEDS_I)
				begin
					i_next = 0;
					o_next = o_reg + 1'b1;
					if (o_next == LEDS_O)
						o_next = 0;
				end
		end
		
	assign val_en = (val_reg >= VAL_Z) ? (cur_next >= VAL_Z) && (cur_next <= val_reg)
	              : (cur_next >= val_reg) && (cur_next <= VAL_Z);
	
	// Set the IO enable state maps
	always @*
		begin
			in_en_next = 0;
			out_en_next = 0;
			if (val_en)
				begin
					in_en_next = (1'b1 & b_en & en) << i_next;
					out_en_next = (1'b1 & b_en & en) << o_next;
				end
		end
			
	assign in_en = in_en_reg;
	assign out_en = out_en_reg;
			
endmodule