module stack
#(
	parameter B=8,
	          W=4
)
(
	input wire clk, reset, rd, wr,
	input wire [B-1:0] wr_data,
	output wire [B-1:0] rd_data,
	output wire of, uf
);
	reg [B-1:0] array_reg [2**W-1:0];
	reg [W-1:0] data_reg, data_next, data_succ, data_pred;
	reg of_reg, of_next, uf_reg, uf_next;
	wire wr_en;
	
	// register file write operation
	always @(posedge clk)
		if (wr)
			array_reg[data_reg] <= wr_data;
			
	assign rd_data = array_reg[data_reg];
	assign of = of_reg;
	assign uf = uf_reg;
	
	// stack control logic
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				data_reg <= 1'b0;
				of_reg <= 1'b0;
				uf_reg <= 1'b0;
			end
		else
			begin
				data_reg <= data_next;
				of_reg <= of_next;
				uf_reg <= uf_next;
			end
	
	always @*
	begin
		// successive pointer values
		data_succ = data_reg + 1'b1;
		data_pred = data_reg - 1'b1;
		
		// default: keep old values
		data_next = data_reg;
		of_next = of_reg;
		uf_next = uf_reg;
		
		if (wr)
			begin
				if (data_succ < data_next)
					of_next = 1'b1;
				data_next = data_succ;
				uf_next = 1'b0;
			end
		else if (rd)
			begin
				if (data_pred > data_next)
					uf_next = 1'b1;
				data_next = data_pred;
				of_next = 1'b0;
			end
	end
				
endmodule