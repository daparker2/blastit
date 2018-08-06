module mod_m_counter
#(
	parameter M_BITS=8 // number of bits in counter and clock output
)
(
	input wire clk, reset,
	input wire [M_BITS-1:0] m,  // mod-M
	output wire max_tick,
	output wire [M_BITS-1:0] q
);

// signal declaration
reg [M_BITS-1:0] r_reg, r_next;
reg max_tick_reg, max_tick_next;

// body
// register
always @(posedge clk, posedge reset)
	if (reset)
		begin
			r_reg <= 0;
			max_tick_reg <= 0;
		end
	else
		begin
			r_reg <= r_next;
			max_tick_reg <= max_tick_next;
		end
		
always @*
	begin
		max_tick_next = max_tick_reg;
		begin
			r_next = r_reg;
			if (r_next == m)
				begin
					max_tick_next = 1'b1;
					r_next = 0;
				end
			else
				begin
					r_next = r_next + 1;
					max_tick_next = 0;
				end
		end
		
	end

// output logic 
assign q = r_reg;
assign max_tick = max_tick_reg;

endmodule