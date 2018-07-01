module uart_rx
#(
	parameter DBIT    = 8,
				 PARITY  = 0,  // 1=even, 2 = odd
	          SB_TICK = 16
)
(
	input wire clk, reset,
	input wire rx, s_tick,
	output reg rx_done_tick,
	output wire [7:0] dout,
	output wire e_parity, e_frame
);

localparam [2:0]
	idle 	 = 3'b00,
	start  = 3'b01,
	data   = 3'b10,
	parity = 3'b11,
	stop   = 3'b100;
	
reg [2:0] state_reg, state_next;
reg [3:0] s_reg, s_next;
reg [2:0] n_reg, n_next;
reg [7:0] b_reg, b_next;
reg e_parity_reg, e_parity_next;
reg e_frame_reg, e_frame_next;
reg tx_parity_reg, tx_parity_next;
wire rx_parity;

parity_calculator #(DBIT, PARITY) p1(b_reg, rx_parity);

// body
// FSMD state & data registers
always @(posedge clk, posedge reset)
	if (reset)
		begin
			state_reg <= idle;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
			e_parity_reg <= 0;
			e_frame_reg <= 0;
			tx_parity_reg <= 0;
		end
	else
		begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			e_parity_reg <= e_parity_next;
			e_frame_reg <= e_frame_next;
			tx_parity_reg <= tx_parity_next;
		end
		
// FSMD next-state logic
always @*
	begin
		state_next = state_reg;
		rx_done_tick = 1'b0;
		s_next = s_reg;
		n_next = n_reg;
		b_next = b_reg;
		e_parity_next = e_parity_reg;
		e_frame_next = e_frame_reg;
		tx_parity_next = tx_parity_reg;
		case (state_reg)
			idle:
				if (~rx)
					begin
						state_next = start;
						s_next = 0;
					end
			start:
				if (s_tick)
					if (s_reg == 7)
						begin
							state_next = data;
							s_next = 0;
							n_next = 0;
						end
					else
						s_next = s_reg + 1'd1;
			data:
				if (s_tick)
					if (s_reg == 15)
						begin
							s_next = 0;
							b_next = {rx, b_reg[7:1]};
							if (n_reg == (DBIT - 1))
								begin
									n_next = 0;
									if (PARITY > 0)
										state_next = parity;
									else
										state_next = stop;
								end
							else
								n_next = n_reg + 1'd1;
						end
				else
					s_next = s_reg + 1'd1;
			parity:
					if (s_tick)
						begin
							tx_parity_next = parity;
								if (s_reg == 15)
									begin
										s_next = 0;
										n_next = 0;
										state_next = stop;
									end
								else
									s_next = s_reg + 1'b1;
						end
			stop:
				if (s_tick)
					if (s_reg == (SB_TICK-1))
						begin
							state_next = idle;
							rx_done_tick = 1'b1;
							e_frame_next = ~rx;
							e_parity_next = ~rx_parity;
						end
					else
						s_next = s_reg + 1'd1;
		endcase
	end
	
	// output
	assign dout = b_reg;
	assign e_parity = e_parity_reg;
	assign e_frame = e_frame_reg;

endmodule