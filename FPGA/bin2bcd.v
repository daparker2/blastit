// N bit precision signed binary to BCD converter with decimal point
module bin2bcd
#(
	parameter BCD_N=4,  // Number of BCD modules
	          BIN_N=14  // Bit precision of decimal number
)
(
	input wire clk, reset,
	input wire start, sign,      // Sign is 1 for negative, 0 for positive
	input wire [BIN_N-1:0] bin,
	output reg ready, done_tick,
	output wire [(BCD_N*4)-1:0] bcd
);

localparam [1:0]
	idle = 2'b00,
	op   = 2'b01,
	done = 2'b10;
	
integer i;
reg [1:0] state_reg, state_next;
reg [BCD_N*3:0] p2s_reg, p2s_next;
reg [BCD_N-1:0] n_reg, n_next;
reg [3:0] bcd_reg [BCD_N-1:0];
reg [3:0] bcd_next [BCD_N-1:0];
wire [3:0] bcd_tmp [BCD_N-1:0];

// body
// FSMD state & data registers
always @(posedge clk, posedge reset)
	if (reset)
		begin
			state_reg = idle;
			p2s_reg = 0;
			n_reg = 0;
			for (i = 0; i <= BCD_N-1; i = i + 1)
				bcd_reg[i] = 0;
		end
	else
		begin
			state_reg = state_next;
			p2s_reg = p2s_next;
			n_reg = n_next;
			for (i = 0; i <= BCD_N-1; i = i + 1)
				bcd_reg[i] = bcd_next[i];
		end

// FSMD next-state logic
always @*
	begin
		state_next = state_reg;
		ready = 1'b0;
		done_tick = 1'b0;
		p2s_next = p2s_reg;
		for (i = 0; i <= BCD_N-1; i = i + 1)
			bcd_next[i] = bcd_reg[i];
		n_next = n_reg;
		case (state_reg)
			idle:
				begin
					ready = 1'b1;
					if (start)
						begin
							state_next = op;
							for (i = 0; i <= BCD_N-1; i = i + 1)
								bcd_next[i] = 0;
							n_next = (BCD_N * 3) + 1; // index
							if (sign)
								p2s_next = ~bin + 1;
							else
								p2s_next = bin;   // shift register
							state_next = op;
						end
				end
			op:
				begin
					// shift in binary bit
					p2s_next = p2s_reg << 1;
					// shift 4 BCD digits
					// {bcd3_next, bcd2_next, bcd1_next, bcd0_next}
					// {bcd3_tmp[2:0], bcd2_temp, bcd1_tmp, bcd0_tmp}
					// p2s_reg[12]
					
					for (i = 0; i <= BCD_N-1; i = i + 1)
						begin
							if (i == 0)
								bcd_next[0] = {bcd_tmp[0][2:0], p2s_reg[BCD_N * 3]};
							else
								bcd_next[i] = {bcd_tmp[i][2:0], bcd_tmp[i-1][3]};
						end
					
					n_next = n_reg - 1'b1;
					if (n_next == 0)
						state_next = done;
				end
			done:
				begin
					done_tick = 1'b1;
					state_next = idle;
				end
			default:
				state_next = idle;
		endcase
	end
	
// data path
genvar g;
generate
	for (g = 0; g <= BCD_N-1; g = g + 1)
	begin : dataoutput
		assign bcd_tmp[g] = (bcd_reg[g] > 4'd4) ? bcd_reg[g] + 4'd3 : bcd_reg[g];
		assign bcd[(4 * g) + 3:(4 * g)] = bcd_reg[g];
	end
endgenerate
	
endmodule