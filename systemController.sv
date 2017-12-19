module systemController(

	// Input timing signals
	input logic 			CLOCK_50,

	// Input control signals:
	input logic 			RESET,
	input logic				POS_UPDATE_DONE,
	input logic  			ENV_DONE,
	input logic				SPR_DONE,
	input logic  			PAGE_FLIP,
	input logic				GAME_OVER,
	input logic				YOU_WIN,
	input logic				G_O_DONE,
	input logic				Y_W_DONE,
	
	// Output control signals:

	output logic			RUN_POS_UPDATE,
	output logic 			RUN_ENV,
	output logic 			RUN_SPR,
	output logic 			RUN_GAME_OVER,
	output logic			RUN_YOU_WIN,
	output logic [1:0]   ENG_SEL
);

	enum logic [2:0]
	{
	
		UPDATE_POS,		// State 0
		DRAW_ENV,		// State 1
		DRAW_CHAR,		// State 2
		HOLD_FRAME,		// State 3
		DRAW_GAME_OVER,	// State 4
		DRAW_YOU_WIN	// State 5
	
	}	State, Next_state;
	
	always_ff @ (posedge CLOCK_50)
	begin
	
		if (RESET)
			State <= UPDATE_POS;
		else
			State <= Next_state;
	
	end
	
		
	// Next State Control:
	always_comb
	begin

		// Default next state:
		Next_state = State;
		
		unique case (State)
		
			UPDATE_POS:
			begin
				
				if(GAME_OVER)
					Next_state = DRAW_GAME_OVER;
				else if(YOU_WIN)
					Next_state = DRAW_YOU_WIN;
				else
				begin
				
					if(POS_UPDATE_DONE)
						Next_state = DRAW_ENV;
					else
						Next_state = State;
				end
			
				/*
				if(POS_UPDATE_DONE && ~GAME_OVER)
					Next_state = DRAW_ENV;
				else if(GAME_OVER)
					Next_state = DRAW_GAME_OVER;
				else
					Next_state = State;
				*/
					
			end
			DRAW_ENV:
			
				if(ENV_DONE)
					Next_state = DRAW_CHAR;
				
			DRAW_CHAR:
			
				if(SPR_DONE)
					Next_state = HOLD_FRAME;
					
			HOLD_FRAME:
			
				if(PAGE_FLIP)
					Next_state = UPDATE_POS;
					
			DRAW_GAME_OVER: 
			
				if(G_O_DONE)
					Next_state = HOLD_FRAME;
					
			DRAW_YOU_WIN:
				if(Y_W_DONE)
					Next_state = HOLD_FRAME;
					
			default : ;
			
		endcase
	
	end
	
	//Assign control signals based on current state:
	always_comb
	begin
	
		//default control signal outputs:
		
		RUN_POS_UPDATE = 1'b0;
		RUN_ENV = 1'b0;
		RUN_SPR = 1'b0;
		RUN_GAME_OVER = 1'b0;
		RUN_YOU_WIN = 1'b0;
		ENG_SEL = 2'b00;
		
		unique case (State)
		
			UPDATE_POS: 
				RUN_POS_UPDATE = 1;
				
			DRAW_ENV:
				RUN_ENV = 1;
							
			DRAW_CHAR:
			begin
				RUN_SPR = 1;
				ENG_SEL = 2'b01;
			end
			
			HOLD_FRAME: ;
			
			DRAW_GAME_OVER:
			begin
				RUN_GAME_OVER = 1;
				ENG_SEL = 2'b10;
			end
			
			DRAW_YOU_WIN:
			begin 
				RUN_YOU_WIN = 1;
				ENG_SEL = 2'b11;
			end
			
			default : ;
			
		endcase
	
	end
	
endmodule