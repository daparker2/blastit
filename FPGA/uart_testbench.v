`timescale 1 ns / 10 ps

module uart_testbench;

localparam T = 20;
localparam DVSR = 163;
localparam N= 1000000;

reg clk, reset;
reg rd_uart1, wr_uart1, rx, rd_uart2, wr_uart2;
reg [7:0] w_data1, w_data2;
wire rxd;
wire tx_full1, rx_empty1, tx_full2, rx_empty2, tx;
wire [7:0] r_data1, r_data2;
wire tx_done_tick1, rx_done_tick1, tx_done_tick2, rx_done_tick2;
wire e_parity1, e_frame1, e_rxof1, e_txof1;
wire e_parity2, e_frame2, e_rxof2, e_txof2;

uart #(8, 1, 16, 163, 8, 2) uut(clk, reset, rd_uart1, wr_uart1, rx, w_data1, tx_full1, rx_empty1, tx, r_data1, tx_done_tick1, rx_done_tick1, e_parity1, e_frame1, e_rxof1, e_txof1),
                            uut2(clk, reset, rd_uart2, wr_uart2, tx, w_data2, tx_full2, rx_empty2, rxd, r_data2, tx_done_tick2, rx_done_tick2, e_parity2, e_frame2, e_rxof2, e_txof2);

task uart_w1;
	input reg [7:0] data;
	begin
		@(negedge clk);
		w_data1 = data;
		wr_uart1 = 1'b1;
		#(T);
		wr_uart1 = 1'b0;
	end
endtask

task uart_w2;
	input reg [7:0] data;
	begin
		@(negedge clk);
		w_data2 = data;
		wr_uart2 = 1'b1;
		#(T);
		wr_uart2 = 1'b0;
	end
endtask

task uart_r1;
	begin
		@(negedge clk);
		rd_uart1 = 1'b1;
		#(T);
		rd_uart1 = 1'b0;
	end
endtask
  
task uart_r2;
	begin
		@(negedge clk);
		rd_uart2 = 1'b1;
		#(T);
		rd_uart2 = 1'b0;
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
		
		uart_w1(8'hAE);
		#(N);
		uart_r2;
		
		uart_w2(8'hAE);
		#(N);
		uart_r1;
		
		$stop;
	end

assign rxd = rx;
	
endmodule