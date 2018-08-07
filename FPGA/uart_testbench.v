`timescale 1 ns / 10 ps

module uart_testbench;

localparam T = 20;

integer i, j;
integer i_clk, i_sync;
reg clk, reset;
wire tx, rx;
reg rd_uart1, wr_uart1, rd_uart2, wr_uart2;
reg [3:0] dbit;            // Data bits (7 or 8)
reg [1:0] pbit;            // 0=none, 1=even, 2 = odd
reg [7:0] sb_tick;         // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
reg [7:0] os_tick;         // overscan ticks ex 16 or 32. 32 is recommended
reg [7:0] dvsr;            // Baud rate divisor, ex 50M/(16 * baud rate)
reg [7:0] w_data1, w_data2;
reg [7:0] actual1, actual2;
wire tx_full1, rx_empty1, tx_full2, rx_empty2;
wire [7:0] r_data1, r_data2;
wire tx_done_tick1, rx_done_tick1, tx_done_tick2, rx_done_tick2;
wire e_parity1, e_frame1, e_rxof1, e_txof1;
wire e_parity2, e_frame2, e_rxof2, e_txof2;
wire rx_ready1, tx_ready1;
wire rx_ready2, tx_ready2;

uart #(.FIFO_R(8), .FIFO_W(8), .DVSR_BIT(8), .DBIT(8)) uut(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .dvsr(dvsr), .rd_uart(rd_uart1), .wr_uart(wr_uart1), .rx(), .w_data(w_data1), .tx_full(tx_full1), .rx_empty(rx_empty1), .tx(tx), .r_data(r_data1), .tx_done_tick(tx_done_tick1), .rx_done_tick(rx_done_tick1), .e_parity(e_parity1), .e_frame(e_frame1), .e_rxof(e_rxof1), .e_txof(e_txof1), .rx_ready(rx_ready1), .tx_ready(tx_ready1)),
                                                       uut2(.clk(clk), .reset(reset), .dbit(dbit), .pbit(pbit), .sb_tick(sb_tick), .os_tick(os_tick), .dvsr(dvsr), .rd_uart(rd_uart2), .wr_uart(wr_uart2), .rx(tx), .w_data(w_data2), .tx_full(tx_full2), .rx_empty(rx_empty2), .tx(), .r_data(r_data2), .tx_done_tick(tx_done_tick2), .rx_done_tick(rx_done_tick2), .e_parity(e_parity2), .e_frame(e_frame2), .e_rxof(e_rxof2), .e_txof(e_txof2), .rx_ready(rx_ready2), .tx_ready(tx_ready2));


task uart_init;		
	input reg [3:0] t_dbit;
	input reg [1:0] t_pbit;
	input reg [7:0] t_sb_tick;
	input reg [7:0] t_os_tick;
	input reg [7:0] t_dvsr;
	begin
		reset = 1;
		dbit = t_dbit;
		pbit = t_pbit;
		sb_tick = t_sb_tick;
		os_tick = t_os_tick;
		dvsr = t_dvsr;
		// Assert reset high for at least 2 full cycles
		#(2 * T * (dvsr * os_tick * (dbit + pbit) + dvsr * sb_tick));
		reset = 0;
		#(T);	
	end
endtask

task uart_w1;
	input reg [7:0] data;
	begin
		while (!tx_ready1)
			#(i_clk);
		w_data1 = data;
		wr_uart1 = 1'b1;
		#(i_clk);
		wr_uart1 = 1'b0;
		#(i_clk);
	end
endtask

task uart_w2;
	input reg [7:0] data;
	begin
		while (!tx_ready2)
			#(i_clk);
		w_data2 = data;
		wr_uart2 = 1'b1;
		#(i_clk);
		wr_uart2 = 1'b0;
		#(i_clk);
	end
endtask

task uart_r1;
	begin
		while (!rx_ready1)
			#(i_clk);
		rd_uart1 = 1'b1;
		#(i_clk);
		rd_uart1 = 1'b0;
		#(i_clk);
		actual1 = r_data1;
	end
endtask
  
task uart_r2;
	begin
		while (!rx_ready2)
			#(i_clk);
		rd_uart2 = 1'b1;
		#(i_clk);
		rd_uart2 = 1'b0;
		#(i_clk);
		actual2 = r_data2;
	end
endtask

task compare;
	input reg [7:0] uart_module, expected, actual;
	integer i_expected;
	begin
		i_expected = (dbit == 4'd7) ? (expected & 8'b01111111) : expected;
		if (i_expected != actual)
			$display("uart_test: module %d compare failure: %x != %x", uart_module, i_expected, actual);
	end
endtask
	  
task uart_test;
	input reg [3:0] t_dbit;
	input reg [1:0] t_pbit;
	input reg [7:0] t_sb_tick;
	input reg [7:0] t_os_tick;
	input reg [7:0] t_dvsr;
	input integer max;
	input integer clocks;
	input integer sync;
	begin	
		i_clk = clocks;
		uart_init(t_dbit, t_pbit, t_sb_tick, t_os_tick, t_dvsr);
		$display("uart_test: dbit=%d pbit=%d sb_tick=%d os_tick=%d dvsr=%d max=%d clocks=%d sync=%d", dbit, pbit, sb_tick, os_tick, dvsr, max, clocks, sync);
		for (j = 1; j <= max; j = j + 1)
			begin:wr
				uart_w1(j);
				//uart_w2(i);
			end
			
		#(sync);
			
		for (j = 1; j <= max; j = j + 1)
			begin:rd
				uart_r2;	
				compare(2, j, actual2);
				//uart_r1;
				//compare(1, i, actual1);
			end
			
		for (j = 1; j <= max; j = j + 1)
			begin:wr2
				uart_w1(j);
				//uart_w2(i);
			end
			
		#(sync);
			
		for (j = 1; j <= max; j = j + 1)
			begin:rd2
				uart_r2;	
				compare(2, j, actual2);
				//uart_r1;
				//compare(1, i, actual1);
			end
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

		for (i = 1; i <= 150; i = i + 100)
			begin
				uart_test(8, 0, 72, 72, 6, i, T, 10);
				uart_test(8, 1, 72, 72, 6, i, T * 2, 10);
				uart_test(8, 2, 72, 72, 6, i, T * 3, 10);
				
				uart_test(8, 0, 24, 16, 162, i, T, 11);
				uart_test(8, 1, 24, 16, 162, i, T * 2, 11);
				uart_test(8, 2, 24, 16, 162, i, T * 3, 11);
				
				uart_test(7, 0, 48, 48, 9, i, T, 12);
				uart_test(7, 1, 48, 48, 9, i, T * 2, 12);
				uart_test(7, 2, 48, 48, 9, i, T * 3, 12);
				
				uart_test(7, 0, 32, 16, 162, i, T, 13);
				uart_test(7, 1, 32, 16, 162, i, T * 2, 13);
				uart_test(7, 2, 32, 16, 162, i, T * 3, 13);
			end
		
		$stop;
	end
	
endmodule