module sseg
(
	input wire[3:0] num,
	input wire dp, sign,
	output reg[7:0] hex
);

	always @*
	begin
		if (sign)
			hex[7:0] <= 8'b10111111;
		else
			case (num)
				4'h0: hex[7:0] <= {~dp, 7'b1000000};
				4'h1: hex[7:0] <= {~dp, 7'b1111001};
				4'h2: hex[7:0] <= {~dp, 7'b0100100};
				4'h3: hex[7:0] <= {~dp, 7'b0110000};
				4'h4: hex[7:0] <= {~dp, 7'b0011001};
				4'h5: hex[7:0] <= {~dp, 7'b0010010};
				4'h6: hex[7:0] <= {~dp, 7'b0000010};
				4'h7: hex[7:0] <= {~dp, 7'b1111000};
				4'h8: hex[7:0] <= {~dp, 7'b0000000};
				4'h9: hex[7:0] <= {~dp, 7'b0010000};
				4'ha: hex[7:0] <= {~dp, 7'b0001000};
				4'hb: hex[7:0] <= {~dp, 7'b0000011};
				4'hc: hex[7:0] <= {~dp, 7'b0100111};
				4'hd: hex[7:0] <= {~dp, 7'b0100001};
				4'he: hex[7:0] <= {~dp, 7'b0000110};
				4'hf: hex[7:0] <= {~dp, 7'b0001110};
				default: hex[7:0] <= {~dp, 7'b0101100};
			endcase
	end

endmodule