`timescale 1 ns / 10 ps

module led_matrix_testbench;
	
	localparam T=20;
	localparam LEDS_N=4,
				  LEDS_M=4,
				  N_BITS = 3,
				  M_BITS = 3,
				  PWM_BITS=1,
				  LED_PERIOD_BITS=4;
	
	integer i;
	reg clk, reset;
	reg [PWM_BITS-1:0] brightness;
	reg [N_BITS + M_BITS - 1:0] sel_addr;
	reg [LED_PERIOD_BITS-1:0] led_period;
	reg sel, en;
	wire [LEDS_N-1:0] n_en;
	wire [LEDS_M-1:0] m_en;
	wire done_tick;
	
	led_matrix #(
						.LEDS_N(LEDS_N), .LEDS_M(LEDS_M), .N_BITS(N_BITS),
						.M_BITS(M_BITS), .PWM_BITS(PWM_BITS), .LED_PERIOD_BITS(LED_PERIOD_BITS)
					)
					uut
					(
						.clk(clk), .reset(reset), .brightness(brightness), .sel_addr(sel_addr), .led_period(led_period),
						.sel(sel), .en(en), .n_en(n_en), .m_en(m_en), .done_tick(done_tick)
					);

	// Start the clock
	always
		begin
			clk = 1;
			#(T / 2);
			clk = 0;
			#(T / 2);
		end
		
	// reset the UUT
	initial
		begin
			led_period = 2;
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
	
	task set_brightness;
		input reg [PWM_BITS-1:0] brightness_i;
		
		begin
			brightness = brightness_i;
			while (!done_tick)
				#(T / 2);
				
			while (!done_tick)
				#(T / 2);
		end
	endtask	
	
	task set_val;
		input reg [N_BITS + M_BITS - 1:0] sel_addr_i;
		input reg en_i;
		
		begin
			$display("set_val: sel_addr_i: %d en_i: %b", sel_addr_i, en_i);
			sel = 1;
			sel_addr = sel_addr_i;
			en = en_i;
			#(T);
			sel = 0;	
		end
	endtask	
	
	task led_matrix_test;
		input reg en_i;
		
		begin
			for (i = 0; i <= (LEDS_M * LEDS_N - 1); i = i + 1)
				begin
					set_val(i, en_i);
					while (!done_tick)
						#(T / 2);
				end
				
			for (i = 0; i <= (LEDS_M * LEDS_N - 1); i = i + 1)
				begin
					set_val(i, ~en_i);
					while (!done_tick)
						#(T / 2);
				end
		end		
	endtask
	
	always @*
		$display("val: m_en: %b n_n: %b", m_en, n_en);
		
	initial
		begin
			@(negedge reset);
			$display("init");
			for (i = 0; i <= (LEDS_M * LEDS_N - 1); i = i + 1)
				set_val(i, 0);
					
			$display("regular output tests");
			set_brightness(1);
			led_matrix_test(1);
			
			$display("shouldn't output anything");
			set_brightness(0);
			led_matrix_test(1);
			
			$stop;
		end
	
endmodule