module system_toplevel(

	input 					CLOCK_50,
	input 					RESET,
	input 					PS2_CLK,
	input 					PS2_DAT,		
	
	// Output to VGA:
	output logic			VGA_CLK,
	output logic			VGA_SYNC_N,
	output logic			VGA_BLANK_N,
	output logic			VGA_HS,
	output logic			VGA_VS,
	output logic [7:0]	VGA_R,
	output logic [7:0]	VGA_G,
	output logic [7:0]	VGA_B,
	
	output logic [6:0]	HEX0, HEX1,
	output logic			LEDR0, LEDR1

);

	//Internal wires
	logic reset_h;
	logic game_over;
	logic spr_we, env_we, g_o_we, y_w_we, eng_we, pos_we, ef_mux_we;
	logic run_pos_update, run_env, run_spr, run_game_over;
	logic pos_update_done, spr_queue_done, env_done, g_o_done;
	logic page_flip, page_sel;
	logic [1:0] eng_sel;
	logic [1:0] sprite_id, sprite_id_reg;
	logic [2:0] stop_addr;
	logic [1:0] spr_addr, pos_addr, ef_mux_addr;
	logic [7:0] p_data;
	logic [8:0] eng_x, eng_y;
	logic [8:0] target_x, target_y, target_x_reg, target_y_reg;
	logic [7:0] spr_pixel_data;
	logic [8:0] spr_pixel_x, spr_pixel_y;
	logic [7:0] env_pixel_data;
	logic [8:0] env_pixel_x, env_pixel_y;
	logic [7:0] g_o_pixel_data, y_w_pixel_data;
	logic [8:0] g_o_pixel_x, g_o_pixel_y, y_w_pixel_x, y_w_pixel_y;
	logic you_win;
	logic y_w_done;
	logic run_you_win;
	
	
	//logic COLLISION, POS_CTRL_DEBUG;
	//assign LEDR0 = POS_CTRL_DEBUG;
	assign LEDR0 = game_over;
	assign LEDR1 = reset_h;
	
	
	assign reset_h = ~RESET;
	
	systemController FSM(
		.CLOCK_50,
		.RESET(reset_h),
		.POS_UPDATE_DONE(pos_update_done),
		.ENV_DONE(env_done),
		.SPR_DONE(spr_queue_done),
		.PAGE_FLIP(page_flip),
		.GAME_OVER(game_over),
		.YOU_WIN(you_win),
		.G_O_DONE(g_o_done),
		.Y_W_DONE(y_w_done),
		.RUN_POS_UPDATE(run_pos_update),
		.RUN_ENV(run_env),
		.RUN_SPR(run_spr),
		.RUN_GAME_OVER(run_game_over),
		.RUN_YOU_WIN(run_you_win),
		.ENG_SEL(eng_sel)
	);
	
	detectPageFlip dfp(
		.CLOCK_50,
		.PAGE_SEL(page_sel),
		.PAGE_FLIP(page_flip)
	);
	
	video_comp video(
	
		.CLOCK_50,		// 50 MHz Master (Data) Clock
	
		.RESET,			// System reset
	
		.PIXEL_DIN(p_data),		// Input pixel from sprite engines
		.PIXEL_X(eng_x),			// Range: 0 to 319
		.PIXEL_Y(eng_y),			// Range: 0 to 239
		.WE(eng_we),				// Write-Enable command from sprite engines
	
		// Output (to DAC via Pin-Planner)
		.VGA_CLK,			// 25 MHz VGA (Video) Clock
		.VGA_SYNC_N,
		.VGA_BLANK_N,
		.VGA_HS,
		.VGA_VS,
		.VGA_R,
		.VGA_G,
		.VGA_B,
		.PAGE_SEL(page_sel)
	);
	
	engine_MUX engine(

		.ENG_SEL(eng_sel),
		.ENV_PIXEL_DIN(env_pixel_data),	
		.ENV_PIXEL_X(env_pixel_x),		
		.ENV_PIXEL_Y(env_pixel_y),
		.ENV_WE(env_we), 
		.SPR_PIXEL_DIN(spr_pixel_data),		
		.SPR_PIXEL_X(spr_pixel_x),		
		.SPR_PIXEL_Y(spr_pixel_y),
		.SPR_WE(spr_we),
		.G_O_PIXEL_DIN(g_o_pixel_data),		
		.G_O_PIXEL_X(g_o_pixel_x),		
		.G_O_PIXEL_Y(g_o_pixel_y),
		.G_O_WE(g_o_we),
		.Y_W_PIXEL_DIN(y_w_pixel_data),		
		.Y_W_PIXEL_X(y_w_pixel_x),		
		.Y_W_PIXEL_Y(y_w_pixel_y),
		.Y_W_WE(y_w_we),
		.ENG_PIXEL_DOUT(p_data),	
		.ENG_PIXEL_X(eng_x),	
		.ENG_PIXEL_Y(eng_y),
		.ENG_WE(eng_we)
	);
	
	
	position_subsystem pos_sub_sys(
	
		// Input timing:
		.CLOCK_50,								// Master data clock
		.PS2_CLK,								// PS2 Protocol clock
	
		// Input control:
		.RESET_H(reset_h),					// Reset command (active high)
		.RUN_POS_UPDATE(run_pos_update),	// Control signal from system core FSM
	
		// Input data:
		.PS2_DAT,
		.SPRITE_ID(sprite_id),				// from Entity File
		.TARGET_X(target_x),					// entity's stored x,y coords
		.TARGET_Y(target_y),
		.STOP_ADDRESS(stop_addr),	
	
		// Output control:
		.POS_UPDATE_DONE(pos_update_done),// Communication back to system core FSM
		.GAME_OVER(game_over),							// Indication of game over event
		.YOU_WIN(you_win),								// i win
		.WE_reg(pos_we),
	
		// Output data:
		.ADDRESS(pos_addr),					// Entity file address
		.SPRITE_ID_reg(sprite_id_reg),	// Sprite ID Code to assign for entity at address
		.TARGET_X_reg(target_x_reg),		// Updated x,y coords...
		.TARGET_Y_reg(target_y_reg),
	
		.HEX0, 
		.HEX1
		
	);
	
	
	sprite_subsystem spr_sub_sys(
	
		.CLOCK_50,
		.RESET_H(reset_h),
		.RUN(run_spr),
		.SPRITE_ID(sprite_id),
		.TARGET_X(target_x),
		.TARGET_Y(target_y),
		.STOP_ADDRESS(stop_addr),
		.PIXEL_DOUT(spr_pixel_data),
		.PIXEL_X(spr_pixel_x),		// Ref x coord (to frame buffer)
		.PIXEL_Y(spr_pixel_y),
		.ADDRESS(spr_addr),
		.WE(spr_we), 
		.QUEUE_DONE(spr_queue_done)
	
	);
	
	envir_subsystem envir_sub_sys(

		.CLOCK_50,							// Master data clock
		.RESET_H(reset_h),				// Reset signal
		.RUN_ENV(run_env),							// Command from system FSM
		.WE(env_we),						// Command to engine MUX input
		.ENV_DONE(env_done),							// Command to system FSM
		.PIXEL_DOUT(env_pixel_data),	// Pixel data to engine MUX input
		.PIXEL_X(env_pixel_x),			// Pixel x,y coord to engine MUX input
		.PIXEL_Y(env_pixel_y)

	);
	
	game_over_subsystem game_over_sub_sys(
	
		.CLOCK_50,							// Master data clock
		.RESET_H(reset_h),				// Reset signal
		.RUN_GAME_OVER(run_game_over),// Command from system FSM
		.WE(g_o_we),						// Command to engine MUX input
		.GAME_OVER_DONE(g_o_done),				// Command to system FSM
		.PIXEL_DOUT(g_o_pixel_data),	// Pixel data to engine MUX input
		.PIXEL_X(g_o_pixel_x),			// Pixel x,y coord to engine MUX input
		.PIXEL_Y(g_o_pixel_y)
	
	);
	
	// similar to the above module
	you_win_subsystem you_win_sub_sys(

		.CLOCK_50,						// Master data clock
		.RESET_H(reset_h),						// Reset signal
		.RUN_YOU_WIN(run_you_win),	// Command from system FSM
		.WE(y_w_we),					// Command to engine MUX input
		.YOU_WIN_DONE(y_w_done),	// Command to system FSM
		.PIXEL_DOUT(y_w_pixel_data),				// Pixel data to engine MUX input
		.PIXEL_X(y_w_pixel_x),						// Pixel x,y coord to engine MUX input
		.PIXEL_Y(y_w_pixel_y)
	);
	
	
	file_MUX entity_file_MUX(
	
		.INPUT_SEL(run_pos_update),	// Control signal from system FSM (tied to RUN_POS_UPDATE state)
		.SPR_ADDR(spr_addr),				// Address input from sprite subsystem
		.POS_ADDR(pos_addr),				// Address input from position subsystem
		.POS_WE(pos_we),					// Write enable input from position subsystem
		.MUX_ADDR(ef_mux_addr),			// Mux output to entity file
		.MUX_WE(ef_mux_we)
	
	);
	
	entity_file entityFile(
	
		//timing:
		.CLOCK_50,
		.RESET_H(reset_h),
	
		//Generic ROM inputs:
		.ADDRESS(ef_mux_addr),
		.SPRITE_ID_reg(sprite_id_reg),
		.TARGET_X_reg(target_x_reg),		// target_x_reg correct input, testing with x = 160 hardcoded
		.TARGET_Y_reg(target_y_reg),
		.RE_reg(1),
		.WE_reg(ef_mux_we),

		.SPRITE_ID(sprite_id),
		.TARGET_X(target_x),
		.TARGET_Y(target_y),
		.STOP_ADDRESS(stop_addr)
	
	);



endmodule