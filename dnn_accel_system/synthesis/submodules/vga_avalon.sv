module vga_avalon(input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] vga_red, output logic [7:0] vga_grn, output logic [7:0] vga_blu,
                  output logic VGA_HS, output logic vga_vsync, output logic vga_clk);

    
    // your Avalon slave implementation goes here

	 logic [9:0] VGA_R;
	 logic [9:0] VGA_G;
	 logic [9:0] VGA_B;
	 
	 assign vga_red = VGA_R[9:2];
	 assign vga_grn = VGA_G[9:2];
	 assign vga_blu = VGA_B[9:2];
	 
    vga_adapter #( .RESOLUTION("320x240"), .MONOCHROME("TRUE"), .BITS_PER_COLOUR_CHANNEL(8) )
	vga( 
		.resetn(reset_n),
		.clock(clk),
		.colour(writedata[7:0]),
		.x(writedata[23:16]),
		.y(writedata[30:24]),
		.plot(write),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(vga_vsync),
		.VGA_BLANK(1'b0),
		.VGA_SYNC(1'b0),
		.VGA_CLK(vga_clk)
	);

    // NOTE: We will ignore the VGA_SYNC and VGA_BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the upper 8 bits of the VGA module outputs.

endmodule: vga_avalon
