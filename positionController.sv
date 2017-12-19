module positionController(

	// Timing signals
	input logic				CLOCK_50,
	
	// Input control
	input logic				RESET_H,
	input logic				RUN_POS_UPDATE,
	input logic				COLLISION_DONE,
	input logic				GAME_OVER_FLAG,
	input logic				YOU_WIN_FLAG,
	
	// Input data
	input logic	[2:0]		STOP_ADDRESS,
	input logic [1:0]		ID_CODE,
	
	// Output control
	output logic			POS_UPDATE_DONE,
	output logic			GAME_OVER,
	output logic			YOU_WIN,
	output logic			GET_INPUT,
	output logic			TRIGGER_AI,
	output logic			BUFFER_LOAD,
	output logic			RUN_COLLISION,
	output logic [1:0]	ADDR_MUX_SEL,
	output logic			BUF_MUX_SEL,
	output logic			WE_reg,
	
	// Output data
	output logic [1:0]	ADDRESS
	
	//output logic POS_CTRL_DEBUG

);

	enum logic [3:0]
	{
		HALT,					// State 0
		LOAD_ADDR,			// State 1
		CHECK_FILE,			// State 2
		PLAYER_MOTION,		// State 3
		ENEMY_MOTION,		// State 4
		CALC_MOTION,		// State 5
		COLLISION_DETECT,	// State 6
		STAGE_OUTPUT,		// State 7
		UPDATE_FILE,		// State 8
		DONE					// State 9
	
	}	State, Next_state;
	
	// Internal wires & registers
	logic [2:0] address, next_address;
	logic game_over, game_over_in, you_win, you_win_in;
	
	// Other assignments:
	assign ADDRESS = address[1:0];
	
	// Update state
	always_ff @ (posedge CLOCK_50)
	begin
	
		if(RESET_H)
		begin
			State <= HALT;
			address <= 3'b000;
		end		
		else
		begin
			State <= Next_state;
			address <= next_address;
		end
	end
	
	// Game over flag capture:
	always_ff @ (posedge CLOCK_50)
	begin
	
		if(RESET_H)
		begin
			game_over <= 1'b0;
			you_win <= 1'b0;
		end
		else
		begin
			game_over <= game_over_in;
			you_win <= you_win_in;
		end
	end
	
	always_comb
	begin
	
		if( GAME_OVER_FLAG )
			game_over_in = 1'b1;
		else
			game_over_in = game_over;
			
		if( YOU_WIN_FLAG )
			you_win_in = 1'b1;
		else
			you_win_in = you_win;
	
	end
	
	assign GAME_OVER = game_over;
	assign YOU_WIN = you_win;
	
	// Next State Control:
	always_comb
	begin
	
		Next_state = State;
		
		unique case(State)
		
			HALT:
			begin
				if(RUN_POS_UPDATE)
					Next_state = LOAD_ADDR;
			end
			
			LOAD_ADDR:
				
					Next_state = CHECK_FILE;
					
			CHECK_FILE:
			begin
			
				if(address == STOP_ADDRESS)
					Next_state = DONE;
			
				//else if( (ID_CODE == 2'b11) || (ID_CODE == 2'b10) )
				//	Next_state = LOAD_ADDR;		// Skip opcode at this address
					
				else if(ID_CODE == 2'b00)
					Next_state = PLAYER_MOTION;
					
				else if(ID_CODE == 2'b01)
					Next_state = ENEMY_MOTION;
				
				else
					Next_state = LOAD_ADDR;
					
			end
			
			PLAYER_MOTION:
			
				Next_state = CALC_MOTION;
				
			ENEMY_MOTION:
			
				Next_state = CALC_MOTION;
				
			CALC_MOTION:
			
				Next_state = COLLISION_DETECT;
				
			COLLISION_DETECT:
			begin

				if(COLLISION_DONE)
					Next_state = STAGE_OUTPUT;
					
				else
					Next_state = COLLISION_DETECT;
					
			end
			
			STAGE_OUTPUT:

					Next_state = UPDATE_FILE;
			
			UPDATE_FILE:

					Next_state = LOAD_ADDR;
			
			DONE:

					Next_state = HALT;
			
		endcase
	
	end
	
	// Control signals
	always_comb
	begin
	
		// Default assignments:
		POS_UPDATE_DONE = 1'b0;
		GET_INPUT = 1'b0;
		TRIGGER_AI = 1'b0;
		WE_reg = 1'b0;
		BUFFER_LOAD = 1'b0;
		RUN_COLLISION = 1'b0;
		ADDR_MUX_SEL = 2'b00;
		BUF_MUX_SEL = 1'b0;
		
		unique case(State)
		
			HALT: ;
			
			LOAD_ADDR: ;
			
			CHECK_FILE: ;
			
			PLAYER_MOTION:
				
				GET_INPUT = 1'b1;			// Capture keyboard input
				
			ENEMY_MOTION:
				
				TRIGGER_AI = 1'b1;		// Trigger AI module
				
			CALC_MOTION:
			
				BUFFER_LOAD = 1'b1;		// Store projected motion calculations
				
			COLLISION_DETECT:
			begin	
				RUN_COLLISION = 1'b1;
				ADDR_MUX_SEL = 2'b10;
				
			end
			STAGE_OUTPUT:
			begin
				BUFFER_LOAD = 1'b1;		// Store final motion calculations
				BUF_MUX_SEL = 1'b1;		// Select input from collision unit
			end
			
			UPDATE_FILE:
			begin
				ADDR_MUX_SEL = 2'b01;		// Give position buffer control of ef addr access
				WE_reg = 1'b1;					// Send write-enable command to ef
			end
			
			DONE: 
			
				POS_UPDATE_DONE = 1'b1;
			
		endcase
	
	end
	
	// Next Address Calculation:
	always_comb
	begin
		
		if(State == UPDATE_FILE || (State == CHECK_FILE && (ID_CODE == 2'b11 || ID_CODE == 2'b10)))
			next_address = address + 1;
		else if(State == DONE)
			next_address = 3'b000;
		else
			next_address = address;
	
	end

endmodule