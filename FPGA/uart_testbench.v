`timescale 1 ns / 10 ps

module uart_testbench;

localparam T = 20;

reg clk, reset;
reg rd_uart1, wr_uart1, rx, rd_uart2, wr_uart2;
reg [3:0] dbit;            // Data bits (7 or 8)
reg [1:0] pbit;            // 0=none, 1=even, 2 = odd
reg [7:0] sb_tick;         // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
reg [7:0] os_tick;         // overscan ticks ex 16 or 32. 32 is recommended
reg [7:0] dvsr;            // Baud rate divisor, ex 50M/(16 * baud rate)
reg [7:0] w_data1, w_data2;
wire rxd, txd;
wire tx_full1, rx_empty1, tx_full2, rx_empty2, tx;
wire [7:0] r_data1, r_data2;
wire tx_done_tick1, rx_done_tick1, tx_done_tick2, rx_done_tick2;
wire e_parity1, e_frame1, e_rxof1, e_txof1;
wire e_parity2, e_frame2, e_rxof2, e_txof2;
wire rx_ready1, tx_ready1;
wire rx_ready2, tx_ready2;

uart #(.FIFO_R(2), .FIFO_W(2), .DVSR_BIT(8), .DBIT(8)) uut(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .dvsr(dvsr), .rd_uart(rd_uart1), .wr_uart(wr_uart1), .rx(rx), .w_data(w_data1), .tx_full(tx_full1), .rx_empty(rx_empty1), .tx(tx), .r_data(r_data1), .tx_done_tick(tx_done_tick1), .rx_done_tick(rx_done_tick1), .e_parity(e_parity1), .e_frame(e_frame1), .e_rxof(e_rxof1), .e_txof(e_txof1), .rx_ready(rx_ready1), .tx_ready(tx_ready1)),
                                                       uut2(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .dvsr(dvsr), .rd_uart(rd_uart2), .wr_uart(wr_uart2), .rx(rxd), .w_data(w_data2), .tx_full(tx_full2), .rx_empty(rx_empty2), .tx(txd), .r_data(r_data2), .tx_done_tick(tx_done_tick2), .rx_done_tick(rx_done_tick2), .e_parity(e_parity2), .e_frame(e_frame2), .e_rxof(e_rxof2), .e_txof(e_txof2), .rx_ready(rx_ready2), .tx_ready(tx_ready2));

task uart_w1;
	input reg [7:0] data;
	begin
		w_data1 = data;
		wr_uart1 = 1'b1;
		#(T);
		wr_uart1 = 1'b0;
		while (!tx_done_tick1)
			#(T / 2);
	end
endtask

task uart_w2;
	input reg [7:0] data;
	begin
		w_data2 = data;
		wr_uart2 = 1'b1;
		#(T);
		wr_uart2 = 1'b0;
		while (!tx_done_tick2)
			#(T / 2);
	end
endtask

task uart_r1;
	begin
		rd_uart1 = 1'b1;
		#(T);
		rd_uart1 = 1'b0;
		#(T);
	end
endtask
  
task uart_r2;
	begin
		rd_uart2 = 1'b1;
		#(T);
		rd_uart2 = 1'b0;
		#(T);
	end
endtask
	  
task uart_test;
	input reg [3:0] t_dbit;
	input reg [1:0] t_pbit;
	input reg [7:0] t_sb_tick;
	input reg [7:0] t_os_tick;
	input reg [7:0] t_dvsr;
	begin
		dbit = t_dbit;
		pbit = t_pbit;
		sb_tick = t_sb_tick;
		os_tick = t_os_tick;
		dvsr = t_dvsr;
		$display("dbit=%d pbid=%d sb_tick=%d os_tick=%d dvsr=%d", dbit, pbit, sb_tick, os_tick, dvsr);
		#(T);		
		uart_w1(8'hAE);
		uart_r2;		
		uart_w2(8'hAE);
		uart_r1;
		
		uart_w1(8'hEA);
		uart_r2;		
		uart_w2(8'hEA);
		uart_r1;	
		
		
	end
endtask
	  
// set up the clock
always
	begin
		clk = 1'b1;
		#(T / 2);
		clk = 1'b0;
		#(T / 2);
	end
	
// reset the UUT
initial
	begin
		@(negedge clk);
		reset = 1'b1;
		wr_uart1 = 1'b0;
		wr_uart2 = 1'b0;
		rd_uart1 = 1'b0;
		rd_uart2 = 1'b0;
		#(T / 2);
		reset = 1'b0;
	end

initial
	begin
		@(negedge reset);
		@(negedge clk);

		uart_test(8, 0, 32, 32, 13);
		uart_test(8, 1, 32, 32, 13);
		uart_test(8, 2, 32, 32, 13);
		
		uart_test(8, 0, 24, 16, 162);
		uart_test(8, 1, 24, 16, 162);
		uart_test(8, 2, 24, 16, 162);
		
		uart_test(7, 0, 32, 32, 13);
		uart_test(7, 1, 32, 32, 13);
		uart_test(7, 2, 32, 32, 13);
		
		uart_test(7, 0, 32, 16, 162);
		uart_test(7, 1, 32, 16, 162);
		uart_test(7, 2, 32, 16, 162);
		
		$stop;
	end

assign rxd = tx;
assign txd = rx;
	
endmodule