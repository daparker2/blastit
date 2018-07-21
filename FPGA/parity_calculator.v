module parity_calculator
#(
	parameter DBIT=8 // # of data bits
)
(
	input wire [DBIT-1:0] data,
	input wire [3:0] dbit,            // Data bits (7 or 8)
	input wire [1:0] pbit,            // 0=none, 1=even, 2 = odd
	output wire parity
);

// n-bit parity counter

wire zero;
wire xs;

assign zero = 0;
assign xs = (dbit == 7) ? ^data[6:0] : ^data[7:0];
assign parity = pbit == 0 ? zero :
					 pbit == 1 ? xs  :
					 ~xs;

endmodule