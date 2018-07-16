`timescale 1 ns / 10 ps

module led_bar_testbench;
	
	localparam T=20,
	           VAL_BITS = 3,
				  LEDS_I = 4,
				  LEDS_O = 2,
				  VAL_L = 0,
				  VAL_U = 7;
	
	reg clk, reset;
	reg en;
	reg [VAL_BITS-1:0] value;
	reg blink;
	wire [LEDS_I-1:0] in_en;
	wire [LEDS_O-1:0] out_en;
	integer i;
	
	led_bar         #(
								.LEDS_I(LEDS_I), .LEDS_O(LEDS_O), .LEDS_BITS(4),
								.VAL_L(VAL_L), .VAL_U(VAL_U), .VAL_Z(3), .VAL_BITS(VAL_BITS),
								.C_ON(2), .C_OFF(3), .C_BITS(3)
						  )
						 uut
						 (
								.clk(clk), .reset(reset), .en(en),
								.value(value), .blink(blink),
								.in_en(in_en), .out_en(out_en)
						 );

	always
		begin
			clk = 1'b1;
			#(T / 2);
			clk = 1'b0;
			#(T / 2);
		end
		
	// reset the UUT
	initial
		begin
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
	
	initial
		begin
			@(negedge reset);
			
			for (i = VAL_L; i <= VAL_U; i = i + 1)
				begin
					@(negedge clk);
					en = 1;
					blink = 0;
					value = i;
					#(1000);
					@(negedge clk);
					blink = 1;
					#(1000);
					@(negedge clk);
					en = 0;
					#(1000);
					@(negedge clk);
				end
		
			$stop;
		end
	
endmodule