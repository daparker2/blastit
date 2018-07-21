`timescale 1ns / 10ps

module parity_calculator_testbench;

integer i;
reg [7:0] test_i;
reg [3:0] dbit;
wire test_d, test_o, test_e;

parity_calculator #(.DBIT(8)) uut1(.data(test_i), .dbit(dbit), .pbit(0), .parity(test_d));
parity_calculator #(.DBIT(8)) uut2(.data(test_i), .dbit(dbit), .pbit(1), .parity(test_e));
parity_calculator #(.DBIT(8)) uut3(.data(test_i), .dbit(dbit), .pbit(2), .parity(test_o));

initial
begin
	for (i = 0; i <= 255; i = i + 1)
		begin
			test_i = i;
			dbit = 7;
			#200;
			dbit = 8;
			#200;
		end
end

endmodule