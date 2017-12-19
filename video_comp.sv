module video_comp(

	// Input timing signals
	input logic				CLOCK_50,		// 50 MHz Master (Data) Clock
	
	// Input control signals
	input logic				RESET,			// System reset
	
	// Input data signals:
	input logic [7:0]		PIXEL_DIN,		// Input pixel from sprite engines
	input logic [8:0]		PIXEL_X,			// Range: 0 to 319
	input logic [8:0]		PIXEL_Y,			// Range: 0 to 239
	input logic				WE,				// Write-Enable command from sprite engines
	
	// Output (to DAC via Pin-Planner:
	output logic			VGA_CLK,			// 25 MHz VGA (Video) Clock
	output logic			VGA_SYNC_N,
	output logic			VGA_BLANK_N,
	output logic 			VGA_HS,
	output logic			VGA_VS,
	output logic [7:0]	VGA_R,
	output logic [7:0]	VGA_G,
	output logic [7:0]	VGA_B,
	output logic 			PAGE_SEL

);

	// Internal wires:
	logic reset_h;
	logic page_select;
	logic [9:0] x_out, y_out;
	logic [7:0] p_out;
	logic [8:0] x_read, y_read;
	
	assign x_in = PIXEL_X;
	assign y_in = PIXEL_Y;
	assign PAGE_SEL = page_select;
	
	// Invert RESET from active-low to active-high
	always_ff @ (posedge CLOCK_50)
	begin
		reset_h <= ~RESET;
	end

	// 25 MHz VGA Clock Source
	// (Posedge rises w/ CLOCK_50 posedge)
	vga_clk_generator VGA_CLOCK_25(
		.CLOCK_50,
		.RESET(reset_h),
		.VGA_CLK	
	);

	// VGA Controller
	// (Provides timing signals per VGA spec)
	VGA_controller VGA_VIDEO(
		.Clk(CLOCK_50),
		.Reset(reset_h),
		.VGA_VS,
		.VGA_HS,
		.VGA_CLK,
		.VGA_BLANK_N,
		.VGA_SYNC_N,
		.DrawX(x_out),
		.DrawY(y_out)
	);
	
	// Palette LUT
	// (Converts 8' pixel to three 8' VGA color channels)
	palette_LUT color_mapper(
		.PIXEL_IN(p_out),
		.VGA_R,
		.VGA_G,
		.VGA_B
	);
	
	// Page Controller
	// (Controls alternating pages. Set to effect a 30 FPS)
	page_controller page_flipper(
		.VGA_CLK,
		.RESET(reset_h),
		.DrawX(x_out),
		.DrawY(y_out),
		.PAGE_SEL(page_select)
	);
	
	// Upscaler
	// (Converts ref coords from 640x480 to 320x240 space)
	upscaler coord_mapper(
		.X_IN(x_out),
		.Y_IN(y_out),
		.X_OUT(x_read),
		.Y_OUT(y_read)
	);
	
	// Frame Buffer
	// (Dual buffer: while one page reads, the other is written to)
	frame_buffer video_buf(
		.CLOCK_50,
		.VGA_CLK,
		.WE,
		.PIXEL_DIN,
		.PIXEL_X,
		.PIXEL_Y,
		.PAGE_SEL(page_select),
		.DOUT_X(x_read),
		.DOUT_Y(y_read),
		.OUT_PIXEL(p_out)
	);

endmodule