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

	localparam T = 20;

	wire reset;
	wire [8:0] disp_w;	                                         // Display brightness
	reg disp_en;                                                  // Display enable
	wire [11:0] boost_val, afr_val, oil_val, coolant_val;         // Vital statistics
	reg wrn, boost_wrn, afr_wrn;                                  // Warning indicators
	reg rd_uart, wr_uart;                                         // UART rd/write enable
	wire [7:0] w_data;
	wire [7:0] r_data;
	wire tx_full, rx_empty;
	wire e_parity, e_frame, e_rxof, e_txof;
	wire [9:0] boost_G, afr_G;
	
	// Front panel controller
	front_panel_controller #(.T(T), .BOOST_D_W(5), .BOOST_G_W(10), .AFR_D_W(5), .AFR_G_W(10))
	                   fpc (.clk(CLOCK_50), .reset(reset), .disp_w(disp_w), .disp_en(disp_en), 
							      .boost_val(boost_val[9:0]), .afr_val(afr_val[9:0]), .oil_val(oil_val[9:0]), .coolant_val(coolant_val[9:0]),
									.boost_sign(boost_val[11]), .wrn(wrn), .boost_wrn(boost_wrn), .afr_wrn(afr_wrn),
									.sseg(C_SSEG), .c(C), .boost_d(D[4:0]), .boost_g(boost_G), .afr_d(D[9:5]), .afr_g(afr_G), .warning(WARN));
									
									
	// UART
	uart #(.DBIT(8), .PARITY(0), .SB_TICK(16), .DVSR(163), .DVSR_BIT(8), .FIFO_W(3)) 
		  uart_unit(
			  .clk(CLOCK_50), .reset(reset), .rd_uart(rd_uart), .wr_uart(wr_uart), 
			  .rx(UART_RX), .w_data(w_data), .tx_full(tx_full), .rx_empty(rx_empty),
			  .tx(UART_TX), .r_data(r_data), .tx_done_tick(LED[0]), .rx_done_tick(LED[1]),
			  .e_parity(e_parity), .e_frame(e_frame), .e_rxof(e_rxof), .e_txof(e_txof)
		  );
		  
	wire [7:0] command_status;
	wire [2:0] warning_en;
	wire [1:0] command_en;
		  
   // Microcontroller
	controller mcu(.clk_clk(CLOCK_50), .command_tx_export(w_data), .command_rx_export(r_data), .command_status_export(command_status),
	               .disp_en_brightness_export(disp_w), .system_status_export(), .warning_en_export(warning_en), .command_en_export(command_en), 
						.boost_export(boost_val), .afr_export(afr_val), .oil_temp_export(oil_val), .coolant_temp_export(coolant_val),
						.intake_temp_export(), .ign_en_export());

	assign G = boost_G | afr_G;
	assign command_status = {e_parity, e_frame, e_rxof, e_txof, tx_full, rx_empty};
	assign warning_en = {wrn, boost_wrn, afr_wrn};
	assign command_en = {rd_uart, wr_uart};
	
	assign reset = 0;
									
endmodule