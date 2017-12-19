// Updated 11/19/17 4:29 PM
// Changed trigger condition for incrementing page counter from the
// VGA_VS pulse to the exact pixel coord.
// The VS pulse would have been several raster lines too soon.
module page_controller(

	// Input Timing Signals
	input logic VGA_CLK,						// VGA Clock
	//input logic VGA_VS,						// Vertical Sync (Active Low)
	input logic RESET,						// Reset signal
	
	// Input Draw Pixel Coord.
	input logic [9:0] DrawX,				// Current X Coord.
	input logic [9:0] DrawY,				// Current Y Coord.
	
	// Output control signals
	output logic PAGE_SEL					// Output to Frame Buffer

);

	// Internal wires:
	logic [1:0] page_count;
	
	//initial page_count = 2'b00;
	
	// Assign to MSB of page count so that each frame buffer page
	// is drawn twice, giving an effective 30 FPS refresh rate.
	assign PAGE_SEL = page_count[1];	
	
	// Update page counter on the rising edge following final pixel
	// locn: (799, 524)
	always_ff @ (posedge VGA_CLK or posedge RESET)
	begin
	
		// Reset
		if(RESET)
		begin
			page_count <= 2'b00;
		end
		// ... at end of frame raster
		else if( (DrawX == 799) && (DrawY == 524) )
		begin
			page_count <= page_count + 2'b01;
		end
		else
		begin
		
		end
	
	end

endmodule