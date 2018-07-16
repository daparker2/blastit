module blinker_counter
#(
	parameter C_ON=2,     // Number of clocks the blinker stays on
	          C_OFF=3,    // Number of clocks the blinker stays off
	          C_BITS=3    // Number of bits of precision of the blinker
)
(
	input wire clk, reset,
	input wire blink,
	output wire b_en
);

localparam C_MAX = C_ON + C_OFF - 1;
reg [C_BITS-1:0] c_reg, c_next;

always @(posedge clk, posedge reset)
	begin
		if (reset)
			c_reg <= 0;
		else
			c_reg <= c_next;
	end

always @*
	begin
		c_next = c_reg + 1'b1;
		if (c_next == C_MAX)
			c_next = 0;
	end
	
assign b_en = ~blink || (c_reg < C_ON);

endmodule