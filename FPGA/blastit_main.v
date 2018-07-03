// Top level module for blastit. Contains I/Os definitions.

module blastit_main
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
	inout wire[7:0] C_SSEG,
	
	//
	// Seven segment selector address input
	//
	inout wire[15:0] C,
	
	//
	// Diode array address output
	//
	inout wire[9:0] D,
	
	//
	// Diode array address input
	//
	inout wire[9:0] G,
	
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

endmodule