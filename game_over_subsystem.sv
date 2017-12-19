module game_over_subsystem(

	// Timing signals
	input logic				CLOCK_50,	// Master data clock
	
	// Input control
	input logic				RESET_H,	// Reset signal
	input logic				RUN_GAME_OVER,	// Command from system FSM
	
	// Output control
	output logic			WE,			// Command to engine MUX input
	output logic			GAME_OVER_DONE,	// Command to system FSM
	
	// Output data
	output logic [7:0]	PIXEL_DOUT,	// Pixel data to engine MUX input
	output logic [8:0]	PIXEL_X,	// Pixel x,y coord to engine MUX input
	output logic [8:0]	PIXEL_Y

);

	// Internal wires:
	logic [7:0] g_data, gameover_pixel_data;
	logic [8:0] spr_x, spr_y;
	logic [8:0] gameover_x, gameover_y;
	logic r_g_o;
	logic [2:0] g_o_ID;
	
	assign PIXEL_DOUT = gameover_pixel_data;
	assign PIXEL_X = gameover_x;
	assign PIXEL_Y = gameover_y;
	

	game_over_engine gameoverEngine(
		.CLOCK_50,	
		.RESET(RESET_H),	
		.RUN_GAME_OVER,
		.PIXEL_DIN(g_data),	
		.PIXEL_DOUT(gameover_pixel_data),	
		.PIXEL_X(gameover_x),		
		.PIXEL_Y(gameover_y),		
		.SPRITE_ID(g_o_ID),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.GAME_OVER_DONE,
		.WE,			
		.RE(r_g_o)	
	);
	
	gameoverROM gameover(
		.CLOCK_50, 
		.RESET(RESET_H),
		.R_G_O(r_g_o),
		.SPRITE_ID(g_o_ID),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.SPRITE_PIXEL(g_data)
	);

endmodule