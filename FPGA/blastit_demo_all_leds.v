// Top level module for blastit. Enables all LEDs on the board.

module blastit_demo_all_leds
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

	reg [4:0] c_sel_reg, c_sel_next;
	wire clock;
	wire c_i, g_i; // Input wires for C and G
	
	// LED bar
	assign D = 10'b1111111111;
	assign G = 10'b0000000000;
	
	// 7 segment display
	
	always @(posedge clock)
		begin
			c_sel_reg <= c_sel_next;
		end
		
	always @*
		begin
			c_sel_next = c_sel_reg + 1'b1;
		end
		
	assign C_SSEG = 8'b00000000;
	assign C = 16'b1111111111111111;
	//assign C = 16'b0000000000000000;
//	assign C = 
//	{
//		(5'd15 == c_sel_reg) ? c_i : 1'dz,
//		(5'd14 == c_sel_reg) ? c_i : 1'dz,
//		(5'd13 == c_sel_reg) ? c_i : 1'dz,
//		(5'd12 == c_sel_reg) ? c_i : 1'dz,
//		(5'd11 == c_sel_reg) ? c_i : 1'dz,
//		(5'd10 == c_sel_reg) ? c_i : 1'dz,
//		(5'd9 == c_sel_reg) ? c_i : 1'dz,
//		(5'd8 == c_sel_reg) ? c_i : 1'dz,
//		(5'd7 == c_sel_reg) ? c_i : 1'dz,
//		(5'd6 == c_sel_reg) ? c_i : 1'dz,
//		(5'd5 == c_sel_reg) ? c_i : 1'dz,
//		(5'd4 == c_sel_reg) ? c_i : 1'dz,
//		(5'd3 == c_sel_reg) ? c_i : 1'dz,
//		(5'd2 == c_sel_reg) ? c_i : 1'dz,
//		(5'd1 == c_sel_reg) ? c_i : 1'dz,
//		(5'd0 == c_sel_reg) ? c_i : 1'dz,
//	};
	
	// Misc LEDS and warning LED
	assign LED = 4'b0000;
	assign WARN = 1'b1;
	
	assign clock = CLOCK_50;

endmodule