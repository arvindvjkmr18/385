module entity_file(
	
	//timing:
	input logic CLOCK_50,
	input logic RESET_H,
	
	//Generic ROM inputs:
	input logic [1:0] ADDRESS,
	input logic [1:0] SPRITE_ID_reg,
	input logic	[8:0]	TARGET_X_reg,	
	input logic	[8:0]	TARGET_Y_reg,
	input logic RE_reg,
	input logic WE_reg,
	
	
	//MUXed outputs to sprite engine:
	output logic [1:0] SPRITE_ID,
	output logic [8:0] TARGET_X,
	output logic [8:0] TARGET_Y,
	
	output logic [2:0] STOP_ADDRESS
	
);

	logic [19:0] entities [4];
	//logic reset_h;
	//assign reset_h = ~RESET;
	
	assign STOP_ADDRESS = 3'b100;
	
	// Load data:
	always_ff @ (posedge CLOCK_50)
	begin
	
		// Reinitialize reg file
		if(RESET_H)
		begin
			// LINK IS ALWAYS AT ADDRESS 0:
			entities[0][19:18]		<= 2'b00;
			entities[0][17:9]		<= 9'b000100000;
			entities[0][8:0]		<= 9'b000100000;
			
			// Object slot 1 (empty for debug)
			entities[1][19:18]		<= 2'b01;
			entities[1][17:9]		<= 9'b100000000;
			entities[1][8:0]		<= 9'b000100000;
			
			// Object slot 2 (empty for debug)
			entities[2][19:18]		<= 2'b01;
			entities[2][17:9]		<= 9'b000100000;
			entities[2][8:0]		<= 9'b011000000;
			
			// Object slot 3 (empty for debug)
			entities[3][19:18]		<= 2'b10;
			entities[3][17:9]		<= 9'b100000000;
			entities[3][8:0]		<= 9'b011000000;
		end
		
	
		if(WE_reg)
		begin
		
			entities[ADDRESS][19:18] 	<= SPRITE_ID_reg;
			entities[ADDRESS][17:9]		<= TARGET_X_reg;
			entities[ADDRESS][8:0]		<= TARGET_Y_reg;
		
		end
	
	end
	
	// Read data:
	always_comb
	begin
	
		SPRITE_ID 	= 2'bX;
		TARGET_X		= 9'bX;
		TARGET_Y		= 9'bX;
	
		if(RE_reg)
		begin
		
			case( ADDRESS )
			
				2'b00:
				begin
				
					SPRITE_ID 	= entities[0][19:18];
					TARGET_X		= entities[0][17:9];
					TARGET_Y		= entities[0][8:0];
				
				end
				
				2'b01:
				begin
				
					SPRITE_ID 	= entities[1][19:18];
					TARGET_X		= entities[1][17:9];
					TARGET_Y		= entities[1][8:0];
				
				end
				
				2'b10:
				begin
				
					SPRITE_ID 	= entities[2][19:18];
					TARGET_X		= entities[2][17:9];
					TARGET_Y		= entities[2][8:0];
				
				end
				
				2'b11:
				begin
				
					SPRITE_ID 	= entities[3][19:18];
					TARGET_X		= entities[3][17:9];
					TARGET_Y		= entities[3][8:0];
				
				end
				
				default:
				begin
				
					SPRITE_ID 	= 2'bX;
					TARGET_X		= 9'bX;
					TARGET_Y		= 9'bX;
				
				end
			
			endcase
		
		end
	
	end



endmodule