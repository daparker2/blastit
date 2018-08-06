// A single input rising edge trigger
module edge_trigger
(
	input wire clk, reset,
	input wire in,
	input wire tick
);

	localparam start = 2'd0,
	           trigger = 2'd1,
				  stop;

endmodule