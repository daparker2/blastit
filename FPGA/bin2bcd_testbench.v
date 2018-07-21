`timescale 1 ns / 10 ps

module bin2bcd_testbench;

	localparam BCD_N = 4,
	           BIN_N = 14;
	localparam T = 20;
	
	integer i;
	reg clk, reset, start;
	reg [BIN_N:0] bin;
	wire ready, done_tick;
	wire [(4*BCD_N)-1:0] bcd;
	
	bin2bcd #(.BCD_N(BCD_N), .BIN_N(BIN_N)) uut(.clk(clk), .reset(reset), .start(start), .sign(bin[BIN_N]),
                                               .bin(bin[BIN_N-1:0]), .ready(ready), .done_tick(done_tick), .bcd(bcd));
	
	// set up the clock
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
	
	task bin2bcd_test;
		input reg [BIN_N:0] data;
		begin
			bin = data;
			start = 1'b1;
			#(T);
			start = 1'b0;
			while (!ready)
				#(T);
				
			$display("data=%d bcd=%h", data, bcd);
		end
	endtask
	
	initial
	begin
		start = 1'b0;
		@(negedge reset);
		@(negedge clk);
		
		for (i = 0; i <= 16383; i = i + 1000)
			bin2bcd_test(i);
		
		$stop;
	end
endmodule