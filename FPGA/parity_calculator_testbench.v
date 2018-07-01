`timescale 1ns / 10ps

module parity_calculator_testbench;

integer i;
reg [7:0] test_i;
wire test_d, test_o, test_e;

parity_calculator #(8, 0) uut1(test_i, test_d);
parity_calculator #(8, 1) uut2(test_i, test_e);
parity_calculator #(8, 2) uut3(test_i, test_o);

initial
begin
	for (i = 0; i <= 15; i = i + 1)
		begin
			test_i = i;
			#200;
		end
end

endmodule