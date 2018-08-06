// A single input rising edge trigger synced to clk
module edge_trigger
(
	input wire clk, reset,
	input wire in, en,
	output reg tick
);

	localparam wait_trigger = 2'd0,
	           triggered = 2'd1;

	reg in_reg, in_next;
	reg [2:0] state_reg, state_next;
	
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				in_reg <= 0;
				state_reg <= wait_trigger;
			end
		else
			begin
				in_reg <= in_next;
				state_reg <= state_next;
			end
			
	always @*
		begin
			in_next = in;
			state_next = state_reg;
			tick = 0;
			case (state_reg)
				wait_trigger:
					if (in_next == en && in_reg == ~en)
						begin
							state_next = triggered;
							tick = 1'b1;
						end
				triggered:
					if (in_next == ~en)
						state_next = wait_trigger;
			endcase
		end
				  
endmodule