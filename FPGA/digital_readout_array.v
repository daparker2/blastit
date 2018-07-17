module digital_readout_array
#(
	parameter READOUT_N_BITS=2,       // Digital readout storage bits
				 READOUT_W_BITS=2,       // Digital readout counter bits
				 READOUT_N=4,            // Digital readout module count
				 READOUT_W=4,            // Count of SSEG displays per module
				 READOUT_BIN_N=10,       // Bit precision of floating binary number, note that one module is always reserved for the sign
				 READOUT_DECM_N=2,       // Bit precision of decimal mantissa
				 
				 // Blinker parameters
				 C_ON_DIV_SSEG_N=2,      // Number of clocks the blinker stays on when b_en / SSEG_N
				 C_OFF_DIV_SSEG_N=3,     // Number of clocks the blinker stays off when b_en / SSEG_N
				 C_BITS=3                // Number of bits of precision of the blinker
)
(
	input wire clk, reset,
	input wire en, wr,                        // Display enable signal for PWM and write enable
	input wire [READOUT_N_BITS-1:0] sel,      // Selected digital readout
	input wire [READOUT_BIN_N-1:0] val,       // Selected value binary
	input wire [READOUT_DECM_N-1:0] mantissa, // Selected value decimal mantissa
	input wire sign, blink,                   // Sign and blink
	output wire [7:0] sseg,                   // Current output
	output reg ready, done_tick,              // Read or write operation state
	output wire [READOUT_N*READOUT_W-1:0] oe  // Output enable for current clock cycle
);

	localparam [2:0] idle    = 3'd0,
	                 encode  = 3'd1,
						  write   = 3'd2,
						  stop    = 3'd3;
	
	
	reg [2:0] state_reg, state_next;             // Readout encoder state
	reg start_reg, start_next;                   // Encoder start
	reg sign_reg, sign_next;
	reg [READOUT_N_BITS-1:0] sel_reg, sel_next;  // Selected module
	reg en_reg, en_next;                         // Enable
	reg dp_reg, dp_next;
	reg wr_reg, wr_next;                         // SSEG array write enable
	reg [3:0] bcd_reg, bcd_next;                 // BCD register
	reg [READOUT_W_BITS-1:0] n_reg, n_next;      // State counter
	wire bcd_ready, bcd_done_tick;
	wire [(READOUT_W-1)*4-1:0] bcd;               // Encoded BCD array value
	
	bin2bcd #(.BCD_N(READOUT_W-1), .BIN_N(READOUT_BIN_N)) b2bcd(.clk(clk), .reset(reset), .start(start_reg), .bin(val), .ready(bcd_ready), .done_tick(bcd_done_tick), .bcd(bcd));
	sseg_array #(.SSEG_BITS(READOUT_N_BITS + READOUT_W_BITS), .SSEG_N(READOUT_N*READOUT_W), .C_ON_DIV_SSEG_N(C_ON_DIV_SSEG_N), .C_OFF_DIV_SSEG_N(C_OFF_DIV_SSEG_N), .C_BITS(C_BITS))           
	           ssegarr(.clk(clk), .reset(reset), .en(en), .wr(wr), .sel(n_reg), .val(bcd[bcd_reg]), .sign(sign_reg), .dp(dp_reg), .blink(blink), .sseg(sseg), .oe(oe));

	// FF logic
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				state_reg <= 0;
				start_reg <= 0;
				sel_reg <= 0;
				sign_reg <= 0;
				en_reg <= 0;
				dp_reg <= 0;
				wr_reg <= 0;
				bcd_reg <= 0;
				n_reg <= 0;
			end
		else
			begin
				state_reg <= state_next;
				start_reg <= start_next;
				sel_reg <= sel_next;
				sign_reg <= sign_next;
				en_reg <= en_next;
				wr_reg <= wr_next;
				dp_reg <= dp_next;
				bcd_reg <= bcd_next;
				n_reg <= n_next;
			end
			
	always @*
		begin
			state_next = state_reg;
			start_next = start_reg;
			sign_next = sign_reg;
			sel_next = sel_reg;
			en_next = en_reg;
			dp_next = dp_reg;
			wr_next = wr_reg;
			bcd_next = bcd_reg;
			n_next = n_reg;
			ready = 1'b0;
			done_tick = 1'b0;
			
			case (state_reg)
				idle: 
					begin
						ready = 1'b1;
						if (wr)
							begin
								start_next = 1'b1;
								state_next = encode;
							end
					end
				encode:
					begin
						if (bcd_done_tick)
							begin
								n_next = 0;
								sign_next = 0;
								en_next = 0;
								wr_next = 1'b1;
								sel_next = sel * READOUT_W;
								state_next = write;
							end
					end
				write:
					begin
						dp_next = 1'b0;
						if (n_next == READOUT_W)
							begin
								// Stop the operation
								wr_next = 1'b0;
								state_next = stop;
							end
						else if (n_next == READOUT_W - 1)
							begin
								// Write the sign value
								en_next = sign;
								sign_next = sign;
							end
						else
							begin
								// Write the decimal value
								bcd_next = (bcd >> (4 * n_next));
								en_next = (n_next == 0) || (bcd_next != 0);
								if (n_next == mantissa)
									dp_next = 1'b1;
							end
							
						sel_next = sel_next + 1'b1;
						n_next = n_next + 1'b1;
					end
				stop:
					begin
						done_tick = 1'b1;
						state_next = idle;
					end
			endcase
		end
				  
endmodule