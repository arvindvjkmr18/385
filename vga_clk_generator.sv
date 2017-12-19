module vga_clk_generator(

	// Input signals:
	input logic		CLOCK_50,	// 50 MHz master data clock
	input logic		RESET,		// Manual reset signal
	
	// Output signals:
	output logic	VGA_CLK		// 25 MHz video clock

);

	// Internal wires:
	logic vga_clk_cycle;
	
	//initial vga_clk_cycle = 1'b0;
	
	assign VGA_CLK = vga_clk_cycle;

	 always_ff @ (posedge CLOCK_50) 
	 begin
	 
			if(RESET)
			begin
            vga_clk_cycle <= 1'b0;
			end
			else
			begin
            vga_clk_cycle <= ~vga_clk_cycle;
			end
				
	 end

endmodule