module uart_test
(
	input wire clk, reset,
	input wire rx,
	input wire [2:0] btn,
	output wire tx,
	output wire [3:0] an,
	output wire [6:0] sseg, led
);

// signal declaration
wire tx_full, rx_empty, btn_tick;
wire [7:0] rec_data, rec_data1;

// body
// instantinate uart
uart uart_unit(clk, reset, btn_tick, btn_tick, rx, rec_data1, tx_full, rx_empty, rec_data, tx);
debounce btn_db_unit(clk, reset, btn[0], btn_tick);
// incremented data loops back
assign rec_data1 = rec_data + 1'b1;
// LED display
assign led = rec_data[6:0];
assign an = 4'b1110;
assign sseg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 2'b11}; 

endmodule