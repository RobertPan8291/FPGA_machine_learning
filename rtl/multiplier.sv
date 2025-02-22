module multiplier(
	input [31:0] a,
	input [31:0] b,
	output logic [31:0] result
);
	logic [63:0] result_64;
   logic [63:0] product;
   logic [63:0] a_extended, b_extended;

   always_comb begin
        // Treat inputs as signed by sign-extending to 64 bits
       a_extended = {{32{a[31]}}, a};
       b_extended = {{32{b[31]}}, b};
        
        // Multiply sign-extended values
       product = a_extended * b_extended;
        
        // Shift the result to align the fractional part correctly
       result_64[47:0] = product[63:16];
		 result_64 [63:48] = {16{product[63]}};
		 result = result_64 [31:0];
    end

endmodule
