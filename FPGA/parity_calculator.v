module parity_calculator
#(
	parameter N = 8,
				 PARITY  = 0  // 1=even, 2 = odd
)
(
	input wire[N-1:0] i,
	output wire o
);

// n-bit parity counter

wire zero;
wire xs;

assign zero = 0;
assign xs = ^i;
assign o = PARITY == 0 ? zero :
           PARITY == 1 ? xs  :
			  ~xs;

endmodule