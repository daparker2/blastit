module pwm_demo
(
	input wire clk, reset,
	input wire [3:0]  w,
	output wire [0:0] led
);

	reg in = 1;
	wire db_reset;
	
	// Connects the two output registers to two hex displays on the devkit.
	debounce db1(clk, reset, reset, db_reset);
	pwm pwm1(clk, db_reset, in, w, led);
		
endmodule