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

	uart_demo uart_test1(.clk(CLOCK_50), .key_reset(1), .rx(UART_RX), .tx(tx), .ntx_full(LED[1]), .nrx_empty(LED[0]));
	//assign tx = UART_RX;
	
	assign UART_TX = tx;
	
endmodule