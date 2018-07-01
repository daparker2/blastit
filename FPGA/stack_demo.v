module stack_demo
#(
	parameter DB_TICKS=10,
				 DB_CW=4
)
(
	input wire clk, key_reset,
	input wire [7:0] sw_data,
	input wire key_push, key_pop,
	output wire [6:0] hex_rd1, hex_rd2,
	output wire [6:0] hex_wr1, hex_wr2,
	output wire led_of, led_uf, 
	output wire led_push, led_pop, led_reset
);

	reg pushed_reg, pushed_next, popped_reg, popped_next, reset_reg, reset_next;
	wire db_push, db_pop, of, uf;
	wire [7:0] rd_data;
	
	assign led_push = pushed_reg;
	assign led_pop = popped_reg;
	assign led_reset = reset_reg;
	assign led_of = of;
	assign led_uf = uf;

	latched #(DB_TICKS,1,DB_CW) push_db(clk, reset_reg, ~key_push, db_push),
	                            pop_db(clk, reset_reg, ~key_pop, db_pop);
	sseg sseg_rd1(rd_data[3:0], hex_rd1), sseg_rd2(rd_data[7:4], hex_rd2),
	     sseg_wr1(sw_data[3:0], hex_wr1), sseg_wr2(sw_data[7:4], hex_wr2);
	stack #(8, 4) stack(clk, reset_reg, db_pop, db_push, sw_data, rd_data, of, uf);
	
	always @(posedge clk)
	begin
		if (reset_reg)
			begin
				pushed_reg = 0;
				popped_reg = 0;
				reset_reg = 0;
			end
		else
			begin
				pushed_reg = pushed_next;
				popped_reg = popped_next;
				reset_reg = reset_next;
				reset_next = ~key_reset;
			end
	end
	
	always @*
	begin
		popped_next = 1'b0;
		pushed_next = 1'b0;
		if (db_pop || popped_reg)
			begin
				popped_next = 1'b1;
				pushed_next = 1'b0;
			end
			
		if (db_push || pushed_reg)
			begin
				pushed_next = 1'b1;
				popped_next = 1'b0;
			end
	end
	
endmodule