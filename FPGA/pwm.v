module pwm

#(
	parameter N = 4,
	          M = 1
)
(
	input wire clk, reset,
	input wire [M-1:0] in,
	input wire [N-1:0] w,
	output reg [M-1:0] out
);
	
	reg [N-1:0] cw;
	reg [N-1:0] counter;

	always @(posedge clk, posedge reset)
	begin
		cw = w;
	
		if (reset)
			begin
				out <= in;
				counter = 0;
			end
		else
			begin
				if (counter > cw || cw == 0)
					out <= 0;
				else
					out <= in;
				
				counter = counter + 1'b1;
			end
	end

endmodule