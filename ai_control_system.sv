module ai_control_system(

	// Input timing
	input logic				CLOCK_50,
	
	// Input control
	input logic				RESET_H,
	input logic				GET_PLAYER_POS,	// Controls capture of player x,y
	input logic 			RUN_AI,				// Command to run monster AI
	
	// Input data
	input logic [8:0] 	PLAYER_X,
	input logic [8:0] 	PLAYER_Y,

	input logic [8:0]		TARGET_X,			// enemy x,y (from position buffer)
	input logic [8:0]		TARGET_Y,
	
	// Output data	
	output logic [8:0]	NEW_ENEMY_X,
	output logic [8:0]	NEW_ENEMY_Y

);


	// Internal wires & registers:
	logic [9:0] player_x, player_y, new_player_x, new_player_y, target_x, target_y;	// Zero extended
	int x_diff, y_diff, dx, dy;
	
	// Other assignments:
	
	// Zero-extend TARGET to make compatible with signed int
	assign target_x = {1'b0, TARGET_X};
	assign target_y = {1'b0, TARGET_Y};
	
	// Store player's prev locn:
	always_ff @ (posedge CLOCK_50)
	begin
	
		player_x <= new_player_x;
		player_y <= new_player_y;
	
	end

	// Player locn logic:
	always_comb
	begin
	
		if(RESET_H)
		begin									// Middle of screen:
			new_player_x = 010010000;	// x = 114
			new_player_y = 001101000;	// y = 104
		end
		else if(GET_PLAYER_POS)
		begin
			new_player_x = {1'b0, PLAYER_X};
			new_player_y = {1'b0, PLAYER_Y};
		end
		else
		begin
			new_player_x = player_x;
			new_player_y = player_y;
		end
	
	end
	
	// Calculate enemy movement (i.e. "chasing algorithm")
	always_comb
	begin
	
		// Get signed dist b/t player and enemy:
		x_diff = player_x - target_x;
		y_diff = player_y - target_y;
		
		// Calculate abs dist:
		if(x_diff < 0)
			dx = 0 - x_diff;
		else
			dx = x_diff;
			
		if(y_diff < 0)
			dy = 0 - y_diff;
		else
			dy = y_diff;
		
		// Choose movement based on abs dist
		if(dx <= dy)
		begin
		
			NEW_ENEMY_X = TARGET_X;
		
			if(y_diff < 0)
			
				NEW_ENEMY_Y = TARGET_Y - 1;
			
			else
			
				NEW_ENEMY_Y = TARGET_Y + 1;
		
		end
		else if(dx > dy)
		begin
		
			NEW_ENEMY_Y = TARGET_Y;
		
			if(x_diff < 0)
			
				NEW_ENEMY_X = TARGET_X - 1;
			
			else
			
				NEW_ENEMY_X = TARGET_X + 1;
		
		end
		else
		begin
		
			NEW_ENEMY_X = TARGET_X;
			NEW_ENEMY_Y = TARGET_Y;
		
		end
	
	end

endmodule