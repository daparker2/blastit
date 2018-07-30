// Top level module for blastit. Demonstrates that all LEDs on the board can be enabled.

module blastit_demo_all_leds
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
	wire clk;
	reg [3:0] d_i_reg, g_i_reg, d_i_next, g_i_next;
	reg [3:0] led_i_reg, led_i_next;
	reg [5:0] c_i_reg, c_i_next;
	reg [3:0] cseg_i_reg, cseg_i_next;
	reg warn_en_reg, warn_en_next;
	reg daylight_reg, daylight_next;
	wire led_tick;
	
	mod_m_counter #(.M_BITS(24)) tick_counter(.clk(clk), .reset(0), .m(24'd5000), .max_tick(led_tick), .q());
	
	always @(posedge clk)
		begin
			d_i_reg <= d_i_next;
			g_i_reg <= g_i_next;
			led_i_reg <= led_i_next;
			warn_en_reg <= warn_en_next;
			cseg_i_reg <= cseg_i_next;
			c_i_reg <= c_i_next;
			daylight_reg <= daylight_next;
		end
		
	always @*
		begin
			d_i_next = d_i_reg;
			g_i_next = g_i_reg;
			led_i_next = led_i_reg;
			warn_en_next = warn_en_reg;
			cseg_i_next = cseg_i_reg;
			c_i_next = c_i_reg;
			daylight_next = daylight_reg;
			if (led_tick)
				begin
					daylight_next = DAYLIGHT;
					c_i_next = c_i_reg + 1;
					if (c_i_next == 16)
						begin
							c_i_next = 0;
							cseg_i_next = cseg_i_reg + 1;
							if (cseg_i_next == 8)
								cseg_i_next = 0;
						end
				
					warn_en_next = ~warn_en_reg;
				
					led_i_next = led_i_reg + 1;
					if (led_i_next == 4)
						led_i_next = 0;
				
					g_i_next = g_i_reg + 1;
					if (g_i_next == 10)
						begin
							g_i_next = 0;
							d_i_next = d_i_reg + 1;
							if (d_i_next == 4)
								d_i_next = 0;
						end
					end
		end

	// LED bar
	assign G = g_i_reg == 0 ? 10'bzzzzzzzzz0:
				  g_i_reg == 1 ? 10'bzzzzzzzz0z:
				  g_i_reg == 2 ? 10'bzzzzzzz0zz:
				  g_i_reg == 3 ? 10'bzzzzzz0zzz:
				  g_i_reg == 4 ? 10'bzzzzz0zzzz:
				  g_i_reg == 5 ? 10'bzzzz0zzzzz:
				  g_i_reg == 6 ? 10'bzzz0zzzzzz:
				  g_i_reg == 7 ? 10'bzz0zzzzzzz:
				  g_i_reg == 8 ? 10'bz0zzzzzzzz:
				  g_i_reg == 9	? 10'b0zzzzzzzzz:
				                 10'bzzzzzzzzzz;	
									  
	assign D = d_i_reg == 0 ? 8'bzz1zzzz1:
				  d_i_reg == 1 ? 8'bzzz1zz1z:
				  d_i_reg == 2 ? 8'b1zzzz1zz:
				  d_i_reg == 3 ? 8'bz1zz1zzz:
				                 8'bzzzzzzzz;
									  
	// 7 segment display
	assign C_SSEG = cseg_i_reg == 0 ? 8'bzzzzzzz0:
						 cseg_i_reg == 1 ? 8'bzzzzzz0z:
						 cseg_i_reg == 2 ? 8'bzzzzz0zz:
						 cseg_i_reg == 3 ? 8'bzzzz0zzz:
						 cseg_i_reg == 4 ? 8'bzzz0zzzz:
						 cseg_i_reg == 5 ? 8'bzz0zzzzz:
						 cseg_i_reg == 6 ? 8'bz0zzzzzz:
						 cseg_i_reg == 7 ? 8'b0zzzzzzz:
												 8'bzzzzzzzz;
							
	assign C = c_i_reg == c_i_reg == 0 ?  16'bzzzzzzzzzzzzzzz1:
								 c_i_reg == 1 ?  16'bzzzzzzzzzzzzzz1z:
								 c_i_reg == 2 ?  16'bzzzzzzzzzzzzz1zz:
								 c_i_reg == 3 ?  16'bzzzzzzzzzzzz1zzz:
								 c_i_reg == 4 ?  16'bzzzzzzzzzzz1zzzz:
								 c_i_reg == 5 ?  16'bzzzzzzzzzz1zzzzz:
								 c_i_reg == 6 ?  16'bzzzzzzzzz1zzzzzz:
								 c_i_reg == 7 ?  16'bzzzzzzzz1zzzzzzz:
								 c_i_reg == 8 ?  16'bzzzzzzz1zzzzzzzz:
								 c_i_reg == 9 ?  16'bzzzzzz1zzzzzzzzz:
								 c_i_reg == 10 ? 16'bzzzzz1zzzzzzzzzz:
								 c_i_reg == 11 ? 16'bzzzz1zzzzzzzzzzz:
								 c_i_reg == 12 ? 16'bzzz1zzzzzzzzzzzz:
								 c_i_reg == 13 ? 16'bzz1zzzzzzzzzzzzz:
								 c_i_reg == 14 ? 16'bz1zzzzzzzzzzzzzz:
								 c_i_reg == 15 ? 16'b1zzzzzzzzzzzzzzz:
													  16'bzzzzzzzzzzzzzzzz;
						
	
	// Misc LEDS and warning LED
	assign LED = led_i_reg == 3'd0 ? 4'bzzz0:
					 led_i_reg == 3'd1 ? 4'bzz0z:
					 led_i_reg == 3'd2 ? 4'bz0zz:
					 led_i_reg == 3'd3 ? 4'b0zzz:
	                                 4'bzzzz;
												
	assign WARN = daylight_reg ? warn_en_reg : 1'bz;
	
	assign clk = CLOCK_50;
	
	assign UART_TX = UART_RX;

endmodule