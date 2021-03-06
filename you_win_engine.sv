module you_win_engine(
	
	// Input timing:
	input logic				CLOCK_50,	// 50 MHz master (data) clock
	
	// Input command:
	input logic				RESET,		// Reset command
	input logic				RUN_YOU_WIN,		// Run command (for toggling env engin separately)
	
	// Input data:
	input logic	 [7:0] 	PIXEL_DIN,	// 8' pixel data from ROM;
	
	// Output data:
	output logic [7:0]	PIXEL_DOUT,	// 8' pixel data to frame buffer
	output logic [8:0]	PIXEL_X,		// Ref x coord (to frame buffer)
	output logic [8:0]	PIXEL_Y,		// Ref y coord (to frame buffer)
	
	output logic [2:0]	SPRITE_ID,	// Sprite ID code (to ROM),
	output logic [4:0]	SPRITE_X,
	output logic [4:0]	SPRITE_Y,
	
	// Output control:
	output logic			YOU_WIN_DONE,	// Envir Engine Status (0 if drawing, 1 if done)
	output logic 			WE,			// Write enable command (to frame buffer)
	output logic			RE				// Read enable command (to ROM)
);


	// Map data:
	//logic register_file[48];		// to be developed later...
	
	// Tile coordinates (10 horizontal by 7.5 vertical tiles):
	int tile_x, tile_y;
	
	// Relative sprite pixel and coords (32 x 32):
	int sprite_x, sprite_y;
	
	// Absolute pixel coord (for relay to frame buffer)
	int pixel_x, pixel_y, pixel_x_sync, pixel_y_sync;
	
	// Internal wires & registers:
	int x_update, y_update;
	//logic page_sel_in, page_sel_prev;
	//logic new_frame;				// Edge detection var for reinitializing env draw
	//logic env_done;
	
	// Port Connections:
	//assign ENV_DONE = env_done;
	//assign page_sel_in = PAGE_SEL;
	
	// Update registers:

	always_ff @ (posedge CLOCK_50)
	begin
	
		if (RESET)
		begin
		
			//env_done <= 0;	// Indicate env not drawn
			pixel_x <= 0;
			pixel_y <= 0;
			
		end
		else if(RUN_YOU_WIN)
		begin
		
			
			pixel_x <= x_update;
			pixel_y <= y_update;
		
		end
	
		else
		begin
		
			pixel_x <= 0;
			pixel_y <= 0;
		
		end
	
	
	end
	
	// Sends control signal to FSM to indicate that the environment has finished drawing:
	always_ff @ (posedge CLOCK_50)
	begin
		
		if(pixel_x == 319 && pixel_y == 239)
			YOU_WIN_DONE = 1;
			
		else
			YOU_WIN_DONE = 0;
		
	end

	// Synchronizer for output to frame buffer:
	always_ff @ (posedge CLOCK_50)
	begin
	
		pixel_x_sync <= pixel_x;
		pixel_y_sync <= pixel_y;
		
	
	end

	// Has +1 clock cycle delay from ROM fetch:
	assign PIXEL_DOUT = PIXEL_DIN;
	assign PIXEL_X = pixel_x_sync;
	assign PIXEL_Y = pixel_y_sync;
	assign SPRITE_X = sprite_x;
	assign SPRITE_Y = sprite_y;
	//assign RE = 1;
	//assign WE = 1;
	
	always_comb
	begin
		
		if(RUN_YOU_WIN)
		begin
			RE = 1;
			WE = 1;
		end
		
		else
		begin
			RE = 0;
			WE = 0;
		end	
	
	end

	// Calculation of the next pixel x and y value:
	always_comb
	begin
		
		// Reach end of row...
		if(pixel_x == 319)
		begin
			
			x_update = 0;
				
			// Reach end of column, reset to zero:
			if(pixel_y == 239)
			begin
				
				y_update = 0;	
			
			end
			// ... column end not reached, iterate normally:
			else
			begin
				
				y_update = pixel_y + 1;
				
			end
			
		end
		else
		begin
			
			x_update = pixel_x + 1;
			y_update = pixel_y;
			
		end

	end

	// Mapping of absolute frame x,y to corresp. tile, and in tandem
	// the relative x,y coord of the sprite data
	always_comb
	begin

		sprite_x = pixel_x % 32;
		sprite_y = pixel_y % 32;

		tile_x = pixel_x / 32;
		tile_y = pixel_y / 32;

		if(tile_y == 3)
		begin
		
			if(tile_x == 1)
				SPRITE_ID = 3'b001;
				
			else if(tile_x == 2)
				SPRITE_ID = 3'b010;
				
			else if(tile_x == 3)
				SPRITE_ID = 3'b011;
			
			else if(tile_x == 5)
				SPRITE_ID = 3'b100;
			
			else if(tile_x == 6) 
				SPRITE_ID = 3'b101;
				
			else if(tile_x == 7) 
				SPRITE_ID = 3'b110;
			
			else if(tile_x == 8) 
				SPRITE_ID = 3'b111;
				
			else
				SPRITE_ID = 3'b000;
		end
		
		else
				SPRITE_ID = 3'b000;
		
	end
	
endmodule