module pwm

#(
	parameter N = 4,
	          M = 1
)
(
	input wire clk, reset,
	input wire [M-1:0] in,
	input wire [N-1:0] w,
	output wire [M-1:0] out
);

	reg [N-1:0] counter_reg, counter_next;

	always @(posedge clk, posedge reset)
		if (reset)
			counter_reg <= 0;
		else
			counter_reg <= counter_next;
			
	always @*
		counter_next = counter_reg + 1'b1;
		
	assign out = (counter_reg > w || w == 0) ? 0 : in;

endmodule