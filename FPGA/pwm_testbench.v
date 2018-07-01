`timescale 1 ns / 10 ps

module pwm_testbench;
	reg clk, reset;
	reg [0:0] test_in;
	reg [3:0] test_ds;
	wire [0:0] test_out;
	
	localparam T=20;
	
	pwm uut(clk, reset, test_in, test_ds, test_out);
	
	always
	begin
		clk = 1'b1;
		#(T / 2);
		clk = 1'b0;
		#(T / 2);
	end
	
	initial
	begin
		reset = 1'b1;
		#(T / 2);
		reset = 1'b0;
	end
	
	initial
	begin
		test_in = 1'b1;
		test_ds = 4'b1111;
		@(negedge reset);
		@(negedge clk);
		
		#1000;
		@(negedge clk);
		test_ds = 4'b1000;
		
		#1000;
		@(negedge clk);
		test_ds = 4'b0100;
		
		#1000;
		@(negedge clk);
		test_ds = 4'b0010;
		
		#1000;
		@(negedge clk);
		test_ds = 4'b0001;
		
		#1000;
		@(negedge clk);
		test_ds = 4'b0000;
		
		#1000;
		$stop;
	end
	
endmodule