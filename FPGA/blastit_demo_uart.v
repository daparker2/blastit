// Top level module for blastit. Simple UART echo server to verify the UART connection

module blastit_demo_uart
(
	//
	// 50Mhz clock signal
	//
	input wire CLOCK_50,

	//
	// Daylight operation indicator
	//
	input wire DAYLIGHT,
	
	//
	// UART RX
	//
	input wire UART_RX,
	
	//
	// Seven segment selector output
	//
	output wire[7:0] C_SSEG,
	
	//
	// Seven segment selector address input
	//
	output wire[15:0] C,
	
	//
	// Diode array address output
	//
	output wire[9:0] D,
	
	//
	// Diode array address input
	//
	output wire[9:0] G,
	
	//
	// UART TX
	// 
	output wire UART_TX,
	
	//
	// (Possibly unused) status LEDs
	//
	output wire[3:0] LED,
	
	//
	// Warning indicator
	//
	output wire WARN
);

	wire tx;

	// signal declaration
	reg [7:0] tx_data_reg, tx_data_next;
	reg tx_en_reg, tx_en_next;
	wire [7:0] e_data;
	wire rx_done_tick, tx_done_tick;
	wire tx_full, rx_empty;
	wire tx_empty, rx_full;

	// Should be set up for 8 data bits, even parity, 1 stop bit, 115200 baud

	// body
	// instantinate uart
	uart #(.FIFO_R(2), .FIFO_W(2), .DVSR_BIT(8), .DBIT(8)) 
		  uart_unit(
			  .clk(CLOCK_50), .reset(0), 
			  .dbit(8), .pbit(1), .sb_tick(32), .os_tick(32), .dvsr(13),
			  .rd_uart(~rx_empty), .wr_uart(rx_done_tick), 
			  .rx(UART_RX), .w_data(e_data), .tx_full(tx_full), .rx_empty(rx_empty),
			  .tx(UART_TX), .r_data(e_data), .tx_done_tick(tx_done_tick), .rx_done_tick(rx_done_tick),
			  .tx_empty(tx_empty), .rx_full(rx_full)
		  );
		
	assign LED = { ~rx_empty, ~rx_full, ~tx_empty, ~tx_full };
	
endmodule