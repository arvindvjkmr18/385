module envir_subsystem(

	// Timing signals
	input logic				CLOCK_50,	// Master data clock
	
	// Input control
	input logic				RESET_H,	// Reset signal
	input logic				RUN_ENV,	// Command from system FSM
	
	// Output control
	output logic			WE,			// Command to engine MUX input
	output logic			ENV_DONE,	// Command to system FSM
	
	// Output data
	output logic [7:0]		PIXEL_DOUT,	// Pixel data to engine MUX input
	output logic [8:0]		PIXEL_X,	// Pixel x,y coord to engine MUX input
	output logic [8:0]		PIXEL_Y

);

	// Internal wires:
	logic [7:0] e_data, env_pixel_data;
	logic [8:0] spr_x, spr_y;
	logic [8:0] env_x, env_y;
	
	assign PIXEL_DOUT = env_pixel_data;
	assign PIXEL_X = env_x;
	assign PIXEL_Y = env_y;
	

	env_engine envEngine(
		.CLOCK_50,	
		.RESET(RESET_H),	
		.RUN_ENV,
		.PIXEL_DIN(e_data),	
		.PIXEL_DOUT(env_pixel_data),	
		.PIXEL_X(env_x),		
		.PIXEL_Y(env_y),		
		.SPRITE_ID(envir_id),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.ENV_DONE,
		.WE,			
		.RE(env_re)	
	);
	
	envROM env(
		.CLOCK_50, 
		.RESET(RESET_H),
		.R_ENV(env_re),
		.SPRITE_ID(envir_id),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.SPRITE_PIXEL(e_data)
	);

endmodule