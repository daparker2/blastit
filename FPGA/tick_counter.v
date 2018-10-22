// N-bit tick counter with overflow which samples tick and increments the counter each clock period it is high.
module tick_counter
#(
	parameter N=4
)
(
	input wire clk, reset,
	input wire tick,
	output wire [N-1:0] counter,
	output wire of
);

	reg [N-1:0] counter_reg, counter_next;
	reg of_reg, of_next;
	
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				counter_reg <= 0;
				of_reg <= 0;
			end
		else
			begin
				counter_reg <= counter_next;
				of_reg <= of_next;
			end
			
	always @*
		begin
			counter_next = counter_reg + (tick == 1'b1 ? 1'b1 : 0);
			of_next = of_reg;
			if (counter_next < counter_reg)
				of_next = 1;
		end
		
	assign counter = counter_reg;
	assign of = of_reg;

endmodule