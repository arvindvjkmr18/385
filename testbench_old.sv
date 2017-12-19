module testbench();

timeunit 10ns;

timeprecision 1ns;

// Signals:

	
	// Input timing signals
	logic				CLOCK_50;		// 50 MHz Master (Data) Clock	
	
	logic				PS2_CLK;
	logic				PS2_DAT;
	
	// Input control signals
	logic				RESET;			// System reset
	
	// Output (to DAC via Pin-Planner)
	logic				VGA_CLK;			// 25 MHz VGA (Video) Clock
	logic				VGA_SYNC_N;
	logic				VGA_BLANK_N;
	logic 			VGA_HS;
	logic				VGA_VS;
	logic [7:0]		VGA_R;
	logic [7:0]		VGA_G;
	logic [7:0]		VGA_B;
	logic [6:0]		HEX0;
	logic [6:0]		HEX1;
	logic 			LEDR0;
	logic				LEDR1;
	
always begin : CLOCK_GEN
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: INITIALIZATION

	CLOCK_50 = 1'b0;
	RESET = 1'b1;
	
end

system_toplevel dut(.*);

	// Internal signals:
	logic [7:0] mux_dout;	// 8' pixel data to frame buffer
	logic [8:0] mux_x;		// Ref x coord (to frame buffer)
	logic [8:0] mux_y;		// Ref y coord (to frame buffer)
	logic mux_we;
	

	logic [1:0] State, Next_state;
	logic pos_update_done, fsm_env_done, fsm_spr_done, fsm_page_flip, fsm_run_env, fsm_run_spr, fsm_eng_sel;
	
	logic [3:0] pos_state, pos_next_state;
	logic [2:0] pos_fsm_address;
	logic [2:0] pos_SPRITE_ID;
	logic collision_done, get_input, trigger_ai, buffer_load, run_collision, game_over_flag, addr_mux_sel, buf_mux_sel;
	logic [1:0] fsm_addr, collision_addr, collision_mux_addr, buf_mux_addr, buf_addr;
	logic [1:0] buf_mux_code, buf_code, collision_code, collision_mux_code;
	logic [8:0] buf_mux_x, buf_mux_y, buf_x, buf_y, hero_x, hero_y, enemy_x, enemy_y, collision_x, collision_y, collision_mux_x, collision_mux_y;
	
	// Internal collision detec signals:
	logic collision;
	logic [2:0] obj_addr, next_obj_address;
	logic [9:0] new_x, new_y, obj_x, obj_y;
	int x_diff, y_diff, dx, dy;
	logic we_reg;
	logic [1:0] ef_address, ef_sprite_id, ef_sprite_id_reg;
	logic [8:0] ef_target_x, ef_target_y, ef_target_x_reg, ef_target_y_reg;
	
	
	assign collision = dut.pos_sub_sys.dc_comp.collision;
	assign obj_addr = dut.pos_sub_sys.dc_comp.obj_addr;
	assign next_obj_address = dut.pos_sub_sys.dc_comp.next_obj_address;
	assign new_x = dut.pos_sub_sys.dc_comp.new_x;
	assign new_y = dut.pos_sub_sys.dc_comp.new_y;
	assign obj_x = dut.pos_sub_sys.dc_comp.obj_x;
	assign obj_y = dut.pos_sub_sys.dc_comp.obj_y;
	assign x_diff = dut.pos_sub_sys.dc_comp.x_diff;
	assign y_diff = dut.pos_sub_sys.dc_comp.y_diff;
	assign dx = dut.pos_sub_sys.dc_comp.dx;
	assign dy = dut.pos_sub_sys.dc_comp.dy;
	assign we_reg = dut.pos_sub_sys.FSM.WE_reg;
	assign ef_address = dut.entityFile.ADDRESS;
	assign ef_sprite_id_reg = dut.entityFile.SPRITE_ID_reg;
	assign ef_target_x_reg = dut.entityFile.TARGET_X_reg;
	assign ef_target_y_reg = dut.entityFile.TARGET_Y_reg;
	assign ef_sprite_id = dut.entityFile.SPRITE_ID;
	assign ef_target_x = dut.entityFile.TARGET_X;
	assign ef_target_y = dut.entityFile.TARGET_Y;
	
	// Position subsystem signals:
	assign pos_update_done = dut.pos_update_done;
	assign pos_state = dut.pos_sub_sys.FSM.State;
	assign pos_SPRITE_ID = dut.pos_sub_sys.SPRITE_ID;
	assign pos_fsm_address = dut.pos_sub_sys.FSM.address;
	assign pos_next_state = dut.pos_sub_sys.FSM.Next_state;
	assign collision_done = dut.pos_sub_sys.collision_done;
	assign get_input = dut.pos_sub_sys.get_input;
	assign trigger_ai = dut.pos_sub_sys.trigger_ai;
	assign buffer_load = dut.pos_sub_sys.buffer_load;
	assign run_collision = dut.pos_sub_sys.run_collision;
	assign game_over_flag = dut.pos_sub_sys.game_over_flag;
	assign addr_mux_sel = dut.pos_sub_sys.addr_mux_sel;
	assign buf_mux_sel = dut.pos_sub_sys.buf_mux_sel;
	assign fsm_addr = dut.pos_sub_sys.fsm_addr;
	assign collision_addr = dut.pos_sub_sys.collision_addr;
	assign collision_mux_addr = dut.pos_sub_sys.collision_mux_addr;
	assign buf_mux_addr = dut.pos_sub_sys.buf_mux_addr;
	assign buf_addr = dut.pos_sub_sys.buf_addr;
	assign buf_mux_code = dut.pos_sub_sys.buf_mux_code;
	assign buf_code = dut.pos_sub_sys.buf_code;
	assign collision_code = dut.pos_sub_sys.collision_code;
	assign collision_mux_code = dut.pos_sub_sys.collision_mux_code;
	assign buf_mux_x = dut.pos_sub_sys.buf_mux_x;
	assign buf_mux_y = dut.pos_sub_sys.buf_mux_y;
	assign buf_x = dut.pos_sub_sys.buf_x;
	assign buf_y = dut.pos_sub_sys.buf_y;
	assign hero_x = dut.pos_sub_sys.hero_x;
	assign hero_y = dut.pos_sub_sys.hero_y;
	assign enemy_x = dut.pos_sub_sys.enemy_x;
	assign enemy_y = dut.pos_sub_sys.enemy_y;
	assign collision_x = dut.pos_sub_sys.collision_x;
	assign collision_y = dut.pos_sub_sys.collision_y;
	assign collision_mux_x = dut.pos_sub_sys.collision_mux_x;
	assign collision_mux_y = dut.pos_sub_sys.collision_mux_y;
	
	
	
	logic [2:0] spr_eng_state;
	logic [2:0] spr_queue_address;
	logic [7:0] spr_pixel_dout;
	logic [8:0]	spr_x_out, spr_y_out;
	logic spr_we_out;
	
	logic [1:0] spr_addr_file_to_queue;
	logic [1:0] sprite_id_eng_to_rom;
	logic [7:0] spr_pixel_rom_out;
	logic spr_eng_done;
	
	
	
	// System internal signals
	assign State = dut.FSM.State;
	assign Next_state = dut.FSM.Next_state;
	assign fsm_env_done = dut.FSM.ENV_DONE;
	assign fsm_spr_done = dut.FSM.SPR_DONE;
	assign fsm_page_flip = dut.FSM.PAGE_FLIP;
	assign fsm_run_env = dut.FSM.RUN_ENV;
	assign fsm_run_spr = dut.FSM.RUN_SPR;
	assign fsm_eng_sel = dut.FSM.ENG_SEL;
	
	
	// Sprite subsys:
	assign spr_eng_state = dut.spr_sub_sys.sq.State;
	assign spr_queue_address = dut.spr_sub_sys.sq.address;
	assign spr_addr_file_to_queue = dut.spr_sub_sys.SPRITE_ID;
	assign sprite_id_eng_to_rom = dut.spr_sub_sys.sprite_id_engine_to_rom;
	assign spr_pixel_rom_out = dut.spr_sub_sys.sprite_pixel_rom_to_engine;
	assign spr_we_out = dut.spr_sub_sys.WE;
	assign spr_eng_done = dut.spr_sub_sys.eng_done;
	
	// Top level connections:
	assign spr_pixel_dout = dut.spr_pixel_data;
	assign spr_x_out = dut.spr_pixel_x;
	assign spr_y_out = dut.spr_pixel_y;
/*	
	assign mux_dout = dut.p_data;
	assign mux_x = dut.eng_x;
	assign mux_y = dut.eng_y;
	assign mux_we = dut.eng_we;
	
	*/
	/*
	logic [7:0] envir_rom_to_eng, sprite_rom_to_eng;
	logic [7:0] frame_buf_PIXEL_DIN;
	logic [8:0] x_write_to_buf, y_write_to_buf;
	logic [7:0] page_0_PIXEL_DIN;
	logic [7:0] page_1_PIXEL_DIN;
	logic [1:0] page_1_QUAD_SEL;
	logic [9:0] page_1_REF_X;
	logic [9:0] page_1_REF_Y;
	logic [14:0] page_1_ADDRESS;
	logic page_1_WE_0, page_1_WE_1, page_1_WE_2, page_1_WE_3;
	logic [7:0] buf_to_LUT;
	logic [8:0] x_draw, y_draw;
	//logic [7:0] p_data_int, // redundant to frame_buf_PIXEL_DIN
	
	logic env_we, spr_we, eng_we, env_re, spr_re;
	logic [4:0] spr_x, spr_y;
	//logic reset_h_int;
	
	assign State = dut.FSM.State;
	assign Next_state = dut.FSM.Next_state;
	assign frame_buf_PIXEL_DIN = dut.video.video_buf.PIXEL_DIN;
	assign page_0_PIXEL_DIN = dut.video.video_buf.page_0.PIXEL_DIN;
	assign page_1_PIXEL_DIN = dut.video.video_buf.page_1.PIXEL_DIN;
	assign buf_to_LUT = dut.video.p_out;
	//assign p_data_int = dut.p_data;
	assign envir_rom_to_eng = dut.e_data;
	assign sprite_rom_to_eng = dut.s_data;
	assign x_write_to_buf = dut.eng_x;
	assign y_write_to_buf = dut.eng_y;
	assign env_we = dut.env_we;
	assign spr_we = dut.spr_we;
	assign eng_we = dut.eng_we;
	assign env_re = dut.env_re;
	assign spr_re = dut.spr_re;
	//assign sprite_id_int = dut.sprite_id;
	assign spr_x_int = dut.spr_x;
	assign spr_y_int = dut.spr_y;
	//assign reset_h_int = dut.reset_h;
	assign x_draw = dut.video.x_out;
	assign y_draw = dut.video.y_out;
	
	assign page_1_QUAD_SEL = dut.video.video_buf.page_1.QUAD_SEL;
	assign page_1_REF_X = dut.video.video_buf.page_1.REF_X;
	assign page_1_REF_Y = dut.video.video_buf.page_1.REF_Y;
	assign page_1_ADDRESS = dut.video.video_buf.page_1.ADDRESS;
	assign page_1_WE_0 = dut.video.video_buf.page_1.WE_0;
	assign page_1_WE_1 = dut.video.video_buf.page_1.WE_1;
	assign page_1_WE_2 = dut.video.video_buf.page_1.WE_2;
	assign page_1_WE_3 = dut.video.video_buf.page_1.WE_3;
	*/
	
initial begin

	force dut.pos_sub_sys.player.keycode = 8'h23;
	
	#20000 release dut.pos_sub_sys.player.keycode;

end


initial begin : TEST_VECTORS
	
	#1 RESET = 1'b0;

	#1 RESET = 1'b1;
	
end

endmodule
