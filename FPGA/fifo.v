module fifo
#(
	parameter B=8, // number of bits in a word
				 W=4  // number of address bits
)
(
	input wire clk, reset,
	input wire rd, wr,
	input wire [B-1:0] w_data,
	output wire empty, full,
	output wire [B-1:0] r_data
);

// signal declaration
reg [B-1:0] array_reg [(1'b1 << W)-1:0]; // register array
reg [W-1:0] w_ptr_reg, w_ptr_next, w_ptr_succ;
reg [W-1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;

// body
// register file write operation
always @(posedge clk)
	begin
		if (wr)
			array_reg[w_ptr_reg] <= w_data;
	end

// fifo control logic
// register for read and write pointers
always @(posedge clk, posedge reset)
	if (reset)
		begin
			w_ptr_reg <= 0;
			r_ptr_reg <= 0;
		end
	else
		begin
			w_ptr_reg <= w_ptr_next;
			r_ptr_reg <= r_ptr_next;
		end

// next-state logic for read and write pointers
always @*
	begin		
		w_ptr_succ = w_ptr_reg + 1'b1;
		r_ptr_succ = r_ptr_reg + 1'b1;
		r_ptr_next = r_ptr_reg;
		w_ptr_next = w_ptr_reg;
		
		if (rd && wr) // read and write
			begin
				r_ptr_next = r_ptr_succ;
				w_ptr_next = w_ptr_succ;
			end
		else if (rd) // read
			r_ptr_next = r_ptr_succ;
		else if (wr) // write
			w_ptr_next = w_ptr_succ;
	end
	
	// output
	assign full = w_ptr_reg == r_ptr_reg - 1;
	assign empty = w_ptr_reg == r_ptr_reg;
		
	// register file read operation
	assign r_data = array_reg[r_ptr_reg];
	
endmodule
