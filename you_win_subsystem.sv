module you_win_subsystem(

	// Timing signals
	input logic				CLOCK_50,	// Master data clock
	
	// Input control
	input logic				RESET_H,	// Reset signal
	input logic				RUN_YOU_WIN,	// Command from system FSM
	
	// Output control
	output logic			WE,			// Command to engine MUX input
	output logic			YOU_WIN_DONE,	// Command to system FSM
	
	// Output data
	output logic [7:0]	PIXEL_DOUT,	// Pixel data to engine MUX input
	output logic [8:0]	PIXEL_X,	// Pixel x,y coord to engine MUX input
	output logic [8:0]	PIXEL_Y

);

	// Internal wires:
	logic [7:0] y_data, youwin_pixel_data;
	logic [8:0] spr_x, spr_y;
	logic [8:0] youwin_x, youwin_y;
	logic r_y_w;
	logic [2:0] y_w_ID;
	
	assign PIXEL_DOUT = youwin_pixel_data;
	assign PIXEL_X = youwin_x;
	assign PIXEL_Y = youwin_y;
	

	you_win_engine youwinEngine(
		.CLOCK_50,	
		.RESET(RESET_H),	
		.RUN_YOU_WIN,
		.PIXEL_DIN(y_data),	
		.PIXEL_DOUT(youwin_pixel_data),	
		.PIXEL_X(youwin_x),		
		.PIXEL_Y(youwin_y),		
		.SPRITE_ID(y_w_ID),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.YOU_WIN_DONE,
		.WE,			
		.RE(r_y_w)	
	);
	
	youwinROM youwin(
		.CLOCK_50, 
		.RESET(RESET_H),
		.R_Y_W(r_y_w),
		.SPRITE_ID(y_w_ID),	
		.SPRITE_X(spr_x),
		.SPRITE_Y(spr_y),
		.SPRITE_PIXEL(y_data)
	);

endmodule