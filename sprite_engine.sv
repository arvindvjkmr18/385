module sprite_engine(

	// Input timing:
	input logic				CLOCK_50,	// 50 MHz master (data) clock
	
	// Input command:
	input logic				RESET_H,		// Reset command
	input logic				RUN_SPR,		// Run command (for toggling env engin separately)
	input logic				UPDATE,		// Load new target for drawing
	
	// Input data:
	input logic  [1:0]   SPRITE_ID_IN,
	input logic	 [7:0] 	PIXEL_DIN,	// 8' pixel data from ROM;
	
	input logic	 [8:0]	TARGET_X,	// Target X coord. in playfield (anchor point)
	input logic	 [8:0]	TARGET_Y,	// Target Y coord. in playfield (anchor point)
	
	// Output data:
	output logic [7:0]	PIXEL_DOUT,	// 8' pixel data to frame buffer
	output logic [8:0]	PIXEL_X,		// Ref x coord (to frame buffer)
	output logic [8:0]	PIXEL_Y,		// Ref y coord (to frame buffer)
	
	output logic [1:0]	SPRITE_ID,	// Sprite ID code (to ROM).
	output logic [4:0]	SPRITE_X,
	output logic [4:0]	SPRITE_Y,
	
	// Output control:
	output logic			SPR_DONE,	// Envir Engine Status (0 if drawing, 1 if done)
	output logic 			WE,			// Write enable command (to frame buffer)
	output logic			RE				// Read enable command (to ROM)

);

	// Internal wires & registers:
	int target_x, target_y;	// superfluous?
	int sprite_x, sprite_x_update, sprite_y, sprite_y_update;
	int pixel_x, pixel_x_update, pixel_y, pixel_y_update, pixel_x_sync, pixel_y_sync;
	
	// Has +1 clock cycle delay from ROM fetch:
	//assign PIXEL_DOUT = PIXEL_DIN;
	assign PIXEL_X = pixel_x_sync;
	assign PIXEL_Y = pixel_y_sync;
	assign SPRITE_X = sprite_x;
	assign SPRITE_Y = sprite_y;
	assign SPRITE_ID = SPRITE_ID_IN;
	
	// Update internal registers:
	always_ff @ (posedge CLOCK_50)
	begin
	
		if (RESET_H)
		begin
		
			//env_done <= 0;	// Indicate env not drawn
			pixel_x <= 0;
			pixel_y <= 0;
			
		end
		else if(RUN_SPR)
		begin
		
			pixel_x <= pixel_x_update;
			pixel_y <= pixel_y_update;
		
		end
		
		// for debug, to load sprite id target data
		else if(UPDATE)
		begin
		
			pixel_x <= TARGET_X;
			pixel_y <= TARGET_Y;
		
		end
	
	
	end
	
	// ** CHECK THAT THIS IS STILL NECESSARY **
	// Synchronizer for output to frame buffer:
	always_ff @ (posedge CLOCK_50)
	begin
	
		pixel_x_sync <= pixel_x;
		pixel_y_sync <= pixel_y;
		
	
	end
	// **
	
	// Sends control signal to FSM to indicate that the sprite eng has finished drawing:
	always_ff @ (posedge CLOCK_50)
	begin
		
		if( (pixel_x - TARGET_X) == 31 && (pixel_y - TARGET_Y) == 31)
			SPR_DONE <= 1;
			
		else
			SPR_DONE <= 0;
		
	end
	
	// Coordinate update calculation:
	always_comb
	begin
	
		sprite_x = pixel_x - TARGET_X;
		sprite_y = pixel_y - TARGET_Y;
	
		if( sprite_x == 31 )
		begin
		
			pixel_x_update = TARGET_X;
	
			if( sprite_y == 31 )
			begin

				pixel_y_update = TARGET_Y;
		
			end
			
			else
			begin
			
				pixel_y_update = pixel_y + 1;
			
			end
		
		end
		
		else
		begin
		
			pixel_x_update = pixel_x + 1;
			pixel_y_update = pixel_y;
		
		end
		
	
	end
	
	// Slave controls:
	always_comb
	begin
	
		// Default:
		RE = 0;
		WE = 0;
		
		PIXEL_DOUT = 8'hFF;
	
		// Sprite engine activated:
		if(RUN_SPR)
		begin
		
			RE = 1;
			
			PIXEL_DOUT = PIXEL_DIN;
		
			// Check for magenta transparency key:
			if(PIXEL_DIN != 8'hE3)
			begin
			
				WE = 1;
			
			end
		
		end
	
	end
	
endmodule	