module sprite_subsystem(

	input logic CLOCK_50,
	input logic RESET_H,
	
	input logic RUN,

	input logic [1:0] SPRITE_ID,
	input logic [8:0] TARGET_X,	
	input logic [8:0] TARGET_Y,
	input logic [2:0] STOP_ADDRESS,
	
	output logic [7:0] PIXEL_DOUT,
	output logic [8:0] PIXEL_X,		// Ref x coord (to frame buffer)
	output logic [8:0] PIXEL_Y,
	
	output logic [1:0] ADDRESS,
	output logic WE, QUEUE_DONE
	
);

logic [1:0]	sprite_id_queue_to_engine;
logic [1:0]	sprite_id_engine_to_rom;  

logic [8:0]	target_x_queue_to_engine;	
logic [8:0]	target_y_queue_to_engine;
logic [4:0]	sprite_x_engine_to_rom;	
logic [4:0]	sprite_y_engine_to_rom;
logic [7:0] sprite_pixel_rom_to_engine;
logic update, run_eng, queue_done, eng_done;
logic we_eng_to_buf, re_eng_to_rom;

assign WE = we_eng_to_buf;
assign QUEUE_DONE = queue_done;


sprite_queue sq(

	// Timing signals:
	.CLOCK_50,	// 50 MHz master data clock

	// Input control:
	.RESET_H,		// Reset command
	.RUN_QUEUE(RUN),	// Run command from FSM
	.ENG_DONE(eng_done),	// Done command from engine
	
	// Input data:
	.STOP_ADDRESS,					// Stop address from entity file
	.ID_CODE(SPRITE_ID),		// Sprite ID code (character or envir tile)
	.X_COORD(TARGET_X),		// Target X anchor coord
	.Y_COORD(TARGET_Y),		// Target Y anchor coord
	
	// Output control:
	.QUEUE_DONE(queue_done),	// Done command to FSM
	.UPDATE(update),		// Load/refresh command to engine
	.RUN_ENG(run_eng),		// Run the draw engine
	
	// Output data:
	.ADDRESS,		// Address of sprite info in entity reg file
	.SPRITE_ID(sprite_id_queue_to_engine),	// Sprite ID code pass-thru to engine
	.TARGET_X(target_x_queue_to_engine),	   // Target X pass-thru to engine
	.TARGET_Y(target_y_queue_to_engine)		// Target Y pass-thru to engine
	
);

sprite_engine se(

	// Input timing:
	.CLOCK_50,	// 50 MHz master (data) clock
	
	// Input command:
	.RESET_H,		// Reset command
	.RUN_SPR(run_eng),		// Run command (for toggling env engin separately)
	.UPDATE(update),		// Load new target for drawing
	
	// Input data:
	.SPRITE_ID_IN(sprite_id_queue_to_engine),
	.PIXEL_DIN(sprite_pixel_rom_to_engine),	// 8' pixel data from ROM;
	
	.TARGET_X(target_x_queue_to_engine),	// Target X coord. in playfield (anchor point)
	.TARGET_Y(target_y_queue_to_engine),	// Target Y coord. in playfield (anchor point)
	
	// Output data:
	.PIXEL_DOUT,	// 8' pixel data to frame buffer
	.PIXEL_X,		// Ref x coord (to frame buffer)
	.PIXEL_Y,		// Ref y coord (to frame buffer)
	
	.SPRITE_ID(sprite_id_engine_to_rom),	// Sprite ID code (to ROM).
	.SPRITE_X(sprite_x_engine_to_rom),
	.SPRITE_Y(sprite_y_engine_to_rom),
	
	// Output control:
	.SPR_DONE(eng_done),	// Envir Engine Status (0 if drawing, 1 if done)
	.WE(we_eng_to_buf),			// Write enable command (to frame buffer)
	.RE(re_eng_to_rom)				// Read enable command (to ROM)

);

spriteROM sr(

	// Timing signals:
	.CLOCK_50,
	
	// Input control signals:
	.RESET_H,
	.R_SPR(re_eng_to_rom),		//read enable signal
	
	// Input data signals:
	.SPRITE_ID(sprite_id_engine_to_rom),
	.SPRITE_X(sprite_x_engine_to_rom),
	.SPRITE_Y(sprite_y_engine_to_rom),
	
	// Output data signals:
	.SPRITE_PIXEL(sprite_pixel_rom_to_engine)

);

endmodule