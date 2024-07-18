module rounder(
	input [63:0] in,
	output logic [31:0] round_32_bit
);
	
	 logic [63:0] rounded;
    logic [47:0] integer_part;
    logic [15:0] fractional_part;
    logic round_up;
	 
	 assign integer_part = in[63:16];
	 assign fractional_part = in[15:0];
	
	 assign round_up = (fractional_part >= 16'h8000); 
	 
	 assign rounded = {integer_part, 16'b0} + (round_up ? 64'h1_0000_0000_0000 : 64'b0);
	 
	 assign round_32_bit = rounded[47:16]; 
	 
endmodule
