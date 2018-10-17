module uart_rx
#(
	parameter DBIT=8 // # of data bits in storage
)
(
	input wire clk, reset,
	input wire [3:0] dbit,            // Data bits (7 or 8)
	input wire [1:0] pbit,            // 0=none, 1=even, 2 = odd
	input wire [7:0] sb_tick,         // stop bit ticks, where the bit width is 1*os_ticks, 1.5*os_ticks, 2*os_ticks
	input wire [7:0] os_tick,         // overscan ticks ex 16 or 32. 32 is recommended
	input wire rx, s_tick,
	output reg rx_done_tick,
	output wire [DBIT-1:0] dout,
	output wire e_parity, e_frame
);

localparam [2:0]
	idle 	 = 3'b000,
	start  = 3'b001,
	data   = 3'b010,
	parity = 3'b011,
	stop   = 3'b101;
	
reg [2:0] state_reg, state_next;
reg [7:0] s_reg, s_next;
reg [2:0] n_reg, n_next;
reg [DBIT-1:0] b_reg, b_next;
reg e_parity_reg, e_parity_next;
reg e_frame_reg, e_frame_next;
wire rx_parity;

parity_calculator #(.DBIT(DBIT)) pc(.data(b_reg), .dbit(dbit), .pbit(pbit), .parity(rx_parity));

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
		end
	else
		begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			e_parity_reg <= e_parity_next;
			e_frame_reg <= e_frame_next;
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
		case (state_reg)
			idle:
				if (~rx)
					begin
						state_next = start;
						s_next = 0;
					end
			start:
				if (s_tick)
					if (s_reg == ((os_tick - 1) >> 1))
						begin
							state_next = data;
							e_parity_next = 0;
							e_frame_next = 0;
							s_next = 0;
							n_next = 0;
						end
					else
						s_next = s_reg + 1'd1;
			data:
				if (s_tick)
					if (s_reg == (os_tick - 1))
						begin
							s_next = 0;
							b_next = {rx, b_reg[7:1]};
							if (n_reg == (dbit - 1))
								begin
									n_next = 0;
									if (pbit > 0)
										state_next = parity;
									else
										begin
											state_next = stop;
											e_parity_next = 0;
										end
								end
							else
								n_next = n_reg + 1'd1;
						end
					else
						s_next = s_reg + 1'd1;
			parity:
					if (s_tick)
						begin
							if (s_reg == (os_tick - 1))
								begin
									e_parity_next = rx_parity != rx;
									s_next = 0;
									n_next = 0;
									state_next = stop;
								end
							else
								s_next = s_reg + 1'b1;
						end
			stop:
				if (s_tick)
					if (s_reg == (sb_tick - 1))
						begin
							e_frame_next = ~rx;
							s_next = 0;
							n_next = 0;
							state_next = idle;
							rx_done_tick = 1'b1;
						end
					else
						s_next = s_reg + 1'd1;
		endcase
	end
	
	// output
	assign dout = (dbit == 4'd7) ? (b_reg >> 1) :
	              (dbit == 4'd8) ? b_reg :
					  0;
	assign e_parity = e_parity_reg;
	assign e_frame = e_frame_reg;

endmodule