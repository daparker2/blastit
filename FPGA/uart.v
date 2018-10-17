module uart
#(
	parameter FIFO_R = 2,     // # addr bits of read FIFO
	          FIFO_W = 2,     // # addr bits of write FIFO
			    DVSR_BIT = 8,   // # of bits for DVSR multiplier storage
             DBIT = 8        // # number of data bits storage
)
(
	input wire clk, reset,
	input wire rd_uart, wr_uart, rx,
	input wire [3:0] dbit,                  // Data bits (7 or 8)
	input wire [1:0] pbit,                  // 0=none, 1=even, 2 = odd
	input wire [7:0] sb_tick,               // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
	input wire [7:0] os_tick,               // overscan ticks ex 16 or 32. 32 is recommended
	input wire [DVSR_BIT-1:0] dvsr,         // Baud rate divisor, ex 50M/(16 * baud rate)
	input wire [DBIT-1:0] w_data,
	output wire tx_full, rx_empty, tx,
	output wire [DBIT-1:0] r_data,
	output wire tx_done_tick, rx_done_tick,
	output wire e_parity, e_frame, e_rxof, e_txof,
	output wire rx_full, tx_empty
);

// signal declaration
wire tick;
wire tx_fifo_not_empty;
wire [DBIT-1:0] tx_fifo_out, rx_data_out, fifo_r_data;
wire rd_uart_tick, wr_uart_tick;

// body
mod_m_counter #(.M_BITS(DVSR_BIT)) baud_gen_unit(.clk(clk), .reset(reset), .m(dvsr), .q(), .max_tick(tick)); 
edge_trigger uart_rx_trigger(.clk(clk), .reset(reset), .in(rd_uart), .en(1'b1), .tick(rd_uart_tick));
fifo #(.B(DBIT), .W(FIFO_R)) fifo_rx_unit(.clk(clk), .reset(reset), .rd(rd_uart_tick), .wr(rx_done_tick), .w_data(rx_data_out), .empty(rx_empty), .full(rx_full), .r_data(fifo_r_data), .of(e_rxof));
uart_rx #(.DBIT(DBIT)) uart_rx_unit(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .rx(rx), .s_tick(tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out), .e_parity(e_parity), .e_frame(e_frame));
edge_trigger uart_tx_trigger(.clk(clk), .reset(reset), .in(wr_uart), .en(1'b1), .tick(wr_uart_tick));
fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit(.clk(clk), .reset(reset), .rd(tx_done_tick), .wr(wr_uart_tick), .w_data(w_data), .empty(tx_empty), .full(tx_full), .r_data(tx_fifo_out), .of(e_txof));
uart_tx #(.DBIT(DBIT)) uart_tx_unit(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), .tx_done_tick(tx_done_tick), .tx(tx));

assign tx_fifo_not_empty = ~tx_empty;
assign r_data = fifo_r_data;

endmodule