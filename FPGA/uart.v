module uart
#(
	// default setting:
	// 19200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
	parameter DBIT = 8,		 // 8 data bits
				 PARITY = 0,    // 1=even, 2 = odd
				 SB_TICK = 16,	 // # ticks for stop bits
									 // 16/24/32 for 1/1.5/2 bits
				 DVSR = 163,	 // baud rate divisor
									 // DVSR = 50M(16 * baud rate)
				 DVSR_BIT = 8,	 // 8 bits of DVSR
				 FIFO_W = 2     // # addr bits of FIFO
									 // # words on FIFO=2^FIFO_W
)
(
	input wire clk, reset,
	input wire rd_uart, wr_uart, rx,
	input wire [7:0] w_data,
	output wire tx_full, rx_empty, tx,
	output wire [7:0] r_data,
	output wire tx_done_tick, rx_done_tick,
	output wire e_parity, e_frame, e_rxof, e_txof
);

// signal declaration
wire tick;
wire tx_empty, tx_fifo_not_empty, rx_full;
wire [7:0] tx_fifo_out, rx_data_out;
reg e_rxof_reg, e_rxof_next;
reg e_txof_reg, e_txof_next;

always @(posedge clk, posedge reset)
	begin
		if (reset)
			begin
				e_rxof_reg <= 0;
				e_txof_reg <= 0;
			end
		else
			begin
				e_rxof_reg = e_rxof_next;
				e_txof_reg = e_txof_next;
			end
	end
	
always @*
	begin
		e_rxof_next = e_rxof_reg;
		e_txof_next = e_txof_reg;
		if (!e_rxof_reg && rx_full && rd_uart)
			e_rxof_next = 1'b1;
		if (!e_txof_reg && tx_full && wr_uart)
			e_rxof_next = 1'b1;
	end

// body
mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit(.clk(clk), .reset(reset), .q(), .max_tick(tick)); 
uart_rx #(.DBIT(DBIT), .PARITY(PARITY), .SB_TICK(SB_TICK)) uart_rx_unit(.clk(clk), .reset(reset), .rx(rx), .s_tick(tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out), .e_parity(e_parity), .e_frame(e_frame));
fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit(.clk(clk), .reset(reset), .rd(rd_uart), .wr(rx_done_tick), .w_data(rx_data_out), .empty(rx_empty), .full(rx_full), .r_data(r_data));
fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit(.clk(clk), .reset(reset), .rd(tx_done_tick), .wr(wr_uart), .w_data(w_data), .empty(tx_empty), .full(tx_full), .r_data(tx_fifo_out));
uart_tx #(.DBIT(DBIT), .PARITY(PARITY), .SB_TICK(SB_TICK)) uart_tx_unit(.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), .tx_done_tick(tx_done_tick), .tx(tx));

assign tx_fifo_not_empty = ~tx_empty;
assign e_rxof = e_rxof_reg;
assign e_txof = e_txof_reg;

endmodule