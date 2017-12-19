module engine_MUX(

	// Input control signals:
	input logic [1:0] ENG_SEL,
	
	// Input data:
	input logic [7:0]	ENV_PIXEL_DIN,		// 8' pixel data to frame buffer
	input logic [8:0]	ENV_PIXEL_X,		// Ref x coord (to frame buffer)
	input logic [8:0]	ENV_PIXEL_Y,		// Ref y coord (to frame buffer)
	input logic			ENV_WE,				// Write enable control
	
	input logic [7:0]	SPR_PIXEL_DIN,		// 8' pixel data to frame buffer
	input logic [8:0]	SPR_PIXEL_X,		// Ref x coord (to frame buffer)
	input logic [8:0]	SPR_PIXEL_Y,		// Ref y coord (to frame buffer)
	input logic			SPR_WE,				// Write enable control
	
	input logic [7:0]	G_O_PIXEL_DIN,		// 8' pixel data to frame buffer
	input logic [8:0]	G_O_PIXEL_X,		// Ref x coord (to frame buffer)
	input logic [8:0]	G_O_PIXEL_Y,		// Ref y coord (to frame buffer)
	input logic			G_O_WE,				// Write enable control
	
	input logic [7:0]	Y_W_PIXEL_DIN,		// 8' pixel data to frame buffer
	input logic [8:0]	Y_W_PIXEL_X,		// Ref x coord (to frame buffer)
	input logic [8:0]	Y_W_PIXEL_Y,		// Ref y coord (to frame buffer)
	input logic			Y_W_WE,				// Write enable control


	// Output logic:
	output logic [7:0] ENG_PIXEL_DOUT,	// 8' pixel data to frame buffer
	output logic [8:0] ENG_PIXEL_X,		// Ref x coord (to frame buffer)
	output logic [8:0] ENG_PIXEL_Y,		// Ref y coord (to frame buffer)
	output logic		 ENG_WE				// Write enable control
	
);

	always_comb
	begin
	
		case (ENG_SEL)
		
			2'b00:
			begin
			
				ENG_PIXEL_DOUT = ENV_PIXEL_DIN;
				ENG_PIXEL_X = ENV_PIXEL_X;
				ENG_PIXEL_Y = ENV_PIXEL_Y;
				ENG_WE = ENV_WE;
			
			end
			
			2'b01:
			begin
			
				ENG_PIXEL_DOUT = SPR_PIXEL_DIN;
				ENG_PIXEL_X = SPR_PIXEL_X;
				ENG_PIXEL_Y = SPR_PIXEL_Y;
				ENG_WE = SPR_WE;
			
			end
			
			2'b10:
			begin
			
				ENG_PIXEL_DOUT = G_O_PIXEL_DIN;
				ENG_PIXEL_X = G_O_PIXEL_X;
				ENG_PIXEL_Y = G_O_PIXEL_Y;
				ENG_WE = G_O_WE;
			
			end
			
			2'b11: 
			begin
			
				ENG_PIXEL_DOUT = Y_W_PIXEL_DIN;
				ENG_PIXEL_X = Y_W_PIXEL_X;
				ENG_PIXEL_Y = Y_W_PIXEL_Y;
				ENG_WE = Y_W_WE;
			
			end
			
		endcase
	
	end



endmodule