module uart_demo
(
	input wire clk, key_reset,
	input wire rx,
	output wire tx,
	output wire ntx_full, nrx_empty,
	output wire [6:0] rx2, rx1, tx2, tx1
);

// signal declaration
reg [7:0] tx_data_reg, tx_data_next;
reg tx_en_reg, tx_en_next;
reg reset_reg, reset_next;
wire [7:0] rx_data;
wire tx_full, rx_empty;
wire rx_done_tick, tx_done_tick;

// body
// instantinate uart
uart #(.DBIT(8), .PARITY(1), .SB_TICK(16), .DVSR(163), .DVSR_BIT(8), .FIFO_W(2)) 
	  uart_unit(
		  .clk(clk), .reset(reset_reg), .rd_uart(~rx_empty), .wr_uart(tx_en_reg), 
		  .rx(rx), .w_data(tx_data_reg), .tx_full(tx_full), .rx_empty(rx_empty),
		  .tx(tx), .r_data(rx_data), .tx_done_tick(tx_done_tick), .rx_done_tick(rx_done_tick)
	  );
sseg hex4(rx_data[7:4], rx2),
	  hex3(rx_data[3:0], rx1),
	  hex2(tx_data_reg[7:4], tx2),
	  hex1(tx_data_reg[3:0], tx1);
	  
always @(posedge clk)
	begin
		tx_data_reg <= tx_data_next;
		tx_en_reg <= tx_en_next;
		reset_reg <= reset_next;
	end
	  
always @*
	begin
		tx_data_next = tx_data_reg;
		tx_en_next = 1'b0;
		reset_next = ~key_reset;
		if (~rx_empty && ~tx_full)
			begin
				tx_data_next = rx_data;			
				tx_en_next = 1'b1;
			end
	end
	
assign ntx_full = ~tx_full;
assign nrx_empty = ~rx_empty;

endmodule