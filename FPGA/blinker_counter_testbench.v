`timescale 1 ns / 10 ps

module blinker_counter_testbench;
	
	localparam T=20;
	
	reg clk, reset;
	reg blink;
	wire b_en;
	
	blinker_counter #(.C_ON(3), .C_OFF(2), .C_BITS(2)) uut(clk, reset, blink, b_en);

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
			blink = 1'b1;
			#(200);
			blink = 1'b0;
			#(200);		
			$stop;
		end
	
endmodule