module uart_tx
#(
	parameter DBIT=8 // # of data bits in storage
)
(
	input wire clk, reset,
	input wire [3:0] dbit,            // Data bits (7 or 8)
	input wire [1:0] pbit,            // 0=none, 1=even, 2 = odd
	input wire [7:0] sb_tick,         // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
	input wire [7:0] os_tick,         // overscan ticks ex 16 or 32. 32 is recommended
	input wire tx_start, s_tick,
	input wire [DBIT-1:0] din,
	output reg tx_done_tick,
	output wire tx,
	output wire [2:0] tx_status
);

localparam [2:0]
	idle 	 = 3'b000,
	start  = 3'b001,
	data   = 3'b010,
	parity = 3'b011,
	stop   = 3'b100;
	
reg [2:0] state_reg, state_next;
reg [7:0] s_reg, s_next;
reg [2:0] n_reg, n_next;
reg [DBIT-1:0] b_reg, b_next;
reg tx_reg, tx_next;
wire tx_parity;

parity_calculator #(.DBIT(DBIT))  pc(.data(din), .dbit(dbit), .pbit(pbit), .parity(tx_parity));

// body
// FSMD state & data registers
always @(posedge clk, posedge reset)
	if (reset)
		begin
			state_reg <= idle;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
			tx_reg <= 1'b1;
		end
	else
		begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			tx_reg <= tx_next;
		end

always @*
	begin
		state_next = state_reg;
		tx_done_tick = 1'b0;
		s_next = s_reg;
		n_next = n_reg;
		b_next = b_reg;
		tx_next = tx_reg;
		case (state_reg)
			idle:
				begin
					tx_next = 1'b1;
					if (tx_start)
						begin
							state_next = start;
							s_next = 0;
							b_next = din;
						end
				end
			start:
				begin
					tx_next = 1'b0;
					if (s_tick)
						if (s_reg == (os_tick - 1))
							begin
								state_next = data;
								s_next = 0;
								n_next = 0;
							end
						else
							s_next = s_reg + 1'b1;
				end
			data:
				begin
					tx_next = b_reg[n_reg];
					if (s_tick)
						if (s_reg == (os_tick - 1))
							begin
								s_next = 0;
								if (n_reg == (dbit - 1))
									begin
										n_next = 0;
										if (pbit > 0)
											state_next = parity;
										else
											state_next = stop;
									end
								else
									n_next = n_reg + 1'd1;
							end
						else
							s_next = s_reg + 1'b1;
				end
			parity:
				begin
					tx_next = tx_parity;
					if (s_tick)
						if (s_reg == (os_tick - 1))
							begin
								s_next = 0;
								n_next = 0;
								state_next = stop;
							end
						else
							s_next = s_reg + 1'b1;
				end
			stop:
				begin
					tx_next = 1'b1;
					if (s_tick)
						if (s_reg == (sb_tick - 1))
							begin
								state_next = idle;
								tx_done_tick = 1'b1;
							end
						else
							s_next = s_reg + 1'b1;
				end
		endcase
	end

// output
assign tx = tx_reg;
assign tx_status = state_reg;
		
endmodule