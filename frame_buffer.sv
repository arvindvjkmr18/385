// UPDATED 12/3/17
// Fixed addressing bug to correct for quadrant. Previously 320x240 2d coords
// used to get linear address w/o accounting for quadrant partitioning. Added
// offsets to correct. Confirmed to work.
//
// UPDATED 12/3/17
// Removed the "predictive" x,y lookup for reading pixel data to the DAC
// and the performance is the same, so we're dropping the coord modification
//
// UPDATED 12/3/17
// Moved Addressing calculation to optimize code. Confirmed operation.
//
// UPDATED 11/19/17
// Modified read-mode address indexing to account for inherent output
// delay of vram IP component used. Based on DOUT_X and DOUT_Y, each
// buffer page module will advance the pixel by one -- effectively
// "reading ahead" of the VGA controller to ensure that the pixel data
// output from the frame buffer matches the DrawX and DrawY coordinates.
// *** Operation verified 11/19/2017 7:30 pm ***
//
// UPDATED 11/19/17
//	Added QUAD_SEL routine for read-mode, which was previously absent.
//
// *** Operation verified 11/12/2017 8:15 pm ***
module frame_buffer(	

	// Input Clock:
	input logic 			CLOCK_50,	// 50 MHz clock
	
	input logic 			VGA_CLK,		// 25 MHz clock

	// Data Input:
	
	input logic WE,						// Write enable ctrl signal from engine(s)

	////	Pixel Data
	input logic [7:0] 	PIXEL_DIN,
	input logic [8:0]		PIXEL_X,		
	input logic [8:0]		PIXEL_Y,		
	
	//// Timing Data
	input logic 			PAGE_SEL,	// Selects which buffer is being drawn (i.e. read from)
	
	//// Draw Coord.
	input logic [8:0]		DOUT_X,		// X-coord of pixel to draw
	input logic [8:0]		DOUT_Y,		// Y-coord of pixel to draw

	// Data Output:
	
	output logic [7:0]		OUT_PIXEL	// 8-bit Paletted RGB pixel data
	
);

	// Internal Wires:
	logic page_sel, page_sel_n;
	logic [7:0] OUT_PIXEL0, OUT_PIXEL1;	// Output pixel data from each page
	
	assign page_sel = PAGE_SEL;		// Maintain page select signal to active high
	assign page_sel_n = ~PAGE_SEL;	// Convert page select signal to active low
	
	// Assign pixel and coord data output, per PAGE_SEL signal:
	always_comb
	begin
	
		case(PAGE_SEL)
		
			1'b0:	OUT_PIXEL = OUT_PIXEL0;
			
			1'b1:	OUT_PIXEL = OUT_PIXEL1;
			
			default: ;
		
		endcase
	
	end

	buffer_page page_0(
	
		.CLOCK_50,
		.VGA_CLK,
		.PIXEL_DIN,
		.PIXEL_X,
		.PIXEL_Y,
		.WE,
		.PE(page_sel),		// Page 0 Selected -> PE = 0
		.DOUT_X,
		.DOUT_Y,
		.OUT_PIXEL(OUT_PIXEL0)
	
	);
	
	buffer_page page_1(
	
		.CLOCK_50,
		.VGA_CLK,
		.PIXEL_DIN,
		.PIXEL_X,
		.PIXEL_Y,
		.WE,
		.PE(page_sel_n),		// Page 1 Selected -> PE = 0
		.DOUT_X,
		.DOUT_Y,
		.OUT_PIXEL(OUT_PIXEL1)
	
	);
	

endmodule

module buffer_page(

	// Input Clock:
	input logic 			CLOCK_50,	// 50 MHz clock
	input logic 			VGA_CLK,		// 25 MHz clock

	// Data Input:

	////	Pixel Data
	input logic [7:0] 	PIXEL_DIN,	// From Object Engine
	input logic [8:0]		PIXEL_X,		// w/o a timing schema for where to draw pixel when, must send target coord. data...
	input logic [8:0]		PIXEL_Y,		// ... ideally this can be eliminated once timing is mapped.
	
	//// Chip Select
	input logic				WE,			// Write enable
	input logic				PE,			// Page enable
	
	//// Draw Coord.
	input logic [8:0]		DOUT_X,		// X-coord of pixel to draw
	input logic [8:0]		DOUT_Y,		// Y-coord of pixel to draw

	// Data Output:
	
	output logic [7:0]	OUT_PIXEL	// 8-bit Paletted RGB pixel data

);

	// Internal wires:
	logic [14:0] ADDRESS;
	logic [1:0] QUAD_SEL;
	logic [7:0] PIXEL_DOUT0, PIXEL_DOUT1, PIXEL_DOUT2, PIXEL_DOUT3;
	logic [8:0] REF_X, REF_Y;
	logic WE_0, WE_1, WE_2, WE_3;
	
	// Convert 2D Coordinates to linear address, accounting for mode(W/R):
	always_comb
	begin
	
		// Write-mode address calculation from (x,y)
		if(PE)
		begin
		
			//ADDRESS = (PIXEL_Y * 320) + PIXEL_X;
			REF_X = PIXEL_X;
			REF_Y = PIXEL_Y;
		end
		// Read-mode address calculation from (x,y) -- "reads ahead" 1 pixel:
		else
		begin
			
			REF_X = DOUT_X;
			REF_Y = DOUT_Y;
			
		end

		//ADDRESS = (REF_Y * 320) + REF_X;
	
		// Quardant Select:
	
		// Default: Upper left quadrant:
		QUAD_SEL = 2'b00;
		ADDRESS = (REF_Y * 160) + REF_X;
		
		// Left side of frame:
		if(REF_X < 160)
		begin
		
			// Lower left quadrant:
			if(REF_Y > 119)
			begin
				
				QUAD_SEL = 2'b10;
				ADDRESS = ((REF_Y - 120) * 160) + REF_X;
				
			end
		
		end
		else
		begin
			
			// Upper right quadrant:
			if(REF_Y < 120)
			begin
			
				QUAD_SEL = 2'b01;
				ADDRESS = (REF_Y * 160) + (REF_X - 160);
			
			end
			// Lower right quadrant:
			else
			begin
			
				QUAD_SEL = 2'b11;
				ADDRESS = ((REF_Y - 120) * 160) + (REF_X - 160);
			
			end
		
		end
		// end quadrant select
		
		// Quadrant I/O:
		WE_0 = 1'b0;
		WE_1 = 1'b0;
		WE_2 = 1'b0;
		WE_3 = 1'b0;
		
		OUT_PIXEL = 8'hFFFF;	// Default output all white
		
		case(QUAD_SEL)
		
			2'b00:	begin		
						WE_0 = WE & PE;
						OUT_PIXEL = PIXEL_DOUT0;
						end
						
			2'b01:	begin
						WE_1 = WE & PE;
						OUT_PIXEL = PIXEL_DOUT1;
						end
						
			2'b10:	begin
						WE_2 = WE & PE;
						OUT_PIXEL = PIXEL_DOUT2;
						end
						
			2'b11:	begin
						WE_3 = WE & PE;
						OUT_PIXEL = PIXEL_DOUT3;
						end
						
			default: ;
		
		endcase
	
	end
	
	

	// Memory quadrants:
	// (0,0) to (159, 119)
	vram quad0(
	
		.address(ADDRESS),
		.data(PIXEL_DIN),
		.inclock(CLOCK_50),
		.outclock(VGA_CLK),
		.wren(WE_0),
		.q(PIXEL_DOUT0)
	
	);
	
	// (160,0) to (319, 119)
	vram quad1(
	
		.address(ADDRESS),
		.data(PIXEL_DIN),
		.inclock(CLOCK_50),
		.outclock(VGA_CLK),
		.wren(WE_1),
		.q(PIXEL_DOUT1)
	
	);
	
	// (0,160) to (159, 239)
	vram quad2(
	
		.address(ADDRESS),
		.data(PIXEL_DIN),
		.inclock(CLOCK_50),
		.outclock(VGA_CLK),
		.wren(WE_2),
		.q(PIXEL_DOUT2)
	
	);
	
	// (160, 120) to (319, 239)
	vram quad3(
	
		.address(ADDRESS),
		.data(PIXEL_DIN),
		.inclock(CLOCK_50),
		.outclock(VGA_CLK),
		.wren(WE_3),
		.q(PIXEL_DOUT3)
	
	);
	
endmodule