module uart
#(
	parameter FIFO_R = 2,    // # addr bits of read FIFO
	          FIFO_W = 2,    // # addr bits of write FIFO
			    DVSR_BIT = 8,  // # of bits for DVSR multiplier storage
             DBIT = 8       // # number of data bits storage
)
(
	input wire clk, reset,
	input wire rd_uart, wr_uart, rx,
	input wire [3:0] dbit,            // Data bits (7 or 8)
	input wire [1:0] pbit,            // 0=none, 1=even, 2 = odd
	input wire [7:0] sb_tick,         // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
	input wire [7:0] os_tick,         // overscan ticks ex 16 or 32. 32 is recommended
	input wire [DVSR_BIT-1:0] dvsr,   // Baud rate divisor, ex 50M/(16 * baud rate)
	input wire [DBIT-1:0] w_data,
	output wire tx_full, rx_empty, tx,
	output wire [DBIT-1:0] r_data,
	output wire tx_done_tick, rx_done_tick,
	output wire e_parity, e_frame, e_rxof, e_txof
);

// signal declaration
wire tick;
wire tx_empty, tx_fifo_not_empty, rx_full;
reg [3:0] dbit_reg;
reg [1:0] pbit_reg;
reg [7:0] sb_tick_reg;
reg [7:0] os_tick_reg;
reg [DVSR_BIT-1:0] dvsr_reg;
wire [DBIT-1:0] tx_fifo_out, rx_data_out;
reg e_rxof_reg, e_rxof_next;
reg e_txof_reg, e_txof_next;

always @(posedge clk, posedge reset)
	begin
		if (reset)
			begin
				e_rxof_reg <= 0;
				e_txof_reg <= 0;
				dbit_reg <= 0;
				pbit_reg <= 0;
				sb_tick_reg <= 0;
				os_tick_reg <= 0;
				dvsr_reg <= 0;
			end
		else
			begin
				e_rxof_reg = e_rxof_next;
				e_txof_reg = e_txof_next;
				dbit_reg <= dbit;
				pbit_reg <= pbit;
				sb_tick_reg <= sb_tick;
				os_tick_reg <= os_tick;
				dvsr_reg <= dvsr;
			end
	end
	
always @*
	begin
		e_rxof_next = e_rxof_reg;
		e_txof_next = e_txof_reg;
		if (!e_rxof_reg && rx_full && ~rd_uart)
			e_rxof_next = 1'b1;
		if (!e_txof_reg && tx_full && wr_uart)
			e_txof_next = 1'b1;
	end
	
// body
mod_m_counter #(.M_BITS(DVSR_BIT)) baud_gen_unit(.clk(clk), .reset(reset), .m(dvsr_reg), .q(), .max_tick(tick)); 
uart_rx #(.DBIT(DBIT)) uart_rx_unit(.clk(clk), .reset(reset), .dbit(dbit_reg), .pbit(pbit_reg), .sb_tick(sb_tick_reg), .os_tick(os_tick_reg), .rx(rx), .s_tick(tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out), .e_parity(e_parity), .e_frame(e_frame));
fifo #(.B(DBIT), .W(FIFO_R)) fifo_rx_unit(.clk(clk), .reset(reset), .rd(rd_uart), .wr(rx_done_tick), .w_data(rx_data_out), .empty(rx_empty), .full(rx_full), .r_data(r_data));
fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit(.clk(clk), .reset(reset), .rd(tx_done_tick), .wr(wr_uart), .w_data(w_data), .empty(tx_empty), .full(tx_full), .r_data(tx_fifo_out));
uart_tx #(.DBIT(DBIT)) uart_tx_unit(.clk(clk), .reset(reset), .dbit(dbit_reg), .pbit(pbit_reg), .sb_tick(sb_tick_reg), .os_tick(os_tick_reg), .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), .tx_done_tick(tx_done_tick), .tx(tx));

assign tx_fifo_not_empty = ~tx_empty;
assign e_rxof = e_rxof_reg;
assign e_txof = e_txof_reg;

endmodule