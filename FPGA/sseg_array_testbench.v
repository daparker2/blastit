module sseg_array_testbench;

	localparam T=20,
	           SSEG_BITS=2,
				  SSEG_N=2,
				  PWM_BITS=1;

	integer i, j;
	reg clk, reset;
	reg wr;
	reg [PWM_BITS-1:0] brightness;
	reg [SSEG_BITS-1:0] sel;
	reg en, sign, dp;
	reg [3:0] val;
	wire [7:0] sseg;
	wire [SSEG_BITS-1:0] oe;
	wire done_tick;
	
	sseg_array #(.SSEG_BITS(SSEG_BITS), .SSEG_N(SSEG_N), .PWM_BITS(PWM_BITS)) uut(.clk(clk), .reset(reset), .wr(wr), .brightness(brightness),
	                                                                              .sel(sel), .en(en), .sign(sign), .dp(dp),
																											.val(val), .sseg(sseg), .oe(oe), .done_tick(done_tick));
	
	// Clock control
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
		
	task sseg_set_brightness;
		input reg [PWM_BITS-1:0] brightness_i;
		
		begin
			brightness = brightness_i;
			while (!done_tick)
				#(T / 2);
				
			while (!done_tick)
				begin
					$display("brightness: sseg=%h oe=%b", sseg, oe);
					#(T / 2);
				end
				
			while (!done_tick)
				begin
					$display("brightness: sseg=%h oe=%b", sseg, oe);
					#(T / 2);
				end
		end
	endtask
		
	task sseg_set_val;
		input reg [SSEG_BITS-1:0] sel_i;
		input reg [3:0] val_i;
		input reg en_i, sign_i, dp_i;
		
		begin
			sel = sel_i;
			val = val_i;
			en =  en_i;
			sign = sign_i;
			dp = dp_i;
			wr = 1;
			#(T);
			wr = 0;		
			
			while (!done_tick)
				#(T);
			
			$display("val: sseg=%h oe=%b", sseg, oe);
			while (!done_tick)
				begin
					$display("val: sseg=%h oe=%b", sseg, oe);
					#(T);
				end
		end
	endtask	
	
	task sseg_test;
		input reg en_i, sign_i, dp_i;
		
		begin
			j = 0;
			for (i = 0; i <= 15; i = i + 1)
				begin
					if (j == SSEG_BITS-1)
						j = 0;
					else
						j = j + 1;
						
					sseg_set_val(j, i, en_i, sign_i, dp_i);
				end
		end		
	endtask
	
	initial
		begin
			@(negedge reset);
			@(negedge clk);
			
			sseg_set_brightness(1);
			$display("regular output tests");
			sseg_test(0, 0, 0);
			sseg_test(1, 0, 0);
			sseg_test(0, 1, 0);
			sseg_test(0, 0, 1);
			
			$display("shouldn't output anything");
			sseg_set_brightness(0);
			sseg_test(1, 0, 0);
			
			$stop;
		end
	
endmodule