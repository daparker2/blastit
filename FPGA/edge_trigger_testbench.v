module edge_trigger_testbench;
	localparam T = 20;

	reg clk, reset;
	reg in, en;
	wire tick;
	
	edge_trigger uut(.clk(clk), .reset(reset), .in(in), .en(en), .tick(tick));
		
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
			@(negedge clk);
			reset = 1'b1;
			#(T / 2);
			reset = 1'b0;
		end
		
	task edge_test;
		input reg i_en;
		begin
			en = i_en;
			in = ~en;
			#(T);
			in = en;
			#(T * 2);
			in = ~en;
			#(T);
		end
	endtask
		
	initial
		begin
			@(negedge reset);
			
			edge_test(0);
			edge_test(1);
			edge_test(1);
			edge_test(0);
			edge_test(0);
			
			$stop;
		end
endmodule